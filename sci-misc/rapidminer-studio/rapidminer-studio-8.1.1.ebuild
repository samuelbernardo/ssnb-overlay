# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="RapidMiner Studio Free"
HOMEPAGE="http://rapidminer.com/"
SRC_URI="https://s3.amazonaws.com/rapidminer.releases/rapidminer-studio/${PV}/rapidminer-studio-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

#RESTRICT="fetch"

DEPEND=">=virtual/jdk-1.8"
RDEPEND="${DEPEND}"

#pkg_nofetch {
#    einfo "Please download ${P}.zip from ${HOMEPAGE}"
#	einfo "and place them in ${DISTDIR}"
#}

src_unpack() {
	if [ "${A}" != "" ]; then
		unpack ${A}
	fi
	ln -sf "$WORKDIR/rapidminer-studio" "$WORKDIR/$P"
}

src_configure() {
	return
}

src_compile() {
	return
}

src_install() {
	local RAPIDDIR="opt/rapidminer/${PV}"
	dodir "$RAPIDDIR"
	cp -a "${S}/"* "${D}/${RAPIDDIR}"
	cp "${FILESDIR}/rapidminer-studio-logo.png" "${D}/${RAPIDDIR}"
	dodir usr/share/applications
	cat <<DESKTOP > "$D/usr/share/applications/rapidminer-studio.desktop"
[Desktop Entry]
Name=RapidMiner Studio $PV
Type=Application
Comment=RapidMiner Studio
Exec=/$RAPIDDIR/RapidMiner-Studio.sh
Icon=/$RAPIDDIR/rapidminer-studio-logo.png
Categories=Science;
DESKTOP
}

