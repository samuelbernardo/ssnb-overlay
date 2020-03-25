# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-vcs-snapshot

EGO_PN="github.com/golang/dep"
DESCRIPTION="A Go's dependency management tool"
HOMEPAGE="https://github.com/golang/dep"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -o bin/dep ./cmd/dep || die
}

src_install() {
	dodoc README.md CHANGELOG.md
	dobin bin/dep
}
