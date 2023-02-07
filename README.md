# Development Environment Setup (Docker)

This is a set of Docker files for building a repeatable development environment.

## base
This folder contains the base installation, with the correct versions of dependencies
installed and also CUDA 10.2, CUDNN8, TensorRT 7.1.3.4, OpenCV 3.4.5 and Eigen 3.2.10.

Build this image with the following commands:  
```
docker build -t iris/dev_base:0.1
docker tag iris/dev_base:0.1 iris/dev_base:latest
```

You can tag it with whatever name you wish, but that is what I did. You will need that
tag for a later part of the process, the iris packages builds.

Here's how I'm doing those builds:
1. Build a thin container on top of `iris/dev_base:latest` that just links to your UID and GID.
2. git clone any Iris source packages that you wish to build.
2. Run that container with your 

