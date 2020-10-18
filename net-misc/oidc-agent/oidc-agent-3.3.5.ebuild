# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils git-r3

DESCRIPTION="A set of tools to manage OpenID Connect tokens and make them easily usable from the command line"
HOMEPAGE="https://github.com/indigo-dc/oidc-agent"
RTAG="_so"
if [[ ${PV} == *9999* ]];then
	EGIT_REPO_URI="https://github.com/indigo-dc/oidc-agent"
	KEYWORDS=""
	#EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR=${WORKDIR}/${P}
else
	EGIT_REPO_URI="https://github.com/LIP-Computing/oidc-agent"
	EGIT_BRANCH="v${PV}${RTAG}"
	#EGIT_SUBMODULES=( '*' )
	EGIT_CHECKOUT_DIR=${WORKDIR}/${P}
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="sys-apps/help2man
	"
RDEPEND="${DEPEND}
	net-libs/libmicrohttpd
	sys-libs/libseccomp
	app-crypt/libsecret
	dev-libs/libsodium
	net-misc/curl[openssl]
	"

PATCHES=( )

if [[ ${PV} != *9999* ]];then
	src_prepare(){
		if [ -e "${FILESDIR}/${PV}/*.patch" ]; then
			EPATCH_OPTS="-p0" epatch "${FILESDIR}/${PV}/*.patch"
		fi
		if [ ! -z ${PATCHES} ]; then
			epatch ${PATCHES}
		fi
		eapply_user
		default
	}
fi

src_compile(){
	emake -j1 PREFIX="${D}" || die "Failed at compile phase"
}

src_install(){
	emake install_lib PREFIX="${D}" || die "Failed in install_lib target"
	emake install PREFIX="${D}" || die "Failed in install_lib target"
	insinto usr/share/licenses/${PN}
	doins LICENSE
}
