# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="2"
RUBY_FAKEGEM_NAME="${PN}_${SLOT}"

inherit ruby-fakegem

DESCRIPTION="Ruby library designed to make manipulation of IPv4 and IPv6 addresses."
HOMEPAGE="https://github.com/ipaddress2-gem/ipaddress_2"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

