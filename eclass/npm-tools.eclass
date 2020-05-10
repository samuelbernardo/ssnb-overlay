# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: npm-tools.eclass
# @MAINTAINER:
# samuelbernardo@gmail.com
# @BLURB: functions to install project nodejs dependencies
# @DESCRIPTION:
# The npm-tools eclass contains functions to manage nodejs package
# for projects that needs it.
#
# For more details review the following url:
# https://gruntjs.com/getting-started

if [[ -z ${_NPM_TOOLS_ECLASS} ]]; then
_NPM_TOOLS_ECLASS=1

# implicitly inherited eclasses
#case ${EAPI:-0} in
#0|1|2|3|4|5|6)
#	inherit eutils
#	;;
#esac

# @FUNCTION: npm_install
# @USAGE: [project dir]
# @DESCRIPTION:
# Run npm install in the provided project directory.
# If no directory is provided it will run on current path.
case ${EAPI:-0} in
5|6|7)
	npm_install() {
		local dir="$1"
		if [[ -z "${dir}" ]] ; then
			$(which npm) install
		else
			pushd ${dir}
			$(which npm) install
			popd
		fi
	}
	;;
esac

fi
