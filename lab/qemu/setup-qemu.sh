
if [ $1 = "arm64" ];then
    echo "run with arch=arm64"
    qemu-system-aarch64 -m 1024 -smp 2 \
 			-machine virt -cpu cortex-a57 -machine type=virt \
			-kernel $2/arm64-build-out/arch/arm64/boot/Image \
			-hda ../rootfs/arm64/sda-rootfs.img \
			--append "rdinit=/init root=/dev/vda console=ttyAMA0" \
			-nographic \
			$3 $4
fi

if [ $1 = "x86_64" ];then
    echo "run with arch=x86_64"
    qemu-system-x86_64  -m 1024 --enable-kvm  -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-initrd ../rootfs/x86_64/initrd.gz \
			-nographic \
			--append "rdinit=/init console=ttyS0 nokaslr" \
			$3 $4
fi

if [ $1 = "x86_64_Q" ];then
    echo "run with arch=x86_64"
    /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 --enable-kvm -m 1024  -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-initrd ../rootfs/x86_64/initrd.gz \
			--append "rdinit=/init console=ttyS0 nokaslr" \
			$3 $4
fi

if [ $1 = "x86_64_G" ];then
    echo "run with arch=x86_64"
    cgdb --args /home/dongzaiq/Downloads/qemu-5.2.0/build/qemu-system-x86_64 --enable-kvm -m 1024  -smp 1\
			-kernel $2/x86_64-build-out/arch/x86_64/boot/bzImage \
			-initrd ../rootfs/x86_64/initrd.gz \
			-nographic \
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

