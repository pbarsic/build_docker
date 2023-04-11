FROM iris/dev_base:latest

RUN apt-get update \
    && apt-get -y install sudo

ARG RUNTIME_USERNAME
ARG RUNTIME_UID
RUN groupadd $RUNTIME_USERNAME
RUN useradd -r -u $RUNTIME_UID -g $RUNTIME_USERNAME -G sudo,dialout -m $RUNTIME_USERNAME
RUN passwd -d $RUNTIME_USERNAME
USER $RUNTIME_USERNAME
ENV PATH=$PATH:/home/$RUNTIME_USERNAME/.local/bin
ENV CUDA_FORCE_PTX_JIT=1

#RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py \
#    && python3 /tmp/get-pip.py --user \
#    && rm /tmp/get-pip.py \
#    && pip3 install --user awscli

WORKDIR /home/$RUNTIME_USERNAME/

# to buid this image, run the following:
# docker build -t iris/paul:0.2 --build-arg RUNTIME_USERNAME=${USER} --build-arg RUNTIME_UID=${UID} .

