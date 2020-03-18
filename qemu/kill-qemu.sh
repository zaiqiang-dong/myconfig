pid=$(ps -e | grep "qemu")
echo $pid
tid=${pid%%pts*}
echo $tid
kill $tid
