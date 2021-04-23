#!/bin/bash

OUTDIR=""
ARCHDIR=""
CONFIGFILE=""

if [ ! -n "$1" ] ;then
    echo "You should set arch, ths!"
else
    echo "Set arch : $1"
fi


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
		rm -rf $1
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
    #CONFIGFILE="debian_defconfig"
	clear_build $OUTDIR
    mkdir $OUTDIR
    need_copy_config $ARCHDIR $CONFIGFILE
    make menuconfig O=./$OUTDIR/
    need_continue "build"
    make -j12 O=./$OUTDIR/
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
