#!/bin/bash

LINK_IMAGE="https://sourceforge.net/projects/xanmod/files/releases/lts/6.6.50-xanmod1/6.6.50-x64v3-xanmod1/linux-image-6.6.50-x64v3-xanmod1_6.6.50-x64v3-xanmod1-0~20240908.g4a315c8_amd64.deb/download"
LINK_HEADER="https://sourceforge.net/projects/xanmod/files/releases/lts/6.6.50-xanmod1/6.6.50-x64v3-xanmod1/linux-headers-6.6.50-x64v3-xanmod1_6.6.50-x64v3-xanmod1-0~20240908.g4a315c8_amd64.deb/download"


# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#install
rm -rf linux-*.deb 
if [[ "$(uname -r)" == "6.6.50-x64v3-xanmod1" ]]; then
echo -e "${YELLOW} (WARN) kernel sudah menggunakan xanmod 6.6.50 ${RESET}"
sleep 2
exit 1
else
echo -e "${RED} (ERR) kernel masih default ${RESET}"
sleep 1
echo -e "${GREEN} (INFO) mencoba install xanmod 6.6.50.......... ${RESET}"
sleep 2
      #downloading & install
echo -e "${GREEN} (INFO) mendownload linux-image ${RESET}"
sleep 1
      if wget $LINK_IMAGE -O linux-image.deb; then
      echo -e "${GREEN} (INFO) download success ${RESET}"
      sleep 1
      #update repository & install xanmod-image
      sudo apt update -y
      sudo dpkg -i linux-image.deb
      echo -e "${GREEN} (INFO) linux-image berhasil terinstall ${RESET}" 
      sleep 1
      #mendownload linux-header
              echo -e "${GREEN} (INFO) mendownload linux-header ${RESET}"
              if wget $LINK_HEADER -O linux-header.deb; then
              sleep 1
              echo -e "${GREEN} (INFO) linux-header berhasil di download ${RESET}"
              sleep 1
              echo -e "${GREEN} (INFO) mencoba menginstall linux-header ${RESET}"
                      if sudo dpkg -i linux-header.deb; then
                      echo -e "${GREEN} linux-header berhasil di install ${RESET}"
                      sleep 1
                      else
                      echo -e "${RED} (ERR) linux-header gagal terinstall ${RED}"
                      echo -e "${RED} (ERR) exiting ......."
                      exit 1
                      fi 
              else 
              echo -e "${RED} (ERR) linux-header gagal terdownload ${RESET}"
              echo -e "${RED} (ERR) exiting .......... ${RESET}"
              sleep 1
              exit 1
              fi
      else
      echo -e "${RED} (ERR) linux-image dan linux-header gagal terdownload ${RESET}"
      echo -e "${RED} exiting ......... ${RESET}"
      sleep 1
      exit 1
      fi
fi

     


