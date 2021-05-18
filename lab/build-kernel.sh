#!/bin/bash

OUTDIR=""
ARCHDIR=""
CONFIGFILE=""

# export INSTALL_PATH=$PWD/tmprfs/boot/
# export INSTALL_MOD_PATH=$PWD/tmprfs/
# export INSTALL_HDR_PATH=$PWD/tmprfs/usr/

if [ ! -n "$1" ] ;then
    echo "You should set arch, ths!"
else
    echo "Set arch : $1"
fi

install_rootfs()
{
	cd $OUTDIR
	mkdir tmprfs
	if [ $OUTDIR == "x86_64-build-out" ];then
		/usr/bin/expect <<-EOF
			spawn sudo mount -t ext4 /home/dongzaiq/work/lab/rootfs/make-ubuntu-initrc/rootfs-amd64.img ./tmprfs
			expect {
				"dongzaiq:" { send "isbn7810\r"; }
			}
			expect eof
		EOF
	fi
	if [ $OUTDIR == "arm64-build-out" ];then
		/usr/bin/expect <<-EOF
			spawn sudo mount -t ext4 /home/dongzaiq/work/lab/rootfs/make-ubuntu-initrc/rootfs-aarch64.img ./tmprfs
			expect {
				"dongzaiq:" { send "isbn7810\r"; }
			}
			expect eof
		EOF
	fi

	sudo make install INSTALL_PATH=$PWD/tmprfs/boot/
	sudo make modules_install INSTALL_MOD_PATH=$PWD/tmprfs/
	sudo make headers_install INSTALL_HDR_PATH=$PWD/tmprfs/usr/


	/usr/bin/expect <<-EOF
		spawn sudo umount ./tmprfs
		expect {
			"dongzaiq:" { send "isbn7810\r"; }
		}
		expect eof
	EOF
	cd ..
}

need_copy_config()
{
    echo -n "Need copy config (y/n) "
    read need
    if [ $need == "y" ];then
        echo "copy config!"
	cp ./arch/$1/configs/$2 ./$OUTDIR/.config
    else
        echo "no copy $1 config"
    fi
}

need_continue(){
    echo -n "Need continue $1 (y/n) "
    read need
    if [ $need == "y" ];then
        echo "continue $1!"
    else
        echo " stop $1 and exit!"
		exit
    fi
}

clear_build(){
	if [ -d $1 ];then
		echo "clear build"
		/usr/bin/expect <<-EOF
			spawn sudo rm -rf $1
			expect {
				"dongzaiq:" { send "isbn7810\r"; }
			}
			expect eof
		EOF
	fi
}


if [ $1 == "arm64" ];then
    echo "Config build env to aarch64"
    export ARCH=arm64
    export CROSS_COMPILE=aarch64-linux-gnu-
    OUTDIR="arm64-build-out"
    ARCHDIR="arm64"
    CONFIGFILE="defconfig"
	clear_build $OUTDIR
    mkdir $OUTDIR
    need_copy_config $ARCHDIR $CONFIGFILE
    make menuconfig O=./$OUTDIR/
    need_continue "build"
    make -j12 O=./$OUTDIR/
fi

if [ $1 == "x86_64" ];then
    echo "Config build env to x86_64"
    export ARCH=x86_64
    export CROSS_COMPILE=
    OUTDIR="x86_64-build-out"
    ARCHDIR="x86"
    CONFIGFILE="x86_64_defconfig"
	clear_build $OUTDIR
    mkdir $OUTDIR
    need_copy_config $ARCHDIR $CONFIGFILE
    make menuconfig O=./$OUTDIR/
    need_continue "build"
    make -j12 O=./$OUTDIR/
	install_rootfs
fi

if [ $1 == "arm64_E" ];then
    echo "Config build env to aarch64"
    export ARCH=arm64
    export CROSS_COMPILE=aarch64-linux-gnu-
    OUTDIR="arm64-build-out"
    ARCHDIR="arm64"
    CONFIGFILE="defconfig"
	clear_build $OUTDIR
    mkdir $OUTDIR
    make $CONFIGFILE O=./$OUTDIR/
    make -j12 O=./$OUTDIR/
fi

if [ $1 == "x86_64_E" ];then
    echo "Config build env to x86_64"
    export ARCH=x86_64
    export CROSS_COMPILE=
    OUTDIR="x86_64-build-out"
    ARCHDIR="x86"
    CONFIGFILE="x86_64_defconfig"
	clear_build $OUTDIR
    mkdir $OUTDIR
    make $CONFIGFILE O=./$OUTDIR/
    make -j12 O=./$OUTDIR/
fi
