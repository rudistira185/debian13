esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 460800 write_flash 0x1000 bootloader.bin 0x8000 partitions.bin 0xe0000 firmware.bin
