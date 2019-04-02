# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="O Autenticação.gov.pt é o mecanismo que permite utilizar o Cartão de Cidadão eficientemente e em segurança nos navegadores que suportem ou não plugins Java"
HOMEPAGE="https://www.autenticacao.gov.pt/"

inherit unpacker eutils

SRC_URI="https://autenticacao.gov.pt/fa/ajuda/software/plugin-autenticacao-gov.deb"

LICENSE="EUPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/pcsc-lite
	sys-apps/pcsc-tools
	app-crypt/ccid
	( >=virtual/jdk-1.8:1.8 || ( >=dev-java/oracle-jdk-bin-1.8:1.8 dev-java/icedtea dev-java/icedtea-bin ) )"
RDEPEND="${DEPEND}
	!app-misc/autenticacao-gov-pt:2
	!app-misc/autenticacao-gov-pt:3"

src_unpack() {
	default
	unpack_deb ${A}
}

src_prepare() {
	default
}

src_configure() {
	true
}

src_compile() {
	true
}

src_install() {
	# deb install
	cp -R "${WORKDIR}/usr" "${D}" || die "Error: copy files in install phase failed!"
}

