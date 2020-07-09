idinfo=$(ps -e | grep "qemu" | awk '{print $1}')
array=($idinfo)

pid1=${array[0]}
pid2=${array[1]}

echo $pid1
echo $pid2

if [[ $1 == "a" ]]
then
    echo "kill "$pid1
    kill $pid1
    echo "kill "$pid2
    kill $pid2
else
    if [ $pid1 -gt $pid2 ]
    then
        echo "kill "$pid1
	kill $pid1
    else
        echo "kill "$pid2
	kill $pid2
    fi
fi
