#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if getent group docker > /dev/null; then
echo -e "${YELLOW} (WARN) docker group exist ${RESET}"
sleep 1
echo -e "${YELLOW} exiting... ${RESET}"
exit 1
else
echo -e "${RED} (ERR) dockergroup not found ${RESET}"
echo -e "${GREEN} (INFO) add docker to groups ${RESET}"
       if sudo groupadd docker; then
       echo -e "${GREEN} (INFO) success add docker to group ${RESET}"
       else
       echo -e "${RED} (ERR) failed add docker to group ${RESET}"
       fi
fi
