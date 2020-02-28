#!/bin/bash

sudo proot -q qemu-arm-static \
	-r ${PWD}/${CHROOT}/ \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-b /etc/resolv.conf \
	-b /usr/bin/qemu-arm-static \
	-0 \
	qemu-arm-static /bin/bash
