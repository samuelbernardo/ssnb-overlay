# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# http://repo.sinew.in/dists/stable/main/binary-{amd64,i386}/Packages

EAPI=5

inherit eutils unpacker

DESCRIPTION="A cross-platform, complete password management solution that securely manages passwords and all other life important credentials like bank accounts, Credit cards, IDs, passport, driving licenses etc. Everything is saved locally on user’s device and optionally he can sync through other devices using his accounts of Dropbox, Box, Google Drive, OneDrive, iCloud and ownCloud."
HOMEPAGE="http://enpass.io/apps/linux/"
SRC_URI="amd64? ( http://repo.sinew.in/pool/main/e/enpass/enpass_${PV}_amd64.deb )
         x86?  ( http://repo.sinew.in/pool/main/e/enpass/enpass_${PV}_i386.deb )"

LICENSE="SINEW"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	app-arch/unzip
	dev-libs/openssl
	dev-libs/libappindicator:2
	x11-libs/libXScrnSaver
	x11-libs/libX11
	sys-libs/glibc
	sys-devel/gcc
	sys-libs/zlib
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/libXau
	x11-libs/libXdmcp
	dev-db/sqlcipher
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	dev-qt/qtsql:5
	dev-qt/qtgui:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	dev-qt/qtmultimedia:5
"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack_deb "${A}"
	S="${WORKDIR}"
}

#src_prepare() {
	#epatch "${FILESDIR}"'/fix-rc-.desktop-Icon-key.patch'
	#rm -r "${WORKDIR}"/opt/Enpass/lib
#}

src_install() {
	cp -R "${WORKDIR}/usr" "${D}" || die "Install failed!"
	cp -R "${WORKDIR}/opt" "${D}" || die "Install failed!"
}

pkg_postinst() {
	elog "Enpass browser extentions are available from the website:"
	elog "https://enpass.io/enpass-browser-extension/"
}

pkg_postinst() {
	elog "Enpass introduces browser extentions in this version."
	elog "To install the Chrome extention, visit the chrome store:"
	elog "https://chrome.google.com/webstore/detail/enpass-password-manager-r/kmcfomidfpdkfieipokbalgegidffkal"
	elog ""
	elog "The Firefox extention is provided, and is located at:"
	elog "/opt/Enpass_RC/share/Firefox/enpass_rc_firefox.xpi"
	elog ""
	elog "For local extention install guide for Firefox, visit:"
	elog "https://developer.mozilla.org/en-US/Add-ons/Installing_extensions"
	elog "(Open the Extentions page and drag the file onto it)"
}
