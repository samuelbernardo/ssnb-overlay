# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="A gem that shortcuts typing out forms and tables for SQL users"
HOMEPAGE="http://rubygems.org/gems/make"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Unpackaged dependencies
RESTRICT="test"

ruby_add_bdepend "test? ( dev-ruby/rspec )"
