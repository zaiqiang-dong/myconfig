BASE=$PWD
cd ./kernel/study-linux-5.8.18/
./build-kernel.sh x86_64_E
./build-kernel.sh arm_64_E
cd $BASE

cd ./qemu/study-qemu-5.2.0
./build-qemu.sh
cd $BASE

cd ./rootfs/make-ubuntu-initrc
./make-rootfs.sh x86
./make-rootfs.sh aarch64
cd $BASE


