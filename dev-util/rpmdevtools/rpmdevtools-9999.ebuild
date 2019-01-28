# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rpmdevtools/rpmdevtools-8.3-r1.ebuild,v 1.2 2013/06/04 21:40:33 bicatali Exp $

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4} )

inherit fedora-fedorahosted git-r3 python-r1 autotools

DESCRIPTION="Collection of rpm packaging related utilities"

LICENSE="GPL-2"
SLOT="0"
IUSE="emacs"

COMMON_DEPEND="
	${PYTHON_DEPS}
	app-arch/rpm[${PYTHON_USEDEP}]
	net-misc/curl
	emacs? ( app-emacs/rpm-spec-mode )
	dev-util/checkbashisms
"
DEPEND="
	${COMMON_DEPEND}
	dev-lang/perl
	sys-apps/help2man
"
RDEPEND="
	${COMMON_DEPEND}
"

#src_prepare() {
#	python_copy_sources
#}

src_prepare() {
	[ "${PV}" = 9999 ] && eautoreconf
}

#src_configure() {
#	python_foreach_impl run_in_build_dir econf
#}

#src_compile() {
#	python_foreach_impl run_in_build_dir make
#}
#
#src_compile() {
#	python_foreach_impl run_in_build_dir make install DESTDIR=${ED}
#}
