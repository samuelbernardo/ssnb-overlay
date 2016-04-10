EAPI=5
inherit eutils
#EAP='-EAP'
#PVERSION='11'
HOMEPAGE="http://www.jetbrains.com/webstorm/"
DESCRIPTION="Most Intelligent WebStorm IDE for develop on js html css, 11 EAP version"
#SRC_URI="https://download.jetbrains.com/webstorm/WebStorm${EAP}-${PVERSION:-${PV}}.tar.gz"
SRC_URI="https://download.jetbrains.com/webstorm/WebStorm-${PVERSION:-${PV}}.tar.gz"

if [[ x${PVERSION} != 'x' ]]; then
	KEYWORDS="x86 amd64"
else
	KEYWORDS="~x86 ~amd64"
fi

PROGNAME="WebStorm"
RESTRICT="strip mirror"
DEPEND=">=virtual/jre-1.6"
SLOT="0"
S=${WORKDIR}
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

