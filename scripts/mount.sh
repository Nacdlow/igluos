#!/bin/bash

echo "Attempting to add partitions with kpartx"
#PART=$(sudo kpartx -av $IMG_FILE | sed -n 2p | cut -d' ' -f3)
sudo kpartx -av $IMG_FILE
BOOT_PART=loop0p1
PART=loop0p2

echo "Mouting the first partition ${BOOT_PART} to ${BOOT}"
sudo mount -o loop /dev/mapper/${BOOT_PART} $BOOT
echo "Mounting the second partition ${PART} to ${CHROOT}"
sudo mount -o loop /dev/mapper/${PART} $CHROOT

# Enable PCF8523 Real-time clock
echo "Enabling PCF8523 Real-time Clock"
echo "dtoverlay=i2c-rtc,pcf8523" | sudo tee -a ${BOOT}/config.txt
# Enable Ethernet gadget
echo "Enabling Ethernet gadget"
echo "dtoverlay=dwc2" | sudo tee -a ${BOOT}/config.txt
sudo sed -i -e 's/rootwait/rootwait modules-load=dwc2,g_ether/g' ${BOOT}/cmdline.txt

echo "Unmounting boot partition..."
sudo umount $BOOT
