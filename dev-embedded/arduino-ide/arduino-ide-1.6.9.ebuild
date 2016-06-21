# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc examples"

inherit eutils java-pkg-2 java-ant-2

MY_P="Arduino"
PNS="arduino"
DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="http://arduino.cc/ https://arduino.googlecode.com/"
SRC_URI="https://github.com/arduino/${MY_P}/archive/${PV}.tar.gz -> arduino-${PV}.tar.gz
	 mirror://gentoo/arduino-icons.tar.bz2"
LICENSE="GPL-2 GPL-2+ LGPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip binchecks"
IUSE=""

COMMONDEP="
dev-java/jna:0
>dev-java/rxtx-2.1:2"

RDEPEND="${COMMONDEP}
dev-embedded/arduino-libs
dev-embedded/avrdude
sys-devel/crossdev
>=virtual/jre-1.8"

DEPEND="${COMMONDEP}
>=virtual/jdk-1.8"

S="${WORKDIR}/${MY_P}-${PV}"
EANT_GENTOO_CLASSPATH="jna,rxtx-2"
EANT_EXTRA_ARGS="-Dversion=${PV}"
EANT_BUILD_TARGET="build"
JAVA_ANT_REWRITE_CLASSPATH="yes"

java_prepare() {
	# Patch launcher script to include rxtx class/ld paths
	epatch "${FILESDIR}/${P}-script.patch"
}

src_compile() {
	eant -f arduino-core/build.xml
	EANT_GENTOO_CLASSPATH_EXTRA="../core/core.jar"
	eant -f app/build.xml
	eant "${EANT_EXTRA_ARGS}" -f build/build.xml
}

src_install() {
	cd "${S}"/build/linux/work || die
	java-pkg_dojar lib/*.jar
	java-pkg_dolauncher ${PNS} --pwd /usr/share/${PNS} --main processing.app.Base

	if use examples; then
		java-pkg_doexamples examples
		docompress -x /usr/share/doc/${P}/examples/
	fi

	if use doc; then
		dodoc revisions.txt "${S}"/README.md
		dohtml -r reference
	fi

	insinto "/usr/share/${PNS}/"
	#doins -r hardware libraries tools tools-builder dist
	doins -r tools tools-builder dist
	#fowners -R root:uucp "/usr/share/${PNS}/hardware"

	insinto "/usr/share/${PNS}/lib"
	doins -r lib/*.txt lib/theme lib/*.png lib/*.bmp lib/*.key lib/*.so lib/*.ico lib/*.conf

	# install menu and icons
	sed -e 's/Exec=FULL_PATH\/arduino/Exec=arduino/g' -i arduino.desktop
	sed -e 's/Icon=FULL_PATH\/lib\/arduino.png/Icon=arduino/g' -i arduino.desktop
	sed -e 's/x-arduino/x-arduino;/g' -i arduino.desktop
	domenu "${PNS}.desktop"
	for sz in 16 24 32 48 128 256; do
		newicon -s $sz \
			"${WORKDIR}/${PNS}-icons/debian_icons_${sz}x${sz}_apps_${PNS}.png" \
			"${PNS}.png"
	done
}

pkg_postinst() {
	[ ! -x /usr/bin/avr-g++ ] && ewarn "Missing avr-g++; you need to crossdev -s4 avr"

	elog "I have *NOT* tested if this ebuild even works, because I don't use it myself."
	elog "If you encounter issues with the installation, please report them to me, and"
	elog "I will try my best to fix them."
}
