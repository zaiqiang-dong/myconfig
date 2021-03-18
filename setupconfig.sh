#sudo apt-get install vim-gnome

#for java
sudo apt-get install openjdk-8-jdk

#for android
sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc unzip build-essential libncurses5-dev texinfo libreadline-dev
sudo apt-get install android-platform-tools-base
sudo apt-get install android-tools-adb
sudo apt-get install android-tools-fastboot
sudo cp ./misc/rules.d/* /etc/udev/rules.d/

#ctags cscope
sudo snap install universal-ctags
sudo apt-get install cscope

#nodejs
sudo apt-get install nodejs
sudo apt install nodejs-legacy
sudo apt install npm
sudo npm config set registry https://registry.npm.taobao.org
sudo npm install n -g
sudo n stable

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
sudo apt install clangd

#for ssh config
cp ./sshconfig/config ~/.ssh/


#for open ssl
sudo apt-get install openssl
sudo apt-get install libssl-dev

#for sphinx
apt-get install python3-sphinx

#for termtosvg
sudo pip3 install termtosvg
sudo pip3 install pyte python-xlib svgwrite

#for vuepress bolg system
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install --no-install-recommends yarn

yarn global add vuepress
yarn global add vuepress-plugin-mathjax
yarn global add vuepress-plugin-container
yarn global add @vuepress/plugin-back-to-top -D
yarn global add @vuepress/plugin-google-analytics -D
yarn global add @vssue/api-github-v3
yarn global add @vssue/vuepress-plugin-vssue

#for download tool
sudo apt-get install axel

#for input method
sudo apt install fcitx fcitx-table-wbpy

#for zsh
sudo apt install zsh
sudo apt-get install subversion
sudo chsh -s /bin/zsh

#for terminator
# sudo apt install terminator
# cp ./terminator-config/terinator-config ~/.config/terminator/config


#for ripgrep
sudo apt  install ripgrep

#for fun
sudo apt install fortunes-min fortune-mod fortunes-zh
sudo npm install -g cowsay

#for un/rar
sudo apt install unrar rar

# vinager
sudo apt install vinagre

#for env config
echo "export PATH=\$PATH:/home/$USER/.yarn/bin" >> ~/.bashrc

