# Building a Yocto (Rocko) image for the Raspberry Pi

The goal of this tutorial is to build a Yocto Rocky image for the Raspberry Pi with packages that allow for Mono (.NET) development. The original tutorial and a lot of the content was taken from the wonderful tutorial: [Building Raspberry Pi Systems with Yocto](http://www.jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html). The goal is to create aminimal image with the following functionality:
- WiFi and wired network support
- Nano for text editing
- Mono as a .NET Runtime
- raspi-config For Configuration
- raspistill for taking pictures
- raspivid for taking video
- SSH Daemon ```openssh``` and SFTP for remote access and file deployment
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
git clone -b rocko git://git.yoctoproject.org/meta-mono
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
    /home/mario/poky-rocko/meta-openembedded/meta-mono \
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
cd ..
cd rpi
gedit build/conf/local.conf 
```
The variables you want to customize with absolute paths are the following:
- MACHINE: This is the machine you want to build for. Only uncomment one line.
- TMPDIR: I created the following folder above: ```/home/mario/rpioe4/tmp_dir```
- DL_DIR: In my case" ```/home/mario/rpioe4/dl_dir```
- SSTATE_DIR: In my case: ```/home/mario/rpioe4/sstate_dir```

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

In my case it took about 90 minutes to fetch and build all packages on an Intel i7-6700K @ 4.20 GHz, 16GB RAM and a 500 Mbit Internet connection.

### Troubleshooting Builds

You may occasionally run into build errors related to packages that either failed to download or sometimes out of order builds. The easy solution is to clean the failed package and rerun the build again. For instance if the build for ```zip``` failed for some reason, I would run this:

```bash
~/rpi/build$ bitbake -c cleansstate zip
~/rpi/build$ bitbake zip
```

And then continue with the full build.

```bash
~/rpi/build$ bitbake console-image
```

Note: The bitbake ```cleansstate``` command (with two s) works for image recipes as well. The image files won’t get deleted from the ```TMPDIR``` until the next time you build.

## Deploying the Resulting Image

After the build completes, the bootloader, kernel and rootfs image files can be found in ```/deploy/images/$MACHINE``` with ```MACHINE``` coming from your ```local.conf```.

The ```meta-rpi/scripts``` directory has some helper scripts to format and copy the files to a microSD card. The ```mk2parts.sh``` script will partition an SD card with the minimal 2 partitions required for the RPI.

### Creating the required Partitions on the SD Card

Insert the microSD into your workstation and note where it shows up. ```lsblk``` is convenient for finding the microSD card.
In my case my SD card shows as ```sdb```. It doesn’t matter if some partitions from the SD card are mounted. The ```mk2parts.sh``` script will unmount them.

**WARNING**: This script will format any disk on your workstation so make sure you choose the SD card.
```bash
~$ cd ~/rpi/meta-rpi/scripts
~/rpi/meta-rpi/scripts$ sudo ./mk2parts.sh sdb
```
Temporary mount point: You will need to create a temporary mount point on your workstation for the copy scripts to use. The default is
```bash
~$ sudo mkdir /media/card
```

### Copying the contents of the Boot Partition to the SD Card

If you don’t want that location, you will have to edit the following scripts to use the mount point you choose" ```copy_boot.sh```. This script copies the GPU firmware, the Linux kernel, dtbs and overlays, ```config.txt``` and ```cmdline.txt``` to the boot partition of the SD card. This copy_boot.sh script needs to know the ```TMPDIR``` to find the binaries. It looks for an environment variable called ```OETMP```.

For instance, if I had this in ```build/conf/local.conf```: ```TMPDIR = "/home/mario/rpioe4/tmp_dir"``` Then I would export this environment variable before running ```copy_boot.sh```

```bash
export OETMP=/home/mario/rpioe4/tmp_dir
```

The ```copy_boot.sh``` script also needs a ```MACHINE``` environment variable specifying the type of RPi board.

```bash
export MACHINE=raspberrypi2
```

Now you can run the script:
```bash
~/rpi/meta-rpi/scripts$ ./copy_boot.sh sdb
```

This script should run very fast. If you want to customize the ```config.txt``` or ```cmdline.txt``` files for the system, you can place either of those files in the ```meta-rpi/scripts``` directory and the ```copy_boot.sh``` script will copy them as well. Take a look at the script if this is unclear.

### Copying the contents of the Root File System to the SD Card

The ```copy_rootfs.sh``` script copies the root file system to the second partition of the SD card.
It also needs the same ```OETMP``` and ```MACHINE``` environment variables. The script accepts an optional command line argument for the image type, for example console or ```qt5```. The default is ```console``` if no argument is provided. The script also accepts a ```hostname``` argument if you want the host name to be something other then the default ```MACHINE```.

Here’s an example of how you would run ```copy_rootfs.sh```
```bash
./copy_rootfs.sh sdb console
```
or:
```bash
./copy_rootfs.sh sdb qt5 rpi3
```

## Adding Additional Packages!

To display the list of available recipes from the ```meta-layers``` included in ```bblayers.conf```:
```bash
source poky-rocko/oe-init-build-env ~/rpi/build
bitbake -s
```

Once you have the recipe name, you need to find what packages the recipe produces. Use the ```oe-pkgdata-util``` utility for this.
```bash
~/rpi/build$ oe-pkgdata-util list-pkgs -p openssh
openssh-keygen
openssh-scp
openssh-ssh
openssh-sshd
openssh-sftp
openssh-misc
openssh-sftp-server
openssh-dbg
openssh-dev
openssh-doc
openssh
```
These are the individual packages you could add to your image recipe. You can also use ```oe-pkgdata-util``` to check the individual files a package will install.

For instance, to see the files for the ```openssh-sshd package```
```bash
~/rpi/build$ oe-pkgdata-util list-pkg-files openssh-sshd
openssh-sshd:
        /etc/default/volatiles/99_sshd
        /etc/init.d/sshd
        /etc/ssh/moduli
        /etc/ssh/sshd_config
        /etc/ssh/sshd_config_readonly
        /usr/libexec/openssh/sshd_check_keys
        /usr/sbin/sshd
```

For a package to be installed in your image it has to get into the ```IMAGE_INSTALL``` variable some way or another. See the example image recipes for some common conventions.

## Using the Raspberry Pi Camera Module

The raspicam command line tools are installed with the ```console-image``` or any image that includes the ```console-image```
- ```raspistill```
- ```raspivid```
- ```raspiyuv```

To enable the RPi camera, add or edit the following in the RPi configuration file ```config.txt```
```
start_x=1
gpu_mem=128
disable_camera_led=1   # optional for disabling the red LED on the camera
```
