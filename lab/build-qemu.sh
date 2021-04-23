if [ -d build ]
then
	rm -rf ./build
fi

mkdir ./build
cd ./build
../configure --enable-debug
make -j12
cd ..

cd ./roms/seabios/
make
cd ../../

