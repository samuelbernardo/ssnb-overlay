# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

inherit user eutils multilib ruby-ng systemd

MY_P="one-release-${PV}"

DESCRIPTION="OpenNebula Virtual Infrastructure Engine"
HOMEPAGE="http://www.opennebula.org/"
SRC_URI="http://downloads.opennebula.org/packages/${PN}-${PV}/${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qemu +mysql xen sqlite +extras systemd docker vnc"

RDEPEND=">=dev-libs/xmlrpc-c-1.18.02[abyss,cxx,threads]
	dev-lang/ruby
	dev-lang/python
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
	>=dev-util/scons-1.2.0-r1
	dev-ruby/nokogiri
	dev-ruby/bundler
	dev-nodejs/grunt-cli
	dev-nodejs/bower
	net-libs/nodejs[npm]
	net-libs/libvncserver
	docker? ( dev-go/dep )"

# make sure no eclass is running tests
RESTRICT="test"

S="${WORKDIR}/${P}"

ONEUSER="oneadmin"
ONEGROUP="oneadmin"

pkg_setup () {
	enewgroup ${ONEGROUP}
	enewuser ${ONEUSER} -1 /bin/bash /var/lib/one ${ONEGROUP}
}

src_unpack() {
	default
}

src_prepare() {
	sed -i -e 's|chmod|true|' install.sh || die "sed failed"
	eapply_user
}

src_configure() {
	:
}

src_compile() {
	###########################################################################
	##                                                                       ##
	## It is highly recommended that you read the documentation and tweak    ##
	## the PKGBUILD accordingly:                                             ##
	## http://docs.opennebula.org/stable/integration/references/compile.html ##
	##                                                                       ##
	###########################################################################
	local myconf
	myconfg+="parsers=yes new_xmlrpc=yes "
	use extras && myconf+="new_xmlrpc=yes "
	use mysql && myconf+="mysql=yes " || myconf+="mysql=no "
	use docker && myconf+="docker_machine=yes "
	use systemd && myconf+="systemd=yes "
	use vnc && myconf+="svncterm=yes "
	python2.7 $(which scons) \
		${myconf} \
		$(sed -r 's/.*(-j\s*|--jobs=)([0-9]+).*/-j\2/' <<< ${MAKEOPTS}) \
		|| die "building ${PN} failed"
}

src_install() {
	DESTDIR=${T} ./install.sh -u ${ONEUSER} -g ${ONEGROUP} || die "install failed"

	cd "${T}"

	# set correct owner
	fowners -R ${ONEUSER}:${ONEGROUP} etc/ var/ usr/

	# installing things for real
	keepdir /var/{lib,run}/${PN} || die "keepdir failed"

	dodir /usr/$(get_libdir)/one
	dodir /var/lock/one
	dodir /var/log/one
	dodir /var/lib/one
	dodir /var/run/one
	dodir /var/tmp/one
	dodir /var/lib/one
	dodir /var/lib/one/vms
	dodir /usr/share/one
	dodir /etc/tmpfiles.d

	insinto	/
	doins -r etc/
	doins -r var/

	insinto /usr
	doins -r usr/bin
	doins -r usr/include
	doins -r usr/share

	insinto /usr/$(get_libdir)
	doins -r usr/lib/*

	doenvd "${FILESDIR}/99one"

	newinitd "${FILESDIR}/opennebula.initd" opennebula
	newinitd "${FILESDIR}/sunstone-server.initd" sunstone-server
	newinitd "${FILESDIR}/oneflow-server.initd" oneflow-server
	newconfd "${FILESDIR}/opennebula.confd" opennebula
	newconfd "${FILESDIR}/sunstone-server.confd" sunstone-server
	newconfd "${FILESDIR}/oneflow-server.confd" oneflow-server

	use systemd && systemd_dounit "${FILESDIR}"/opennebula{,-sunstone,-econe,-oneflow,-onegate}.service

	insinto /etc/one
	insopts -m 0640
	doins -r etc/*
	doins "${FILESDIR}/one_auth"

	insinto /etc/tmpfiles.d
	doins "${FILESDIR}/tmpfilesd.opennebula.conf"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated.opennebula" "opennebula"

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

