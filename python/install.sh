#!/bin/bash

sudo apt-get install -y libhdf5-dev libhdf5-serial-dev libhdf5-103

# below not needed for headless
# apt-get install libqtgui4 libqtwebkit4 libqt4-test python3-pyqt5

sudo apt-get -y install libatlas-base-dev
sudo apt-get -y install libjasper-dev
sudo apt-get -y install libharfbuzz-dev libopenexr-dev
sudo apt-get -y install libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get -y install libeigen3-dev
sudo apt-get -y install libtbb2 libtbb-dev
# sudo apt-get -y install ffmpeg # do I need this if I am using picamera?
# sudo apt-get -y install libjpeg8-dev libtiff-dev libjasper-dev libpng-dev libpng-tools
# sudo apt-get -y install libv4l-dev v4l-utils x264
sudo apt-get -y install libgtk-3-0 # wtf ... headless?

# .bashrc -> export LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libatomic.so.1
pip install opencv-contrib-python-headless
pip install picamera[array]
