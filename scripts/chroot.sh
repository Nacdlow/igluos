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

if [ ! -d nacdlow-server ]; then
	git clone git@gitlab.com:group-nacdlow/nacdlow-server.git
fi

cd nacdlow-server
git pull
cd ..
sudo cp -r nacdlow-server $CHROOT/nacdlow-server

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
apt update
#apt upgrade -y
apt purge fake-hwclock -y
apt install python3-pip libtiff5-dev libopenjp2-7-dev fonts-freefont-ttf -y
uname -a
ln -s /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyGS0.service
ln -s /lib/systemd/system/ssh.service /etc/systemd/system/multi-user.target.wants/ssh.service
pip3 install RPi.GPIO spidev qrcode Pillow twython python-dotenv
# install go
wget https://dl.google.com/go/go1.14.linux-armv6l.tar.gz
tar -C /usr/local -xzf go1.14.linux-armv6l.tar.gz
#cd /nacdlow-server
#go get
#go install
EOF
echo -e "interface usb0\nstatic ip_address=10.0.0.2" | sudo tee -a ${CHROOT}/etc/dhcpcd.conf

echo "export PATH=$PATH:/usr/local/go/bin" | sudo tee -a ${CHROOT}/etc/profile

# For Real-time clock
sudo install -v -m755 data/hwclock-set $CHROOT/lib/udev/hwclock-set

# Install iglu
echo "Installing iglu systemd service"
sudo install -v -m644 data/iglu.service $CHROOT/lib/systemd/system/iglu.service
sudo cp -r data/iglu $CHROOT/iglu
sudo chmod +x $CHROOT/iglu/nacdlow-server

sudo proot -q qemu-arm-static \
	-r ${PWD}/${CHROOT}/ \
	-b /proc/ \
	-b /dev/ \
	-b /sys/ \
	-b /etc/resolv.conf \
	-b /usr/bin/qemu-arm-static \
	-0 \
	qemu-arm-static /bin/bash
