FROM ubuntu:20.04

# Change into home directory of the root user
WORKDIR /root

# Update the base image
RUN apt-get update
RUN apt-get upgrade -y

# Install base dependencies
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get install -y wget git python3 python-is-python3 python3-venv tzdata

# Install ROCm
RUN wget https://repo.radeon.com/amdgpu-install/5.3/ubuntu/focal/amdgpu-install_5.3.50300-1_all.deb
RUN apt-get install -y ./amdgpu-install_5.3.50300-1_all.deb
RUN rm -f amdgpu-install_5.3.50300-1_all.deb
RUN yes | amdgpu-install --usecase=dkms,graphics,rocm,lrt,hip,hiplibsdk
RUN apt-get install -y libopenmpi-dev miopen-hip libopenblas-dev
RUN ln -s libroctx64.so /opt/rocm/lib/libroctx64.so.1
RUN ln -s libroctracer64.so /opt/rocm/lib/libroctracer64.so.1

# Create a python virtual environment
RUN mkdir stable-diffusion
RUN cd stable-diffusion
ENV VIRTUAL_ENV=/root/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN bash -c 'source ./venv/bin/activate; python -m pip install --upgrade pip wheel'

# Install torch and stable diffusion
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm530/hsa-rocr_1.7.0.50300-63.20.04_amd64.deb
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm530/rocblas_2.45.0.50300-63.20.04_amd64.deb
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm500/torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl
RUN wget https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm500/torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
RUN apt-get install --allow-downgrades -y ./hsa-rocr_1.7.0.50300-63.20.04_amd64.deb ./rocblas_2.45.0.50300-63.20.04_amd64.deb
RUN yes | python -m pip install --upgrade pip wheel
RUN yes | python -m pip install diffusers huggingface-hub transformers accelerate
RUN yes | python -m pip install torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
ENV LD_LIBRARY_PATH=/opt/rocm/lib

# Final clean up
RUN rm -f hsa-rocr_1.7.0.50300-63.20.04_amd64.deb rocblas_2.45.0.50300-63.20.04_amd64.deb torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
