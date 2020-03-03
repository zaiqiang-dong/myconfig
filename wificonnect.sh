adb disconnect
adb root
sleep 1
adb tcpip 5555; sleep 2;
adb shell ifconfig wlan0| grep -Eo  "*inet addr:[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*?"|grep -Eo "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | xargs  adb connect
