# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

SLOT="1"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="Ruby library designed to make manipulation of IPv4 and IPv6 addresses."
HOMEPAGE="https://github.com/bluemonk/ipaddress"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

