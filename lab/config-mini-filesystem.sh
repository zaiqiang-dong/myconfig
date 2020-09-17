#!/bin/sh
if [ $# -lt 2 ]; then
    echo "input parameter error"
    echo $#", and need 3"
    exit 0
fi

echo "Clear old files"
if [ -d "./rootfs" ]; then
    sudo rm ./rootfs -rf
fi

if [ -d "./tmp" ]; then
    sudo rm ./tmp -rf
fi

if [ -f "./initrd.gz" ]; then
    rm ./initrd.gz -rf
fi

echo "Create rootfs directons"
mkdir $1/rootfs
cd $1/rootfs
echo "Create root,dev and so on"
mkdir root dev etc bin sbin mnt sys proc lib home tmp var usr
mkdir usr/sbin usr/bin usr/lib usr/modules
mkdir mnt/usb mnt/nfs mnt/etc mnt/etc/init.d
mkdir lib/modules
chmod 1777 tmp
cp ../$2* . -r
cd ./dev
sudo mknod -m 660 console c 5 1
sudo mknod -m 660 null c 1 3
cd ..
touch ./etc/fstab
echo "proc    /proc   proc    defaults    0   0" > ./etc/fstab
echo "none    /tmp    ramfs   defaults    0   0" >> ./etc/fstab
echo "mdev    /dev    ramfs   defaults    0   0" >> ./etc/fstab
echo "sysfs   /sys    sysfs   defaults    0   0" >> ./etc/fstab
mkdir ./etc/init.d/
touch ./etc/init.d/rcS
chmod 777 ./etc/init.d/rcS

echo "#! /bin/sh" > ./etc/init.d/rcS
echo "/bin/mount -a" > ./etc/init.d/rcS

touch ./etc/inittab

echo "::sysinit:/etc/init.d/rcS" > ./etc/inittab
echo "::respawn:-/bin/sh" >> ./etc/inittab
echo "::restart:/sbin/init" >> ./etc/inittab
echo "::ctrlaltdel:/bin/umount -a -r" >> ./etc/inittab
echo "::shutdown:/bin/umount -a -r" >> ./etc/inittab
echo "::shutdown:/sbin/swapoff –a" >> ./etc/inittab

touch ./etc/group
echo "root:*:0:" > ./etc/group
echo "daemon:*:1:" >> ./etc/group
echo "bin:*:2:" >> ./etc/group
echo "sys:*:3:" >> ./etc/group
echo "adm:*:4:" >> ./etc/group
echo "tty:*:5:" >> ./etc/group
echo "disk:*:6:" >> ./etc/group
echo "lp:*:7:lp" >> ./etc/group
echo "mail:*:8:" >> ./etc/group
echo "news:*:9:" >> ./etc/group
echo "uucp:*:10:" >> ./etc/group
echo "proxy:*:13:" >> ./etc/group
echo "kmem:*:15:" >> ./etc/group
echo "dialout:*:20:" >> ./etc/group
echo "fax:*:21:" >> ./etc/group
echo "voice:*:22:" >> ./etc/group
echo "cdrom:*:24:" >> ./etc/group
echo "floppy:*:25:" >> ./etc/group
echo "tape:*:26:" >> ./etc/group
echo "sudo:*:27:" >> ./etc/group

touch ./etc/profile

echo "# /etc/profile: system-wide .profile file for the Bourne shells" > ./etc/profile
echo "" >> ./etc/profile
echo "echo" >> ./etc/profile
echo "echo "FileSystem is Ready"" >> ./etc/profile
echo "echo" >> ./etc/profile
echo "" >> ./etc/profile
echo "USER=\"`id -un`\"" >> ./etc/profile
echo "LOGNAME=$USER" >> ./etc/profile
echo "PS1='[\u@\h \W]\# '" >> ./etc/profile
echo "PATH=$PATH" >> ./etc/profile
echo "HOSTNAME=`/bin/hostname`" >> ./etc/profile
echo "" >> ./etc/profile
echo "export USER LOGNAME PS1 PATH" >> ./etc/profile
ln -sv bin/busybox init
sudo find . |sudo  cpio -H newc -o > ../tt.cpio
sudo find . |sudo  cpio -H newc -o | sudo gzip -9 -n > ../initrd.gz
cd ..
dd if=/dev/zero of=sda-rootfs.img bs=1M count=100
mkfs.ext4 sda-rootfs.img
mkdir tmp
sudo mount -t ext4 ./sda-rootfs.img ./tmp
cd tmp/
sudo cp ../rootfs/* . -rf
cd ..
sudo umount tmp
echo "Make direction done"
