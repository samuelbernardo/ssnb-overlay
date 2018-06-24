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

NPM_EXTRA_FILES="support"

RDEPEND="dev-nodejs/component-emitter
	 dev-nodejs/get-value
	 dev-nodejs/source-map
	 dev-nodejs/map-cache
	 dev-nodejs/source-map-resolve"
