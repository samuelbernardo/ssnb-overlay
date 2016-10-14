EAPI=5

inherit eutils versionator

#EAP='-EAP'
#PVERSION='11'
PV_STRING="$(get_version_component_range 3-5)"
MY_PV="$(get_version_component_range 1-2)"
MY_PN="WebStorm"

HOMEPAGE="http://www.jetbrains.com/webstorm/"
DESCRIPTION="Most Intelligent WebStorm IDE for develop on js html css, 11 EAP version"
SRC_URI="https://download.jetbrains.com/webstorm/${MY_PN}-${MY_PV}.tar.gz"

KEYWORDS=""

PROGNAME="WebStorm"
RESTRICT="strip mirror"
DEPEND=">=virtual/jre-1.6"
SLOT="0"
S="${WORKDIR}/${MY_PN}-${PV_STRING}"

src_install() {
	dodir /opt/${PN}

	cd WebStorm-*/
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/webstorm.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "Chmod failed"
	dosym /opt/${PN}/bin/webstorm.sh /usr/bin/${PN}
	
	#mv "bin/webstorm.svg" "bin/${PN}.svg"
	doicon "bin/${PN}.svg"
	make_desktop_entry ${PN} "${PROGNAME}" "${PN}"
}
pkg_postinst() {
    elog "Run /usr/bin/${PN}"
}

