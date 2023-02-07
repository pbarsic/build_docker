#!/bin/sh

set -e

echo "Installing Prerequisite Libraries"
 

## Install dependencies
apt-get -y install \
    build-essential \
    checkinstall \
    cmake \
    git \
    gfortran \
    libatlas-base-dev
    libavcodec-dev \
    libavresample-dev \
    libavformat-dev \
    libdc1394-22-dev \
    libfaac-dev\
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev
    libgtk2.0-dev\
    libjpeg8-dev \
    libmp3lame-dev\
    libopencore-amrnb-dev\
    libopencore-amrwb-dev \
    libpng-dev \
    libtbb-dev qt5-default
    libtheora-dev
    libtiff-dev \
    libtiff5-dev \
    libswscale-dev \
    libv4l-dev \
    libvorbis-dev\
    libxine2-dev \
    libxvidcore-dev
    pkg-config \
    v4l-utils \
    x264 \
    yasm \
 
 
cd /usr/include/linux \
    && ln -s -f ../libv4l1-videodev.h videodev.h
 

echo "deb http://old-releases.ubuntu.com/ubuntu/ yakkety universe" | tee -a /etc/apt/sources.list \
    && apt update
    && apt-get -y install \
                  libjasper1 \
                  libjasper-dev
