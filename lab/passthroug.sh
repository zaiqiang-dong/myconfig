echo 0000:05:00.0 > /sys/bus/pci/devices/0000:05:00.0/driver/unbind
echo 8086 2723 > /sys/bus/pci/drivers/vfio-pci/new_id
exit
