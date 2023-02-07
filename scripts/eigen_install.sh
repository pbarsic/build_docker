#!/bin/bash

set -e

apt -y install cmake

tar -xvf eigen-3.2.10.tar.gz -C /tmp/
cd /tmp/eigen-3.2.10
mkdir build
cd build
cmake ..
make -j8
make install
ldconfig
rm -rf /tmp/eigen-3.2.10
