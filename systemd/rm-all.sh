#!/bin/bash

#var
gns3=gns3server-user.service

if sudo rm -rf /etc/systemd/system/$gns3; then
echo -e "$gns3 deleted"
else
echo -e "$gns3 failed remove"
fi
