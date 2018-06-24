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

NPM_EXTRA_FILES="bin internal-tasks"
NPM_BIN="${PN}"

RDEPEND="dev-nodejs/grunt-cli
         dev-nodejs/mkdirp
		 dev-nodejs/minimatch
		 dev-nodejs/js-yaml
		 dev-nodejs/iconv-lite
		 dev-nodejs/grunt-legacy-util
		 dev-nodejs/grunt-legacy-log
		 dev-nodejs/glob
		 dev-nodejs/exit
		 dev-nodejs/eventemitter2
		 dev-nodejs/dateformat
		 dev-nodejs/coffeescript"
