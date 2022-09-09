# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit desktop multilib

DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/rhboot/pesign"
SRC_URI="https://github.com/rhboot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE="libressl"

RDEPEND="
	dev-libs/nspr
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"

src_install() {
	default

	# remove some files that don't make sense for Gentoo installs
	rm -rf "${ED}/etc/" "${ED}/usr/share/doc/pesign/" || die

	# create .so symlink
	ln -s libdpe.so "${ED}/usr/$(get_libdir)/libdpe.so.0"
}
