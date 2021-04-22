BASE=$PWD
cd ./kernel/study-linux-5.8.18/
./build-kernel.sh x86_64_E
./build-kernel.sh arm64_E
cd $BASE

cd ./qemu/study-qemu-5.2.0
./build-qemu.sh
cd $BASE



