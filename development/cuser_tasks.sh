#!/bin/bash

# Copy a good vimrc
cd ~
git clone https://github.com/mahsu/vimrc
cd vimrc
chmod +x setup.sh
./setup.sh

mkdir -p ~/Desktop/dev
cd ~/Desktop/dev
git clone https://github.com/curocketry/launchvehiclecontroller2016
