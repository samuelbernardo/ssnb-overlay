# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils prefix versionator

# This is a list of archs supported by this update.
AT_AVAILABLE=( amd64 x86 )

T_amd64="meocloud-latest_amd64.tar.gz"
T_x86="meocloud-latest_x86.tar.gz"

DESCRIPTION="meocloud client"
HOMEPAGE="https://meocloud.pt/downloads"

SLOT=0
KEYWORDS="amd64 x86"

for d in "${AT_AVAILABLE[@]}"; do
    SRC_URI+=" ${d}? ( $(eval "echo \${$(echo AT_${d/-/_})}")"
    if has ${d} "${DEMOS_AVAILABLE[@]}"; then
        SRC_URI+=" examples? ( $(eval "echo \${$(echo DEMOS_${d/-/_})}") )"
    fi
    SRC_URI+=" )"
done
unset d

src_install() {
	cp -a ${S}/* ${D};
}


