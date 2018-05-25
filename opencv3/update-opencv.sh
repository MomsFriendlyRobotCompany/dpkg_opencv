#!/usr/bin/env bash

# check if we are root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo ""
echo "============================="
echo "| Let's update some pkgs    |"
echo "============================="
echo ""

apt-get update
apt-get -y upgrade
apt-get -y install build-essential cmake git pkg-config python-dev swig
apt-get -y install libeigen3-dev
apt-get -y install ffmpeg
apt-get -y install libjpeg-dev libtiff5-dev libjasper-dev libpng-dev libpng-tools
apt-get -y install libv4l-dev v4l-utils
apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
apt-get -y --force-yes install libxvidcore-dev libx264-dev
apt-get -y install libatlas-base-dev gfortran
apt-get -y install python2.7-dev python3-dev
apt-get -y install libgtk2.0-dev
apt-get autoremove -y

# old
# apt-get -y install build-essential cmake git pkg-config python-dev swig
# apt-get -y install libeigen3-dev
# apt-get -y install ffmpeg
# apt-get -y install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
# apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
# apt-get -y install libxvidcore-dev libx264-dev
# apt-get -y install libatlas-base-dev gfortran
# apt-get -y install python2.7-dev
# apt-get -y install libgtk2.0-dev

echo ""
echo "============================="
echo "| Clean up and fix perms    |"
echo "============================="
echo ""

chown -R pi:pi /home/pi
chown -R pi:pi /usr/local
chown -R pi:pi /usr/lib/python2.7/dist-packages/
chown -R pi:pi /usr/lib/python3.*/dist-packages/

echo ""
echo "============================="
echo "| Done !!! :)               |"
echo "============================="
echo ""
