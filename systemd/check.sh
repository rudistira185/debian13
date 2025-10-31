#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

DST=/etc/systemd/system

#service
GNS3SERVER_USER=gns3server-user.service


#check
if [ -f $DST/$GNS3SERVER_USER ]; then
echo -e "${GREEN} (INFO) gns3server exist ${RESET}"
else 
echo -e "${RED} (ERR) gns3server not exist ${RESET}"
fi
