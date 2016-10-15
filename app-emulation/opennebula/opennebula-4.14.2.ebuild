# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
#
# Official documentation
#  * Build dependencies - http://docs.opennebula.org/4.14/integration/references/build_deps.html
#  * Building from source - http://docs.opennebula.org/4.14/integration/references/compile.html
#
# Inspired by 
#  * http://gpo.zugaina.org/app-emulation/opennebula/ChangeLog
#  * https://github.com/himbeere/opennebula
#

EAPI=5
USE_RUBY="ruby20 ruby21"

inherit eutils multilib user ruby-ng

DESCRIPTION="OpenNebula exists to help companies build simple, cost-effective, reliable, open enterprise clouds on existing IT infrastructure."
HOMEPAGE="http://www.opennebula.org/"
SRC_URI="http://downloads.opennebula.org/packages/${P}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

IUSE="-flow frontend -gate -node mysql -sqlite -sunstone syslog qemu -xen"
REQUIRED_USE="
	?? ( node frontend )
	node? ( ||  ( !flow !frontend !gate !sunstone qemu xen ) )
	frontend? ( || ( mysql sqlite ) )
	flow? ( frontend )
	gate? ( frontend )
	sunstone? ( frontend )
"

ONE_DEPEND="
	>=dev-ruby/sequel-4
	dev-ruby/json
	dev-ruby/rack
	dev-ruby/sinatra
	www-servers/thin
"

RDEPEND="
	dev-libs/libxml2
	net-misc/openssh
	sys-apps/pciutils
	sys-apps/usbutils
	>=dev-libs/xmlrpc-c-1.31[abyss,cxx,threads]
	>=dev-lang/ruby-1.8.7
	>=dev-libs/openssl-0.9.8
	!node? (
		mysql? ( 
			>=virtual/mysql-5.5
			dev-ruby/mysql2
		)
		sqlite? (
			dev-db/sqlite:3
			dev-ruby/sqlite3
		)
		syslog? (
			dev-libs/log4cpp
			virtual/logger
		)
		flow? (${ONE_DEPEND})
		gate? (${ONE_DEPEND})
		sunstone? (
			${ONE_DEPEND}
			www-apps/novnc
		)
	)
    qemu? ( 
		app-emulation/libvirt[libvirtd,qemu]
		app-emulation/qemu[vnc]
	)
	xen? (
		app-emulation/xen-tools
	)
"
DEPEND="
	>=dev-util/scons-1.2.0-r1
	${RDEPEND}
"

ruby_add_rdepend "
	dev-ruby/nokogiri
	dev-ruby/crack
	dev-ruby/curb
"

# make sure no eclass is running tests
RESTRICT="test"

# opennebula-4.12.0/work/opennebula-4.12.0
S="${S}/${P}"

ONEUSER="oneadmin"
ONEGROUP="oneadmin"

pkg_setup () {
	enewgroup ${ONEGROUP}
	if use qemu; then
		enewuser ${ONEUSER} -1 /bin/bash /var/lib/one "${ONEGROUP},kvm,qemu"
	else
		enewuser ${ONEUSER} -1 /bin/bash /var/lib/one "${ONEGROUP}"
	fi
}

src_unpack() {
	default
}

src_prepare() {
    epatch "${FILESDIR}/OpenNebulaVNC.rb.diff"
    epatch "${FILESDIR}/websocketproxy.py.diff"
    epatch "${FILESDIR}/websocket.py.diff"
}


src_configure() {
	:
}

src_compile() {
	local myconf="new_xmlrpc=yes "

	use mysql \
		&& myconf+="mysql=yes " \
		|| myconf+="mysql=no "

	use sqlite \
		&& myconf+="sqlite=yes " \
		|| myconf+="sqlite=no "

	use syslog \
		&& myconf+="syslog=yes "

	# FIXME
	# creates minified css and js only, it is not required for sunstone to run
	# fails because it needs grunt, sass and possibly something else
	#use sunstone \
	#	&& myconf+="sunstone=yes "

	if use frontend; then
		scons \
			${myconf} \
			$(sed -r 's/.*(-j\s*|--jobs=)([0-9]+).*/-j\2/' <<< ${MAKEOPTS}) \
			|| die "building ${PN} failed"
	fi
}

src_install() { 
	if use node; then
		src_install_node
	elif use frontend; then
		src_install_frontend
	fi
}

src_install_node() {
	dodir /var/{lib,log,run,tmp}/one /var/lib/one/{datastores,remotes} || die "dodir failed"
}

src_install_frontend() {
	DESTDIR="${T}/one" ./install.sh -u "$ONEUSER" -g "$ONEGROUP"
	cd "${T}/one"
	# installing things for real
	dodir /var/{lib,lock,log,run,tmp}/one /var/lib/one/datastores /usr/$(get_libdir)/one /usr/share/one  || die "dodir failed"
	cp -a lib/* "${D}/usr/$(get_libdir)/one/" || die "copying lib files failed"
	cp -a var/remotes "${D}/var/lib/one/" || die "copying remotes failed"
	cp -a share/websockify "${D}/usr/share/one/" || die "copying websockify failed"
	dobin bin/*
    doman share/man/*/*[0-9].gz
	insinto /usr/share/doc/${PF}
	doins -r share/docs/*
	doins -r share/examples
	doenvd "${FILESDIR}/99one"
	newinitd "${FILESDIR}/opennebula.initd" opennebula
	newconfd "${FILESDIR}/opennebula.confd" opennebula
	newinitd "${FILESDIR}/sunstone-server.initd" sunstone-server
	newconfd "${FILESDIR}/sunstone-server.confd" sunstone-server
	newinitd "${FILESDIR}/oneflow-server.initd" oneflow-server
	newconfd "${FILESDIR}/oneflow-server.confd" oneflow-server
	insinto /etc/one
	insopts -m 0640
	doins -r etc/*
	doins "${FILESDIR}/one_auth"
	doins "${FILESDIR}/tmpfilesd.opennebula.conf"
	fowners -R root:${ONEGROUP} /etc/one
	fowners ${ONEUSER}:${ONEGROUP} /etc/one/one_auth
}

src_install_sunstone() {
	:
}

src_install_gate() {
	:
}

src_install_flow() {
	:
}

pkg_postinst() {
	chown -R oneadmin:oneadmin ${ROOT}var/{lock,lib,log,run,tmp}/one

	if use qemu ; then
		elog "Make sure that the user ${ONEUSER} has access to the libvirt"
		elog "control socket /var/run/libvirt/libvirt-sock"
		elog "To check this as ${ONEUSER} user issue command:"
		elog "  virsh -c qemu:///system nodeinfo"
		echo ""
		elog "Make sure to set user = ${ONEUSER} and group = ${ONEGROUP} and"
		elog "dynamic_ownership = 0 in /etc/libvirt/qemu.conf."
		echo ""
		elog "OpenNebula doesn't allow you to specify the disc format."
		elog "Unfortunately the default in libvirt is not to guess and"
		elog "it therefores assumes a 'raw' format when using qemu/kvm."
		elog "Set 'allow_disk_format_probing = 0' in /etc/libvirt/qemu.conf"
		elog "to work around this until OpenNebula fixes it."
	fi


#	local onedir="${EROOT}var/lib/one"
#	if [ ! -d "${onedir}/.ssh" ] ; then
#		einfo "Generating ssh-key..."
#		umask 0027 || die "setting umask failed"
#		mkdir "${onedir}/.ssh" || die "creating ssh directory failed"
#		ssh-keygen -q -t dsa -N "" -f "${onedir}/.ssh/id_dsa" || die "ssh-keygen failed"
#		cat > "${onedir}/.ssh/config" <<EOF
#UserKnownHostsFile /dev/null
#Host *
#    StrictHostKeyChecking no
#EOF
#		cat "${onedir}/.ssh/id_dsa.pub"  >> "${onedir}/.ssh/authorized_keys" || die "adding key failed"
#		chown -R ${ONEUSER}:${ONEGROUP} "${onedir}/.ssh" || die "changing owner failed"
#	fi
}
