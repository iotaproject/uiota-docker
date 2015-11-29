#!/bin/bash

docker exec -i uiotaCont bash -c "esptool.py --port /dev/ttyUSB0 write_flash 0x00000 \
    /uiota/firmware/0x00000.bin 0x40000 /uiota/firmware/0x40000.bin"
