cp ~/.config/nvim/init.vim ./nvim/init.vim
cp ~/.config/nvim/coc-settings.json ./nvim/coc-settings.json
cp ~/.config/terminator/config ./terminator-config/terinator-config

git add .
git commit -m "update"
git push

