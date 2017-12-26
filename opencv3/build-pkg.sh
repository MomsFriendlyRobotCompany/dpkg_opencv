#!/usr/bin/env bash

if [[ $# -ne 2 ]]; then
  echo "Please supply an OpenCV version number"
  echo "ex: ./build-pkg.sh 3.4.0"
fi

VERSION=$1

echo "building OpenCV ${VERSION}"
dpkg-deb -v --build opencv-dpkg libopencv${VERSION}.deb

echo ""
echo "reading debian package: \n"
dpkg-deb --info libopencv${VERSION}.deb
