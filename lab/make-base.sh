mkdir kernel
mkdir rootfs
mkdir qemu

cd kernel
git clone git@github.com:zaiqiang-dong/study-linux-5.8.18.git
cd ..

cd rootfs
cp ../../myconfig/lab/make-ubuntu-initrc . -rf
cp ../../myconfig/lab/make-mini-initrc . -rf
cd ..

cd qemu
git clone git@github.com:zaiqiang-dong/study-qemu-5.2.0.git
cd ..

cp ../myconfig/lab/auto-make.sh .
cp ../myconfig/lab/setup-qemu.sh .
cp ../myconfig/lab/kill-qemu.sh .
