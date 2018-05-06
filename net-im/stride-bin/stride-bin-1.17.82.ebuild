# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils unpacker xdg-utils xdg versionator

MY_PN="${PN/-bin/}"

DESCRIPTION="Stride desktop client"
HOMEPAGE="https://www.stride.com/"
SRC_URI="https://packages.atlassian.com/${MY_PN}-apt-client/pool/${MY_PN}_${PV}_amd64.deb -> ${P}.deb"
LICENSE="no-source-code"
RESTRICT="mirror"

SLOT="$(get_major_version)"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

QA_PREBUILT="opt/${PN}/*"

S="${WORKDIR}/usr/lib/${MY_PN}"

src_prepare() {
	sed -i -e 's:Network;::' "${WORKDIR}/usr/share/applications/${MY_PN}.desktop"
	eapply_user
}

src_install() {
	exeinto "/opt/${PN}"
	doexe "${MY_PN}"

	insinto "/opt/${PN}"
	doins *.pak *.so icudtl.dat natives_blob.bin snapshot_blob.bin version
	doins -r locales resources

	insinto /usr/share
	doins -r "${WORKDIR}/usr/share/icons"

	make_wrapper "${MY_PN}" "./${MY_PN}" "/opt/${PN}" .

	domenu "${WORKDIR}/usr/share/applications/${MY_PN}.desktop"
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
