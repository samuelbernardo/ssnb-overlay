# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/dvds/DVDS}
WX_GTK_VER=3.0

inherit wxwidgets

DESCRIPTION="A cross-platform free DVD authoring application"
HOMEPAGE="http://www.dvdstyler.org/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libav +udev"

COMMON_DEPEND="
	>=app-cdr/dvd+rw-tools-7.1
	media-libs/libexif:=
	>=media-libs/wxsvg-1.5.19:=
	>=media-video/dvdauthor-0.7.0
	>=media-video/xine-ui-0.99.7
	virtual/cdrtools
	>=app-cdr/cdrtools-2.01
	libav? ( >=virtual/ffmpeg-9:0=[libav=] )
	!libav? ( >=media-video/ffmpeg-2.6:0=[encode] )
	virtual/jpeg:0
	x11-libs/wxGTK:${WX_GTK_VER}=[gstreamer,X]
	sys-apps/dbus
	udev? ( >=virtual/libudev-215:= )
"
RDEPEND="${COMMON_DEPEND}
	>=app-cdr/dvdisaster-0.72.4
	media-video/mjpegtools
"
DEPEND="${COMMON_DEPEND}
	app-arch/zip
	app-text/xmlto
	>=sys-devel/gettext-0.17
	virtual/yacc
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	need-wxwidgets unicode
	# disable obsolete GNOME 2.x libraries wrt #508854
	sed -i -e '/PKG_CONFIG/s:libgnomeui-2.0:dIsAbLeAuToMaGiC&:' configure || die
	# rmdir: failed to remove `tempfoobar': Directory not empty
	sed -i -e '/rmdir "$$t"/d' docs/Makefile.in || die
	# fix underlinking wrt #367863
	sed -i -e 's:@LIBS@:& -ljpeg:' wxVillaLib/Makefile.in || die
	# silence desktop-file-validate QA check
	sed -i \
		-e '/Icon/s:.png::' -e '/^Encoding/d' -e '/Categories/s:Application;::' \
		data/dvdstyler.desktop || die
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable debug) \
		--with-wx-config=${WX_CONFIG}
}

src_install() {
	default
	rm -f "${ED}"/usr/share/doc/${PF}/{COPYING*,INSTALL*}
}
