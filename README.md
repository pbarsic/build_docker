# Development Environment Setup (Docker)

This is a set of Docker files for building a repeatable development environment.

## base
This folder contains the base installation, with the correct versions of dependencies
installed and also CUDA 10.2, CUDNN8, TensorRT 7.1.3.4, OpenCV 3.4.5 and Eigen 3.2.10.

Build this image with the following commands:  
```
cd base
docker build -t iris/dev_base:0.3 .
docker tag iris/dev_base:0.3 iris/dev_base:latest
```

You can tag it with whatever name you wish, but that is what I did. You will need that
tag for a later part of the process, the iris packages builds.

### dev

1. Build a developer container, which is a thin container on top of `iris/dev_base:latest` but does nice things with ownership and permissions: `cd dev && docker build -t iris/dev`.
```
2. Mount the shared folders (`/mnt/dms`, `/mnt/research`, `/mnt/sim`) prior to starting a docker container which may need those resources.
3. Start the container with the `dev/run_docker.sh` script, which will cache container changes in the image.
4. (optional) Clone and build any needed Iris projects.

### Dynamic Tracker

As a member of R&D, I'm biased toward getting Dynamic Tracker working. The
[setup instructions can be found here](https://irisautomation.atlassian.net/wiki/spaces/RD/pages/1792639001/Setup+Instructions+dev+environment+with+Docker).
If you've already built DT but have had to re-start the container for any reason, 
the cached state will be forgotten. In that case, simply run the `dev/install_dt.sh`
script to re-install.

