# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit findlib autotools

DESCRIPTION="Provides support for internationalization of OCaml program"
HOMEPAGE="https://github.com/gildor478/ocaml-gettext"
SRC_URI="https://github.com/gildor478/ocaml-gettext/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
#IUSE="doc test"
#RESTRICT="!test? ( test )"
IUSE=""

RDEPEND=">=dev-lang/ocaml-3.12.1:=
	>=dev-ml/ocaml-fileutils-0.4.0:=
	>=dev-ml/camomile-0.8.3:=
	sys-devel/gettext
	dev-ml/camlp4:=
	"
#DEPEND="${RDEPEND}
#	doc? ( app-text/docbook-xsl-stylesheets dev-libs/libxslt )
#	test? ( dev-ml/ounit )"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
}

src_configure() {
	:
}

src_compile() {
	emake -j1 build
}

src_install() {
	findlib_src_preinst
	emake -j1 DESTDIR="${D}" \
		BINDIR="${ED}/usr/bin" \
		PODIR="${ED}/usr/share/locale/" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		MANDIR="${ED}/usr/share/man" \
		install

	#findlib_src_install DATADIR="${ED}/usr/share" BINDIR="${ED}/usr/bin"
}
