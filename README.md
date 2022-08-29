# Stable diffusion in a Box

> **Note: these instructions are hastily put together and suitable for someone comfortable with command line.**

The script in this repo is meant to setup a suitable enviroment for [Stable Diffusion](https://github.com/CompVis/stable-diffusion) with [UI](https://github.com/hlky/stable-diffusion-webui) on an ubuntu gpu instance such as those provided by [Paperspace](https://paperspace.com) so that you can forward a local port and play with stable diffusion in your browser.

Here's a [referral link for Paperspace](https://console.paperspace.com/signup?R=WF9770R), it should give you 10\$ off if you don't already have an account.

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
**NOTE** the host might disconnect at this, ssh in again and run this command again.
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

## TODO

I want to create a single command, say `artfart.sh` that

- [ ] starts the machine
- [ ] runs the webui on startup
- [ ] forwards the local port
- [ ] stops the machine on script exit

### Keep it cheap (Paperspace)

Programmatically starting and stopping:

```sh
# paperspace-cli
paperspace machines start \
  --apiKey "" \
  --machineId ""

paperspace machines stop \
  --apiKey "" \
  --machineId ""

paperspace machines waitfor \
  --apiKey "" \
  --machineId "" \
  --state "ready"

# node
paperspace.machines.start(
  {
    machineId: "",
  },
  function (err, res) {
    // handle error or result
  }
);

paperspace.machines.stop(
  {
    machineId: "",
  },
  function (err, res) {
    // handle error or result
  }
);

paperspace.machines.waitfor(
  {
    machineId: "",
    state: "ready",
  },
  function (err, res) {
    // handle error or result
  }
);
```

### On startup

- Script on startup, `.startup.sh`

```sh
#!/bin/bash
cd stable-diffusion
. ~/miniconda3/etc profile.d/conda.sh
conda activate ldm
# python scripts/relauncher.py
```

- Add to end of `.profile`: 

```sh
# enable ldm and move straight into stable-diffusion
if [ -d "$HOME/stable-diffusion" ] ; then
    . "$HOME/.startup.sh"
fi
```

<!-- - Add script to reboot
```sh
crontab -e
@reboot . $HOME/.startup.sh
```
-->