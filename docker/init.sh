#!/bin/bash

#!/bin/bash

# Warna ANSI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

if [ -f /usr/bin/docker ]; then
echo -e "${YELLOW} (WARN) docker has installed ${RESET}"
sleep 1
echo -e "${YELLOW} exiting...... ${RESET}"
exit 1
else
echo -e "${RED} (ERR) docker not installed ${RESET}"
echo -e "${GREEN} (INFO) intalling docker ........ ${RESET}"
sleep 2
      #docker debian3
      # Add Docker's official GPG key:
      sudo apt-get update -y
      sudo apt-get install ca-certificates curl -y
      sudo install -m 0755 -d /etc/apt/keyrings
      sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
      sudo chmod a+r /etc/apt/keyrings/docker.asc

      #Add the repository to Apt sources:
      echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update -y

      #instal  docker
      sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y 
      sleep 2
      echo -e "${GREEN} (INFO) docker succes to installed ${RESET}"
      sleep 2
fi
