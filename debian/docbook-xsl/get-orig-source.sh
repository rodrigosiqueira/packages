#!/bin/sh

set -ex

UPSTREAM_VERSION=$2
ORIG_TARBALL=$3

REAL_TARBALL=`readlink -f ${ORIG_TARBALL}`
REAL_TARBALL_NS=`echo ${REAL_TARBALL} | sed -e "s/docbook-xsl-\(${UPSTREAM_VERSION}\.tar\.\(bz2\|gz\)\)/docbook-xsl-ns-\1/g"`
REAL_TARBALL_NS_STRIP=`basename ${REAL_TARBALL_NS}`

WORKING_DIR=`dirname ${ORIG_TARBALL}`

[ -f ${REAL_TARBALL_NS} ] || wget -P ${WORKING_DIR} http://downloads.sourceforge.net/docbook/${REAL_TARBALL_NS_STRIP}
[ -f ${REAL_TARBALL_NS} ] || exit 1

ORIG_TARBALL_DFSG=`echo ${REAL_TARBALL} | sed -e "s/-\(${UPSTREAM_VERSION}\)/_\1+dfsg.orig/g"`
ORIG_TARBALL_DIR=`echo ${ORIG_TARBALL_DFSG} | sed -e "s/_\(${UPSTREAM_VERSION}\)/-\1/g" -e "s/\.tar\.\(bz2\|gz\)//g"`
ORIG_TARBALL_DIR_STRIP=`basename ${ORIG_TARBALL_DIR}`

mkdir -p ${ORIG_TARBALL_DIR}/docbook-xsl/ ${ORIG_TARBALL_DIR}/docbook-xsl-ns/
tar --directory=${ORIG_TARBALL_DIR}/docbook-xsl/    --strip 1 -xf ${REAL_TARBALL} || exit 1
tar --directory=${ORIG_TARBALL_DIR}/docbook-xsl-ns/ --strip 1 -xf ${REAL_TARBALL_NS} || exit 1
rm -f ${ORIG_TARBALL} ${REAL_TARBALL} ${REAL_TARBALL_NS}
rm -rf ${ORIG_TARBALL_DIR}/docbook-xsl/extensions/    ${ORIG_TARBALL_DIR}/docbook-xsl/webhelp \
       ${ORIG_TARBALL_DIR}/docbook-xsl-ns/extensions/ ${ORIG_TARBALL_DIR}/docbook-xsl-ns/webhelp/
GZIP=-9 tar --remove-files --directory ${WORKING_DIR} -cjf ${ORIG_TARBALL_DFSG} ${ORIG_TARBALL_DIR_STRIP} || exit 1

exit 0
