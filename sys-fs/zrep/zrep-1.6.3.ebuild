# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
#PYTHON_COMPAT=( python2_7 )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="
		https://github.com/bolthole/zrep.git
		git@github.com:bolthole/zrep.git"
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
#else
#	SRC_URI="http://.../${P}.tar.bz2"
#	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
else
	scm_eclass=git-r3
	EGIT_REPO_URI="
		https://github.com/bolthole/zrep.git
		git@github.com:bolthole/zrep.git"
	EGIT_COMMIT="v$PV"
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools eutils user ${scm_eclass}

DESCRIPTION="ZFS based replication and failover solution"
HOMEPAGE="http://www.bolthole.com/solaris/zrep/"

LICENSE="ZREP"
SLOT="0"
#IUSE=""

CDEPEND="
	sys-apps/nawk
	"
DEPEND="${CDEPEND}
	"
RDEPEND="${CDEPEND}
	app-shells/ksh
	sys-fs/zfs
	"
src_install() {
	# copy zrep script to expected directory
	into /usr
	dosbin zrep
}

