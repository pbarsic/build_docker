#!/bin/bash

set -e

rm /etc/apt/sources.list.d/cuda.list

apt update

apt -y install curl

# you need this old key for tensorrt
#apt-key del 7fa2af80

curl https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.0-1_all.deb \
    -o /tmp/cuda-keyring_1.0-1_all.deb && \
    dpkg -i /tmp/cuda-keyring_1.0-1_all.deb \
    && rm /tmp/cuda-keyring_1.0-1_all.deb

apt update
