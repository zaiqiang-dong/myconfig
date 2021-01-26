cp ~/.config/nvim/init.vim ./nvim/init.vim
cp ~/.config/nvim/coc-settings.json ./nvim/coc-settings.json
cp ~/.config/nvim/colors/mycolor.vim ./nvim/colors/mycolor.vim
cp ~/.config/terminator/config ./terminator-config/terinator-config
cp ~/.hyper.js ./hyper-config/.hyper.js

git add .
git commit -m "update"
git push

