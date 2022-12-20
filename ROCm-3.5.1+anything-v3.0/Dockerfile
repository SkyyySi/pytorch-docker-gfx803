FROM ubuntu:20.04

# Change into home directory of the root user
WORKDIR /root

# Update the base image
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

# Install base dependencies
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN apt-get install -y wget git python3 python-is-python3 python3-venv tzdata gnupg linux-headers-5.4.0-54-generic libnuma-dev

# Install ROCm
###RUN wget https://repo.radeon.com/amdgpu-install/5.3/ubuntu/focal/amdgpu-install_5.3.50300-1_all.deb
###RUN apt-get install -y ./amdgpu-install_5.3.50300-1_all.deb
###RUN rm -f amdgpu-install_5.3.50300-1_all.deb
###RUN yes | amdgpu-install --usecase=dkms,graphics,rocm,lrt,hip,hiplibsdk
###RUN apt-get install -y libopenmpi-dev miopen-hip libopenblas-dev
###RUN ln -s libroctx64.so /opt/rocm/lib/libroctx64.so.1
###RUN ln -s libroctracer64.so /opt/rocm/lib/libroctracer64.so.1
#RUN echo 'APT { Get { AllowUnauthenticated "1"; }; };' >> /etc/apt/apt.conf # The official signature key seems to have expired :/
#RUN wget -q -O - 'http://repo.radeon.com/rocm/apt/3.5.1/rocm.gpg.key' | apt-key add -
RUN wget -q -O - 'https://repo.radeon.com/rocm/rocm.gpg.key' | apt-key add -
RUN echo 'deb [arch=amd64] http://repo.radeon.com/rocm/apt/3.5.1/ xenial main' | tee /etc/apt/sources.list.d/rocm.list
RUN apt-get update
#RUN apt-get install -y amdgpu-dkms rocm-core amdgpu-core amdgpu-lib amdgpu-lib32 rocm-dev rocm-language-runtime rocm-hip-runtime rocm-hip-sdk libopenmpi-dev miopen-hip libopenblas-dev rocm-libs 
RUN apt-get install -y rocm-dkms libopenmpi-dev miopen-hip libopenblas-dev rocm-libs rccl
RUN echo 'export PATH="${PATH}:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin"' >> /etc/profile.d/rocm.sh
ENV PATH="${PATH}:/opt/rocm/bin:/opt/rocm/profiler/bin:/opt/rocm/opencl/bin"
RUN ldconfig

# Create a python virtual environment
RUN mkdir stable-diffusion
RUN cd stable-diffusion
ENV VIRTUAL_ENV=/root/venv
RUN python -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN bash -c 'source ./venv/bin/activate; python -m pip install --upgrade pip wheel'

# Install torch and stable diffusion
ENV LB_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/rocm/hip/lib:/opt/rocm/lib"
RUN wget 'https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm35/torch-1.7.0a0-cp38-cp38-linux_x86_64.whl'
RUN wget 'https://github.com/xuhuisheng/rocm-gfx803/releases/download/rocm35/torchvision-0.8.0a0+2f40a48-cp38-cp38-linux_x86_64.whl'
RUN yes | python -m pip install --upgrade pip wheel
RUN yes | python -m pip install diffusers huggingface-hub transformers accelerate
RUN yes | python -m pip install torch-1.7.0a0-cp38-cp38-linux_x86_64.whl torchvision-0.8.0a0+2f40a48-cp38-cp38-linux_x86_64.whl

# Download anything-v3.0, embedding it into the image
RUN python -c 'from diffusers import StableDiffusionPipeline; import torch; model_id = "Linaqruf/anything-v3.0"; pipe = StableDiffusionPipeline.from_pretrained(model_id, torch_dtype=torch.float16)'

# Final clean up
RUN rm -f torch-1.7.0a0-cp38-cp38-linux_x86_64.whl torchvision-0.8.0a0+2f40a48-cp38-cp38-linux_x86_64.whl
