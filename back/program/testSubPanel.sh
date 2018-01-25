count=1
while true
do
	echo "--------------------"$count"-----------------------"
	adb root
	sleep 2
	adb shell input keyevent 82
	sleep 1
	adb shell input keyevent 82
	adb shell dumpsys SurfaceFlinger | grep "390 390"
	sleep 2
	adb reboot
	count=$((($count)+1))
	sleep 60
done
