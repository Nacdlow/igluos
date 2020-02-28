#!/bin/bash

CHROOT="chroot"
BOOT="boot"
ORIG_FILE="raspbian-buster-lite.img"
IMG_FILE="igluOS-$(date +%Y%m%d).img"

if [ ! -f $ORIG_FILE ]; then
	echo "The file ${ORIG_FILE} doesn't exist. Be sure to download/extract it first"
	exit
fi

cp -vf $ORIG_FILE $IMG_FILE

mkdir $CHROOT
mkdir $BOOT

. ./scripts/mount.sh
. ./scripts/chroot.sh
. ./scripts/unmount.sh
