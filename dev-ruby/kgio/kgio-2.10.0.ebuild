# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README TODO HACKING"

inherit ruby-fakegem multilib

DESCRIPTION="Mon-blocking I/O methods for Ruby without raising exceptions"
HOMEPAGE="http://bogomips.org/kgio.git/ http://bogomips.org/kgio/ https://rubygems.org/gems/kgio"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3.0
	<dev-ruby/test-unit-4 )"

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/kgio_ext$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib -S testrb test/test_*.rb || die
}
