# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
#PYTHON_COMPAT=( python2_7 )

if [[ $PV = *9999* ]]; then
	scm_eclass=git-r3
	EGIT_REPO_URI="
		https://github.com/kdave/btrfsmaintenance.git
		git@github.com:kdave/btrfsmaintenance.git"
	SRC_URI=""
	KEYWORDS=""
else
	scm_eclass=git-r3
	EGIT_REPO_URI="
		https://github.com/kdave/btrfsmaintenance.git
		git@github.com:kdave/btrfsmaintenance.git"
	EGIT_COMMIT="v$PV"
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools eutils systemd user ${scm_eclass}

DESCRIPTION="Scripts for btrfs periodic maintenance task"
HOMEPAGE="https://github.com/kdave/btrfsmaintenance"

LICENSE="GPL2"
SLOT="0"
#IUSE=""

#CDEPEND="
#	"
#DEPEND="${CDEPEND}
#	"
RDEPEND="app-shells/bash
	 sys-fs/btrfs-progs"

src_install() {
	#dodir "/usr/share/${PN}"
	# copy files to expected directory
	#cp -R "${S}/${P}/" "${D}/usr/share/${PN}" || die "Install failed!"

	exeinto "/usr/share/${PN}"
	doexe btrfs-balance.sh
	doexe btrfs-defrag.sh
	doexe btrfs-scrub.sh
	doexe btrfs-trim.sh
	doexe ${PN}-refresh-cron.sh
	doexe prepare-release.sh
	doexe dist-install.sh

	insinto "/usr/share/${PN}"
	doins btrfs-defrag-plugin.py
	doins ${PN}.changes
	doins ${PN}-functions
	doins sysconfig.${PN}
	doins README.md
	doins COPYING

	insinto "/etc/default"
	newins sysconfig.${PN} ${PN}

	systemd_dounit ${PN}-refresh.service

	dosym "/usr/share/${PN}/${PN}-refresh-cron.sh" "/etc/cron.hourly/"
}

pkg_postinst() {
	elog "You will need to review your /etc/default/${PN} file before starting the service."
	elog "The source file is at /usr/share/${PN}/sysconfig.${PN}. Setup as necessary."
}

