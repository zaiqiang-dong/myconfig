path=$(pwd)
home=$(echo ~)
echo filepath=$path
echo home=$home
ln -s $path/.vim $home/.vim
ln -s $path/.vimrc $home/.vimrc
