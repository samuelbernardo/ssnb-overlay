# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="KNOWN_ISSUES ISSUES HACKING PHILOSOPHY README SIGNALS FAQ DESIGN"

inherit ruby-fakegem

DESCRIPTION="An HTTP server for Rack applications"
HOMEPAGE="https://rubygems.org/gems/unicorn http://bogomips.org/unicorn.git http://unicorn.bogomips.org/"

LICENSE="GPL-2+ Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/kgio-2.6
	<dev-ruby/kgio-3
	dev-ruby/rack
	>=dev-ruby/raindrops-0.7
	<dev-ruby/raindrops-1"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3.0
	<dev-ruby/test-unit-4 )"

RESTRICT="test"

each_ruby_configure() {
	${RUBY} -Cext/unicorn_http extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/unicorn_http
	cp ext/unicorn_http/unicorn_http$(get_modname) lib/ || die
}

all_ruby_install() {
	all_fakegem_install
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test/unit/test_*.rb
}
