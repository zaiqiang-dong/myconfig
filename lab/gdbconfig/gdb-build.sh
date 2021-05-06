t=`pwd`
cd ~/Downloads
wget http://ftp.gnu.org/gnu/gdb/gdb-10.2.tar.xz
tar -xvf ./gdb-10.2.tar.xz

mkdir gdb-build-aarm64
cd gdb-build-aarm64
../gdb-10.2/configure --host=x86_64-linux-gnu --target=aarch64-linux-gnu --prefix=/usr/local --enable-python
make -j12
sudo make install
cd ..

mkdir gdb-build-x86
cd gdb-build-x86
../gdb-10.2/configure --prefix=/usr/local --enable-python
make -j12
sudo make install
cd ..

wget https://cgdb.me/files/cgdb-0.7.0.tar.gz
tar -xvf cgdb-0.7.0.tar.gz
cd cgdb-0.7.0
./autogen.sh
./configure --prefix=/usr/local
make
sudo make install

cd $t

