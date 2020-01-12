# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# repoman gives LIVEVCS.unmasked even with EGIT_COMMIT, so create snapshot
inherit eutils java-pkg-2 git-r3

L_PN="sbt-launch"
L_P="${L_PN}-${PV}"

SV="2.12"

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="http://www.scala-sbt.org/"
EGIT_COMMIT="v${PV}"
EGIT_REPO_URI="https://github.com/sbt/sbt.git"
SRC_URI="
	binary? (
		https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tgz -> ${P}.tar.gz
	)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+binary"

DEPEND=">=virtual/jdk-1.8
	>=dev-lang/scala-2.12.2:${SV}"
RDEPEND=">=virtual/jre-1.8
	>=dev-lang/scala-2.12.2:${SV}"

# test hangs or fails
RESTRICT="test"

JAVA_GENTOO_CLASSPATH="scala-${SV}"


src_unpack() {
	if use binary; then
		#for f in ${A} ; do
		#	[[ ${f} == *".tar."* ]] && unpack ${f}
		#done
		default
		mv "${WORKDIR}/sbt" "${S}" || die
	else
		git-r3_src_unpack
	fi
}

src_prepare() {
	default
	if use binary; then
		default
		java-pkg_init_paths_
	else
		S="${WORKDIR}/${P}"
		mkdir "${WORKDIR}/${L_P}" || die
		cp -p "${DISTDIR}/${L_P}.jar" "${WORKDIR}/${L_P}/${L_PN}.jar" || die
		cat <<- EOF > "${WORKDIR}/${L_P}/sbt"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${WORKDIR}/${L_P}/sbt-launch.jar" "\$@"
		EOF
		cat <<- EOF > "${S}/${P}"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${S}/launch/target/sbt-launch.jar" "\$@"
		EOF
		chmod u+x "${WORKDIR}/${L_P}/sbt" "${S}/${P}" || die
		sed -e "s@scalaVersion := scala210,@scalaVersion := scala${SV/./},\n  scalaHome := Some(file(\"${EROOT}usr/share/scala-${SV}\")),@" \
			-i "${S}/build.sbt" || die

		# suppress this warning in build.log:
		# [warn] Credentials file /var/tmp/portage/dev-java/${P}/work/.bintray/.credentials does not exist
		mkdir -p "${WORKDIR}/.bintray" || die
		cat <<- EOF > "${WORKDIR}/.bintray/.credentials"
			realm = Bintray API Realm
			host = api.bintray.com
			user =
			password =
		EOF
	fi
}

src_compile() {
	if use binary; then
		:;
	else
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${WORKDIR}/${L_P}:${PATH}"
		einfo "=== sbt compile ..."
		"${WORKDIR}/${L_P}/sbt" -Dsbt.log.noformat=true compile || die
		einfo "=== sbt publishLocal with jdk $(java-pkg_get-vm-version) ..."
		cat <<- EOF | "${WORKDIR}/${L_P}/sbt" -Dsbt.log.noformat=true || die
			set every javaVersionPrefix in javaVersionCheck := Some("$(java-pkg_get-vm-version)")
			publishLocal
		EOF
	fi
}

src_test() {
	if ! use binary; then
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${S}:${PATH}"
		"${S}/${P}" -Dsbt.log.noformat=true test || die
	fi
}

src_install() {
	if use binary; then
		local dest="${JAVA_PKG_SHAREPATH}"

		rm -v bin/sbt.bat || die
		sed -i -e 's#bin/sbt-launch.jar#lib/sbt-launch.jar#g;' \
			bin/sbt-launch-lib.bash || die

		insinto "${dest}/lib"
		doins bin/* || die

		insinto "${dest}"
		doins -r conf || die

		fperms 0755 "${dest}/lib/sbt" || die
		dosym "${dest}/lib/sbt" /usr/bin/sbt || die

		java-pkg_regjar ${D}/${dest}/lib/*.jar
	else
		# Place sbt-launch.jar at the end of the CLASSPATH
		java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print | grep -v sbt-launch.jar) \
			       $(find "${WORKDIR}"/.ivy2/local -name sbt-launch.jar -print)
		local ja="-Dsbt.version=${PV} -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
		java-pkg_dolauncher sbt --jar sbt-launch.jar --java_args "${ja}"
	fi
}
