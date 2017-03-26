# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

YEAR=2016
MONTH=07

DESCRIPTION="ssh agent plugin for KeePass 2.x"
HOMEPAGE="http://lechnology.com/software/keeagent/"
SRC_URI="http://lechnology.com/wp-content/uploads/${YEAR}/${MONTH}/KeeAgent_v${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=app-admin/keepass-2.19"
RDEPEND="${DEPEND}"

INSTALL_DIR="/usr/lib/keepass/"
PLUGIN_FILENAME="KeeAgent.plgx"
S="${WORKDIR}"

src_install() {
	chmod 644 "${PLUGIN_FILENAME}"
	insinto "${INSTALL_DIR}"
	doins "${PLUGIN_FILENAME}"
}

pkg_postinst() {
	elog "Restart KeePass to complete the installation."
}
