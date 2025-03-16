# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GOLANG_PKG_IMPORTPATH="github.com/dmacvicar"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_VERSION="$(ver_cut 1-3)"

inherit go-module

EGO_SRC="${GOLANG_PKG_IMPORTPATH}/${PN}"
EGO_PN=${EGO_SRC}/...
EGIT_COMMIT="${GOLANG_PKG_ARCHIVEPREFIX}${GOLANG_PKG_VERSION}"
SRC_URI="https://${EGO_SRC}/archive/${GOLANG_PKG_ARCHIVEPREFIX}${GOLANG_PKG_VERSION}.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Terraform provider to provision infrastructure with Linux's KVM using libvirt"
HOMEPAGE="https://github.com/dmacvicar/terraform-provider-libvirt"

LICENSE="Apache 2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="network-sandbox"

RDEPEND="app-emulation/libvirt-glib
	dev-lang/go
	app-cdr/cdrtools
	app-admin/terraform"

DOCS=(
	README.md
	examples/
)

