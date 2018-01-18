adb reboot-bootloader

sleep 4

fastboot flash aboot emmc_appsboot.mbn
fastboot flash boot boot.img
fastboot flash cache cache.img
fastboot flash recovery recovery.img
fastboot flash -S 100M system system.img
fastboot flash userdata userdata.img

fastboot reboot
