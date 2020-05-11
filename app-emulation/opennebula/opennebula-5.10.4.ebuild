# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"
PYTHON_COMPAT=( python2_7 python3_6 )

inherit user eutils multilib ruby-ng systemd rpm python-r1

MY_P="one-release-${PV}"
P_RPM="${P}-1"

DESCRIPTION="OpenNebula Virtual Infrastructure Engine"
HOMEPAGE="http://www.opennebula.org/"

IUSE="qemu +mysql xen sqlite +extras systemd docker +sunstone vnc +python +doc"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
SRC_URI="https://github.com/OpenNebula/one/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

RDEPEND=">=dev-libs/xmlrpc-c-1.18.02[abyss,cxx,threads]
	dev-lang/ruby
	python? ( ${PYTHON_DEPS}
	        >=dev-python/pygobject-2.90.4:3[${PYTHON_USEDEP}] )
	extras? ( dev-libs/openssl
		dev-ruby/libxml
		net-misc/curl
		dev-libs/libxslt
		dev-libs/expat
		dev-ruby/uuidtools
		dev-ruby/amazon-ec2
		dev-ruby/webmock
		dev-ruby/mysql
		dev-ruby/mysql2
		dev-ruby/parse-cron
		dev-ruby/sequel
		dev-ruby/treetop
		dev-ruby/xml-simple
		dev-ruby/zendesk_api
		dev-ruby/ffi-rzmq
		dev-ruby/ffi-rzmq-core
		dev-ruby/rqrcode
		dev-ruby/rqrcode_core
		dev-ruby/chunky_png
		dev-ruby/rotp
		dev-libs/log4cpp )
	mysql? ( virtual/mysql )
	dev-db/sqlite
	net-misc/openssh
	net-fs/nfs-utils
	dev-db/mariadb
	net-libs/zeromq
	|| ( app-cdr/cdrkit app-cdr/cdrtools )
	sqlite? ( dev-ruby/sqlite3 )
	qemu? ( app-emulation/libvirt[libvirtd,qemu] )
	xen? ( app-emulation/xen-tools )"
DEPEND="${RDEPEND}
	dev-lang/ruby:2.5
	>=dev-util/scons-3.0.0
	dev-ruby/nokogiri
	dev-ruby/bundler
	dev-nodejs/grunt
	dev-nodejs/bower
	dev-nodejs/ini
	dev-nodejs/braces
	net-libs/nodejs[npm]
	net-libs/libvncserver
	app-text/ronn
	dev-ruby/builder
	dev-ruby/highline
	dev-ruby/ipaddress:1
	docker? ( dev-go/dep )"

# make sure no eclass is running tests
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

ONEUSER="oneadmin"
ONEGROUP="oneadmin"

PATCHES=(
	"${FILESDIR}/patches/fix_kvm_emulator.patch"
	"${FILESDIR}/patches/install.sh.patch"
)

test_netsandbox() {
	if use sunstone; then
		elog "Opennebula hotfix releases needs to build sunstone without network sandbox restriction."
		has network-sandbox ${FEATURES} && die "Please disable feature network-sandbox: -network-sandbox"
	fi
	if use docker; then
		elog "Opennebula releases needs to build docker without network sandbox restriction."
		has network-sandbox ${FEATURES} && die "Please disable feature network-sandbox: -network-sandbox"
	fi
}

pkg_pretend() {
	test_netsandbox
}

pkg_setup () {
	test_netsandbox
	enewgroup ${ONEGROUP}
	enewuser ${ONEUSER} -1 /bin/bash /var/lib/one ${ONEGROUP}
}

src_unpack() {
	default
}

src_prepare() {
	# install missing source file
	#cp "${FILESDIR}"/${P}/parsers/* "${S}"/src/parsers/ || die "copy parsers files failed"

	# set correct lib path
	use docker && make -C src/docker_machine/src/docker_machine vendor
	for f in $(grep -rlI "/usr/lib/one" .); do sed -i -e "s/\/usr\/lib\/one/\/usr\/$(get_libdir)\/one/g" $f; done || die "correct lib dir failed"

	# grunt-sass and node-sass versions
	sed -i -e 's|1.2.1|2.1.0|' -e 's|3.10.1|4.13.0|' src/sunstone/public/package.json || die "sed failed"

	# As we install from the github release sources we need to build sunstone as well.
	# To do that we need the npm environment set up
	# https://docs.opennebula.org/5.4/integration/references/sunstone_dev.html#sunstone-dev
	pushd src/sunstone/public/ >/dev/null
	./build.sh -d || die "Install required dependencies for npm and bower failed."
	#export PATH=$PATH:$PWD/node_modules/.bin
	#./build.sh || die "Prepare minified files failed."
	popd >/dev/null

	eapply_user
}

src_configure() {
	:
}

src_compile() {
	# manual pages
	if use doc; then
		pushd ${S}/share/man >/dev/null
		./build.sh
		popd >/dev/null
	fi

	###########################################################################
	##                                                                       ##
	## It is highly recommended that you read the documentation and tweak    ##
	## the PKGBUILD accordingly:                                             ##
	## http://docs.opennebula.org/stable/integration/references/compile.html ##
	##                                                                       ##
	###########################################################################
	local myconf
	myconf+="parsers=yes new_xmlrpc=yes "
	use extras && myconf+="new_xmlrpc=yes "
	use mysql && myconf+="mysql=yes " || myconf+="mysql=no "
	use sunstone && myconf+="sunstone=yes "
	use docker && myconf+="docker_machine=yes "
	use systemd && myconf+="systemd=yes "
	use vnc && myconf+="svncterm=yes "
	python3 $(which scons) \
		${myconf} \
		$(sed -r 's/.*(-j\s*|--jobs=)([0-9]+).*/-j\2/' <<< ${MAKEOPTS}) \
		|| die "building ${PN} failed"
}

src_install() {
	# Prepare installation
	keepdir /var/{lib,run}/${PN} || die "keepdir failed"

	dodir /usr/$(get_libdir)/one
	dodir /var/log/one
	dodir /var/lib/one
	dodir /var/tmp/one
	dodir /var/lib/one
	dodir /var/lib/one/vms
	dodir /usr/share/one
	dodir /etc/tmpfiles.d

	# Installing Opennebula
	DESTDIR="${T}" ./install.sh -u ${ONEUSER} -g ${ONEGROUP} || die "install opennebula core failed"
	use extras && DESTDIR="${T}" ./install.sh -u ${ONEUSER} -g ${ONEGROUP} -c || die "install opennebula client tools failed"
	use docker && DESTDIR="${T}" ./install.sh -u ${ONEUSER} -g ${ONEGROUP} -e -k || die "install docker machine failed"

	pushd "${T}" >/dev/null
	# Clean files
	rm -rf etc/{logrotate.d,sudoers.d} lib/ var/{lock,run}

	# setup etc
	insinto	/etc
	doins -r etc/one
	rm -rf etc/one

	insinto /etc/one
	insopts -m 0640
	doins "${FILESDIR}/one_auth"

	insinto /etc/tmpfiles.d
	insopts -m 0644
	doins "${FILESDIR}"/tmpfiles.d/*

	insinto /etc/logrotate.d
	doins "${FILESDIR}"/logrotate/*

	insinto /etc/sudoers.d
	doins "${FILESDIR}"/sudoers/*

	# set binaries executable
	into /usr
	dobin usr/bin/*

	cp -a usr/$(get_libdir)/one/* "${ED}"/usr/$(get_libdir)/one/
	cp -a usr/share/one/* "${ED}"/usr/share/one/
	cp -a var/lib/one/* "${ED}"/var/lib/one/
	rm -rf usr/bin usr/$(get_libdir)/one usr/share/one var/lib/one

	# add documentation
	dodoc usr/share/docs/one/*
	rm -rf usr/share/docs

	# install remaining files
	insinto /usr/share/man
	doins -r usr/share/man/man1/

	# set correct owner
	fowners -R ${ONEUSER}:${ONEGROUP} /etc/one /usr/$(get_libdir)/one /usr/share/one /var/lib/{one,opennebula} /var/log/one /var/tmp/one

	# install daemon files
	if use systemd; then
		systemd_dounit "${FILESDIR}"/systemd/*.service
	else
		doenvd "${FILESDIR}/openrc/99one"
		newinitd "${FILESDIR}/openrc/opennebula.initd" opennebula
		newinitd "${FILESDIR}/openrc/sunstone-server.initd" sunstone-server
		newinitd "${FILESDIR}/openrc/oneflow-server.initd" oneflow-server
		newconfd "${FILESDIR}/openrc/opennebula.confd" opennebula
		newconfd "${FILESDIR}/openrc/sunstone-server.confd" sunstone-server
		newconfd "${FILESDIR}/openrc/oneflow-server.confd" oneflow-server
	fi

	popd >/dev/null

}

pkg_postinst() {

	#chown -R oneadmin:oneadmin ${ROOT}var/{lock,lib,log,run,tmp}/one
	#chown -R oneadmin:oneadmin ${ROOT}usr/share/one
	#chown -R oneadmin:oneadmin ${ROOT}etc/one
	#chown -R oneadmin:oneadmin ${ROOT}usr/$(get_libdir)/one

	local onedir="${EROOT}var/lib/one"
	if [ ! -d "${onedir}/.ssh" ] ; then
		#einfo "Generating ssh-key..."
		#umask 0027 || die "setting umask failed"
		#mkdir "${onedir}/.ssh" || die "creating ssh directory failed"
		#ssh-keygen -q -t rsa -N "" -f "${onedir}/.ssh/id_rsa" || die "ssh-keygen failed"
		#cat > "${onedir}/.ssh/config" <<EOF
#UserKnownHostsFile /dev/null
#Host *
#    StrictHostKeyChecking no
#EOF
		#cat "${onedir}/.ssh/id_rsa.pub"  >> "${onedir}/.ssh/authorized_keys" || die "adding key failed"
		#chown -R ${ONEUSER}:${ONEGROUP} "${onedir}/.ssh" || die "changing owner failed"
		elog "Create directory ${onedir}/.ssh with umask 0027."
		elog "Then generate ssh key using proper cypher algorithm (at least rsa)."
		elog "Add public key to ${ONEUSER} authorized_keys:"
		elog "cat ${onedir}/.ssh/id_rsa.pub  >> ${onedir}/.ssh/authorized_keys"
		elog "${ONEUSER} ssh config for any host with"
		elog "StrictHostKeyChecking no"
		elog "and"
		elog "UserKnownHostsFile /dev/null"
		elog "In the end set correct owner to ${ONEUSER}:"
		elog "chown -R ${ONEUSER}:${ONEGROUP} ${onedir}/.ssh"
	fi

	if use qemu ; then
		elog "Make sure that the user ${ONEUSER} has access to the libvirt control socket"
		elog "  /var/run/libvirt/libvirt-sock"
		elog "You can easily check this by executing the following command as ${ONEUSER} user"
		elog "  virsh -c qemu:///system nodeinfo"
		elog "If not using using policykit in libvirt, the file you should take a look at is:"
		elog "  /etc/libvirt/libvirtd.conf (look for the unix_sock_*_perms parameters)"
		elog "Failure to do so may lead to nodes hanging in PENDING state forever without further notice."
		echo ""
		elog "Should a node hang in PENDING state even with correct permissions, try the following to get more information."
		elog "In /tmp/one-im execute the following command for the biggest one_im-* file:"
		elog "  ruby -wd one_im-???"
		echo ""
		elog "OpenNebula doesn't allow you to specify the disc format."
		elog "Unfortunately the default in libvirt is not to guess and"
		elog "it therefores assumes a 'raw' format when using qemu/kvm."
		elog "Set 'allow_disk_format_probing = 0' in /etc/libvirt/qemu.conf"
		elog "to work around this until OpenNebula fixes it."
	fi

	elog "If you wish to use the sunstone server, please issue the command"
	#elog "/usr/share/one/install_gems as oneadmin user"
	elog "gem install sequel thin json rack sinatra builder treetop zendesk_api mysql parse-cron"

}

