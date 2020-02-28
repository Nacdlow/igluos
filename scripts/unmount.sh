#!/bin/bash

sudo rm $CHROOT/usr/bin/qemu-arm-static

echo "Unmounting the image"
sudo umount $CHROOT

echo "Closing kpartx loop"
sudo kpartx -d $IMG_FILE
