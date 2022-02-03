# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

inherit eutils prefix

DESCRIPTION="meocloud client"
HOMEPAGE="https://meocloud.pt/downloads"

SLOT=0
KEYWORDS="~amd64 ~x86"

SRC_URI="
	x86? ( https://meocloud.pt/binaries/linux/i386/meocloud-latest_i386_beta.tar.gz -> ${P}_i386.tar.gz )
	amd64? ( https://meocloud.pt/binaries/linux/x86_64/meocloud-latest_x86_64_beta.tar.gz -> ${P}_x86_64.tar.gz )
	"

QA_PRESTRIPPED="
		opt/meocloud/cli/.*
		opt/meocloud/core/*"

QA_FLAGS_IGNORED="*"

src_unpack() {
    if [ "${A}" != "" ]; then
	mkdir -p ${S}
	cd "${S}"
        unpack ${A}
    fi
}

src_install() {
	cp -a ${S}/* ${D};
}

