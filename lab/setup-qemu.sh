#!/bin/bash

armmachine="-machine virt -cpu cortex-a57 -machine type=virt"
armkernelimg="-kernel ./kernel/study-linux-5.8.18/arm64-build-out/arch/arm64/boot/Image"
armrootfsimg="-hda ./rootfs/make-ubuntu-initrc/rootfs-aarch64.img"
armappenarg='--append "root=/dev/vda console=ttyAMA0"'
armemulator="./qemu/study-qemu-5.2.0/build/qemu-system-aarch64"
#armemulator="qemu-system-aarch64"

x86machine="--enable-kvm -m 1024 -smp 1"
x86kernelimg="-kernel ./kernel/study-linux-5.8.18/x86_64-build-out/arch/x86_64/boot/bzImage"
x86rootfsimg="-hda ./rootfs/make-ubuntu-initrc/rootfs-amd64.img"
x86appenarg='--append "root=/dev/sda console=ttyS0 nokaslr"'
x86emulator="./qemu/study-qemu-5.2.0/build/qemu-system-x86_64"
x86bios="-bios ./qemu/study-qemu-5.2.0/roms/seabios/out/bios.bin"
#x86emulator="qemu-system-x86_64"

machine=""
kernelimg=""
rootfsimg=""
appenarg=""
emulator=""
biosarg=""

netarg="-net nic,model=e1000,netdev=m"
netdevarg="-netdev tap,ifname=tap0,script=no,downscript=no,id=m"
nographicarg="-nographic"

emulator=""
debugarg=""
debuger_begin=""
debuger_end=""

cpuarg="-smp 1"
memarg="-m 1024"

runhelp(){
	echo "****************** help   info ************************"
	echo "*******************************************************"
	echo "* -h --help   show this help info                     *"
	echo "* -a --arch   cpu arch <arm64|x86_64>                 *"
	echo "* -d --debug  set debug tartget <qemu|kernel|bios>    *"
	echo "* -c --cpu    set cpu num                             *"
	echo "* -m --memory set memory size ,<mb>                   *"
	echo "*******************************************************"
}


ARGS=`getopt -o ha:d:c:m: --long --help,--arch:,--debug:,--cpu:,--memory:, -n "$0" -- "$@"`
if [[ ! $? -eq 0 ]]; then
	echo ""
	echo ""
	echo ""
	runhelp
	echo ""
	echo ""
	echo ""
	exit
fi

#echo ARGS=[$ARGS]
eval set -- "${ARGS}"

while true; do
	case "$1" in
		-h|--hlep)
			runhelp
			exit
			;;
		-a|--arch)
			if [ "$2" == "arm64" ];then
				machine=$armmachine
				kernelimg=$armkernelimg
				rootfsimg=$armrootfsimg
				appenarg=$armappenarg
				emulator=$armemulator
			elif [ "$2" == "x86_64" ]; then
				machine=$x86machine
				kernelimg=$x86kernelimg
				rootfsimg=$x86rootfsimg
				appenarg=$x86appenarg
				emulator=$x86emulator
				biosarg=$x86bios
			fi
			shift 2
			;;
		-d|--debug)
			case "$2" in
				qemu)
					debuger_begin="cgdb --args "
					;;
				kernel)
					debuger_end="-S -s"
					;;
				bios)
					debuger_end="-S -s"
					;;
			esac
			shift 2
			;;
		-c|--cpu)
			cpuarg="-smp "$2
			shift 2
			;;

		-m|--memory)
			memarg="-m "$2
			shift 2
			;;

		--)
			shift
			break
			;;
		*)
			echo "invalid args!"
			exit
			;;
	esac
done


echo "-----------------------------------------------"
cmd=$debuger_begin" "$emulator" "$machine" "$cpuarg" "$memarg" "$kernelimg" "$rootfsimg" "$biosarg" "$netarg" "$netdevarg" "$nographicarg" "$appenarg" "$debuger_end
echo $cmd

#eval $cmd
echo "-----------------------------------------------"


# if [ $1 = "ARM_64_UNB" ];then
#     echo "run with arch=ARM_64"
# 	qemu-system-aarch64 -m 1024 -smp 1 \
#  			-machine virt -cpu cortex-a57 -machine type=virt \
# 			-kernel $2/arm64-build-out/arch/arm64/boot/Image \
# 			-hda ../rootfs/rootfs-aarch64.img \
# 			-nographic \
# 			-net nic,model=e1000,netdev=m \
# 			-netdev tap,ifname=tap0,script=no,downscript=no,id=m \
# 			--append "root=/dev/vda console=ttyAMA0" \
# 			$3 $4
# fi

# if [ $1 = "x86_64_UNB" ];then
#     echo "run with arch=x86_64"
# 	qemu-system-x86_64 -m 1024 -smp 1\
# 			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
# 			-hda ../rootfs/rootfs-amd64.img \
# 			-bios ~/Downloads/qemu-5.2.0/roms/seabios/out/bios.bin \
# 			-nographic \
# 			-net nic,model=e1000,netdev=m \
# 			-netdev tap,ifname=tap0,script=no,downscript=no,id=m \
# 			-append "root=/dev/sda console=ttyS0 nokaslr" \
# 			$3 $4
# fi

# ./qemu/study-qemu-5.2.0/build/qemu-system-x86_64 \
# 	--enable-kvm -m 1024 -smp 1 \
# 	-kernel ./kernel/study-linux-5.8.18/x86_64-build-out/arch/x86_64/boot/bzImage \
# 	-hda ./rootfs/make-ubuntu-initrc/rootfs-amd64.img \
# 	-net nic,model=e1000,netdev=m \
# 	-netdev tap,ifname=tap0,script=no,downscript=no,id=m \
# 	-nographic \
# 	--append "root=/dev/sda console=ttyS0 nokaslr"
# if [ $1 = "x86_64_G_N" ];then
#     echo "run with arch=x86_64"
#     cgdb --args /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 --enable-kvm -m 1024  -smp 1\
# 			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
# 			-initrd ../rootfs/x86_64/initrd.gz \
# 			-nographic \
# 			-net nic,model=e100,netdev=mmm \
# 			-netdev tap0,ifname=tap0,script=no,downscript=no,id=mmm \
# 			--append "rdinit=/init console=ttyS0 nokaslr" \
# 			$3 $4
# fi


# if [ $1 = "x86_64_G_TCG" ];then
#     echo "run with arch=x86_64"
#     cgdb --args /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 -m 1024  -smp 1\
# 			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
# 			-initrd ../rootfs/x86_64/initrd.gz \
# 			-nographic \
# 			--append "rdinit=/init console=ttyS0 nokaslr" \
# 			$3 $4
# fi
