#!/bin/bash
echo -n "Enter your eduroam username (with domain): "
read WIFI_USERNAME
echo -n "Enter your eduroam password (will not echo): "
read -s WIFI_PASSWORD


cat > wpa_conf.txt <<EOF
network={
	ssid="eduroam"
	proto=RSN
	key_mgmt=WPA-EAP
	pairwise=CCMP
	auth_alg=OPEN
	eap=PEAP
	identity="${WIFI_USERNAME}"
	password="${WIFI_PASSWORD}"
	phase2="auth=MSCHAPV2"
	disabled=0
}
EOF

cat wpa_conf.txt | sudo tee -a $CHROOT/etc/wpa_supplicant/wpa_supplicant.conf
rm wpa_conf.txt

sudo proot -q qemu-arm-static \
	-r ${PWD}/${CHROOT}/ \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-b /etc/resolv.conf \
	-b /usr/bin/qemu-arm-static \
	-0 \
	qemu-arm-static /bin/bash <<EOF
export LC_ALL=C
#apt update && apt upgrade-y
apt purge fake-hwclock
uname -a
EOF


sudo proot -q qemu-arm-static \
	-r ${PWD}/${CHROOT}/ \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-b /etc/resolv.conf \
	-b /usr/bin/qemu-arm-static \
	-0 \
	qemu-arm-static /bin/bash
