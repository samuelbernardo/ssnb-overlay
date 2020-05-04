# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="This pure Ruby library can read and write PNG images without depending on an external image library, like RMagick."
HOMEPAGE="https://github.com/wvanbergen/chunky_png/wiki"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

