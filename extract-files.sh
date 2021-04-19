#!/bin/bash

#	usage: extract-files.sh $1
#	$1 is dir to the /system mount point.

if [ -z ${1} ]; then
	exit 1
fi

VENDOR="sony"
DEVICE="mt6757-common"
BASE="../../../vendor/${VENDOR}/${DEVICE}"

rm -rf ${BASE}/*

for FILE in `cat proprietary-files.txt | grep -v ^# | grep -v ^$`; do
	DIR="`dirname $FILE`"
	if [ ! -d ${BASE}/${DIR} ]; then
		mkdir -p ${BASE}/${DIR}
	fi
	if [ -d ${1} ]; then
		cp -f ${1}/${FILE} ${BASE}/${DIR}
	else
		adb pull system/${FILE} ${BASE}/{$FILE}
	fi
done
. setup-makefiles.sh
