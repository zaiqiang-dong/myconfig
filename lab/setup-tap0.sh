sudo brctl addbr br0
sudo brctl addif br0 enp4s0
sudo ifconfig enp4s0 0
sudo dhclient br0
sudo ip tuntap add dev tap0 mode tap
sudo brctl addif br0 tap0
sudo ip link set dev tap0 up
sudo ifconfig tap0 192.168.122.123 netmask 192.168.122.255
