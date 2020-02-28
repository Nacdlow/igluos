# iglüOS

## What is this?

This is an fork of Raspbian (Buster) Lite built for Nacdlow's iglü. It allows
you to have an OS image for the Raspberry Pi with iglü installed as a service,
which boots on startup.

It also allows you to also set up WiFi configuration (eduroam, in this case)
for expo purposes.

## What does this solve?

It solves:

- Having to copy over new files to the Raspberry Pi, or pull it from the WiFi
  and compile it (may take time).
- Having to set up the system each time.
- Having to set up WiFi manually.
- Having a "cool" factor.

How it solves it:

- By pre-compiling the latest binary of iglü, including some (binary) update
  mechanism.
- Having a systemd service for iglü.
- Having the WiFi pre-configured.
- Giving it a "cool" name (iglüOS).

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

