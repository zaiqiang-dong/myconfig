adb disconnect
adb root
sleep 1
adb tcpip 5555; sleep 2;
adb shell "ifconfig wlan0" | grep inet[^6]|grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}' | grep "192" | grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}' |xargs  adb connect
