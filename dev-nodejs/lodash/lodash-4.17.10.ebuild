# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

NPM_EXTRA_FILES="add.js after.js at.js attempt.js before.js camelCase.js capitalize.js castArray.js ceil.js chunk.js clamp.js cloneDeep.js cloneDeepWith.js clone.js cloneWith.js compact.js cond.js conforms.js conformsTo.js countBy.js create.js debounce.js deburr.js defaultsDeep.js defaults.js defaultToAny.js defaultTo.js defer.js delay.js differenceBy.js difference.js differenceWith.js divide.js drop.js dropRight.js dropRightWhile.js dropWhile.js each.js eachRight.js endsWith.js eqDeep.js eq.js escape.js escapeRegExp.js every.js everyValue.js filter.js filterObject.js findKey.js findLastIndex.js findLast.js findLastKey.js first.js flatMapDeep.js flatMapDepth.js flatMap.js flattenDeep.js flattenDepth.js flatten.js flip.js floor.js flow.js flowRight.js forEach.js forEachRight.js forOwn.js forOwnRight.js fromEntries.js functions.js get.js groupBy.js gte.js gt.js hasIn.js has.js hasPathIn.js hasPath.js head.js indexOf.js initial.js inRange.js intersectionBy.js intersection.js intersectionWith.js invertBy.js invert.js invoke.js invokeMap.js isArguments.js isArrayBuffer.js isArrayLike.js isArrayLikeObject.js isBoolean.js isBuffer.js isDate.js isElement.js isEmpty.js isEqualWith.js isError.js isFunction.js isLength.js isMap.js isMatch.js isMatchWith.js isNative.js isNil.js isNull.js isNumber.js isObject.js isObjectLike.js isPlainObject.js isRegExp.js isSet.js isString.js isSymbol.js isTypedArray.js isUndefined.js isWeakMap.js isWeakSet.js kebabCase.js keyBy.js keys.js lastIndexOf.js last.js lowerCase.js lowerFirst.js lte.js lt.js map.js mapKey.js mapObject.js mapValue.js matches.js matchesProperty.js maxBy.js meanBy.js mean.js memoize.js merge.js mergeWith.js method.js methodOf.js minBy.js multiply.js negate.js nthArg.js nth.js once.js orderBy.js overArgs.js overEvery.js over.js overSome.js padEnd.js pad.js padStart.js parseInt.js partition.js pickBy.js pick.js property.js propertyOf.js pullAllBy.js pullAll.js pullAllWith.js pullAt.js pull.js random.js range.js rangeRight.js reduce.js reduceRight.js reject.js remove.js repeat.js replace.js result.js round.js sample.js sampleSize.js set.js setWith.js shuffle.js size.js slice.js snakeCase.js some.js someValue.js sortedIndexBy.js sortedIndex.js sortedIndexOf.js sortedLastIndexBy.js sortedLastIndex.js sortedLastIndexOf.js sortedUniqBy.js sortedUniq.js split.js startCase.js startsWith.js subtract.js sumBy.js sum.js tail.js take.js takeRight.js takeRightWhile.js takeWhile.js throttle.js times.js toArray.js toFinite.js toInteger.js toLength.js toNumber.js toPath.js toPlainObject.js toSafeInteger.js toString.js transform.js trimEnd.js trim.js trimStart.js truncate.js unescape.js unionBy.js union.js unionWith.js uniqBy.js uniq.js uniqueId.js uniqWith.js unset.js unzip.js unzipWith.js update.js updateWith.js upperCase.js upperFirst.js values.js without.js words.js xorBy.js xor.js xorWith.js zip.js zipObjectDeep.js zipObject.js zipWith.js"

inherit npm

DESCRIPTION="A package manager for the web"
HOMEPAGE="https://www.npmjs.com/package/bower"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

