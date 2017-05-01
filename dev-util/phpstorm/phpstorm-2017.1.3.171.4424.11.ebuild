EAPI=6
inherit eutils versionator

PV_STRING="$(get_version_component_range 4-6)"
MY_PV="$(get_version_component_range 1-3)"
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
	insinto /opt/${PN}
	doins -r *

	fperms a+x /opt/${PN}/bin/phpstorm.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "Chmod failed"
	dosym /opt/${PN}/bin/phpstorm.sh /usr/bin/${PN}

	mv "bin/webide.png" "bin/${PN}.png"
	doicon "bin/${PN}.png"
	make_desktop_entry ${PN} "${PROGNAME}" "${PN}"
}

pkg_postinst() {
    elog "Run /usr/bin/${PN}"
}


