#!/bin/bash

USER=QQ
HOSTNAME=QEMU
PASSWD=123456
export DEBIAN_FRONTEND=noninteractive

rm /var/lib/apt/lists/* -rf
apt update
apt -y upgrade

apt install -y sudo
apt install -y systemd systemd-sysv
apt install -y linux-base
apt install -y util-linux
apt install -y expect
apt install -y gdisk parted u-boot-tools
apt install -y file
apt install -y findutils
apt install -y net-tools
apt install -y network-manager
apt install -y iproute2
apt install -y isc-dhcp-client
apt install -y ethtool
apt install -y ntp
apt install -y wireless-tools
apt install -y dhcpcd5
apt install -y resolvconf
apt install -y avahi-utils
apt install -y iw
apt install -y vim


echo "config root password: "
passwd root
# /usr/bin/expect <<-EOF
# spawn passwd root
# expect {
# 	"password:" { send "$PASSWD\r"; exp_continue }
# 	"password:" { send "$PASSWD\r"; exp_continue }
# }
# expect eof
# EOF

rm -rf /etc/hosts /etc/hostname
touch /etc/hosts /etc/hostname

cat <<-EOF > /etc/hostname
	$HOSTNAME
EOF

cat <<-EOF > /etc/hosts
    127.0.0.1 localhost
    127.0.1.1 $HOSTNAME
    # The following lines are desirable for IPv6 capable hosts
    #::1     localhost ip6-localhost ip6-loopback
    #fe00::0 ip6-localnet
    #ff00::0 ip6-mcastprefix
    #ff02::1 ip6-allnodes
    #ff02::2 ip6-allrouters
EOF

chown root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo

