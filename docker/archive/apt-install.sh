#!/bin/bash -e

apt-get update \
    && apt-get -y install build-essential cmake git pkg-config \
    libatlas-base-dev liblapacke-dev \
    yasm wget \
    libjpeg-dev libpng-dev libtiff-dev libjasper-dev \
    libavcodec-dev libavformat-dev libswscale-dev \
    libeigen3-dev \
    libtbb2 libtbb-dev \
    && apt-get -y autoremove
