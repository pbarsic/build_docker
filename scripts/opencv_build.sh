#!/bin/bash

set -e

#Specify OpenCV version
cvVersion="3.4.5"

echo "Installing OpenCV ${cvVersion}"

workdir=$(mktemp -d)

# Create directory for installation
# cd to it and and save current working directory
pushd ${workdir}

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout $cvVersion
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
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
	    -D BUILD_opencv_cudacodec=OFF  ..

make -j$(nproc)
make install

ldconfig -v
popd
rm -rf ${workdir}
