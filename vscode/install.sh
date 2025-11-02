#!/bin/bash

LINK="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
SRC=/home/carlos/debian13/vscode

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#download vscode
rm -rf $SRC/vscode.deb
if wget $LINK -O vscode.deb;then
echo -e "${GREEN} (INFO) succes download vscode ${RESET}"
sleep 2
    #dpkg install
     if sudo dpkg -i vscode.deb; then 
     echo -e "${GREEN} (INFO) success install vscode ${RESET}"
     else
     echo -e "${RED} (ERR) failed install vscode ${RESET}"
     fi
else
echo -e "${RED} (ERR) failed download vscode ${RESET}"
exit 1
fi
