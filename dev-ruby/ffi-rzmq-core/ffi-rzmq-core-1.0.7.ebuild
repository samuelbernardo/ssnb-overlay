# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="This gem provides only the FFI wrapper for the ZeroMQ (0mq) networking library."
HOMEPAGE="http://github.com/chuckremes/ffi-rzmq-core"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

