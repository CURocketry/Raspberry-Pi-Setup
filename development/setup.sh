#!/bin/bash

sudo ../raspi-config.sh

# Before changing directories:
#
# Copy the udev ttyusb aliases
sudo cp ../99-usb-serial.rules /etc/udev/rules.d

# Install required programs
sudo apt-get -q -qq update
#sudo apt-get -q -y dist-upgrade
#sudo rpi-update
sudo apt-get -y install git vim build-essential g++ python python-dev
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

# Install zlog
cd ~/Desktop/lib
git clone github.com/HardySimpson/zlog
cd zlog
make
sudo make install

# Copy a good vimrc
cd ~
git clone https://github.com/mahsu/vimrc
cd vimrc
sudo chmod +x setup.sh
./setup.sh

# Clone development repos
mkdir -p ~/Desktop/dev
cd ~/Desktop/dev
git clone https://github.com/curocketry/launchvehiclecontroller2016

git clone https://github.com/mahsu/RaspberryPi-Adafruit10DOF
cd RaspberryPi-Adafruit10DOF
make all
sudo make install

echo "Reboot the machine to complete setup"
