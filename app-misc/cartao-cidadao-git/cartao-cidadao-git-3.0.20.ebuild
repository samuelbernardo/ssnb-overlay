# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for authenticating with https://www.autenticacao.gov.pt/"
HOMEPAGE="https://svn.gov.pt/projects/ccidadao"

inherit git-r3 unpacker eutils

EGIT_CLONE_TYPE="single"
EGIT_REPO_URI="https://github.com/amagovpt/autenticacao.gov.git"
EGIT_COMMIT="v$PV"

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
	app-text/poppler
	dev-libs/libzip"
RDEPEND="${DEPEND}
	!app-misc/autenticacao-gov-pt:2
	!app-misc/cartao-cidadao-svn"

PATCHES=(
	#"${FILESDIR}/*.${PV}.patch"
	)

src_unpack() {
	default
	git-r3_fetch
	git-r3_checkout
	unpack ${FILESDIR}/extras-${PV}.tar.gz
}

src_prepare() {
	default
	cd "${S}"
	rm -rf ./docs README.md license.txt
	mv pteid-mw-pt/_src/eidmw/* .
	rm -rf pteid-mw-pt
}

src_configure() {
	# configure
	if [[ -x ${ECONF_SOURCE:-.}/configure ]] ; then
		${ECONF_SOURCE:-.}/configure || die "Error: econf failed"
	elif [[ -f ${ECONF_SOURCE:-.}/configure ]] ; then
		fperms 755 ${ECONF_SOURCE:-.}/configure
		${ECONF_SOURCE:-.}/configure || die "Error: econf failed"
	else
		default
	fi
}

src_compile() {
	# qmake
	if [ -f pteid-mw.pro ]; then
		qmake pteid-mw.pro
	else
		die "Error: compile phase failed because is missing pteid-mw.pro!"
	fi

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

