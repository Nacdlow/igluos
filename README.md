# iglüOS

## What is this?

This is an fork of Raspbian (Buster) Lite built for Nacdlow's iglü. It allows
you to have an OS image for the Raspberry Pi with iglü installed as a service,
which boots on startup.

It also allows you to also set up WiFi configuration (eduroam, in this case)
for expo purposes.

## What are the changes of this compared to Raspbian Lite?

With iglüOS, the following features have been added:

- Support for Real-time Clock (specifically, PCF8523).
- Support for using Raspberry Pi's Ethernet adapter (appears as Ethernet device
  over USB).
- Support for eduroam with pre-filled credentials.
- Installs iglü server and adds it as a service.
- Installs and runs our e-ink display program as a service.

## Prerequisites

- bash
- go
- kpartx
- proot
- qemu-user-static
- trust that this code won't brick your system

## Building

1. Download [Raspbian Buster Lite](https://www.raspberrypi.org/downloads/raspbian/)
2. Extract the file, place it in the project's directory named
   `raspbian-buster-lite.img`.
3. Run `./build.sh`

