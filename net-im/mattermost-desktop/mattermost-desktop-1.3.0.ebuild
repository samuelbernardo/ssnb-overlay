# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=mattermost-desktop

EAPI=5

inherit eutils unpacker

DESCRIPTION="Mattermost chat desktop client for Linux"
HOMEPAGE="https://github.com/mattermost/desktop"
SRC_URI="https://github.com/mattermost/desktop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS=""
IUSE=""

DEPEND="
	net-libs/nodejs[npm]
"
RDEPEND="
	${DEPEND}
	gnome-base/gconf
	!net-im/mattermost
"

src_compile() {
	default

	npm install || die "npm install failed!"
	npm run package || die "npm run package failed!"
}

src_install() {
	cp -R "${WORKDIR}" "${D}/usr/lib/mattermost" || die "Install failed!"

	ln -s "/usr/lib/mattermost/Mattermost" "${D}/usr/bin/mattermost" || die "Install failed!"

	#cp "${WORKDIR}/LICENSE" "${D}/usr/share/licenses/${PN}/LICENSE" || die "Install failed!"

	cp "${WORKDIR}/src/resources/appicon.png" "${D}/usr/share/pixmaps/${PN}.png" || die "Install failed!"
	make_desktop_entry /usr/bin/mattermost "Mattermost Desktop" ${PN} "GNOME;GTK;Network;InstantMessaging;" || die "Install failed!"
}

