#!/usr/bin/env bash

sudo apt-get install cmake sshpass uml-utilities bridge-utils net-tools -y

mkdir -p ~/MAINFRAME/
cd ~/MAINFRAME
git clone https://github.com/hercules-390/hyperion
cd hyperion

# https://github.com/hercules-390/hyperion/commit/c0d55c55201a7829ac5171f2c750c057cc3016db  19 Aug 2018 
git checkout c0d55c55201a7829ac5171f2c750c057cc3016db

mkdir build
cd build
cmake ..
make
sudo make install
