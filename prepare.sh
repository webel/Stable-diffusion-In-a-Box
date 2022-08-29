#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install \
  gcc \
  make \
  pkg-config \
  apt-transport-https \
  ca-certificates

if ! [ -f /etc/modprobe.d/nouveau-blacklist.conf ]; then
  echo "nouveau is not blacklisted, doing so and rebooting"

  # Blacklist nouveau and rebuild kernel initramfs
  echo "blacklist nouveau
options nouveau modeset=0" >> blacklist-nouveau.conf
  sudo mv blacklist-nouveau.conf /etc/modprobe.d/blacklist-nouveau.conf
  sudo update-initramfs -u
  # NOTE: fter rebooting we need to run this file again
  sudo reboot
fi

# Check if nvidia driver is installed
if ! [ -f /usr/bin/nvidia-smi ]; then
  echo "nvidia driver is not installed, installing"
  # Install NVIDIA Linux toolkit 510.54
  wget https://us.download.nvidia.com/XFree86/Linux-x86_64/510.54/NVIDIA-Linux-x86_64-510.54.run
  chmod +x NVIDIA-Linux-x86_64-510.54.run
  sudo bash ./NVIDIA-Linux-x86_64-510.54.run
  rm NVIDIA-Linux-x86_64-510.54.run
fi

# Install CUDA toolkit 11.3 Upgrade 1 for Ubuntu 20.04 LTS
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.3.1/local_installers/cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2004-11-3-local_11.3.1-465.19.01-1_amd64.deb
sudo apt-key add /var/cuda-repo-ubuntu2004-11-3-local/7fa2af80.pub
sudo apt-get update
sudo apt-get -y install cuda

# Install cuDNN 8.2.1 for CUDA 11.x
# authed download, so just ended up rsyncing it up to the machine from my local
# wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/8.2.1.32/11.3_06072021/Ubuntu20_04-x64/libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb
# sudo dpkg -i libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb
# sudo apt-get update
# sudo apt-get -y install libcudnn8
# rm libcudnn8_8.2.1.32-1+cuda11.3_amd64.deb

# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.9.2-Linux-x86_64.sh
bash Miniconda3-py39_4.9.2-Linux-x86_64.sh -b -p $HOME/src/miniconda
export PATH=${PATH}:$HOME/src/miniconda/bin
conda create -y -n rapids-21.08 -c rapidsai -c nvidia -c conda-forge rapids-blazing=21.08 python=3.8 cudatoolkit=11.3
rm Miniconda3-py38_4.10.3-Linux-x86_64.sh

# Update PATH
export PATH=${PATH}:/home/paperspace/.local/bin
echo "export PATH=${PATH}:/home/paperspace/.local/bin" >> ~/.bashrc
echo "export PATH=${PATH}:/home/paperspace/src/miniconda/bin" >> ~/.bashrc
