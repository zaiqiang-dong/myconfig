
if [[ "$(id -u)" -ne "0" ]]; then
    echo "need run with root permission."
    exit 1
fi
rootfsdir=base
rootfssize=1024M
rootfstmp=rtmp
rootfsimg=rootfs

#创建base目录
mkdir $rootfsdir

#下载base包
if [ $1 = "aarch64" ]
then
wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.1-base-arm64.tar.gz
tar -xvf ./ubuntu-base-20.04.1-base-arm64.tar.gz -C $rootfsdir
sudo cp /usr/bin/qemu-aarch64-static ./$rootfsdir/usr/bin/
rootfsimg=$rootfsimg"-aarch64.img"
else
wget http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.1-base-amd64.tar.gz
tar -xvf ./ubuntu-base-20.04.1-base-amd64.tar.gz -C $rootfsdir
rootfsimg=$rootfsimg"-amd64.img"
fi


#配置DNS
cp /etc/resolv.conf ./$rootfsdir/etc
cp  -r /etc/skel ./$rootfsdir/etc/

#cp install.sh
cp ./install.sh ./$rootfsdir
chmod a+x ./$rootfsdir/install.sh

chmod 777 ./$rootfsdir/tmp

#切换根目录
sudo chroot $rootfsdir /bin/bash -c "./install.sh"
sudo ln -s ./$rootfsdir/lib/systemd/systemd ./$rootfsdir/sbin/init

if [ -f  $rootfsimg ];then
	rm -rf $rootfsimg
fi
dd if=/dev/zero of=$rootfsimg bs=$rootfssize count=2 status=progress
if [ -d  $rootfstmp ];then
	rm -rf $rootfstmp
fi

mkdir $rootfstmp

mkfs.ext4 $rootfsimg
mount -t ext4 $rootfsimg $rootfstmp

cp -rf ./$rootfsdir/* $rootfstmp

umount $rootfstmp

#修改权限
chmod 777 ./$rootfsimg

#清理
sudo rm $rootfsdir -rf
sudo rm $rootfstmp -rf
rm *.tar.gz

