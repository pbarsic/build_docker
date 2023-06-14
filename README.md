# Development Environment Setup (Docker)

This is a set of Docker files for building a repeatable development environment.

## pre-build

Follow the instructions on [this page](https://docs.docker.com/engine/install/ubuntu/)
to configure your system properly. 

Briefly:

``` bash
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

Follow the [post-install instructions](https://docs.docker.com/engine/install/linux-postinstall/).
Briefly, they are:

``` bash
sudo usermod -aG docker $USER
```

Log out and log in.

Verify the installation with `docker run hello-world`
which should produce:

```bash
$ docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.
```

Install the [NVIDIA Docker Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker). Briefly:

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
      | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list \
      | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
      | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt update
sudo apt install nvidia-docker2
sudo systemctl restart docker
```

Verify with `docker run --rm --gpus all nvidia/cuda:10.2-cudnn8-devel nvidia-smi`, which should look like:

```bash
$ docker run --rm --gpus all nvidia/cuda:10.2-cudnn8-devel nvidia-smi
Tue Nov 29 21:55:48 2022       
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 520.61.05    Driver Version: 520.61.05    CUDA Version: 11.8     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  NVIDIA GeForce ...  On   | 00000000:01:00.0 Off |                  N/A |
| N/A   42C    P8    N/A /  N/A |      9MiB /  4096MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
+-----------------------------------------------------------------------------+
```


Determine your CUDA architecture.
Copy the following file to `check_cuda.cu`, build it with `/usr/local/cuda/nvcc check_cuda.cu -o check_cuda`, and run the executable with `./check_cuda`. The output will tell you the compute architecture.
```cuda
// this source code comes from 
// https://wagonhelm.github.io/articles/2018-03/detecting-cuda-capability-with-cmake

#include <stdio.h>

int main(int argc, char **argv){
    cudaDeviceProp dP;
    float min_cc = 3.0;

    int rc = cudaGetDeviceProperties(&dP, 0);
    if(rc != cudaSuccess) {
        cudaError_t error = cudaGetLastError();
        printf("CUDA error: %s", cudaGetErrorString(error));
        return rc; /* Failure */
    }
    if((dP.major+(dP.minor/10)) < min_cc) {
        printf("Min Compute Capability of %2.1f required:  %d.%d found\n Not Building CUDA Code", min_cc, dP.major, dP.minor);
        return 1; /* Failure */
    } else {
        printf("Your CUDA compute architecture is %d.%d\n", dP.major, dP.minor);
        return 0; /* Success */
    }
}
```

Download TensorRt for the CUDA verison you intend to use and copy it into the `base` folder. 

## base

This folder contains the base installation, with the correct versions of dependencies
installed and also CUDA 10.2, CUDNN8, TensorRT 7.1.3.4, OpenCV 3.4.5 and Eigen 3.2.10.

Build this image with the following commands:  
```
cd base
docker build -t dev_base:$(cat ../version.txt) .
docker tag dev_base:$(cat ../version.txt) dev_base:latest
```

You can tag it with whatever name you wish, but that is what I did. You will need that
tag for a later part of the process, the iris packages builds.

## dev

1. Build a developer container, which is a thin container on top of `dev_base:latest` but does nice things with ownership and permissions: 
```bash
cd dev && \
docker build \
   -t ${USER}:$(cat ../version.txt) \
   --build-arg RUNTIME_USERNAME=${USER} \
   --build-arg RUNTIME_UID=${UID} \
   .
```

There is a line in `dev/Dockerfile` that says `ENV CUDA_FORCE_PTX_JIT=1`. This is necessary for a newer generation
GPU. I have an Ampere generation GPU (compute 8.6), but CUDA-10.2
only knows up to compute 7.x, so to compensate I build OpenCV at
that version and then set that environment variable.
[Backward Compatibility Guide](https://docs.nvidia.com/cuda/ampere-compatibility-guide/)


2. Mount the any folders prior to starting a docker container which may need those resources.
3. Start the container with the `dev/start_container.sh` script, which will cache container changes.
4. Clone and build any needed projects.

Once the images are built, you can see them with `docker image ls`. Once the
container has been started, you can see it with `docker container ls`. If the
Docker system has restarted, or the container has crashed, you can see if
it's still there with `docker contianer ls -a`

