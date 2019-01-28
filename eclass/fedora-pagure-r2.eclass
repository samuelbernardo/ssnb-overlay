# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: fedora-pagure-r2.eclass
# @MAINTAINER:
# Samuel Bernardo <samuelbernardo.mail@gmail.com>
# @BLURB: Eclass for fetching and unpacking pagure repositories.
# @DESCRIPTION:
# An extension of the git-r3 eclass that makes it easier to fetch
# sources from pagure.

inherit git-r3

PAGURE_PROJECT="${PAGURE_PROJECT:-"${PN}"}"
PAGURE_USER="${PAGURE_USER:-"${PAGURE_PROJECT}"}"
PAGURE_URI="https://pagure.io/${PAGURE_USER}/${PAGURE_PROJECT}"

EGIT_REPO_URI="${EGIT_REPO_URI:-"${PAGURE_URI}.git"}"
HOMEPAGE="${PAGURE_URI}"
