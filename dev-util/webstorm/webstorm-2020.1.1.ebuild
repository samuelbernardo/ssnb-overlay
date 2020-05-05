# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils readme.gentoo-r1 xdg

PROGNAME="WebStorm"
DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="http://www.jetbrains.com/webstorm/"
SRC_URI="http://download.jetbrains.com/webstorm/${PROGNAME}-${PV}.tar.gz"

PROGNAME="WebStorm"
LICENSE="IDEA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_VER="201.7223.93"

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

	rm -rf jre || die
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
