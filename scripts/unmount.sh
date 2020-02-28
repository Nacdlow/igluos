#!/bin/bash

if [ -z $CHROOT ]; then
	echo "\$CHROOT is not set! This may damage your host system."
	exit
fi

echo "Unmounting the image"
sudo umount $CHROOT

echo "Closing kpartx loop"
sudo kpartx -d $IMG_FILE
