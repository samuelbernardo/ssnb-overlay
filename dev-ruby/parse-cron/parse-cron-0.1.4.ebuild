# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

inherit ruby-fakegem

DESCRIPTION="Parse a crontab timing specification and determine when the job should be run."
HOMEPAGE="https://github.com/siebertm/parse-cron"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"

