# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="Support library for inflections."
HOMEPAGE="http://github.com/Tass/extlib/tree/inflection"

LICENSE=""
KEYWORDS="~amd64"
IUSE=""

