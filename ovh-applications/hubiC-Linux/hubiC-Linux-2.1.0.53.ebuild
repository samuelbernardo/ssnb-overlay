# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Command line interface for the hubiC online storage solution"
HOMEPAGE="https://forums.hubic.com/showthread.php?272-hubiC-for-Linux-beta-is-out-!"
SRC_URI="http://mir7.ovh.net/ovh-applications/hubic/${PN}/2.1.0/${P}-linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
