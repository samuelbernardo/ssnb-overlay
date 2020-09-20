# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Gem for Ruby development"
HOMEPAGE="https://github.com/JoshHadik/RubyDev"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Unpackaged dependencies
RESTRICT="test"

ruby_add_rdepend ">dev-ruby/bundler-1.16 >dev-ruby/rake-10.0.0 >dev-ruby/rspec-3.0.0"
ruby_add_bdepend "test? ( dev-ruby/rspec )"
