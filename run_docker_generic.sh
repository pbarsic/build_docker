#!/usr/bin/env bash

xhost +local:docker

#IMAGE=nvidia/cuda:10.2-cudnn7-devel
IMAGE=nvidia/cuda:10.2-cudnn8-devel
ENTRYPOINT=/bin/bash
#ENTRYPOINT=nvidia-smi
WORKDIR=$HOME/Projects/docker_setup

docker run  \
    --gpus all \
    -it --rm \
    --network host \
    --name DynamicTracker_2 \
    --privileged \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v $HOME/Data:$HOME/Data \
    -v $HOME/Projects:$HOME/Projects \
    -v $HOME/iris_ws:$HOME/iris_ws \
    --workdir ${WORKDIR} \
    ${IMAGE} ${ENTRYPOINT}

