# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool for authenticating with https://www.autenticacao.gov.pt/"
HOMEPAGE="https://www.autenticacao.gov.pt/"

inherit subversion

#SRC_URI=""
ESVN_REPO_URI="https://svn.gov.pt/projects/ccidadao/repository/middleware-offline/tags/version${PV}/source/trunk/_src/eidmw"
ESVN_PATCHES="${FILESDIR}/*.patch"

LICENSE="EUPL"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/pcsc-lite
	dev-java/icedtea
	sys-apps/pcsc-tools
	app-crypt/ccid
	>=dev-qt/qtcore-5
	dev-qt/qtchooser
	dev-libs/xml-security-c
	dev-libs/xerces-c
	app-text/poppler"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/qmake.patch" )

src_unpack() {
	default
	subversion_src_unpack
}

src_prepare() {
	if declare -p PATCHES | grep -q "^declare -a "; then
		[[ -n ${PATCHES[@]} ]] && eapply "${PATCHES[@]}" || die "Error: failed to apply ebuild patches ${PATCHES}!"
	else
		[[ -n ${PATCHES} ]] && eapply ${PATCHES} || die "Error: failed to apply ebuild patches ${PATCHES}!"
	fi
	eapply_user
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
		emake DESTDIR="${D}" install || die "Error: emake install failed"
	else
		die "Error: install phase failed because is missing Makefile!"
	fi
}

