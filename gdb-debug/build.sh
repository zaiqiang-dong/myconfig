mkdir build
cd build
../configure --prefix=/home/dongzaiq/Downloads/gdb-9.2/ --host=x86_64-linux-gnu --target=aarch64-linux-gnu
make
sudo cp ./gdb/gdb /usr/bin/aarch64-linux-gnu-gdb
