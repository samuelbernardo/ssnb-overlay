# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="rqrcode_core is a Ruby library for encoding QR Codes."
HOMEPAGE="https://github.com/whomwah/rqrcode_core"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

