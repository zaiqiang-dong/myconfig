cp -r ./back ~
#sudo apt-get install vim-gnome

#for java
sudo apt-get install openjdk-8-jdk

#for android 
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip
sudo apt-get install android-platform-tools-base
sudo apt-get install android-tools-adb
sudo apt-get install android-tools-fastboot
sudo cp ./rules.d/* /etc/udev/rules.d/
#ctags cscope
sudo snap install universal-ctags
sudo apt-get install ctags cscope

#nodejs
curl -sL install-node.now.sh/lts | bash

#python
sudo apt install python3-pip
sudo apt install python-pip
pip3 install pynvim
pip install pynvim
pip install jedi
pip3 install jedi
pip install neovim
pip3 install neovim
sudo apt install python-flake8 python3-flake8 flake flake8

#install neovim
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install -y neovim

#add neovim config
cp ./nvim ~/.config/ -r

#add clang tools 
sudo apt-get install clang-tools-8
sudo ln -s /usr/bin/clangd-8 /usr/bin/clangd



