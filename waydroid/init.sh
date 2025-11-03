#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#script
if command -v waydroid > /dev/null; then
echo -e "${YELLOW} (WARN)waydroid exist ${RESET}"
echo -e "${YELLOW} exiting ........ ${RESET}"
sleep 2
exit 1
else
echo -e "${RED} (ERR) waydroid not installed ${RESET}"
echo -e "${RED} installing ........ ${RESET}"
  sudo apt update -y
  sudo apt install curl ca-certificates -y
  curl -s https://repo.waydro.id | sudo bash

  #install waydroid
   if sudo apt install waydroid -y; then
   echo -e "${GREEN} (INFO) waydroid success to install ${RESET}"
   echo -e "${GREEN} waydroid init, for install image ${RESET}"
   sleep 2
   else
   echo -e "${RED} (ERR) waydroid failed to install ${RESET}"
   echo -e "${RED} exiting ........ ${RESET}"
   exit 1
   fi
fi
