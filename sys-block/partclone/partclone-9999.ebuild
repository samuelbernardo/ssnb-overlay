# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_IN_SOURCE_BUILD=1

inherit autotools-utils git-2

DESCRIPTION="Back up and restore used-blocks of a partition"
HOMEPAGE="http://partclone.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Thomas-Tsai/partclone"
EGIT_BRANCH="release"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+extfs +fat exfat hfsp jfs +ntfs reiserfs reiser4 ufs xfs f2fs nilfs2 minix vmfs btrfs"

DEPEND="reiserfs? ( sys-fs/progsreiserfs )
	exfat? ( sys-fs/exfat-utils )
	ntfs? ( sys-fs/ntfs3g )
	extfs? ( sys-libs/e2fsprogs-libs )
	reiser4? ( sys-fs/reiser4progs )
	reiserfs? ( sys-fs/progsreiserfs )
	xfs? ( sys-fs/xfsprogs )
	ufs? ( sys-fs/ufsutils )
	jfs? ( sys-fs/jfsutils )
	btrfs? ( sys-fs/btrfs-progs )
	nilfs2? ( >=sys-fs/nilfs-utils-2.1.5-r1 )
	f2fs? ( >=sys-libs/e2fsprogs-libs-1.42.13 )"
	# sys-libs/ncurses[tinfo]
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

my_use_enable() {
	use $1 && echo --enable-$1
}

src_prepare() {
	sed -i '/SUBDIRS/s/tests//' "${S}/Makefile.am" || die
	sed -i 's/sizeof(badsector_magic)/(strlen(badsector_magic) + 1)/' "${S}/src/partclone.c" || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(my_use_enable extfs)
		$(my_use_enable fat)
		$(my_use_enable hfsp)
		$(my_use_enable jfs)
		$(my_use_enable ntfs)
		$(my_use_enable reiserfs)
		$(my_use_enable reiser4)
		$(my_use_enable ufs)
		$(my_use_enable xfs)
		$(my_use_enable f2fs)
		$(my_use_enable nilfs2)
		$(my_use_enable minix)
		$(my_use_enable vmfs)
		$(my_use_enable btrfs)
		)
	autotools-utils_src_configure
}
