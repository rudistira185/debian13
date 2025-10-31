#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

#var
GNS3=gns3server-user.service

#script
if [ "$(sudo systemctl is-active $GNS3)" = "active" ]; then
echo -e "${GREEN} "$GNS3" is active ${RESET}"
else
echo -e "${RED} "$GNS3" is not active ${RESET}"
fi

