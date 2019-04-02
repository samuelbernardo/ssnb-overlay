# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for authenticating with https://www.autenticacao.gov.pt/"
HOMEPAGE="https://www.autenticacao.gov.pt/"

inherit subversion unpacker eutils

#SRC_URI="https://autenticacao.gov.pt/fa/ajuda/software/autenticacao.gov.pt.deb"
ESVN_REPO_URI="https://svn.gov.pt/projects/ccidadao/repository/middleware-offline/tags/version${PV}-5238/source/_src/eidmw"
ESVN_PATCHES="${FILESDIR}/*.patch"

LICENSE="EUPL"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+java"

DEPEND="sys-apps/pcsc-lite
	sys-apps/pcsc-tools
	app-crypt/ccid
	>=dev-qt/qtcore-5
	dev-qt/qtchooser
	dev-libs/xml-security-c
	dev-libs/xerces-c
	app-text/poppler
	java? ( >=virtual/jdk-1.8:1.8 || ( >=dev-java/oracle-jdk-bin-1.8:1.8 dev-java/icedtea dev-java/icedtea-bin ) )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/qmake.patch"
	)

src_unpack() {
	default
	subversion_src_unpack
	#if use java; then unpack_deb ${A}; fi
	if use java; then
		unpack_deb ${FILESDIR}/autenticacao.gov.pt-${PV}.deb
		unpack ${FILESDIR}/extras-${PV}.tar.gz
	fi
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
		emake INSTALL_ROOT="${D}" DESTDIR="${D}" install || die "Error: emake install failed"
	else
		die "Error: install phase failed because is missing Makefile!"
	fi

	# deb install
	if use java; then
		cp -R "${WORKDIR}/usr" "${D}" || die "Error: copy files in install phase failed!"
	fi
}

