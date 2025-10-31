#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if  [[ $USER = "carlos" ]]; then
echo -e "${GREEN}(INFO) user adalah $USER ${RESET}"
else
echo -e "${RED} (ERR) user bukan carlos ${RESET}"
echo -e "${RED} exiting...."
sleep 2
exit 1
fi
