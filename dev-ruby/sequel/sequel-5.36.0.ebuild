# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A lightweight database toolkit for Ruby"
HOMEPAGE="https://sequel.jeremyevans.net/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Unpackaged dependencies
RESTRICT="test"

ruby_add_bdepend "test? ( dev-ruby/rspec )"
