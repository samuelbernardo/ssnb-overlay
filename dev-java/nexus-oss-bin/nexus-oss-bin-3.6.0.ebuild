# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils user versionator systemd

DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
MY_PN="nexus-oss-bin"
MY_PV=$(replace_version_separator 3 '-')"-02"
#echo "Debug: custom package version: ${MY_PV}"
MY_P="${MY_PN}-${MY_PV}"

SRC_URI="http://download.sonatype.com/nexus/3/nexus-${PV}-02-unix.tar.gz"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="3"
IUSE=""
S="${WORKDIR}"
#echo "Debug: working directory: ${WORKDIR}"
RDEPEND=">=virtual/jdk-1.8"
INSTALL_DIR="/opt/nexus-oss"

pkg_setup() {
#enewgroup <name> [gid]
enewgroup nexus
#enewuser <user> [uid] [shell] [homedir] [groups] [params]
enewuser nexus -1 /bin/bash "${INSTALL_DIR}" "nexus"
}

src_unpack() {
unpack ${A}
cd "${S}"
if -f "${FILESDIR}/${P}.patch"; then
	epatch "${FILESDIR}/${P}.patch"
fi
}

src_install() {
#echo "Debug: INSTALL_DIR: ${INSTALL_DIR}"
#echo "Debug: doins nexus-${MY_PV}"
#echo "Debug: ${WORKDIR}/nexus-${MY_PV}/bin/nexus"
insinto ${INSTALL_DIR}

dodir ${INSTALL_DIR}/run
dodir "/etc/init.d/"
doins -r nexus-${MY_PV}/*
doins -r nexus-${MY_PV}/.install4j
#BUG: nexus init script needs a symlink because it uses program path to find their configuration files
#newinitd "${WORKDIR}/nexus-${MY_PV}/bin/nexus" nexus
dosym ${INSTALL_DIR}/bin/nexus /etc/init.d/nexus
systemd_dounit "${FILESDIR}"/nexus-oss.service

fowners -R nexus:nexus ${INSTALL_DIR}
fperms 755 "${INSTALL_DIR}/bin/nexus"

}
