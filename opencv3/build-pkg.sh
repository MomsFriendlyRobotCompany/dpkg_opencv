#!/usr/bin/env bash

if [[ $# -ne 1 ]]; then
  echo "Please supply an OpenCV version number"
  echo "ex: ./build-pkg.sh 3.4.0"
  exit 1
fi

VERSION=$1

mkdir -p ./opencv-dpkg
rm -fr ./opencv-dpkg/DEBIAN
mkdir -p ./opencv-dpkg/DEBIAN

cat <<EOF >./opencv-dpkg/DEBIAN/control
Package: opencv
Architecture: all
Maintainer: Kevin
Depends: debconf (>= 0.5.00)
Priority: optional
Version: ${VERSION}
Description: Kevins computer vision library
EOF

cat <<EOF >./opencv-dpkg/DEBIAN/copyright
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: opencv
Upstream-Contact: Name, <email@address>

Files: *
Copyright: 2011, Name, <email@address>
License: (MIT)
Full text of licence.

Unless there is a it can be found in /usr/share/common-licenses
EOF

cat <<EOF >./opencv-dpkg/DEBIAN/install
usr/*
EOF

cat <<EOF >./opencv-dpkg/DEBIAN/postinst
#!/bin/bash
set -e

echo ""
echo "============================="
echo "| Linking libraries         |"
echo "============================="
echo ""
ldconfig

echo ""
echo "============================="
echo "| Clean up and fix perms    |"
echo "============================="
echo ""

chown -R pi:pi /home/pi
chown -R pi:pi /usr/local
chown -R pi:pi /usr/lib/python2.7/dist-packages/
chown -R pi:pi /usr/lib/python3.*/

echo ""
echo "============================="
echo "|      <<< Done >>>         |"
echo "============================="
echo ""
EOF

chmod 0755 ./opencv-dpkg/DEBIAN/*

echo " > building OpenCV ${VERSION}"
echo ""
dpkg-deb -v --build opencv-dpkg libopencv-${VERSION}.deb

echo ""
echo " > reading debian package:"
echo ""
dpkg-deb --info libopencv-${VERSION}.deb
