# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git-2

DESCRIPTION="Tool to store the metadata of files,directories,links in a file tree"
HOMEPAGE="https://github.com/przemoc/metastore"
EGIT_REPO_URI="https://github.com/przemoc/metastore.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README || die "docs install failed"
}

