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
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="
	net-libs/nodejs[npm]
"
RDEPEND="
	${DEPEND}
	gnome-base/gconf
	!net-im/mattermost
"

MY_P="${P/mattermost-/}"
S="${WORKDIR}/${MY_P}"

src_compile() {
	default

	npm install || die "npm install failed!"
	npm run package || die "npm run package failed!"
}

src_install() {
	dodir /usr/lib
	if use amd64; then
		_release="Mattermost-linux-x64"
	elif use x86; then
		_release="Mattermost-linux-ia32"
	else
		die "Architecture not supported!"
	fi
	cp -R "${S}/release/${_release}" "${D}usr/lib/mattermost" || die "Install failed!"

	dodir /usr/bin
	fperms a+x /usr/lib/mattermost/Mattermost
	dosym "/usr/lib/mattermost/Mattermost" "/usr/bin/mattermost" || die "Install failed!"

	#cp "${S}/LICENSE" "${D}usr/share/licenses/${PN}/LICENSE" || die "Install failed!"

	dodir /usr/share/pixmaps
	#cp "${S}/src/resources/appicon.png" "${D}usr/share/pixmaps/${PN}.png" || die "Install failed!"
	insinto /usr/share/pixmaps
	newins "src/resources/appicon.png" "${PN}.png"
	make_desktop_entry /usr/bin/mattermost "Mattermost Desktop" ${PN} "GNOME;GTK;Network;InstantMessaging;" || die "Install failed!"
}

