cp $1 $2 -r
sudo mknod $2/_install/dev/console c 5 1
sudo mknod $2/_install/dev/null c 1 3
