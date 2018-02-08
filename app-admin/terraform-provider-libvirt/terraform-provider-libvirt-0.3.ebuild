# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/dmacvicar"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_HAVE_TEST=1

inherit golang-single versionator

#GOLANG_PKG_VERSION="$(get_version_component_range 1-2)"

DESCRIPTION="Terraform builds, changes, and combines infrastructure safely and efficiently"
HOMEPAGE="http://www.terraform.io"

LICENSE="Apache 2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-emulation/libvirt-glib
	dev-lang/go
	app-cdr/cdrtools"

DOCS=(
	README.md
	examples/
)

src_install() {
	golang-single_src_install
}
