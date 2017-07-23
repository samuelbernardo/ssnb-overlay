# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 autotools user 

AM_OPTS="-i" #define eautoreconf options
#AT_NOELIBTOOLIZE="yes" #disable elibtoolize because eautoreconf is crashing at this phase

if [[ $PV = *9999* ]]; then
	EGIT_REPO_URI="
		https://github.com/libguestfs/supermin.git
		git@github.com:libguestfs/supermin.git"
	EGIT_SUBMODULES=( '*' )
	SRC_URI=""
	KEYWORDS=""
else
	EGIT_REPO_URI="
		https://github.com/libguestfs/supermin.git
		git@github.com:libguestfs/supermin.git"
	EGIT_SUBMODULES=( '*' )
	EGIT_COMMIT="v$PV"
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Tool for creating supermin appliances"
HOMEPAGE="http://libguestfs.org"

LICENSE="GPL"
SLOT="0"
IUSE="test"

DEPEND="
	dev-lang/ocaml
	dev-ml/findlib[-tk]
	dev-lang/perl
	app-shells/bash
	sys-devel/gcc
	sys-apps/gawk
	>=sys-devel/prelink-20151030
	app-arch/cpio
	"
RDEPEND="
	sys-fs/e2fsprogs
	!<=dev-util/febootstrap-3.21
	"

src_prepare() {
	"${S}/.gnulib/gnulib-tool" --update >/dev/null 2>&1 || die "gnulib-tool --update failed!"
	eautoreconf
	eapply_user
}

src_configure() {
	econf $(use_enable !test disable-network-tests)
}

src_install() {
	emake DESTDIR="${D}" install
}

