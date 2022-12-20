FROM ubuntu:20.04

##ARG -it
#ARG -v $HOME:/data
##ARG --rm
#ARG --privileged
#ARG --device=/dev/kfd
#ARG --device=/dev/dri
#ARG --group-add video
#ARG -p 7860:7860
ARG -v $HOME:/data --privileged --rm --device=/dev/kfd --device=/dev/dri --group-add video -p 7860:7860

# Change into home directory of the root user
WORKDIR /root

# Update the base image
RUN apt-get update
RUN apt-get upgrade -y

# Install base dependencies
# DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="Etc/UTC"
RUN echo 'export TZ="Etc/UTC"' >> /root/.bashrc
RUN apt-get install -y wget git python3 python-is-python3 python3-venv tzdata libjpeg-dev

# Install ROCm
RUN wget https://repo.radeon.com/amdgpu-install/5.3/ubuntu/focal/amdgpu-install_5.3.50300-1_all.deb
RUN apt-get install -y ./amdgpu-install_5.3.50300-1_all.deb
RUN rm -f amdgpu-install_5.3.50300-1_all.deb
RUN apt-get update
RUN yes | amdgpu-install --usecase=dkms,graphics,rocm,lrt,hip,hiplibsdk
RUN apt-get update
RUN apt-get install -y libopenmpi-dev libopenblas-dev miopen-hip
RUN ln -s libroctx64.so /opt/rocm/lib/libroctx64.so.1
RUN ln -s libroctracer64.so /opt/rocm/lib/libroctracer64.so.1

# Install PyTorch and AUTOMATIC1111/stable-diffusion-webui
RUN mkdir -p /root/stable-diffusion
RUN cd /root/stable-diffusion

## Create a python virtual environment
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui /root/stable-diffusion/stable-diffusion-webui
ENV VIRTUAL_ENV="/root/stable-diffusion/stable-diffusion-webui/venv"
RUN echo 'export VIRTUAL_ENV="/root/stable-diffusion/stable-diffusion-webui/venv"' >> /root/.bashrc
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN echo 'export PATH="$VIRTUAL_ENV/bin:$PATH"' >> /root/.bashrc
RUN bash -c 'source "$VIRTUAL_ENV/bin/activate"; python -m pip install --upgrade pip wheel'
RUN echo 'source "$VIRTUAL_ENV/bin/activate"' >> /root/.bashrc

## Install PyTorch and dependencies
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm530/hsa-rocr_1.7.0.50300-63.20.04_amd64.deb
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm530/rocblas_2.45.0.50300-63.20.04_amd64.deb
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm500/torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm500/torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
RUN apt-get install --allow-downgrades -y ./hsa-rocr_1.7.0.50300-63.20.04_amd64.deb ./rocblas_2.45.0.50300-63.20.04_amd64.deb
RUN yes | python -m pip install --upgrade pip wheel
RUN yes | python -m pip install diffusers
RUN yes | python -m pip install huggingface-hub
RUN yes | python -m pip install transformers
RUN yes | python -m pip install accelerate
RUN yes | python -m pip install gfpgan
RUN yes | python -m pip install clip
RUN yes | python -m pip install open_clip_torch

RUN git clone "https://github.com/Stability-AI/stablediffusion.git" "/root/stable-diffusion/stable-diffusion-webui/repositories/stable-diffusion-stability-ai"
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/stable-diffusion-stability-ai; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/stable-diffusion-stability-ai fetch'
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/stable-diffusion-stability-ai; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/stable-diffusion-stability-ai checkout 47b6b607fdd31875c9279cd2f4f16b92e4ea958e'

RUN git clone "https://github.com/CompVis/taming-transformers.git" "/root/stable-diffusion/stable-diffusion-webui/repositories/taming-transformers"
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/taming-transformers; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/taming-transformers fetch'
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/taming-transformers; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/taming-transformers checkout 24268930bf1dce879235a7fddd0b2355b84d7ea6'

RUN git clone "https://github.com/crowsonkb/k-diffusion.git" "/root/stable-diffusion/stable-diffusion-webui/repositories/k-diffusion"
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/k-diffusion; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/k-diffusion fetch'
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/k-diffusion; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/k-diffusion checkout 5b3af030dd83e0297272d861c19477735d0317ec'

RUN git clone "https://github.com/sczhou/CodeFormer.git" "/root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer"
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer fetch'
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer checkout c5b4593074ba6214284d6acd5f1719b6c5d739af'

RUN git clone "https://github.com/salesforce/BLIP.git" "/root/stable-diffusion/stable-diffusion-webui/repositories/BLIP"
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/BLIP; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/BLIP fetch'
RUN bash -c 'cd /root/stable-diffusion/stable-diffusion-webui/repositories/BLIP; git -C /root/stable-diffusion/stable-diffusion-webui/repositories/BLIP checkout 48211a1594f1321b00f14c9f7a5b4813144b2fb9'

#RUN yes | python -m pip install cython
#RUN yes | python -m pip install pycocotools
RUN yes | python -m pip install -r /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer/requirements.txt
RUN yes | python -m pip install -r /root/stable-diffusion/stable-diffusion-webui/requirements.txt
#RUN yes | python -m pip install xformers
### These packages need to be installed with the same command or it won't work
### (because installing torchvision would uninstall torch and install the stock
### verion from pypi instead).
RUN yes | python -m pip install --force-reinstall torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
ENV LD_LIBRARY_PATH="/opt/rocm/lib"
RUN echo 'export LD_LIBRARY_PATH="/opt/rocm/lib"' >> /root/.bashrc
RUN wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -O /root/stable-diffusion/stable-diffusion-webui/model.ckpt

# TODO: Provide a model at /root/stable-diffusion/stable-diffusion-webui/model.ckpt

RUN useradd sd -d /root/stable-diffusion
RUN chown -R sd:sd /root/stable-diffusion
RUN chmod 755 /root

#RUN sudo -u sd env LD_LIBRARY_PATH="/opt/rocm/lib" bash -c 'cd ~/stable-diffusion-webui; source venv/bin/activate; ./webui.sh --skip-torch-cuda-test; true'
RUN sudo -u sd env LD_LIBRARY_PATH="/opt/rocm/lib" bash -c 'cd ~/stable-diffusion-webui; source venv/bin/activate; python -c "import webui; webui.initialize()"; true' # This will error out - but that's fine, so we ignore it.
RUN sudo -u sd bash -c "cd ~/stable-diffusion-webui; sed 's|^IS_HIGH_VERSION = |IS_HIGH_VERSION = False # |' -i repositories/CodeFormer/facelib/detection/yolov5face/face_detector.py"

# TODO: Patch /root/stable-diffusion/stable-diffusion-webui/repositories/CodeFormer/facelib/detection/yolov5face/face_detector.py
# to force `IS_HIGH_VERSION` = False (it will try to parse the torch version, 1.11.0a0, into three integers otherwise, which won't work
# because "0a0" is not an int).
# We cannot do this right now, because it is only cloned when actually running CodeFormer

# Final clean up
#RUN rm -f hsa-rocr_1.7.0.50300-63.20.04_amd64.deb rocblas_2.45.0.50300-63.20.04_amd64.deb torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl

EXPOSE 7860/tcp
EXPOSE 7860/udp

# You can run it with on command:
#sudo -u sd env LD_LIBRARY_PATH="/opt/rocm/lib" bash -c 'cd ~/stable-diffusion-webui; source venv/bin/activate; ./webui.sh --disable-safe-unpickle --listen --medvram'
