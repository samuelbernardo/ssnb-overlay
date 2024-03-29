EAPI=8

inherit desktop

PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="PhpStorm"

HOMEPAGE="http://www.jetbrains.com/phpstorm/"
DESCRIPTION="PhpStorm"
#SRC_URI="http://download.jetbrains.com/webide/PhpStorm-EAP-${PV_STRING}.tar.gz -> ${MY_PN}-${PV_STRING}.tar.gz"
SRC_URI="https://download.jetbrains.com/webide/PhpStorm-${MY_PV}.tar.gz -> ${MY_PN}-${PV_STRING}.tar.gz"

if [[ x${PV} != 'x9999' ]]; then
	KEYWORDS="~x86 ~amd64"
else
	KEYWORDS=""
fi

PROGNAME="PHP Storm"

RESTRICT="strip mirror"

QA_PREBUILT="
    opt/${PN}/bin/fsnotifier-arm
"

DEPEND="|| ( >=virtual/jre-1.8 >=virtual/jdk-1.8 )"
SLOT="0"
S=${WORKDIR}

src_install() {
	dodir /opt/${PN}

	cd PhpStorm*/
	sed -i 's/IS_EAP="true"/IS_EAP="false"/' bin/phpstorm.sh
	doicon "bin/${PN}.png"
	make_desktop_entry ${PN} "${PROGNAME}" "${PN}"
	rm "bin/${PN}.png" "bin/${PN}.svg"

	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/*.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/restart.py || die "Chmod failed"
	dosym /opt/${PN}/bin/phpstorm.sh /usr/bin/${PN}
}

pkg_postinst() {
    elog "Run /usr/bin/${PN}"
}


