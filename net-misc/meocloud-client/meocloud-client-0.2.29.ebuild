# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils prefix versionator

# This is a list of archs supported by this update.
AT_AVAILABLE=( amd64 x86 )

AT_amd64="https://meocloud.pt/binaries/linux/x86_64/meocloud-latest_x86_64.tar.gz"
AT_x86="https://meocloud.pt/binaries/linux/i386/meocloud-latest_i386.tar.gz"

DESCRIPTION="meocloud client"
HOMEPAGE="https://meocloud.pt/downloads"

SLOT=0
KEYWORDS="~amd64 ~x86"

for d in "${AT_AVAILABLE[@]}"; do
    SRC_URI+=" ${d}? ( $(eval "echo \${$(echo AT_${d/-/_})}")"
    SRC_URI+=" )"
done
unset d

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

