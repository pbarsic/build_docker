#!/usr/bin/env bash

xhost +local:docker

IMAGE=${USER}:$(cat ../version.txt)
ENTRYPOINT=/bin/bash
WORKDIR=$HOME
CONTAINERNAME=dev_${USER}

MOGRIFY=1

if [[ $MOGRIFY -eq 1 ]] ; then
  docker run  \
    --gpus all \
    -it \
    --network host \
    --name ${CONTAINERNAME} \
    --privileged \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /mnt/research:/mnt/research \
    -v /mnt/sim:/mnt/sim \
    -v /mnt/dms:/mnt/dms \
    -v $HOME/Data:$HOME/Data \
    -v $HOME/Projects:$HOME/Projects \
    --workdir ${WORKDIR} \
    ${IMAGE} ${ENTRYPOINT}
else
  docker run  \
    --gpus all \
    -it \
    --rm \
    --network host \
    --name ${CONTAINERNAME} \
    --privileged \
    -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /mnt/research:/mnt/research \
    -v /mnt/sim:/mnt/sim \
    -v /mnt/dms:/mnt/dms \
    -v $HOME/Data:$HOME/Data \
    -v $HOME/Projects:$HOME/Projects \
    --workdir ${WORKDIR} \
    ${IMAGE} ${ENTRYPOINT}
fi
