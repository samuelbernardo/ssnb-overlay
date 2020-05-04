# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

SLOT="2"
RUBY_FAKEGEM_NAME="${PN}_${SLOT}"

inherit ruby-fakegem

DESCRIPTION="Ruby library designed to make manipulation of IPv4 and IPv6 addresses."
HOMEPAGE="https://github.com/ipaddress2-gem/ipaddress_2"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

