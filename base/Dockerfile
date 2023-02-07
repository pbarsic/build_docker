FROM nvidia/cuda:10.2-cudnn8-devel

RUN rm /etc/apt/sources.list.d/cuda.list
RUN apt-get update \
    && apt-get -y install \
               apt-utils \
               curl \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get -y install \
          libboost-all-dev \
          libhiredis-dev \
          redis-server \
    && rm -rf /var/lib/apt/lists/*

# ALTERNATIVE PROCEDURE
# install eigen and required dependencies from source
#RUN apt-get update && apt-get -y install cmake
#RUN curl https://gitlab.com/libeigen/eigen/-/archive/3.2.10/eigen-3.1.10.tar.bz2 -o /tmp/eigen-3.2.10.tar.bz2
#RUN tar -xf /tmp/eigen-3.2.10.tar.gz -C /tmp/ \
#    && eigendir=$(tar tf /tmp/eigen-3.2.10.tar.gz | sed 's@/.*@@' | uniq) \
#    && mkdir /tmp/${eigendir}/build \
#    && cd /tmp/${eigendir}/build \
#    && cmake .. \
#    && make -j$(($(nproc)-1)) \
#    && make install \
#    && ldconfig \
#    && rm -rf /tmp/eigen-3.2.10*

# OR DON'T install them from source because it does not
# properly configure cmake and just apt-get install them
RUN apt-get update \
    && apt-get -y install libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

## Install OpenCV dependencies
RUN apt-get update \
    && apt-get -y install \
             build-essential \
             checkinstall \
             cmake \
             git \
             gfortran \
             libatlas-base-dev \
             libavcodec-dev \
             libavresample-dev \
             libavformat-dev \
             libdc1394-22-dev \
             libfaac-dev\
             libgstreamer1.0-dev \
             libgstreamer-plugins-base1.0-dev \
             libgtk2.0-dev\
             libjpeg8-dev \
             libmp3lame-dev\
             libopencore-amrnb-dev\
             libopencore-amrwb-dev \
             libpng-dev \
             libtbb-dev qt5-default \
             libtheora-dev \
             libtiff-dev \
             libtiff5-dev \
             libswscale-dev \
             libv4l-dev \
             libvorbis-dev\
             libxine2-dev \
             libxvidcore-dev \
             pkg-config \
             v4l-utils \
             x264 \
             yasm \
    && rm -rf /var/lib/apt/lists/*

RUN cd /usr/include/linux \
    && ln -s -f ../libv4l1-videodev.h videodev.h

# install tensorrt
COPY nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.1.3.4-ga-20200617_1-1_amd64.deb /tmp
RUN dpkg -i /tmp/nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.1.3.4-ga-20200617_1-1_amd64.deb \
    && apt-key add /var/nv-tensorrt-repo-cuda10.2-trt7.1.3.4-ga-20200617/7fa2af80.pub \
    && apt-get update \
    && apt-get -y install libnvinfer7=7.1.3-1+cuda10.2 \
        libnvinfer-plugin7=7.1.3-1+cuda10.2 \
        libnvparsers7=7.1.3-1+cuda10.2 \
        libnvonnxparsers7=7.1.3-1+cuda10.2 \
        libnvinfer-bin=7.1.3-1+cuda10.2 \
        libnvinfer-dev=7.1.3-1+cuda10.2 \
        libnvinfer-plugin-dev=7.1.3-1+cuda10.2 \
        libnvparsers-dev=7.1.3-1+cuda10.2 \
        libnvonnxparsers-dev=7.1.3-1+cuda10.2 \
        libnvinfer-samples=7.1.3-1+cuda10.2 \
        libnvinfer-doc=7.1.3-1+cuda10.2 \
    && rm -rf /var/lib/apt/lists/* 


#    && rm /tmp/nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.1.3.4-ga-20200617_1-1_amd64.deb 
    #&& apt-get -y install tensorrt \
# avoid doing this because it will install the _wrong_ _version_ of cuda
# cuda 11 rather than cuda 10, and you don't want cuda 11
#RUN curl https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
#        -o /tmp/cuda-keyring_1.0-1_all.deb \
#    && dpkg -i /tmp/cuda-keyring_1.0-1_all.deb \
#    && rm /tmp/cuda-keyring_1.0-1_all.deb \
#    && rm -rf /var/lib/apt/lists/*


 
RUN echo "deb http://old-releases.ubuntu.com/ubuntu/ yakkety universe" | tee -a /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y install \
                  libjasper1 \
                  libjasper-dev \
    && rm -rf /var/lib/apt/lists/*

ENV cvVersion="3.4.5"

# build OpenCV version cvVersion
RUN cd /tmp \
    && git clone https://github.com/opencv/opencv.git \
    && cd opencv \
    && git checkout $cvVersion \
    && mkdir build \
    && cd build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
             -D WITH_TBB=ON \
             -D WITH_CUDA=ON \
             -D CUDA_ARCH_BIN="6.1" \
             -D CUDA_ARCH_PTX="" \
             -D WITH_CUBLAS=ON \
             -D ENABLE_FAST_MATH=ON \
             -D CUDA_FAST_MATH=ON \
             -D WITH_V4L=ON \
             -D BUILD_TESTS=OFF \
             -D BUILD_PERF_TESTS=OFF \
             -D BUILD_EXAMPLES=OFF \
             -D WITH_QT=ON \
             -D WITH_OPENGL=OFF \
	         -D BUILD_opencv_cudacodec=OFF \
             .. \
    && make -j$(($(nproc)-1)) \
    && make install \
    && ldconfig -v \
    && cd /tmp \
    && rm -rf /tmp/opencv

# other dependencies
RUN apt-get update \
    && apt-get -y install \
               libcrypto++-dev \
               libcrypto++-doc \
               libcrypto++-utils \
               uuid-runtime \
               libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*
