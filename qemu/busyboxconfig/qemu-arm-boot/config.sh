mkdir $1/etc
mkdir $1/dev
mkdir $1/mnt
mkdir -p $1/etc/init.d/

cp ./rcS $1/etc/init.d/
chmod a+x $1/etc/init.d/rcS
cp ./fstab $1/etc/
cp ./inittab $1/etc/

sudo mknod $1/dev/console c 5 1
sudo mknod $1/dev/null c 1 3

