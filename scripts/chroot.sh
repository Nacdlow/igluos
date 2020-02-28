#!/bin/bash

sudo proot -q qemu-arm-static -r $CHROOT/ qemu-arm-static /bin/bash
