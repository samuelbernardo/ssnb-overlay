# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P="Arduino"
DESCRIPTION="An open-source AVR electronics prototyping platform"
HOMEPAGE="http://arduino.cc/ https://arduino.googlecode.com/"
SRC_URI="https://github.com/arduino/${MY_P}/archive/${PV}.tar.gz -> arduino-${PV}.tar.gz"
LICENSE="GPL-2 GPL-2+ LGPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}-${PV}"

src_install() {
	#cd "${S}"/build/linux/work || die
	cd "${S}" || die

	insinto "/usr/share/arduino/"
	doins -r hardware libraries
	fowners -R root:uucp "/usr/share/arduino/hardware"

	dosym /usr/bin/avrdude "/usr/share/arduino/hardware/tools/avrdude"
	dosym /etc/avrdude.conf "/usr/share/arduino/hardware/tools/avrdude.conf"

	mkdir -p "${D}/usr/share/arduino/hardware/tools/avr/etc/"
	dosym /etc/avrdude.conf "/usr/share/arduino/hardware/tools/avr/etc/avrdude.conf"
}
