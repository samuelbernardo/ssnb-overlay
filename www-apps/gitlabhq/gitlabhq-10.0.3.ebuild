# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

# Mainteiner notes:
# - This ebuild uses Bundler to download and install all gems in deployment mode
#   (i.e. into isolated directory inside application). That's not Gentoo way how
#   it should be done, but GitLab has too many dependencies that it will be too
#   difficult to maintain them via ebuilds.

USE_RUBY="ruby23"
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="https://gitlab.com/gitlab-org/gitlab-ce.git"
EGIT_COMMIT="v${PV}"

inherit eutils git-2 python-r1 ruby-ng versionator user linux-info systemd

DESCRIPTION="GitLab is a free project and repository management application"
HOMEPAGE="https://about.gitlab.com/gitlab-ci/"

LICENSE="MIT"
RESTRICT="splitdebug"
SLOT=$(get_version_component_range 1-2)
KEYWORDS="~amd64 ~x86"
IUSE="memcached mysql +postgres +unicorn"

## Gems dependencies:
#   charlock_holmes		dev-libs/icu
#	grape, capybara		dev-libs/libxml2, dev-libs/libxslt
#   json				dev-util/ragel
#   yajl-ruby			dev-libs/yajl
#   pygments.rb			python 2.5+
#   execjs				net-libs/nodejs, or any other JS runtime
#   pg					dev-db/postgresql-base
#   mysql				virtual/mysql
#	rugged				net-libs/http-parser dev-libs/libgit2
#
GEMS_DEPEND="
	dev-libs/icu
	dev-libs/libxml2
	dev-libs/libxslt
	dev-util/ragel
	dev-libs/yajl
	net-libs/nodejs
	postgres? ( dev-db/postgresql )
	mysql? ( virtual/mysql )
	memcached? ( net-misc/memcached )
	net-libs/http-parser"
DEPEND="${GEMS_DEPEND}
	>=dev-lang/ruby-2.3[readline,ssl]
	>dev-vcs/git-2.2.1
	>=dev-vcs/gitlab-shell-5.9.0
	>=dev-vcs/gitlab-gitaly-0.38.0
	>=www-servers/gitlab-workhorse-3.0.0
	app-eselect/eselect-gitlabhq
	net-misc/curl
	virtual/ssh
	>=sys-apps/yarn-0.27.5
	>=net-libs/nodejs-7.0.0
	dev-libs/re2"
RDEPEND="${DEPEND}
	>=dev-db/redis-2.8.0
	virtual/mta
	virtual/krb5"
ruby_add_bdepend "
	virtual/rubygems
	>=dev-ruby/bundler-1.0"

RUBY_PATCHES=(
	"${PN}-${SLOT}-fix-checks-gentoo.patch"
	"${PN}-${SLOT}-fix-sendmail-param.patch"
)

GIT_USER="git"
GIT_GROUP="git"
GIT_HOME="/var/lib/git"
DEST_DIR="/opt/${PN}-${SLOT}"
CONF_DIR="/etc/${PN}-${SLOT}"

GIT_REPOS="${GIT_HOME}/repositories"
GIT_SATELLITES="${GIT_HOME}/gitlab-satellites"
GITLAB_SHELL="/var/lib/gitlab-shell"
GITLAB_SHELL_HOOKS="${GITLAB_SHELL}/hooks"

RAILS_ENV=${RAILS_ENV:-production}
RUBY=${RUBY:-ruby23}
BUNDLE="${RUBY} /usr/bin/bundle"

pkg_setup() {
	enewgroup ${GIT_GROUP}
	enewuser ${GIT_USER} -1 -1 ${DEST_DIR} "${GIT_GROUP}"
}

all_ruby_unpack() {
	git-2_src_unpack
}

each_ruby_prepare() {

	# fix path to repo and gitlab-shell hooks
	test -d "${GITLAB_SHELL_HOOKS}" || die "Gitlab Shell hooks directory not found: \"${GITLAB_SHELL_HOOKS}. Have you properly installed dev-vcs/gitlab-shell"?

	sed -i \
		-e "s|\(\s*path:\s\)/.*/gitlab-shell/|\1 ${GITLAB_SHELL}/|" \
		-e "s|\(\s*repos_path:\s\)/.*|\1 ${GIT_REPOS}/|" \
		-e "s|\(\s*hooks_path:\s\)/.*|\1 ${GITLAB_SHELL_HOOKS}/|" \
		-e "s|\(\s*path:\s\)/.*/gitlab-satellites/|\1 ${GIT_SATELLITES}/|" \
		-e "s|\(\s*GITLAB_SHELL:\s*\)|\1\n\tpath: \"${GITLAB_SHELL}\"|" \
		-e "s|# socket_path: tmp/sockets/private/gitaly\.socket|socket_path: tmp/sockets/gitaly.socket|" \
		config/gitlab.yml.example || die "failed to filter gitlab.yml.example"

	# modify database settings
	sed -i \
		-e 's|\(username:\) postgres.*|\1 gitlab|' \
		-e 's|\(password:\).*|\1 gitlab|' \
		-e 's|\(socket:\).*|/run/postgresql/.s.PGSQL.5432|' \
		config/database.yml.postgresql \
		|| die "failed to filter database.yml.postgresql"

	# replace "secret" token with random one
	local randpw=$(echo ${RANDOM}|sha512sum|cut -c 1-128)
	sed -i -e "/secret_token =/ s/=.*/= '${randpw}'/" \
		config/initializers/secret_token.rb \
		|| die "failed to filter secret_token.rb"

	# remove needless files
	rm .foreman .gitignore Procfile
	use unicorn || rm config/unicorn.rb.example
	use postgres || rm config/database.yml.postgresql
	use mysql || rm config/database.yml.mysql

	# change cache_store
	if use memcached; then
		sed -i \
			-e "/\w*config.cache_store / s/=.*/= :dalli_store, { namespace: 'gitlab' }/" \
			config/environments/production.rb \
			|| die "failed to modify production.rb"
	fi

	# Update pathes for unicorn
	if use unicorn; then
		sed -i \
			-e "s#/home/git/gitlab#${DEST_DIR}#" \
			config/unicorn.rb.example \
			|| die "failed to modify unicorn.rb.example"
	fi
}

src_install() {
	# DO NOT REMOVE - without this, the package won't install
	ruby-ng_src_install
	
	elog "Installing systemd unit files"
	systemd_dounit "${FILESDIR}/${PN}-${SLOT}-mailroom.service"
	systemd_dounit "${FILESDIR}/${PN}-${SLOT}-sidekiq.service"
	systemd_dounit "${FILESDIR}/${PN}-${SLOT}-unicorn.service"
	systemd_dounit "${FILESDIR}/${PN}-${SLOT}-workhorse.service"
	systemd_dotmpfilesd "${FILESDIR}/${PN}-${SLOT}-tmpfiles.conf"
}

each_ruby_install() {
	local dest="${DEST_DIR}"
	local conf="/etc/${PN}-${SLOT}"
	local temp="/var/tmp/${PN}-${SLOT}"
	local logs="/var/log/${PN}-${SLOT}"
	local uploads="${DEST_DIR}/public/uploads"

	## Prepare directories ##

	diropts -m750
	keepdir "${logs}"
	dodir "${temp}"

	diropts -m755
	dodir "${dest}"
	dodir "${uploads}"

	dosym "${temp}" "${dest}/tmp"
	dosym "${logs}" "${dest}/log"

	## Link gitlab-shell into git home
	dosym "${GITLAB_SHELL}" "${GIT_HOME}/gitlab-shell"

	## Install configs ##

	# Note that we cannot install the config to /etc and symlink
	# it to ${dest} since require_relative in config/application.rb
	# seems to get confused by symlinks. So let's install the config
	# to ${dest} and create a smylink to /etc/gitlabhq-<VERSION>
	dosym "${dest}/config" "${conf}"

	insinto "${dest}/.ssh"
	newins "${FILESDIR}/config.ssh" config

	echo "export RAILS_ENV=production" > "${D}/${dest}/.profile"

	## Install all others ##

	# remove needless dirs
	rm -Rf tmp log

	insinto "${dest}"
	doins -r ./

	## Install logrotate config ##

	dodir /etc/logrotate.d
	sed -e "s|@LOG_DIR@|${logs}|" \
		"${FILESDIR}"/gitlab.logrotate > "${D}"/etc/logrotate.d/${PN}-${SLOT} \
		|| die "failed to filter gitlab.logrotate"

	## Install gems via bundler ##

	cd "${D}/${dest}"

	local without="development test thin"
	local flag; for flag in memcached mysql postgres unicorn; do
		without+="$(use $flag || echo ' '$flag)"
	done
	local bundle_args="--deployment ${without:+--without ${without}}"

	# Use systemlibs for nokogiri as suggested
	${BUNDLE} config build.nokogiri --use-system-libraries

	# Fix invalid ldflags for charlock_holmes,
	# see https://github.com/brianmario/charlock_holmes/issues/32
	${BUNDLE} config build.charlock_holmes --with-ldflags='-L. -Wl,-O1 -Wl,--as-needed -rdynamic -Wl,-export-dynamic -Wl,--no-undefined -lz -licuuc'

	einfo "Running bundle install ${bundle_args} ..."
	${BUNDLE} install ${bundle_args} || die "bundler failed"

	## Clean ##

	local gemsdir=vendor/bundle/ruby/$(ruby_rbconfig_value 'ruby_version')

	# remove gems cache
	rm -Rf ${gemsdir}/cache

	# fix permissions
	fowners -R ${GIT_USER}:${GIT_GROUP} "${dest}" "${conf}" "${temp}" "${logs}"
	fperms o+Xr "${temp}" # Let nginx access the unicorn socket

	## RC scripts ##
	local rcscript=${PN}-${SLOT}.init

	cp "${FILESDIR}/${rcscript}" "${T}" || die
	sed -i \
		-e "s|@GIT_USER@|${GIT_USER}|" \
		-e "s|@GIT_GROUP@|${GIT_USER}|" \
		-e "s|@SLOT@|${SLOT}|" \
		-e "s|@DEST_DIR@|${dest}|" \
		-e "s|@LOG_DIR@|${logs}|" \
		-e "s|@RESQUE_QUEUE@|${resque_queue}|" \
		"${T}/${rcscript}" \
		|| die "failed to filter ${rcscript}"

	if use memcached; then
		sed -i -e '/^depend/,// {/need / s/$/ memcached/}' \
		"${T}/${rcscript}" || die "failed to filter ${rcscript}"
	fi

	newinitd "${T}/${rcscript}" "${PN}-${SLOT}"
}

pkg_preinst() {
	diropts -m "0750" -o "${GIT_USER}" -g "${GIT_GROUP}"
	dodir "${GIT_SATELLITES}"
}

pkg_postinst() {
	if [ ! -e "${GIT_HOME}/.ssh/id_rsa" ]; then
		einfo "Generating SSH key for git user"
		su -l ${GIT_USER} -s /bin/sh -c "
			ssh-keygen -q -N '' -t rsa -f ${GIT_HOME}/.ssh/id_rsa" \
			|| die "failed to generate SSH key"
	fi
	if [ ! -e "${GIT_HOME}/.gitconfig" ]; then
		einfo "Setting git user in ${GIT_HOME}/.gitconfig, feel free to "
		einfo "modify this file according to your needs!"
		su -l ${GIT_USER} -s /bin/sh -c "
			git config --global core.autocrlf 'input';
			git config --global gc.auto 0;
			git config --global user.email 'gitlab@localhost';
			git config --global user.name 'GitLab'
			git config --global repack.writeBitmaps true" \
			|| die "failed to setup git configuration"
	fi

	elog "If this is a new installation, proceed with the following steps:"
	elog
	elog "  1. Copy ${CONF_DIR}/gitlab.yml.example to ${CONF_DIR}/gitlab.yml"
	elog "     and edit this file in order to configure your GitLab settings."
	elog
	elog "  2. Copy ${CONF_DIR}/database.yml.* to ${CONF_DIR}/database.yml"
	elog "     and edit this file in order to configure your database settings"
	elog "     for \"production\" environment."
	elog
	elog "  3. Copy ${CONF_DIR}/initializers/rack_attack.rb.example"
	elog "     to ${CONF_DIR}/initializers/rack_attack.rb"
	elog
	elog "  4. Copy ${CONF_DIR}/resque.yml.example to ${CONF_DIR}/resque.yml"
	elog "     and edit this file in order to configure your Redis settings"
	elog "     for \"production\" environment."
	elog

	if use unicorn; then
		elog "  4a. Copy ${CONF_DIR}/unicorn.rb.example to ${CONF_DIR}/unicorn.rb"
		elog
	fi

	elog "  5. If this is a new installation, create a database for your GitLab instance."
	if use postgres; then
		elog "    If you have local PostgreSQL running, just copy&run:"
		elog "        su postgres"
		elog "        psql -c \"CREATE ROLE gitlab PASSWORD 'gitlab' \\"
		elog "            NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""
		elog "        createdb -E UTF-8 -O gitlab gitlab_production"
		elog "    Note: You should change your password to something more random..."
		elog
		elog "    GitLab uses polymorphic associations which are not SQL-standard friendly."
		elog "    To get it work you must use this ugly workaround:"
		elog "        psql -U postgres -d gitlab"
		elog "        CREATE CAST (integer AS text) WITH INOUT AS IMPLICIT;"
		elog
	fi
	elog "  6. Execute the following command to finalize your setup:"
	elog "         emerge --config \"=${CATEGORY}/${PF}\""
	elog "     Note: Do not forget to start Redis server."
	elog
	elog "To update an existing instance, run the following command and choose upgrading when prompted:"
	elog "    emerge --config \"=${CATEGORY}/${PF}\""
	elog
	elog "Important: Do not remove the earlier version prior migration!"

	if linux_config_exists; then
		if linux_chkconfig_present PAX ; then
			elog  ""
			ewarn "Warning: PaX support is enabled, you must disable mprotect for ruby. Otherwise "
			ewarn "FFI will trigger mprotect errors that are hard to trace. Please run: "
			ewarn "    paxctl -m $RUBY"
		fi
	else
		elog  ""
		einfo "Important: Cannot find a linux kernel configuration, so cannot check for PaX support."
		einfo "			  If CONFIG_PAX is set, you should disable mprotect for ruby since FFI may trigger"
		einfo "			  mprotect errors."
	fi
}

pkg_config() {
	# Ask user whether this is the first installation
	einfon "Do you want to upgrade an existing installation? [Y|n] "
	do_upgrade=""
	while true
	do
		read -r do_upgrade
		if [[ $do_upgrade == "n" || $do_upgrade == "N" ]] ; then do_upgrade="" && break
		elif [[ $do_upgrade == "y" || $do_upgrade == "Y" || $do_upgrade == "" ]] ; then do_upgrade=1 && break
		else eerror "Please type either \"Y\" or \"N\" ... " ; fi
	done

	if [[ $do_upgrade ]] ; then

		LATEST_DEST=$(test -n "${LATEST_DEST}" && echo ${LATEST_DEST} || \
			find /opt -maxdepth 1 -iname 'gitlabhq-*' -and -type d -and -not -iname "gitlabhq-${SLOT}" | \
			sort -rV | head -n1)

		if [[ -z "${LATEST_DEST}" || ! -d "${LATEST_DEST}" ]] ; then
			einfon "Please enter the path to your latest Gitlab instance:"
			while true
			do
				read -r LATEST_DEST
				test -d ${LATEST_DEST} && break ||\
					eerror "Please specify a valid path to your Gitlab instance!"
			done
		else
			einfo "Found your latest Gitlab instance at \"${LATEST_DEST}\"."
		fi

		einfo "Please make sure that you've created a backup and stopped your running Gitlab instance: "
		elog "\$ cd \"${LATEST_DEST}\" && sudo -u ${GIT_USER} ${BUNDLE} exec rake gitlab:backup:create RAILS_ENV=production"
		elog "\$ /etc/init.d/${LATEST_DEST#*/opt/} stop"
		elog ""

		einfon "Proceeed? [Y|n] "
		read -r proceed
		if [[ $proceed != "y" && $proceed != "Y" && $proceed != "" ]]
		then
			einfo "Aborting migration"
			return
		fi

		if [[ ${LATEST_DEST} != ${DEST_DIR} ]] ;
		then
			einfo "Found major update, migrate data from \"$LATEST_DEST\":"

			einfo "Migrating uploads ..."
			einfon "This will move your uploads from \"$LATEST_DEST\" to \"${DEST_DIR}\", (C)ontinue or (s)kip? "
			migrate_uploads=""
			while true
			do
				read -r migrate_uploads
				if [[ $migrate_uploads == "s" || $migrate_uploads == "S" ]] ; then migrate_uploads="" && break
				elif [[ $migrate_uploads == "c" || $migrate_uploads == "C" || $migrate_uploads == "" ]] ; then migrate_uploads=1 && break
				else eerror "Please type either \"c\" to continue or \"n\" to skip ... " ; fi
			done
			if [[ $migrate_uploads ]] ; then
				su -l ${GIT_USER} -s /bin/sh -c "
					rm -rf ${DEST_DIR}/public/uploads && \
					mv ${LATEST_DEST}/public/uploads ${DEST_DIR}/public/uploads" \
					|| die "failed to migrate uploads."

				# Fix permissions
				find "${DEST_DIR}/public/uploads/" -type d -exec chmod 0700 {} \;
			fi

            einfo "Migrating shared data ..."
            einfon "This will move your shared data from \"$LATEST_DEST\" to \"${DEST_DIR}\", (C)ontinue or (s)kip? "
            migrate_shared=""
            while true
            do
                read -r migrate_shared
                if [[ $migrate_shared == "s" || $migrate_shared == "S" ]] ; then migrate_shared="" && break
                elif [[ $migrate_shared == "c" || $migrate_shared == "C" || $migrate_shared == "" ]] ; then migrate_shared=1 && break
                else eerror "Please type either \"c\" to continue or \"n\" to skip ... " ; fi
            done
            if [[ $migrate_shared ]] ; then
                su -l ${GIT_USER} -s /bin/sh -c "
                    rm -rf ${DEST_DIR}/shared && \
                    mv ${LATEST_DEST}/shared ${DEST_DIR}/shared" \
                    || die "failed to migrate shared data."

                # Fix permissions
                find "${DEST_DIR}/shared/" -type d -exec chmod 0700 {} \;
            fi			

			einfon "Migrate configuration, (C)ontinue or (s)kip? "
			while true
			do
				read -r migrate_config
				if [[ $migrate_config == "s" || $migrate_config == "S" ]] ; then migrate_config="" && break
				elif [[ $migrate_config == "c" || $migrate_config == "C" || $migrate_config == "" ]] ; then migrate_config=1 && break
				else eerror "Please type either \"c\" to continue or \"s\" to skip ... " ; fi
			done
			if [[ $migrate_config ]]
			then
				for conf in database.yml gitlab.yml resque.yml unicorn.rb secrets.yml ; do
					einfo "Migration config file \"$conf\" ..."
					cp -p "${LATEST_DEST}/config/${conf}" "${DEST_DIR}/config/"
					sed -s "s#$(basename $LATEST_DEST)#${PN}-${SLOT}#g" -i "${DEST_DIR}/config/$conf"
	
					example="${DEST_DIR}/config/${conf}.example"
					test -f "${example}" && cp -p "${example}" "${DEST_DIR}/config/._cfg0000_${conf}"
				done
	
				# if the user's console is not 80x24, it is better to manually run dispatch-conf
				einfon "Merge config with dispatch-conf, (C)ontinue or (q)uit? "
				while true
				do
					read -r merge_config
					if [[ $merge_config == "q" || $merge_config == "Q" ]] ; then merge_config="" && break
					elif [[ $merge_config == "c" || $merge_config == "C" || $merge_config == "" ]] ; then merge_config=1 && break
					else eerror "Please type either \"c\" to continue or \"q\" to quit ... " ; fi
				done
				if [[ $merge_config ]] ; then
					CONFIG_PROTECT="${DEST_DIR}" dispatch-conf || die "failed to automatically migrate config, run \"CONFIG_PROTECT=${DEST_DIR} dispatch-conf\" by hand, re-run this routine and skip config migration to proceed."
				else
					echo "Manually run \"CONFIG_PROTECT=${DEST_DIR} dispatch-conf\" and re-run this routine and skip config migration to proceed." 
					return
				fi
			fi
		fi

		einfo "Clean up old gems ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
			cd ${DEST_DIR}
			${BUNDLE} clean" \
			|| die "failed to clean up old gems ..."

		einfo "Migrating database ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
			cd ${DEST_DIR}
			${BUNDLE} exec rake db:migrate RAILS_ENV=production" \
			|| die "failed to migrate database."

		einfo "Clear redis cache ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
			cd ${DEST_DIR}
			${BUNDLE} exec rake cache:clear RAILS_ENV=production" \
			|| die "failed to run cache:clear"

		einfo "Clean up assets ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
			cd ${DEST_DIR}
			${BUNDLE} exec rake gitlab:assets:clean RAILS_ENV=production NODE_ENV=production" \
			|| die "failed to run gitlab:assets:clean"

		einfo "Configure Git to generate packfile bitmaps ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			git config --global repack.writeBitmaps true" \
			|| die "failed to configure Git"

	else

		## Check config files existence ##
		einfo "Checking configuration files ..."

		if [ ! -r "${CONF_DIR}/database.yml" ] ; then
			eerror "Copy \"${CONF_DIR}/database.yml.*\" to \"${CONF_DIR}/database.yml\""
			eerror "and edit this file in order to configure your database settings for"
			eerror "\"production\" environment."
			die
		fi
		if [ ! -r "${CONF_DIR}/gitlab.yml" ]; then
			eerror "Copy \"${CONF_DIR}/gitlab.yml.example\" to \"${CONF_DIR}/gitlab.yml\""
			eerror "and edit this file in order to configure your GitLab settings"
			eerror "for \"production\" environment."
			die
		fi

		einfo "Initializing database ..."
		su -l ${GIT_USER} -s /bin/sh -c "
			export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
			cd ${DEST_DIR}
			${BUNDLE} exec rake gitlab:setup RAILS_ENV=${RAILS_ENV}" \
				|| die "failed to run rake gitlab:setup"
	fi

	einfo "Compile assets ..."
	su -l ${GIT_USER} -s /bin/sh -c "
		export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8
		cd ${DEST_DIR}
		yarn add mime-db
		yarn install --production --pure-lockfile --no-progress
		${BUNDLE} exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production" \
		|| die "failed to run yarn install and gitlab:assets:compile"

	## (Re-)Link gitlab-shell-secret into gitlab-shell
	if test -L "${GITLAB_SHELL}/.gitlab_shell_secret"
	then
		rm "${GITLAB_SHELL}/.gitlab_shell_secret"
		ln -s "${DEST_DIR}/.gitlab_shell_secret" "${GITLAB_SHELL}/.gitlab_shell_secret"
	fi

	einfo "You might want to run the following in order to check your application status:"
	einfo "# cd ${DEST_DIR} && sudo -u ${GIT_USER} ${BUNDLE} exec rake gitlab:check RAILS_ENV=production"
	einfo ""
	einfo "GitLab is prepared, now you should configure your web server."
}
