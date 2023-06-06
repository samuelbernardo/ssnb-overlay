# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="This pure Ruby library can read and write PNG images without depending on an external image library, like RMagick."
HOMEPAGE="https://github.com/wvanbergen/chunky_png/wiki"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

