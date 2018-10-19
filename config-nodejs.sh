
sudo apt-get install -y python-software-properties software-properties-common
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs
sudo apt install nodejs-legacy
sudo apt install npm

sudo npm config set registry https://registry.npm.taobao.org
sudo npm config list

sudo npm install n -g

sudo n stable
sudo node -v
