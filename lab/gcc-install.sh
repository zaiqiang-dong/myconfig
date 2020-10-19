sudo chmod 777 /etc/apt/sources.list
echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial main" >> /etc/apt/sources.list
echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list
sudo chmod 644 /etc/apt/sources.list

sudo apt install gcc-5
sudo apt install g++-5
sudo apt install gcc-9
sudo apt install g++-9

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90

sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/g++-5 100
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/g++-9 90

sudo apt install gcc-4.9-aarch64-linux-gnu
sudo apt install gcc-9-aarch64-linux-gnu

sudo update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-9 90
sudo update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-4.9 100
