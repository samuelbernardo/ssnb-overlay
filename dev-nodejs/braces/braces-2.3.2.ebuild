# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit npm

DESCRIPTION="A package manager for the web"
HOMEPAGE="https://www.npmjs.com/package/bower"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

NPM_EXTRA_FILES="lib"

RDEPEND="dev-nodejs/to-regex dev-nodejs/arr-flatten dev-nodejs/array-unique dev-nodejs/extend-shallow dev-nodejs/fill-range dev-nodejs/repeat-element dev-nodejs/snapdragon dev-nodejs/snapdragon-node dev-nodejs/split-string"
