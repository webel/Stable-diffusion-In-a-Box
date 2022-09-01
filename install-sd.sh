# Git clone stable-diffusion
git clone https://github.com/CompVis/stable-diffusion.git $HOME/stable-diffusion
git clone https://github.com/hlky/stable-diffusion-webui $HOME/stable-diffusion-webui

# Copy stable-diffusion-ui scripts to stable-diffusion/scripts
cp $HOME/stable-diffusion-webui/relauncher.py $HOME/stable-diffusion/scripts/webui-relauncher.py
cp $HOME/stable-diffusion-webui/webui.py $HOME/stable-diffusion/scripts/webui.py
cp $HOME/stable-diffusion-webui/webui.yaml $HOME/stable-diffusion/scripts/webui.yaml

cd $HOME/stable-diffusion

# Create the weights directory
mkdir -p models/ldm/stable-diffusion-v1/

# Prepare enviroment and install
conda env create -f environment.yaml
conda activate ldm
conda install pytorch torchvision -c pytorch-nightly

# Install requirements for webui
# NOTE: check here for potential missing packages: https://github.com/hlky/stable-diffusion/blob/main/environment.yaml
python -m pip install --upgrade pip
python -m pip install opencv-python
python -m pip install gradio
python -m pip install pynvml
python -m pip install -e git+https://github.com/hlky/k-diffusion-sd#egg=k_diffusion

