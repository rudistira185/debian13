#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#var
SYSTEMD_SRC_USER=/home/carlos/debian13/systemd/user
SYSTEMD_DEST=/etc/systemd/system

if sudo cp "$SYSTEMD_SRC_USER/gns3server-user.service" "$SYSTEMD_DEST"; then
echo -e "${GREEN} (INFO) gns3server-user success copy to "$SYSTEMD_DEST" ${RESET}"
else
echo -e "${RED} (ERR) failed copy file to "$SYSTEMD_DEST" ${RESET}"
exit 1
fi
