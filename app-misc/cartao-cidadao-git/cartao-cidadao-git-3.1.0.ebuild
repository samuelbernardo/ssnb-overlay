# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tools for authenticating with https://www.autenticacao.gov.pt/"
HOMEPAGE="https://svn.gov.pt/projects/ccidadao"

inherit git-r3 unpacker eutils

EGIT_CLONE_TYPE="single"
EGIT_REPO_URI="https://github.com/amagovpt/autenticacao.gov.git"
EGIT_COMMIT="v$PV"

SRC_URI="https://www.autenticacao.gov.pt/documents/10179/11962/Autenticacao.gov_Ubuntu_20_x64.deb"

LICENSE="EUPL"
SLOT="3"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/swig
        dev-libs/xml-security-c"
RDEPEND="${DEPEND}
        >=sys-apps/pcsc-lite-1.5.0
	sys-apps/pcsc-tools
	app-crypt/ccid
	>=dev-qt/qtcore-5
	dev-qt/qtchooser
	dev-libs/xml-security-c
	dev-libs/xerces-c
	dev-vcs/subversion
	>=dev-libs/openssl-1.0.0 <dev-libs/openssl-1.1
	app-text/poppler[qt5]
	dev-libs/libzip
	net-misc/curl
	dev-qt/qtgraphicaleffects
	dev-qt/qtquickcontrols
	dev-qt/qtquickcontrols2
	!app-misc/autenticacao-gov-pt:2
	!app-misc/cartao-cidadao-svn"

PATCHES=(
	#"${FILESDIR}/*.${PV}.patch"
	)

src_unpack() {
	unpacker_src_unpack
	git-r3_fetch
	git-r3_checkout
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
		emake INSTALL_ROOT="${ED}" DESTDIR="${ED}" install || die "Error: emake install failed"
	else
		die "Error: install phase failed because is missing Makefile!"
	fi

	# install additional icons and images from ubuntu package
	dodir /usr/share/pixmaps
	dodir /usr/share/applications
	dodir /usr/share/doc/pteid-mw
	dodir /usr/share/icons/hicolor/64x64/mimetypes
	dodir /usr/share/icons/hicolor/scalable/apps
	dodir /usr/local/lib/pteid_jni
	insinto /usr/share/pixmaps
	doins "${WORKDIR}"/usr/share/pixmaps/pteid-signature.png
	insinto /usr/share/applications
	doins "${WORKDIR}"/usr/share/applications/pteid-mw-gui.desktop
	insinto /usr/share/doc/pteid-mw
	doins "${WORKDIR}"/usr/share/doc/pteid-mw/copyright
	doins "${WORKDIR}"/usr/share/doc/pteid-mw/changelog.Debian.gz
	insinto /usr/share/icons/hicolor/64x64/mimetypes
	doins "${WORKDIR}"/usr/share/icons/hicolor/64x64/mimetypes/gnome-mime-application-x-signedcc.png
	doins "${WORKDIR}"/usr/share/icons/hicolor/64x64/mimetypes/application-x-signedcc.png
	insinto /usr/share/icons/hicolor/scalable/apps
	doins "${WORKDIR}"/usr/share/icons/hicolor/scalable/apps/pteid-scalable.svg
	insinto /usr/local/lib/pteid_jni
	doins "${WORKDIR}"/usr/local/lib/pteid_jni/pteidlibj.jar
}

