# Building a Yocto (Rocko) image for the Raspberry Pi

The objective today is to build a Yocto Rocky image for the Raspberry Pi with packages that allow for Mono (.NET) development. The original tutorial and a lot of the content was taken from the wonderful tutorial: [Building Raspberry Pi Systems with Yocto](http://www.jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html). The goal is to create aminimal image with the following functionality:
- WiFi and wired network support
- Nano for quick text editing
- Mono as a .NET Runtime
- Nanoweb my own little WebKit based browser with EGLFS, Kiosk mode and virtual keyboard support
- ```raspistill``` for taking pictures
- ```raspivid``` for taking video
- ```openssh``` for SSH and SFTP support
- A package manager, possibly ```opkg```
- Netcat ```nc``` for streaming video if necessary

*Note: The recipes in ```meta-rpi``` were taken from https://github.com/jumpnow/meta-rpi*

## Overview
I have created 2 scripts: ```build.sh``` and ```deploy.sh```. The rest of the files you can modify to build your own Raspberry Pi image. As a build system I am using Ubuntu 16.04 LTS x64. Please note you will need a lot of the following to build images:
- RAM: LOTS of it. I recommend some 24GB (yes, that's right). Otherwise the build process fails on some packages.
- CPU: At least a modern, 4-core CPU. Building images takes quite a long time. Expect hours of absolute fun!
- Disk: You will need plenty of disk spece. Make sure you have around 100GB of free space

## Instructions

In Yocto, ```layers``` preovide a set of ```recipes``` which build ```packages```. A Yocto image is 
The first thing you need to do is to download all files in this folder to your home directory to a new folder ```~/monopi``` and enable execution of the ```build.sh``` and ```deploy.sh``` bash scripts:

```bash
chmod u+x build.sh
chmod u+x deploy.sh
```

Now you can run the build process:
*NOTE: This takes a couple of hours in a powerful computer so be patient!*
```bash
./build.sh
```

If you encounter errors, please see the Troubleshooting section below.
If all succeeds you can now deoply your image to an SD card. Insert that SD card now and run:
```bash
./deploy.sh
```

## Additional Tasks and Configuration

### Login
Username: ```root```

Password: ```monopi```

### Configure WiFi

Uncomment the line ```aut0 wlan0```
```bash
nano /etc/network/interfaces
```

Now configure the WiFi interface:
```bash
nano /etc/wpa_supplicant.conf
```

### Configure Autologin

Edit the file as follows: ```nano /etc/inittab```
Towards the bottom of the file comment the line: 
```
#1:12345:respawn:/sbin/getty 38400 tty1
```
And add the line: 
```
1:12345:respawn:/bin/login -f root tty1 </dev/tty1 >/dev/tty1 2>&1
```

### Running a startup program:

Create a script that starts your app: ```nano /etc/profile```

towards the end of the file add (note the ampersand at the end of the program call):
```bash
nanoweb http://localhost:9696 &
```

or via runlevels:
http://www.armadeus.org/wiki/index.php?title=Automatically_launch_your_application

### Disabling IPv6
```nano /etc/sysctl.conf```
at the end of the file add:

```
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

## Troubleshooting Builds

You may occasionally run into build errors related to packages that either failed to download or sometimes out of order builds. The easy solution is to clean the failed package and rerun the build again. For instance if the build for ```zip``` failed for some reason, I would run this:

```bash
cd ~/monopi
source "poky-rocko/oe-init-build-env" "rpi/build";
bitbake -c cleansstate zip
bitbake zip
```

And then continue with the full build (skip to the last prompt).

```bash
cd ~/monopi
./build.sh
```

Note: The bitbake ```cleansstate``` command (with two s) works for image recipes as well. The image files won’t get deleted from the ```TMPDIR``` until the next time you build.

### Bitbake Tips!

Note: For any bitbake commands to work you always need to setup the bitbake environment:
```bash
cd ~/monopi
source "poky-rocko/oe-init-build-env" "rpi/build";
```

To display the list of available recipes from the ```meta-layers``` included in ```bblayers.conf```:
```bash
bitbake -s
```

Once you have the recipe name, you need to find what packages the recipe produces. Use the ```oe-pkgdata-util``` utility for this.
```bash
oe-pkgdata-util list-pkgs -p openssh
```
These are the individual packages you could add to your image recipe. You can also use ```oe-pkgdata-util``` to check the individual files a package will install.

For instance, to see the files for the ```openssh-sshd package```
```bash
oe-pkgdata-util list-pkg-files openssh-sshd
```
Which produces the following output:
```bash
openssh-sshd:
        /etc/default/volatiles/99_sshd
        /etc/init.d/sshd
        /etc/ssh/moduli
        /etc/ssh/sshd_config
        /etc/ssh/sshd_config_readonly
        /usr/libexec/openssh/sshd_check_keys
        /usr/sbin/sshd
```

You can also list all available recipes via:
```bash
bitbake-layers show-recipes
```

Or, show the layers (and its packages) of your current bblayers:
```bash
bitbake-layers show-layers
```

Or, list all packages that will be built by the given image:
```bash
bitbake -g [package] && cat pn-depends.dot | grep -v -e '-native' | grep -v digraph | grep -v -e '-image' | awk '{print $1}' | sort | uniq
```
You can check out more useful commands here: https://elinux.org/Bitbake_Cheat_Sheet


