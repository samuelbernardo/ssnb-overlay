# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"
inherit eutils versionator

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="The intelligent cross-platform C/C++ IDE"
HOMEPAGE="https://www.jetbrains.com/clion/"

MY_PV="$(get_version_component_range 1-3)"
MY_PN="CLion"
SRC_URI="http://download.jetbrains.com/cpp/${MY_PN}-${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="CLion-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${PN}-${MY_PV}"

src_install() {
    local dir="/opt/${P}"
    local exe="${PN}"

    insinto "${dir}"

    sed -e "s|^message()|source /etc/conf.d/clion\n\nmessage()|" \
        -i bin/${PN}.sh || die "Unable to patch startup script"

    [[ -d "jre" ]] && rm -rf jre || die "no embedded jre found"

    doins -r *

    fperms 755 "${dir}/bin/gdb/bin/gdb"
    fperms 755 "${dir}/bin/${PN}.sh"
    fperms 755 "${dir}/bin/inspect.sh"
    fperms 755 "${dir}/bin/fsnotifier64"
    fperms 755 "${dir}/bin/fsnotifier"
    fperms 755 "${dir}/bin/cmake/bin/cmake"
    fperms 755 "${dir}/bin/cmake/bin/cpack"
    fperms 755 "${dir}/bin/cmake/bin/ctest"
    fperms 755 "${dir}/bin/lldb/LLDBFrontend"
    fperms 755 "${dir}/bin/lldb/bin/lldb-server"
    fperms 755 "${dir}/bin/lldb/lib/python2.7/site-packages/lldb/lldb-argdumper"

    newicon "bin/${PN}.svg" "${exe}.svg"
    make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
    make_desktop_entry ${exe} "CLion IDE ${MY_PV}" "${exe}" "Development;IDE"

    newconfd "${FILESDIR}/config" ${PN}
}
