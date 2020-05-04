# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="Works for both HOTP and TOTP, and includes QR Code provisioning."
HOMEPAGE="http://github.com/mdp/rotp"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/addressable"
