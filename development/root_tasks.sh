#!/bin/bash

# Exit if the script was not launched by root or through sudo
if [[ $UID != 0 ]];
then
    echo "The script needs to run as root" && exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Before changing directories:
#
# Copy the udev ttyusb aliases
cp ../99-usb-serial.rules /etc/udev/rules.d

# Install required programs
apt-get -q -qq update
#apt-get -q -y dist-upgrade
apt-get -y install git vim build-essential g++ tmux
apt-get -y install gpsd libgps-dev gpsd-clients python-gps

#give user permission to USB devices
sudo usermod -a -G dialout $USER

# Install libxbee
cd ~/Desktop
mkdir -p lib
cd lib
git clone https://github.com/attie/libxbee3
cd libxbee3
make configure
make all
sudo make install

echo "Reboot the machine to complete setup"
