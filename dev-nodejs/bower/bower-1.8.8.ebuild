# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit npm

DESCRIPTION="A package manager for the web"
HOMEPAGE="https://www.npmjs.com/package/bower"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

NPM_EXTRA_FILES="bin packages"
NPM_BIN="${PN}"

src_prepare() {
    default
    sed -i -e "s|../lib/bin/|../$(get_libdir)/node_modules/bower/lib/bin/|" "bin/${NPM_BIN}" || die "Failed to correct path for bower lib"
}
