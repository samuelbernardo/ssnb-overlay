# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="O plugin Autenticação.Gov (anteriormente designado por aplicação Autenticação.gov.pt) permite realizar o procedimento de autenticação com o Cartão de Cidadão sem necessidade de efetuar a instalação de qualquer componente no navegador"
HOMEPAGE="https://autenticacao.gov.pt/fa/ajuda/autenticacaogovpt.aspx"

inherit unpacker eutils desktop

SRC_URI="https://aplicacoes.autenticacao.gov.pt/plugin/plugin-autenticacao-gov.deb -> ${P}.deb"

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

S="${WORKDIR}/"

parse_icons() {
	regex="([^_]+)_([0-9]+).png$"
	cd /usr/share/plugin-${P}
	for file in *.png
	do
		if [[ $file  =~ $regex ]]
		then
			icon="${BASH_REMATCH[1]##*/}"
			size="${BASH_REMATCH[2]}"
			newicon -s "${size}" "${file}" "${icon}"
		fi
	done
}

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
	regex="(.*)_([0-9]+).png$"
	for file in "${D}/usr/share/plugin-${P}"/*.png
	do
		if [[ ${file}  =~ ${regex} ]]
		then
			icon_aux="${BASH_REMATCH[1]##*/}"
			icon="${icon_aux//_/-}"
			size="${BASH_REMATCH[2]}"
			insinto "/usr/share/icons/hicolor/${size}x${size}/apps"
			newicon -s "${size}" "${file}" "${icon}"
		fi
	done
}

