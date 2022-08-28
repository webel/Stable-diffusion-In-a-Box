# Stable diffusion in a Box

> **Note: these instructions are hastily put together and suitable for someone comfortable with command line and ssh**

The script in this repo is meant to setup a suitable enviroment for [Stable Diffusion](https://github.com/CompVis/stable-diffusion) with [UI](https://github.com/hlky/stable-diffusion-webui) on an ubuntu instance such as those provided by [Paperspace](https://paperspace.com) so that you can forward a local port and play with stable diffusion in your browser.

## Includes

- **NVidia Driver**
- **CUDA**
- **cuDNN**
- **CUDA toolkit**
- [**CompVis/stable-diffusion**](https://github.com/CompVis/stable-diffusion)
- [**hlky/stable-diffusion-ui**](https://github.com/hlky/stable-diffusion-webui)

## Install

(This is what I do on a paperspace instance of Ubuntu)

1. `git clone https://github.com/webel/Stable-diffusion-In-a-Box.git`
2. `cd Stable-diffusion-In-a-Box`
3. `bash prepare.sh`, (handle potential errors, I haven't had any thus far)
4. `bash install-sd.sh`
5. Grab your weights, either with wget or by copying from your local machine with scp

```sh
# Make sure to change the location of where your weights are
scp ~/dev/sd-v1-4.ckpt [user]@[server-ip]:stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt`
```

## Run

Test the usual on the command-line, make sure you're in the ldm environment, try

```sh
python scripts/txt2img.py --prompt "a photograph of an astronaut riding a horse" --plms
```

Run the UI

```sh
python scripts/webui-relauncher.py
```

The above script will spit out an endpoint, `localhost:7860`.

We'll use **SSH tunneling** to forward our local port to the server port;

```sh
ssh -NL 7860:[server-ip]:7860 [user]@[server-ip]
```

You can now go to `localhost:7860` in your browser and go wild 🎉.

Use scp to copy the output directory back to your local device,

```sh
scp -qpr [user]@[server-ip]:stable-diffusion/outputs ./
```
