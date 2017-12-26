#!/usr/bin/env bash
#
# ------------------------------------------------------------------------------
# This script will setup and build the binaries. It will also install the
# binaries to a local folder so the debian package can be built.
#
# The only thing you should need to change is:
# - OPENCV_VERSION
#
# Everything else should be left alone unless something changed in linux

# https://github.com/opencv/opencv/issues/7744

echo "start ---------------"

# -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
# -D PYTHON_INCLUDE_DIR2=$(python3 -c "from os.path import dirname; from distutils.sysconfig import get_config_h_filename; print(dirname(get_config_h_filename()))") \
# -D PYTHON_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
# -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
# -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
#

# check if we are root
if [ "$EUID" -ne 0 ] ; then
  echo "Please run as root"
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "Please supply an OpenCV version number"
  echo "ex: ./build-opencv.sh 3.4.0"
  exit 1
fi

OPENCV_VERSION=$1
CURRDIR=$(pwd)
OPENCV_INSTALL_DIR="$CURRDIR/opencv-dpkg/usr/local"

echo ""
echo "-------------------------------------------------"
echo "Installing to: $OPENCV_INSTALL_DIR"
echo "-------------------------------------------------"
echo ""


if [[ "$OSTYPE" == "linux-gnu" ]] || [[ "$OSTYPE" == "linux-gnueabihf" ]]; then
  # update system
  ./update-opencv.sh
  apt-get autoremove -y
fi

echo "----------------------------"
echo "Updating things python libs"
echo "----------------------------"

pip install -U pip setuptools wheel
pip install -U numpy PyYAML matplotlib simplejson

pip3 install -U pip setuptools wheel
pip3 install -U numpy PyYAML matplotlib simplejson

# fix permissions from above operations
chown -R pi:pi /usr/local

# python 2
PY2LIB=$(python -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))")
PY2INCLUDE=$(python -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PY2EXE=$(which python)
PY2NUMPY=$(python -c "import numpy; print(numpy.get_include())")
#PY2PKGS=$(python -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
PY2PKGS=$OPENCV_INSTALL_DIR/lib/python2.7/dist-packages

# python 3
PY3LIB=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))")
PY3INCLUDE=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")
PY3EXE=$(which python3)
PY3NUMPY=$(python3 -c "import numpy; print(numpy.get_include())")
#PY3PKGS=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
PY3PKGS=$OPENCV_INSTALL_DIR/lib/python3/dist-packages

if [ ! -f $OPENCV_VERSION.tar.gz ]; then
  wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz
else
  echo ""
  echo "<<< Using previously downloaded file >>>"
  echo ""
fi

# clean out the old
if [ -d opencv-$OPENCV_VERSION ]; then
  echo "*** Deleting opencv-${OPENCV_VERSION} ***"
  sleep 5
  rm -fr opencv-$OPENCV_VERSION
fi

# setup things
tar -xzf $OPENCV_VERSION.tar.gz
mkdir opencv-$OPENCV_VERSION/build
cd opencv-$OPENCV_VERSION/build

cmake -DCMAKE_BUILD_TYPE=RELEASE \
-DCMAKE_INSTALL_PREFIX=$OPENCV_INSTALL_DIR \
-DBUILD_opencv_python2=ON \
-DPYTHON2_PACKAGES_PATH=$PY2PKGS \
-DPYTHON2_LIBRARY=$PY2LIB \
-DPYTHON2_INCLUDE_DIR=$PY2INCLUDE \
-DPYTHON2_NUMPY_INCLUDE_DIRS=$PY2NUMPY \
-DPYTHON2_EXECUTABLE=$PY2EXE \
-DBUILD_opencv_python3=ON \
-DPYTHON3_PACKAGES_PATH=$PY3PKGS \
-DPYTHON3_LIBRARY=$PY3LIB \
-DPYTHON3_INCLUDE_DIR=$PY3INCLUDE \
-DPYTHON3_NUMPY_INCLUDE_DIRS=$PY3NUMPY \
-DPYTHON3_EXECUTABLE=$PY3EXE \
..

# make and install
make -j4
make install
