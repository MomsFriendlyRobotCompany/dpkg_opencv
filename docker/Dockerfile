FROM balenalib/raspberrypi3-debian:buster-build

WORKDIR /opt/opencv

ENV VERSION="4.2.0"
# ENV VERSION="4.1.1"
ENV DIR=/opt/opencv/opencv-dpkg/usr/local
ENV CONTRIB_DIR=""
# ENV CONTRIB_DIR=../../opencv_contrib-$VERSION/modules

# # install pip
# RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
#     && python3 get-pip.py
#
# # do simple update
# RUN pip install -U \
#     pip \
#     setuptools \
#     wheel

# build package
# RUN ./update-docker.sh \
#     && ./build-opencv.sh $VERSION \
#     && ./build-pkg.sh $VERSION

RUN apt-get update \
    && apt-get -y install build-essential cmake git pkg-config \
    && apt-get -y install libhdf5-dev libhdf5-serial-dev libhdf5-103 \
    && apt-get -y install libatlas-base-dev liblapacke-dev \
    && apt-get -y install libjasper-dev \
    && apt-get -y install libharfbuzz-dev libopenexr-dev \
    && apt-get -y install libavcodec-dev libavformat-dev libswscale-dev \
    && apt-get -y install libeigen3-dev \
    && apt-get -y install libtbb2 libtbb-dev \
    && apt-get -y install libgtk-3-0 # wtf ... headless?

# setup things
RUN wget -O opencv-$VERSION.tar.gz https://github.com/opencv/opencv/archive/$VERSION.tar.gz \
    && tar -xzf opencv-$VERSION.tar.gz

RUN wget -O opencv_contrib-$VERSION.tar.gz https://github.com/opencv/opencv_contrib/archive/$VERSION.tar.gz \
    && tar -xzf opencv_contrib-$VERSION.tar.gz

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

RUN mkdir -p opencv-$VERSION/build \
    && cd opencv-$VERSION/build \
    && cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D OPENCV_EXTRA_MODULES_PATH=$CONTRIB_DIR \
    -D CMAKE_SHARED_LINKER_FLAGS='-latomic' \
    -D CMAKE_INSTALL_PREFIX=$DIR \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D BUILD_WITH_DEBUG_INFO=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_opencv_ts=OFF \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D WITH_EIGEN=ON \
    -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
    -D WITH_QT=OFF \
    -D WITH_GTK=OFF \
    -D WITH_VTK=OFF \
    -D WITH_FFMPEG=ON \
    -D WITH_OPENEXR=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF \
    .. \
    && make -j4 install


COPY build-pkg.sh .
RUN chmod a+x build-pkg.sh \
    && ./build-pkg.sh $VERSION
# ENTRYPOINT ["./build-pkg.sh"]
# RUN ["./build-pkg.sh", $VERSION]

run mkdir tmp \
    && mv kevin-opencv-$VERSION.deb tmp/

CMD ["/bin/bash"]
