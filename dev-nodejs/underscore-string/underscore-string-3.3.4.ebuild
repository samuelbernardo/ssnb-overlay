# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NPM_MODULE="underscore.string"
NPM_PN_URI="underscore.string"
NPM_EXTRA_FILES="bench dist helper scripts camelize.js capitalize.js chars.js chop.js classify.js cleanDiacritics.js clean.js count.js dasherize.js decapitalize.js dedent.js endsWith.js escapeHTML.js exports.js humanize.js include.js index.js insert.js isBlank.js join.js levenshtein.js lines.js lpad.js lrpad.js ltrim.js map.js meteor-post.js meteor-pre.js naturalCmp.js numberFormat.js package.js pad.js pred.js prune.js quote.js repeat.js replaceAll.js reverse.js rpad.js rtrim.js slugify.js splice.js sprintf.js startsWith.js stripTags.js strLeftBack.js strLeft.js strRightBack.js strRight.js succ.js surround.js swapCase.js titleize.js toBoolean.js toNumber.js toSentence.js toSentenceSerial.js trim.js truncate.js underscored.js unescapeHTML.js unquote.js vsprintf.js words.js wrap.js"

inherit npm

DESCRIPTION="A package manager for the web"
HOMEPAGE="https://www.npmjs.com/package/bower"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-nodejs/sprintf-js dev-nodejs/util-deprecate"
