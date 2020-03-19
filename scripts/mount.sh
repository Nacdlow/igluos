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
echo "dtoverlay=i2c-rtc,pcf8523,dwc2" | sudo tee -a ${BOOT}/config.txt
# Enable Ethernet gadget and serial
echo "Enabling Ethernet gadget and serial"
#echo "dtoverlay=dwc2" | sudo tee -a ${BOOT}/config.txt
sudo sed -i -e 's/rootwait/rootwait modules-load=dwc2,g_ether/g' ${BOOT}/cmdline.txt
sudo sed -i 's| init=\/usr\/lib\/raspi-config\/init_resize\.sh||g' ${BOOT}/cmdline.txt
# Enable SPI and I2C
echo "dtoverlay=spi1-3cs" | sudo tee -a ${BOOT}/config.txt
echo "dtparam=spi1=on" | sudo tee -a ${BOOT}/config.txt
echo "dtparam=i2c_arm=on" | sudo tee -a ${BOOT}/config.txt
echo "dtparam=i2c1=on" | sudo tee -a ${BOOT}/config.txt
echo "gpu_mem=16" | sudo tee -a ${BOOT}/config.txt

# Enable SSH
sudo sed -i -e 's|\#Port 22|Port 22|g' ${CHROOT}/etc/ssh/sshd_config

# Add hostname to hosts file
echo "127.0.0.1\tpingu" | sudo tee -a ${CHROOT}/etc/hosts

# OS customisation
echo "pingu" | sudo tee ${CHROOT}/etc/hostname
echo 'igluOS (snowball) \n \l' | sudo tee ${CHROOT}/etc/issue
echo 'igluOS (snowball)' | sudo tee ${CHROOT}/etc/issue.net
sudo cp data/os-release ${CHROOT}/etc/os-release

