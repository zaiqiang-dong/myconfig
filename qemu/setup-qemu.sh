qemu-system-aarch64 -machine virt -cpu cortex-a57 -machine type=virt -nographic -m 2048  -kernel ./linux-4.4/arch/arm64/boot/Image --append "rdinit=/linuxrc console=ttyAMA0 loglevel=8" $1 $2
