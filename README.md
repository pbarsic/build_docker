# Development Environment Setup (Docker)

This is a set of Docker files for building a repeatable development environment.

## pre-build

Follow the instructions on [this page](https://irisautomation.atlassian.net/wiki/spaces/RD/pages/1792639001/Setup+Instructions+dev+environment+with+Docker) to configure your system properly. This repository contains
the scripts that you would otherwise have to copy and paste from there.

## base

This folder contains the base installation, with the correct versions of dependencies
installed and also CUDA 10.2, CUDNN8, TensorRT 7.1.3.4, OpenCV 3.4.5 and Eigen 3.2.10.

Build this image with the following commands:  
```
cd base
docker build -t iris/dev_base:$(cat ../version.txt) .
docker tag iris/dev_base:$(cat ../version.txt) iris/dev_base:latest
```

You can tag it with whatever name you wish, but that is what I did. You will need that
tag for a later part of the process, the iris packages builds.

## dev

1. Build a developer container, which is a thin container on top of `iris/dev_base:latest` but does nice things with ownership and permissions: 
```bash
cd dev && \
docker build \
   -t iris/${USER}:$(cat ../version.txt) \
   --build-arg RUNTIME_USERNAME=${USER} \
   --build-arg RUNTIME_UID=${UID} \
   .
```

There is a line in `dev/Dockerfile` that says `ENV CUDA_FORCE_PTX_JIT=1`. This is necessary for a newer generation
GPU. I have an Ampere generation GPU (compute 8.6), but CUDA-10.2
only knows up to compute 7.x, so to compensate I build OpenCV at
that version and then set that environment variable.
[Backward Compatibility Guide](https://docs.nvidia.com/cuda/ampere-compatibility-guide/)


2. Mount the shared folders (`/mnt/dms`, `/mnt/research`, `/mnt/sim`) prior to starting a docker container which may need those resources.
3. Start the container with the `dev/start_container.sh` script, which will cache container changes.
4. (optional) Clone and build any needed Iris projects.

Once the images are built, you can see them with `docker image ls`. Once the
container has been started, you can see it with `docker container ls`. If the
Docker system has restarted, or the container has crashed, you can see if
it's still there with `docker contianer ls -a`

### Dynamic Tracker

As a member of R&D, I'm biased toward getting Dynamic Tracker working. The
[setup instructions can be found here](https://irisautomation.atlassian.net/wiki/spaces/RD/pages/1792639001/Setup+Instructions+dev+environment+with+Docker).
If you've already built DT but have had to re-start the container for any reason, 
the cached state will be forgotten. In that case, simply run the `dev/install_dt.sh`
script to re-install.
