process=`ps -e | grep "qemu"`
array=(${process// / })
echo "kill "${array[0]}
kill ${array[0]}
