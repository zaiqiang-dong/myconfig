cp ~/.config/nvim/init.vim ./nvim/init.vim
cp ~/.config/nvim/coc-settings.json ./nvim/coc-settings.json
cp ~/.config/nvim/colors/mycolor.vim ./nvim/colors/mycolor.vim
cp -r ~/.config/nvim/syntax ./nvim/
cp ~/.hyper.js ./hyper-config/.hyper.js
cp ~/.zshrc ./shell-zsh/.zshrc
cp ~/.history ./misc/

git add .
git commit -m "update"
git push

