# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

USE_RUBY="ruby19 ruby20 ruby21 ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Parse a crontab timing specification and determine when the job should be run."
HOMEPAGE="https://github.com/siebertm/parse-cron"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"

