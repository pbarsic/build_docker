#!/bin/bash

set -e

./cuda_key.sh

dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.1.3.4-ga-20200617_1-1_amd64.deb

apt -y install libhiredis-dev redis-server libboost-all-dev

./eigen_install.sh

# # 

./opencv_deps_install.sh

./opencv_build.sh

# up to here, it is non-iris packages.
# Everything after this should be done as development
#./video_stream_install.sh
