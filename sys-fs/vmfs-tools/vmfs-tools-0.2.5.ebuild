# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Tools for vmfs"
HOMEPAGE="http://glandium.org/projects/vmfs-tools/"
SRC_URI="http://glandium.org/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fuse"

RDEPEND="sys-apps/util-linux
	fuse? ( sys-fs/fuse )"

DEPEND="${RDEPEND}
	app-text/asciidoc
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-buildsystem.patch
	tc-export CC AR RANLIB
	export NO_STRIP=1
	export WANT_FUSE=$(usex fuse 1 "")
}
