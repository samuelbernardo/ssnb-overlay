# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

SLOT="0"
PV_STRING="$(ver_cut 4-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="idea"
# Using the most recent Jetbrains Runtime binaries available at the time of writing
# As the exact bundled versions ( jre 11 build 159.30 and jre 8 build 1483.39 ) aren't
# available separately
JRE17_BASE="17.0.8"
JRE17_VER="1000.22"
JRE11_BASE="11_0_2"
JRE11_VER="164"
JRE_BASE="8u202"
JRE_VER="1483.37"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 7)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS=""
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IU-${MY_PV}.tar.gz -> ${MY_PN}IU-${PV_STRING}.tar.gz
		jbr8? ( x86? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-i586-b${JRE_VER}.tar.gz )
		amd64? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz -> jbrx-${JRE_BASE}-linux-x64-b${JRE_VER}.tar.gz ) )
		jbr11? ( amd64? ( https://bintray.com/jetbrains/intellij-jdk/download_file?file_path=jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz -> jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz ) )
		jbr17? ( amd64? ( https://cache-redirector.jetbrains.com/intellij-jbr/jbr-${JRE17_BASE}-linux-x64-b${JRE17_VER}.tar.gz -> jbr-${JRE17_BASE}-linux-x64-b${JRE17_VER}.tar.gz ) )"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="IDEA
	|| ( IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )"

#Splitting custom-jdk into jbr8 and jbr11 as upstream now offers downloads with
#either (or neither) bundled
#Defaulting to jbr8 to match upstream
IUSE="-jbr8 -jbr11 -jbr17"
REQUIRED_USE="jbr8? ( !jbr11 !jbr17 )
              jbr11? ( !jbr8 !jbr17 )
	      jbr17? ( !jbr8 !jbr11 )"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15"
RDEPEND="${DEPEND}
	>=virtual/jdk-1.7:*
	dev-java/jansi-native
	dev-libs/libdbusmenu
	dev-util/lldb"
BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"
S="${WORKDIR}/${MY_PN}-IU-$(ver_cut 4-6)"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"


jbr_unpack() {
	cd "${WORKDIR}"
	unpack ${MY_PN}IU-${PV_STRING}.tar.gz
	cd "${S}"
	mkdir jre64 && cd jre64 || die "Unable to create jre64 directory"
}

# jbr11 binary doesn't unpack nicely into a single folder
src_unpack() {
	if use jbr8 ; then
		jbr_unpack
		unpack jbr-${JRE8_BASE}-linux-x64-b${JRE8_VER}.tar.gz
	elif use jbr11; then
		jbr_unpack
		unpack jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz
	elif use jbr17; then
		jbr_unpack
		unpack jbr-${JRE17_BASE}-linux-x64-b${JRE17_VER}.tar.gz
	else
		default_src_unpack
	fi
}

src_prepare() {
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi

	if use jbr8 || use jbr11 || use jbr17; then
		mv "${WORKDIR}/jre" ./"${JRE_DIR}"
		PLUGIN_DIR="${S}/${JRE_DIR}/lib/${ARCH}"
	else
		PLUGIN_DIR="${S}/${JRE_DIR}/lib/"
	fi

	rm -vf ${PLUGIN_DIR}/libavplugin*
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*

	if [[ -d "${S}"/"${JRE_DIR}" ]]; then
		for file in "${PLUGIN_DIR}"/{libfxplugins.so,libjfxmedia.so}
		do
			if [[ -f "$file" ]]; then
			  patchelf --set-rpath '$ORIGIN' $file || die
			fi
		done
	fi

	patchelf --replace-needed liblldb.so liblldb.so.9 "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend || die "Unable to patch LLDBFrontend for lldb"

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,restart.py,fsnotifier,ltedit.sh,remote-dev-server.sh,repair}
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi
	if use jbr8 || use jbr11 || use jbr17 ; then
	if use jbr8; then
		JRE_BINARIES="java jjs keytool orbd pack200 policytool rmid rmiregistry servertool tnameserv unpack200"
	else
		JRE_BINARIES="jaotc java javapackager jjs jrunscript keytool pack200 rmid rmiregistry unpack200"
	fi
		if [[ -d ${JRE_DIR} ]]; then
			for jrebin in $JRE_BINARIES; do
				fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
			done
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Ultimate" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
