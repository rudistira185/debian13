#/bin/bash

#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

FIRM_BIN="https://ota.tasmota.com/tasmota32/release/tasmota32.bin"
FIRM_FACTORY="https://ota.tasmota.com/tasmota32/release/tasmota32.factory.bin"
rm -rf firmware/*

echo -e "${YELLOW} (INFO) Download esp32_bin  . .. . . . . . ${RESET}"
if wget $FIRM_BIN -O firmware/tasmota32.bin; then
echo -e "${GREEN} (SUCCESS) succes download tasmota32.bin ${RESET}"
else 
echo -e "${RED} (ERR) error download tasmota32.bin ${RESET}"
fi

echo -e "${YELLOW} (Downloading factory32.bin) ......... ${RESET}"
if wget $FIRM_FACTORY -O firmware/factory32.bin; then
echo -e "${GREEN} (INFO) success download factory32.bin ${RESET}"
else
echo -e "${RED} (ERR) failed download factory32.bin ${RESET}"
fi
