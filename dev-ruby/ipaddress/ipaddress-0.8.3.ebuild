# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="1"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="Ruby library designed to make manipulation of IPv4 and IPv6 addresses."
HOMEPAGE="https://github.com/bluemonk/ipaddress"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

