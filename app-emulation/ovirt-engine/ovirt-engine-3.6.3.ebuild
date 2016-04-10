# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

CHECKREQS_MEMORY="8G"

inherit eutils versionator rpm

MY_PV="$(get_version_component_range 1-2)"

DESCRIPTION="oVirt Engine"
HOMEPAGE="http://www.ovirt.org"
SRC_URI="http://resources.ovirt.org/pub/ovirt-3.6/rpm/el7Server/SRPMS/ovirt-engine-3.6.3.4-1.el7.centos.src.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+system-jars"
RESTRICT="mirror"

# Need to test if the file can be unpacked with rpmoffset and cpio
# If it can't then set:

#DEPEND="app-arch/rpm"

# To force the use of rpmoffset and cpio instead of rpm2cpio from
# app-arch/rpm, then set the following:

#USE_RPMOFFSET_ONLY=1

#JBOSS_HOME="/usr/share/ovirt/wildfly"

DEPEND=">=virtual/jdk-1.7
		app-arch/rpm"
RDEPEND="${PYTHON_DEPS}
	>=virtual/jre-1.7
	app-emulation/ovirt-wildfly-bin
	app-misc/mime-types
	dev-db/postgresql
	dev-lang/python-exec
	dev-libs/libxml2[python]
	dev-libs/openssl
	dev-python/cheetah
	dev-python/m2crypto
	dev-python/psycopg
	dev-python/python-daemon
	dev-python/websockify
	net-dns/bind-tools
	sys-libs/cracklib[python]
	dev-python/numpy
	www-apps/novnc
	www-apps/patternfly:1
	www-apps/spice-html5
	www-servers/apache[apache2_modules_headers,apache2_modules_proxy_ajp,ssl]"



src_unpack () {
	mkdir -p "${S}"
	cd "${S}"
	rpm_src_unpack ${A}
	#EPATCH_SOURCE="${WORKDIR}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
}

pkg_pretend() {
	if has network-sandbox ${FEATURES} ; then
		die "Please disable network-sandbox from FEATURES"
	fi
}

pkg_postinst() {
	ewarn "Setup of ovirt-engine-wildfly-overlay..."
	echo "ENGINE_JAVA_MODULEPATH="/usr/share/ovirt-engine-wildfly-overlay/modules:${ENGINE_JAVA_MODULEPATH}"" \
	  > $PREFIX/etc/ovirt-engine/engine.conf.d/20-setup-jboss-overlay.conf

	ewarn "You should enable proxy by adding the following to /etc/conf.d/apache2"
	ewarn '   APACHE2_OPTS="${APACHE2_OPTS} -D PROXY"'

	elog "To configure package:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_config() {
	/usr/bin/engine-setup
}
