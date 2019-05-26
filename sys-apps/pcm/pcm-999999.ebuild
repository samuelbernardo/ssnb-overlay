# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils multilib git-r3


DESCRIPTION="A Qt-based program for syncing your MEGA account in your PC. This is the official app."
HOMEPAGE="http://mega.co.nz"
if [[ ${PV} == *999999* ]];then
	EGIT_REPO_URI="https://github.com/meganz/MEGAsync"
	KEYWORDS=""
	EGIT_SUBMODULES=( '*' )
else
	MYPV=$(ver_cut 1)
	EGIT_REPO_URI="https://github.com/opcm/pcm.git"
	EGIT_COMMIT="${MYPV}"
	EGIT_SUBMODULES=( '*' )
	KEYWORDS="~x86 ~amd64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="Intel"
SLOT="0"
IUSE=""

#DEPEND=""
#RDEPEND="${DEPEND}"

PATCHES=( )

if [[ ${PV} != *999999* ]];then
	src_prepare(){
		default
	}
fi

src_configure(){
	true
}

src_compile(){
	cd "${S}"
	emake INSTALL_ROOT="${D}" || die
}

src_install(){
	insinto usr/share/licenses/${PN}
	doins LICENCE

	newbin pcm.x pcm
	newbin pcm-numa.x pcm-numa
	newbin pcm-latency.x pcm-latency
	newbin pcm-power.x pcm-power
	newbin pcm-sensor.x pcm-sensor
	newbin pcm-msr.x pcm-msr
	newbin pcm-memory.x pcm-memory
	newbin pcm-tsx.x pcm-tsx
	newbin pcm-pcie.x pcm-pcie
	newbin pcm-core.x pcm-core
	newbin pcm-iio.x pcm-iio
	newbin pcm-lspci.x pcm-lspci
	newbin pcm-pcicfg.x pcm-pcicfg

	into usr/lib/${PN}
	dolib.a libPCM.a
}
