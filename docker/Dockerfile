FROM balenalib/raspberrypi3-debian:buster-build

WORKDIR /opt/opencv

ENV VERSION="4.2.0"
# ENV VERSION="4.1.1"
ENV DIR=/opt/opencv/opencv-dpkg/usr/local
ENV CONTRIB_DIR=""
# ENV CONTRIB_DIR=../../opencv_contrib-$VERSION/modules
ENV VIRTUAL_ENV=/opt/venv

# # install pip
# RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
#     && python3 get-pip.py
#
# do simple update

# RUN ls /opt

# build package
# RUN ./update-docker.sh \
#     && ./build-opencv.sh $VERSION \
#     && ./build-pkg.sh $VERSION

# RUN apt-get update \
#     && apt-get -y install build-essential cmake git pkg-config \
#     libhdf5-dev libhdf5-serial-dev libhdf5-103 \
#     libatlas-base-dev liblapacke-dev \
#     libjasper-dev \
#     libharfbuzz-dev libopenexr-dev \
#     libavcodec-dev libavformat-dev libswscale-dev \
#     libeigen3-dev \
#     libtbb2 libtbb-dev \
#     && apt-get -y autoremove
# && apt-get -y install libgtk-3-0 # wtf ... headless?

RUN apt-get update \
    && apt-get -y install build-essential cmake git pkg-config \
    libatlas-base-dev liblapacke-dev \
    yasm wget unzip \
    libjpeg-dev libpng-dev libtiff-dev libjasper-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libeigen3-dev \
    libtbb2 libtbb-dev \
    && apt-get -y autoremove

RUN apt-get update && apt-get install \
    -y --no-install-recommends python3 python3-virtualenv python3-dev python3-pip \
    && python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV

ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip3 install -U \
    pip \
    setuptools \
    wheel \
    numpy

# setup things
RUN wget -O opencv-$VERSION.tar.gz https://github.com/opencv/opencv/archive/$VERSION.tar.gz \
    && tar -xzf opencv-$VERSION.tar.gz

# RUN wget -O opencv_contrib-$VERSION.tar.gz https://github.com/opencv/opencv_contrib/archive/$VERSION.tar.gz \
#     && tar -xzf opencv_contrib-$VERSION.tar.gz

# add this back in for contrib
# -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-$VERSION/modules \
# RUN mkdir -p opencv-$VERSION/build \
#     && cd opencv-$VERSION/build \
#     && cmake \
#     -D CMAKE_BUILD_TYPE=RELEASE \
#     -D ENABLE_CXX11=ON \
#     -D OPENCV_EXTRA_MODULES_PATH=$CONTRIB_DIR \
#     -D CMAKE_SHARED_LINKER_FLAGS='-latomic' \
#     -D CMAKE_INSTALL_PREFIX=$DIR \
#     -D OPENCV_ENABLE_NONFREE=ON \
#     -D BUILD_WITH_DEBUG_INFO=OFF \
#     -D BUILD_DOCS=OFF \
#     -D BUILD_EXAMPLES=OFF \
#     -D BUILD_TESTS=OFF \
#     -D BUILD_opencv_ts=OFF \
#     -D ENABLE_NEON=ON \
#     -D ENABLE_VFPV3=ON \
#     -D WITH_EIGEN=ON \
#     -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
#     -D WITH_TBB=ON \
#     -D WITH_V4L=OFF \
#     -D WITH_LIBV4L=OFF \
#     -D WITH_FFMPEG=OFF \
#     -D WITH_QT=OFF \
#     -D WITH_GTK=OFF \
#     -D WITH_VTK=OFF \
#     -D WITH_FFMPEG=OFF \
#     -D WITH_OPENEXR=OFF \
#     -D WITH_OPENGL=OFF \
#     -D BUILD_opencv_python2=OFF \
#     -D BUILD_opencv_python3=OFF \
#     -D BUILD_PROTOBUF=OFF \
#     .. \
#     && make -j4 install
# -D OPENCV_EXTRA_MODULES_PATH=$CONTRIB_DIR \

RUN mkdir -p opencv-$VERSION/build \
    && cd opencv-$VERSION/build \
    && cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_SHARED_LINKER_FLAGS='-latomic' \
    -D CMAKE_INSTALL_PREFIX=$DIR \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_WITH_DEBUG_INFO=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_opencv_ts=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D BUILD_opencv_gapi=OFF \
    -D BUILD_opencv_highgui=OFF \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D WITH_EIGEN=ON \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D WITH_QT=OFF \
    -D WITH_GTK=OFF \
    -D WITH_VTK=OFF \
    -D WITH_FFMPEG=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_PROTOBUF=OFF \
    -D WITH_WEBP=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_OPENGL=ON \
    -D WITH_TIFF=ON \
    -D WITH_JPEG=ON \
    -D WITH_PNG=ON \
    .. \
    && make -j4 install


COPY build-pkg.sh .
# RUN chmod a+x build-pkg.sh \
#     && ./build-pkg.sh $VERSION


# ENTRYPOINT ["./build-pkg.sh"]
# RUN ["./build-pkg.sh", $VERSION]

# VOLUME /done

# to get the deb file
# docker run -ti -v `pwd`/pi-opencv:/done <image id> bash

# RUN mkdir -p /done \
#     && cp kevin-opencv-*.deb /done

CMD ["/bin/bash"]
