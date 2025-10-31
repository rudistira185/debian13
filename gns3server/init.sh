#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if [ -f /home/carlos/.local/bin/gns3server ]; then
echo -e "${YELLOW} (WARN) gns3server has installed ${RESET}"
echo -e "${YELLOW} exiting ....... ${RESET}"
sleep 2
exit 1
else
echo -e "${RED} (ERR) gns3server not installed ${RED}"
sleep 1
echo -e "${GREEN} (INFO) Run the installation..... ${RESET}"
sleep 1
    #installerdebian13
     sudo apt update -y
     sudo apt install python3 python3-pip pipx python3-pyqt5 python3-pyqt5.qtwebsockets python3-pyqt5.qtsvg qemu-kvm qemu-utils libvirt-clients libvirt-daemon-system virtinst ca-certificates curl gnupg2 -y
    #pipx 
     pipx install gns3-server
     pipx install gns3-gui
     pipx inject gns3-gui gns3-server PyQt5
fi
