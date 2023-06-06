# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

inherit ruby-fakegem

DESCRIPTION="This client only supports Zendesk's v2 API."
HOMEPAGE="https://github.com/zendesk/zendesk_api_client_rb"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ruby_add_rdepend ">=dev-ruby/faraday-0.9.0 <dev-ruby/faraday-2.0.0
                  >=dev-ruby/hashie-3.5.2 <dev-ruby/hashie-5.0.0
	          dev-ruby/inflection
	          dev-ruby/mime-types
	          >dev-ruby/multipart-post-2.0"
