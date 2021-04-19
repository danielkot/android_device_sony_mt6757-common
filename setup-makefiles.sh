#!/bin/bash

DEVICE=mt6757-common
VENDOR=sony

OUTDIR=vendor/$VENDOR/$DEVICE
MAKEFILE=../../../$OUTDIR/$DEVICE-vendor.mk

cat << EOF > $MAKEFILE
# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This file is generated by device/$VENDOR/$DEVICE/setup-makefiles.sh

PRODUCT_COPY_FILES += \\
EOF

LINEEND=" \\"
FILES=$(eval echo `egrep -v '(^#|^$)' proprietary-files.txt`)
COUNT=`echo $FILES | wc -w`

for FILE in $FILES; do
  COUNT=`expr $COUNT - 1`
  if [ $COUNT = "0" ]; then
    LINEEND=""
  fi
  # Split the file from the destination (format is "file[:destination]")
  OLDIFS=$IFS IFS=":" PARSING_ARRAY=($FILE) IFS=$OLDIFS
  if [[ ! "$FILE" =~ ^-.* ]]; then
    FILE=`echo ${PARSING_ARRAY[0]} | sed -e "s/^-//g"`
    DEST=${PARSING_ARRAY[1]}
    if [ -n "$DEST" ]; then
      FILE=$DEST
    fi
    # Do not include files that not exists in *.mk to avoid errors [+] Decker
    CFILE=../../../$OUTDIR/$FILE
    if [[ -f "$CFILE" ]]; then
    	echo "    $OUTDIR/$FILE:system/$FILE$LINEEND" >> $MAKEFILE
    else
    	echo "    $OUTDIR/$FILE - not found !"
    fi
  fi
done
