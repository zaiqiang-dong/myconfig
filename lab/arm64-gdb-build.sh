cd ~/Downloads
wget ftp://sourceware.org/pub/gdb/releases/gdb-9.2.tar.xz
mkdir gdb-build-aarm64
cd gdb-build-aarm64
tar -xvf ../gdb-9.2.tar.xz -C .
mkdir build
cd build
../gdb-9.2/configure --host=x86_64-linux-gnu --target=aarch64-linux-gnu --prefix=/home/dongzaiq/Downloads/gdb-build/
make -j12
