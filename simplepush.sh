cp ~/.config/nvim/init.vim ./vim-config/nvim/init.vim
cp ~/.config/nvim/coc-settings.json ./vim-config/nvim/coc-settings.json
cp ~/.config/nvim/colors/mycolor.vim ./vim-config/nvim/colors/mycolor.vim
cp -r ~/.config/nvim/syntax ./vim-config/nvim/
cp ~/.hyper.js ./hyper-config/.hyper.js
cp ~/.zshrc ./shell-zsh/.zshrc
cp ~/.histfile ./misc/

git add .
git commit -m "update"
git push

