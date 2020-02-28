#!/bin/bash

echo "Attempting to add partitions with kpartx"
PART=$(sudo kpartx -av $IMG_FILE | sed -n 2p | cut -d' ' -f3)

echo "Mounting the second partition ${PART} to ${CHROOT}"
sudo mount -o loop /dev/mapper/${PART} $CHROOT

echo "Copying qemu to chroot environment"
sudo cp $(which qemu-arm-static) $CHROOT/usr/bin/
