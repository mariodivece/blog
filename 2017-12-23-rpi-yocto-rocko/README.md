# Building a Yocto (Rocko) image for the Raspberry Pi

The goal of this tutorial is to build a Yocto Rocky image for the Raspberry Pi with packages that allow for Mono (.NET) development. Basic tutorial was taken from [Building Raspberry Pi Systems with Yocto](http://www.jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html). The goal is to create aminimal image with the following functionality:
- WPA Supplicant and WiFi support
- Nano for text editing
- Mono as a .NET Runtime
- WiringPi Libraries for GPIO Access
- raspi-config For Configuration
- raspistill for taking pictures
- raspivid for taking video
- SSH Daemon ```openfor remote access
- DHCP Client for automatic network configuration
- A package manager, possibly ```apt-get```
- Netcat ```nc``` for streaming video if necessary

## Setting up the environment
I am using Ubuntu 16 LTS for this build. Start by installing some required packes
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential chrpath diffstat libncurses5-dev texinfo python2.7 git gawk
```

Ensure ```/usr/bin/python``` is pointing to python 2.7
```bash
sudo ln -sf /usr/bin/python2.7 /usr/bin/python
```

For all versions of Ubuntu, you should change the default Ubuntu shell from dash to bash by running this command from a shell
```bash
sudo dpkg-reconfigure dash
```

Choose **No** when prompted. *You can change back to dash when you are done*

## Get the required sources

We will clone a few git repositories and setup a build directory with some default configuration files.

```bash
cd ~
git clone -b rocko git://git.yoctoproject.org/poky.git poky-rocko
cd poky-rocko
git clone -b rocko git://git.openembedded.org/meta-openembedded
git clone -b rocko git://git.yoctoproject.org/meta-security
git clone -b rocko git://git.yoctoproject.org/meta-raspberrypi
git clone -b rocko https://github.com/meta-qt5/meta-qt5
cd ..
mkdir rpi
cd rpi
git clone -b rocko git://github.com/jumpnow/meta-rpi
mkdir build
cd build
mkdir conf
cd ..
cp meta-rpi/conf/local.conf.sample build/conf/local.conf
cp meta-rpi/conf/bblayers.conf.sample build/conf/bblayers.conf
```

## Customize the Build
We will now customize the default ```bblayers.conf``` file.

```bash
gedit build/conf/bblayers.conf
```

In ```bblayers.conf``` file replace ```${HOME}``` with the appropriate path to the meta-layer repositories on your system using absolute paths. This will save you a ton of headaches later. In my case, this is what my file looks like:
```conf
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \
    /home/mario/poky-rocko/meta \
    /home/mario/poky-rocko/meta-poky \
    /home/mario/poky-rocko/meta-openembedded/meta-oe \
    /home/mario/poky-rocko/meta-openembedded/meta-multimedia \
    /home/mario/poky-rocko/meta-openembedded/meta-networking \
    /home/mario/poky-rocko/meta-openembedded/meta-perl \
    /home/mario/poky-rocko/meta-openembedded/meta-python \
    /home/mario/poky-rocko/meta-qt5 \
    /home/mario/poky-rocko/meta-raspberrypi \
    /home/mario/poky-rocko/meta-security \
    /home/mario/rpi/meta-rpi \
"
```

**WARNING**: Do not include ```meta-yocto-bsp``` in your ```bblayers.conf```. The Yocto BSP requirements for the Raspberry Pi are in ```meta-raspberrypi```.

Now, we will need to edit the ```rpi/build/conf/local.conf``` file.

```bash
cd ..
mkdir rpioe4
cd rpioe4
mkdir dl_dir
mkdir sstate_dir
mkdir tmp_dir
gedit build/conf/local.conf 
```
The variables you want to customize with absolute paths are the following:
- MACHINE: This is the machine you want to build for. Only uncomment one line.
- TMPDIR: I created the following folder above: ```/home/mario/rpioe4/dl_dir```
- DL_DIR: In my case" ```/home/mario/rpioe4/sstate_dir```
- SSTATE_DIR: In my case: ```/home/mario/rpioe4/tmp_dir```

Now you need to source the build by navigating to the base home directory. Specify an absolute path to the command which in my case was ```/home/mario/rpi/build```
```bash
cd ..
source poky-rocko/oe-init-build-env /home/mario/rpi/build
```

## Customize and build an image!
The folder ```rpi/meta-rpi/images``` contains a list of images you can use and modify according to your needs. In this case we will build the ```console-image```

```bash
bitbake console-image
```
