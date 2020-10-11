# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7
inherit eutils desktop

SLOT="$(ver_cut 1)"
RDEPEND=">=virtual/jdk-1.7"

MY_PN="RubyMine"
MY_PV="$(ver_cut 1-3)"
RESTRICT="strip"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="The most intelligent Ruby and Rails IDE"
HOMEPAGE="http://jetbrains.com/ruby/"
SRC_URI="http://download.jetbrains.com/ruby/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="all-rights-reserved"
IUSE="jbr11"
KEYWORDS="~amd64 ~x86"
S=${WORKDIR}/${MY_PN}-${MY_PV}

src_prepare() {
	# Remove non-linux libs
	rm -vrf "${S}"/lib/libpty/macosx
	rm -vrf "${S}"/lib/libpty/win

	if use !jbr11; then
		rm -vrf "${S}"/jbr
	fi

	# Java config
	#if use amd64; then local SUFFIX="64"; fi
	#sed -i 's/lcd/on/' "${S}/bin/${PN}${SUFFIX}.vmoptions"
	#echo "-Dswing.aatext=true" >> "${S}/bin/${PN}${SUFFIX}.vmoptions"

	eapply_user
}

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-${SLOT}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}/bin/${PN}.sh" "${dir}/bin/rinspect.sh" "${dir}/bin/fsnotifier" "${dir}/bin/fsnotifier64"
	if use jbr11; then
		fperms 755 "${dir}/jbr/bin/*"
	fi

	newicon "bin/${PN}.png" "${exe}.png"
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
	make_desktop_entry ${exe} "RubyMine ${MY_PV}" "${exe}" "Development;IDE"
}
