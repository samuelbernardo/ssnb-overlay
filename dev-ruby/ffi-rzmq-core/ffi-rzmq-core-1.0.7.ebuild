# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

SLOT="0"
RUBY_FAKEGEM_NAME="${PN}"

inherit ruby-fakegem

DESCRIPTION="This gem provides only the FFI wrapper for the ZeroMQ (0mq) networking library."
HOMEPAGE="http://github.com/chuckremes/ffi-rzmq-core"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE=""

