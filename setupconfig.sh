#sudo apt-get install vim-gnome


#for java
sudo apt-get install openjdk-8-jdk

#for base
sudo apt-get install git-core
sudo apt-get install nupg
sudo apt-get install flex
sudo apt-get install bison
sudo apt-get install gperf
sudo apt-get install build-essential
sudo apt-get install zip
sudo apt-get install curl
sudo apt-get install zlib1g-dev
sudo apt-get install gcc-multilib
sudo apt-get install g++-multilib
sudo apt-get install libc6-dev-i386
sudo apt-get install lib32ncurses5-dev
sudo apt-get install x11proto-core-dev
sudo apt-get install libx11-dev
sudo apt-get install lib32z-dev
sudo apt-get install ccache
sudo apt-get install libgl1-mesa-dev
sudo apt-get install libxml2-utils
sudo apt-get install xsltproc
sudo apt-get install unzip
sudo apt-get install libutils-dev
sudo apt-get install libelf-dev
sudo apt-get install build-essential
sudo apt-get install libncurses5-dev
sudo apt-get install texinfo
sudo apt-get install libreadline-dev
sudo apt-get install android-platform-tools-base
sudo apt-get install android-tools-adb
sudo apt-get install android-tools-fastboot
sudo apt=get install qemu-user-static
sudo cp ./misc/rules.d/* /etc/udev/rules.d/

#ctags cscope
sudo apt install universal-ctags
sudo apt-get install cscope

#nodejs
sudo apt-get install nodejs
sudo apt install nodejs-legacy
sudo apt install npm
sudo npm config set registry https://registry.npm.taobao.org
sudo npm install n -g
sudo n stable

#python
sudo apt install python2.7-dev
sudo apt install python3-pip
pip3 install pynvim
pip3 install jedi
pip3 install neovim
pip3 install pylint
pip3 install 'python-language-server[yapf]'
pip3 install flake8

#install neovim
sudo apt-get install software-properties-common
sudo apt install  neovim

#add neovim config
cp ./vim-config/nvim ~/.config/ -r

#add clang tools
sudo apt install clangd

#for ssh config
cp ./ssh-config/config ~/.ssh/

#open ssh
sudo apt-get install openssh-server


#for open ssl
sudo apt-get install openssl
sudo apt-get install libssl-dev

#for termtosvg
pip3 install termtosvg
pip3 install pyte python-xlib svgwrite

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
yarn global add @vuepress/plugin-medium-zoom

#for download tool
sudo apt-get install axel

#for input method
sudo apt install fcitx fcitx-table-wbpy

#for zsh
sudo apt install zsh
sudo apt-get install subversion
chsh -s /bin/zsh

#for ripgrep
sudo apt  install ripgrep

#for fun
sudo apt install fortunes-min fortune-mod fortunes-zh
sudo npm install -g cowsay

#for un/rar
sudo apt install unrar rar

#zathura pdf
sudo apt install zathura

# vinager
sudo apt install vinagre

# set backgroud
sudo apt install feh

# dwm
sudo apt-get install suckless-tools libx11-dev libxft-dev libxinerama-dev
sudo apt install flameshot

# set font
sudo cp ./font-config/* /usr/share/fonts/
fc-cache -f -v

# xbindkeys
sudo apt install xbindkeys
# bindkey
sudo apt install bindkey
# net tool
sudo apt install net-tools

# x11 config
# sudo cp ./X11-config/xorg.conf /etc/X11/xrdp/

#build kernel
sudo apt install libelf-dev

#autoacp
sudo cp ./misc/agit.sh /usr/bin/agit
sudo cp ./misc/vman.sh /usr/bin/vman
mkdir ~/.cgdb
cp ./misc/cgdbrc ~/.cgdb/cgdbrc

#build
sudo apt install ninja-build
sudo apt-get install libglib2.0-dev
sudo apt-get install libpixman-1-dev

#aarch gcc
sudo apt install gcc-aarch64-linux-gnu

sudo apt install -y expect

#git config
git config --global user.email "zqdong@nreal.ai"
git config --global user.name "Zaiqiang Dong"
git config --global core.editor "vim"


#for env config
echo "export PATH=\$PATH:/home/$USER/.yarn/bin" >> ~/.bashrc


