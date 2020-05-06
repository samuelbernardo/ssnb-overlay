# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils gnome2-utils readme.gentoo-r1 xdg

MY_PV="$(ver_cut 1-3)"
SRC_VER="$(ver_cut 4-6)"

PROGNAME="WebStorm"
DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/webstorm/"
SRC_URI="http://download.jetbrains.com/${PN}/${PROGNAME}-${MY_PV}.tar.gz"

PROGNAME="WebStorm"
LICENSE="IDEA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-jbr11"

RDEPEND=">=virtual/jre-1.8"

RESTRICT="mirror strip"

QA_PREBUILT="opt/${PN}/bin/fsnotifier
	opt/${PN}/bin/fsnotifier64
	opt/${PN}/bin/fsnotifier-arm
	opt/${PN}/bin/libyjpagent-linux.so
	opt/${PN}/bin/libyjpagent-linux64.so"

S="${WORKDIR}/${PROGNAME}-${SRC_VER}"

src_prepare() {
	default

	use !jbr11 && rm -rf jre || die
}

src_install() {
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/{webstorm.sh,fsnotifier{,64},inspect.sh}

	dosym ../../opt/${PN}/bin/webstorm.sh /usr/bin/${PN}
	newicon bin/webstorm.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
}
