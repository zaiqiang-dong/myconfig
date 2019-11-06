adb reboot bootloader
OUTROOT=.
sudo fastboot flash xbl_a xbl.elf
sudo fastboot flash xbl_b xbl.elf
sudo fastboot --slot all flash boot $OUTROOT/boot.img
sudo fastboot flash dtbo_a $OUTROOT/dtbo.img
sudo fastboot flash dtbo_b $OUTROOT/dtbo.img
sudo fastboot flash persist $OUTROOT/persist.img
sudo fastboot --slot all flash system $OUTROOT/system.img
sudo fastboot flash vbmeta_a $OUTROOT/vbmeta.img
sudo fastboot flash vbmeta_b $OUTROOT/vbmeta.img
sudo fastboot flash vendor_a $OUTROOT/vendor.img
sudo fastboot flash vendor_b $OUTROOT/vendor.img
sudo fastboot reboot
