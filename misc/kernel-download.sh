git clone https://github.com/figozhang/runninglinuxkernel_4.0.git
cd runninglinuxkernel_4.0
ctags -R;cscope -Rbqk;
cd ..

wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.4.235.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.9.235.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.19.144.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v4.x/linux-4.14.147.tar.xz
wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.8.8.tar.xz

tar -xvf linux-4.4.235.tar.xz
tar -xvf linux-4.9.235.tar.xz
tar -xvf linux-4.19.144.tar.xz
tar -xvf linux-4.14.147.tar.xz
tar -xvf linux-5.8.8.tar.xz

cd linux-4.4.235
ctags -R;cscope -Rbqk;
cd ..

cd linux-4.9.235
ctags -R;cscope -Rbqk;
cd ..

cd linux-4.19.144
ctags -R;cscope -Rbqk;
cd ..

cd linux-4.14.147
ctags -R;cscope -Rbqk;
cd ..

cd linux-5.8.8
ctags -R;cscope -Rbqk;
cd ..
