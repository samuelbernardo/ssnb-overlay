# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/git-r3.eclass,v 1.47 2014/07/28 14:13:50 mgorny Exp $

# @ECLASS: ixit-fedorahosted.eclass
# @MAINTAINER:
# Pavel šimerda <pavlix@pavlix.net>
# @BLURB: Eclass for fetching and unpacking fedorahosted repositories.
# @DESCRIPTION:
# A standalone eclass to be used with git-r3 or other VCS eclasses to work with fedorahosted
# repositories.

FEDORAHOSTED_PROJECT="${PN}"
HOMEPAGE="https://fedorahosted.org/${FEDORAHOSTED_PROJECT}"
EGIT_REPO_URI="https://git.fedorahosted.org/git/${PN}"
EBZR_REPO_URI="bzr://bzr.fedorahosted.org/bzr/${PN}/devel"
[ ${PV} = 9999 ] || SRC_URI="http://fedorahosted.org/releases/${PN:0:1}/${PN:1:1}/${PN}/${P}.tar.bz2"
