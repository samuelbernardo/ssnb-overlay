# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for authenticating with https://www.autenticacao.gov.pt/"
HOMEPAGE="https://svn.gov.pt/projects/ccidadao"

inherit subversion unpacker eutils

ESVN_REPO_URI="https://svn.gov.pt/projects/ccidadao/repository/middleware-offline/tags/version${PV}/_src/eidmw"
ESVN_PATCHES="${FILESDIR}/*.patch"

LICENSE="EUPL"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-apps/pcsc-lite-1.5.0
	sys-apps/pcsc-tools
	app-crypt/ccid
	>=dev-qt/qtcore-5
	dev-qt/qtchooser
	dev-libs/xml-security-c
	dev-libs/xerces-c
	dev-vcs/subversion
	dev-libs/openssl
	media-libs/jasper
	app-text/poppler"
RDEPEND="${DEPEND}
	!app-misc/autenticacao-gov-pt:2"

PATCHES=(
	"${FILESDIR}/qmake.patch"
	"${FILESDIR}/dlgQndPinpadInfo.cpp.patch"
	"${FILESDIR}/XadesSignature.cpp.patch"
	)

src_unpack() {
	default
	subversion_src_unpack
	unpack ${FILESDIR}/extras-${PV}.tar.gz
}

src_prepare() {
	default
}

src_configure() {
	# configure
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		${ECONF_SOURCE:-.}/configure || die "Error: econf failed"
	elif [[ -f ${ECONF_SOURCE:-.}/configure ]] ; then
		fperms 755 ${ECONF_SOURCE:-.}/configure
		${ECONF_SOURCE:-.}/configure || die "Error: econf failed"
	else
		die "Error: ${ECONF_SOURCE:-.}/configure doesn't exists"
	fi
}

src_compile() {
	# make
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake || die "Error: emake failed"
	else
		die "Error: compile phase failed because is missing Makefile!"
	fi
}

src_install() {
	# make install
	if [[ -f Makefile ]] || [[ -f GNUmakefile ]] || [[ -f makefile ]] ; then
		emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "Error: emake install failed"
	else
		die "Error: install phase failed because is missing Makefile!"
	fi

	# extras install
	cp -R "${WORKDIR}/usr" "${D}" || die "Error: copy files in install phase failed!"
}

