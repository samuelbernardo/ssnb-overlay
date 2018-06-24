# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NPM_EXTRA_FILES="benchclean.js common.js oh-my-glob.gif sync.js prof.sh make-benchmark-fixture.sh benchmark.sh"

inherit npm

DESCRIPTION="A package manager for the web"
HOMEPAGE="https://www.npmjs.com/package/bower"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-nodejs/fs-realpath
         dev-nodejs/inflight
		 dev-nodejs/inherits
		 dev-nodejs/minimatch
		 dev-nodejs/minimatch
		 dev-nodejs/once
		 dev-nodejs/path-is-absolute"
