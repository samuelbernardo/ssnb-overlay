# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit python-r1 git-r3
#inherit python-single-r1
#[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Tool for checking common errors in RPM packages"
HOMEPAGE="http://rpmlint.zarb.org/"
if [ "${PV}" = 9999 ]; then
	EGIT_REPO_URI="git://git.code.sf.net/p/rpmlint/code"
else
	#[ "${PV}" = 9999 ] || SRC_URI="mirror://sourceforge/rpmlint/${P}.tar.xz"
	EGIT_REPO_URI="https://github.com/rpm-software-management/rpmlint.git"
	EGIT_COMMIT="${P}"
fi

LICENSE="GPL-2"
SLOT="0"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	${PYTHON_DEPS}
	app-arch/rpm[python]
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
	|| ( dev-python/python-magic[${PYTHON_USEDEP}] sys-apps/file[${PYTHON_USEDEP}] )
	dev-python/pyenchant[${PYTHON_USEDEP}]
"

src_install() {
	default

	insinto /usr/share/rmplint/config
	newins ${FILESDIR}/fedora.config config
}
