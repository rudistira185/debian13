#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if command -v nginx > /dev/null; then
echo -e "${YELLOW} (WARN) nginx exist /usr/sbin/nginx ${RESET}"
echo -e "${YELLOW} (WARN) exiting ......${RESET}"
else
echo -e "${RED} (ERR) nginx not installed ${RESET}"
echo -e "${GREEN} (INFO) installing . . . . .. . ${RESET}"
sudo apt update -y
sudo apt install nginx
fi
