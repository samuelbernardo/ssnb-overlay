# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib autotools

DESCRIPTION="Pure OCaml functions to manipulate real file (POSIX like) and filename"
HOMEPAGE="http://forge.ocamlcore.org/projects/ocaml-fileutils"
SRC_URI="https://github.com/gildor478/ocaml-fileutils/archive/v${PV}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/ocaml-3.12.1:=
	>=dev-ml/camomile-0.8.3:=
	"
DEPEND="${RDEPEND}
	>=dev-ml/ounit-2.0.0"

src_prepare() {
	epatch "${FILESDIR}/${P}.patch"
	eapply_user
}

src_compile() {
	emake -j1 build all
}

src_install() {
	findlib_src_preinst
	emake -j1 DESTDIR="${D}" \
		BINDIR="${ED}/usr/bin" \
		PODIR="${ED}/usr/share/locale/" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		MANDIR="${ED}/usr/share/man" \
		install
}
