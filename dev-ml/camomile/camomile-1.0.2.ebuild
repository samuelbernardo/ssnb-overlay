# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib

DESCRIPTION="Camomile is a comprehensive Unicode library for ocaml"
SRC_URI="https://github.com/yoriyuki/Camomile/releases/download/${PV}/${P}.tbz"

LICENSE="LGPL-2"
SLOT="0/${PV}"
KEYWORDS="amd64 ppc x86"
IUSE="+ocamlopt"

RDEPEND="
	>=dev-lang/ocaml-4.02.3:=[ocamlopt?]
	dev-ml/camlp4:=
"
DEPEND="
	${RDEPEND}
	>=dev-ml/dune-1.11.4
	"

src_prepare() {
#	has_version '>=dev-lang/ocaml-4.05_beta' && epatch "${FILESDIR}/ocaml405.patch"
	epatch "${FILESDIR}/dune-workspace-${PV}.patch"
	epatch "${FILESDIR}/Makefile-${PV}.patch"
	epatch "${FILESDIR}/${P}.patch"
	eapply_user
}

#src_configure() {
#	econf $(use_enable debug)
#}

src_compile() {
	#emake -j1 all-supported-ocaml-versions
	emake -j1 build
}

src_install() {
	dodir /usr/bin
	emake PREFIX=${ED} install
	findlib_src_install DATADIR="${ED}/usr/share" BINDIR="${ED}/usr/bin"
}
