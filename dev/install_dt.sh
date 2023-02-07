#!/usr/bin/env bash

cd ~/iris_ws/src/video_stream_lib
sudo make install

cd ~/iris_ws/src/vilib/build
sudo make install
sudo ldconfig

