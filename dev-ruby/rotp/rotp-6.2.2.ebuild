# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="Works for both HOTP and TOTP, and includes QR Code provisioning."
HOMEPAGE="http://github.com/mdp/rotp"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/addressable"
