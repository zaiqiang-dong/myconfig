#!/bin/bash

armmachine="-machine virt -cpu cortex-a57 -machine type=virt"
armkernelimg="../kernel/linux-5.8.18/arm64-build-out/arch/arm64/boot/Image"
armrootfsimg="../rootfs/rootfs-aarch64.img"
armappenarg="--append 'root=/dev/vda console=ttyAMA0'"

x86kernelimg="../kernel/linux-5.8.18/x86_64-build-out/arch/x86_64/boot/bzImage"
x86rootfsimg="../rootfs/rootfs-amd64.img"
x86appenarg="--append 'root=/dev/sda console=ttyS0 nokaslr'"

netarg="-net nic,model=e1000,netdev=m"
netdevarg="-net nic,model=e1000,netdev=m"
debugarg=""
nographicarg="-nographic"


if [ $1 = "ARM_64_UNB" ];then
    echo "run with arch=ARM_64"
	qemu-system-aarch64 -m 1024 -smp 1 \
 			-machine virt -cpu cortex-a57 -machine type=virt \
			-kernel $2/arm64-build-out/arch/arm64/boot/Image \
			-hda ../rootfs/rootfs-aarch64.img \
			-nographic \
			-net nic,model=e1000,netdev=m \
			-netdev tap,ifname=tap0,script=no,downscript=no,id=m \
			--append "root=/dev/vda console=ttyAMA0" \
			$3 $4
fi

if [ $1 = "x86_64_UNB" ];then
    echo "run with arch=x86_64"
	qemu-system-x86_64 -m 1024 -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-hda ../rootfs/rootfs-amd64.img \
			-bios ~/Downloads/qemu-5.2.0/roms/seabios/out/bios.bin \
			-nographic \
			-net nic,model=e1000,netdev=m \
			-netdev tap,ifname=tap0,script=no,downscript=no,id=m \
			-append "root=/dev/sda console=ttyS0 nokaslr" \
			$3 $4
fi

if [ $1 = "x86_64_G_N" ];then
    echo "run with arch=x86_64"
    cgdb --args /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 --enable-kvm -m 1024  -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-initrd ../rootfs/x86_64/initrd.gz \
			-nographic \
			-net nic,model=e100,netdev=mmm \
			-netdev tap0,ifname=tap0,script=no,downscript=no,id=mmm \
			--append "rdinit=/init console=ttyS0 nokaslr" \
			$3 $4
fi


if [ $1 = "x86_64_G_TCG" ];then
    echo "run with arch=x86_64"
    cgdb --args /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 -m 1024  -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-initrd ../rootfs/x86_64/initrd.gz \
			-nographic \
			--append "rdinit=/init console=ttyS0 nokaslr" \
			$3 $4
fi

