#!/bin/bash

sudo ./raspi-config.sh

# Before changing directories:
#
# Copy the udev ttyusb aliases
sudo cp ../99-usb-serial.rules /etc/udev/rules.d

# Install required programs
sudo apt-get -q -qq update
# Breaks on Ubuntu 14.04 VM
#apt-get -q -y dist-upgrade
sudo apt-get -y install git vim build-essential g++ tmux
sudo apt-get -y install gpsd libgps-dev gpsd-clients python-gps libi2c-dev

#give user permission to USB devices
sudo usermod -a -G dialout $USER

# TODO Use CRT forks

mkddir -p ~/Desktop/lib
# Install libxbee
cd ~/Desktop/lib
git clone https://github.com/attie/libxbee3
cd libxbee3
make configure
make all
sudo make install

# Install wiringpi
cd ~/Desktop/lib
git clone git://git.drogon.net/wiringPi
cd wiringPi
./build
# Enable I2C
gpio load i2c

# Copy a good vimrc
cd ~
git clone https://github.com/mahsu/vimrc
cd vimrc
chmod +x setup.sh
./setup.sh

# Clone development repos
mkdir -p ~/Desktop/dev
cd ~/Desktop/dev
git clone https://github.com/curocketry/launchvehiclecontroller2016
git clone https://github.com/mahsu/raspberrypi-adafruit10dof

echo "Reboot the machine to complete setup"
