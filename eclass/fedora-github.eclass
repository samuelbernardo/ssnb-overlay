# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/git-r3.eclass,v 1.47 2014/07/28 14:13:50 mgorny Exp $

# @ECLASS: fedora-github.eclass
# @MAINTAINER:
# Pavel šimerda <pavlix@pavlix.net>
# @BLURB: Eclass for fetching and unpacking github repositories.
# @DESCRIPTION:
# An extension of the git-r3 eclass that makes it easier to fetch
# sources from github.

inherit git-r3

GITHUB_PROJECT="${GITHUB_PROJECT:-"${PN}"}"
GITHUB_USER="${GITHUB_USER:-"${GITHUB_PROJECT}"}"
GITHUB_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}"

EGIT_REPO_URI="${EGIT_REPO_URI:-"${GITHUB_URI}.git"}"
HOMEPAGE="${GITHUB_URI}"
