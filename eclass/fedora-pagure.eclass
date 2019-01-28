# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: pavlix
# Purpose: Fetch projects from Fedora Pagure.
#

inherit git-r3

PAGURE_PROJECT="${PN}"
EGIT_REPO_URI="${EGIT_REPO_URI:-"https://pagure.io/${PAGURE_PROJECT}.git"}"
HOMEPAGE="https://pagure.io/${PAGURE_PROJECT}/"
