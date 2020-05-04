# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

inherit ruby-fakegem

DESCRIPTION="Parse a crontab timing specification and determine when the job should be run."
HOMEPAGE="https://github.com/siebertm/parse-cron"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"

