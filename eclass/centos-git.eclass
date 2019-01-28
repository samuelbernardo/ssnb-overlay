# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/git-r3.eclass,v 1.47 2014/07/28 14:13:50 mgorny Exp $

# @ECLASS: centos.eclass
# @MAINTAINER:
# Pavel šimerda <pavlix@pavlix.net>
# @BLURB: Eclass for fetching and unpacking github repositories.
# @DESCRIPTION:
# An extension of the git-r3 eclass that makes it easier to fetch
# sources from github.

inherit git-r3

CENTOS_PROJECT="${CENTOS_PROJECT:-"${PN}"}"
CENTOS_URI="https://git.centos.org/summary/${CENTOS_PROJECT}"

EGIT_REPO_URI="https://git.centos.org/git/${CENTOS_PROJECT}.git"
HOMEPAGE="${CENTOS_URI}"
