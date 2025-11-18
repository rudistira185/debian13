#/bin/bash

sudo usermod -a -G dialout $USER

echo "Reboot for reload permission"