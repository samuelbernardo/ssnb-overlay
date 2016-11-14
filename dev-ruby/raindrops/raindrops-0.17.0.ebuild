# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README NEWS TODO LATEST"

inherit ruby-fakegem multilib

DESCRIPTION="A real-time stats toolkit to show statistics for Rack HTTP servers"
HOMEPAGE="https://rubygems.org/gems/raindrops http://raindrops.bogomips.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

#ruby_add_bdepend "test? ( >=dev-ruby/aggregate-0.2
#	<dev-ruby/aggregate-1
#	>=dev-ruby/io-extra-1.2.3
#	>=dev-ruby/io-extra-1.2
#	<dev-ruby/io-extra-2
#	>=dev-ruby/olddoc-1.0
#	<dev-ruby/olddoc-2
#	>=dev-ruby/posix_mq-2.0
#	<dev-ruby/posix_mq-3
#	>=dev-ruby/rack-1.2
#	<dev-ruby/rack-3
#	>=dev-ruby/test-unit-3.0
#	<dev-ruby/test-unit-4 )"

each_ruby_configure() {
	${RUBY} -Cext/raindrops extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/raindrops
	cp ext/raindrops/raindrops_ext$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test/test_*.rb || die
}
