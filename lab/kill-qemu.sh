p=(`ps -e | grep "qemu" | awk '$1=$1'`)
echo $p
array=($p)

kill $array[1]
