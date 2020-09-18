if [ -d "./build-out" ]; then
    echo "build-out dir exit"
else
    mkdir build-out
fi

if [ $1 == "arm64" ];then
    echo "Config build env to aarch64"
    export ARCH=arm64
    export CROSS_COMPILE=aarch64-linux-gnu-
    cp ./arch/arm64/configs/defconfig ./.config
fi

if [ $1 == "x86_64" ];then
    echo "Config build env to x86_64"
    cp ./arch/x86/configs/x86_64_defconfig ./.config
fi


if [ $1 == "menuconfig" ];then
    cp ./.config ./build-out/
    make menuconfig O=./build-out/
fi

if [ $1 == "build" ];then
    make -j12 O=./build-out/
fi


