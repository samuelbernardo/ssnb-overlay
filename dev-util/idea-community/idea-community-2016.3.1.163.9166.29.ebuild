# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator

SLOT="0"
PV_STRING="$(get_version_component_range 4-6)"
MY_PV="$(get_version_component_range 1-3)"
MY_PN="idea"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(get_version_component_range 7)x" = "prex" ]]
then
	# upstream EAP
	KEYWORDS=""
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${MY_PV}.tar.gz"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"
IUSE="-custom-jdk"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*"
if [[ "${PV_STRING}x" = "x" ]]
then
	S="${WORKDIR}/${MY_PN}-IC-${MY_PV}"
else
	S="${WORKDIR}/${MY_PN}-IC-${PV_STRING}"
fi

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{idea.sh,fsnotifier{,64}}

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry ${PN} "IntelliJ IDEA $(get_version_component_range 1-3)	(Community Edition)" "${PN}" "Development;IDE"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
