#!/bin/sh

set -ex

UPSTREAM_VERSION=$2
UPSTREAM_VERSION_REV=`echo ${UPSTREAM_VERSION} | sed -e "s/^2.0.17+svn//g"`
ORIG_TARBALL=$3

REAL_TARBALL=`readlink -f ${ORIG_TARBALL}`
WORKING_DIR=`dirname ${ORIG_TARBALL}`

ORIG_TARBALL_NEW="${WORKING_DIR}/docbook-defguide_${UPSTREAM_VERSION}.orig.tar.gz"
ORIG_TARBALL_DIR="${WORKING_DIR}/docbook-defguide-${UPSTREAM_VERSION}.orig"
ORIG_TARBALL_DIR_STRIP=`basename ${ORIG_TARBALL_DIR}`

[ ! -e ${ORIG_TARBALL_DIR} ] || exit 1
svn export -r ${UPSTREAM_VERSION_REV} -q --non-interactive --ignore-keywords svn://svn.code.sf.net/p/docbook/code/trunk/defguide ${ORIG_TARBALL_DIR} || exit 1

rm -f ${ORIG_TARBALL} ${REAL_TARBALL}
GZIP="-n -9" tar --remove-files --directory ${WORKING_DIR} -czf ${ORIG_TARBALL_NEW} ${ORIG_TARBALL_DIR_STRIP} || exit 1

exit 0
