# Building a Yocto (Rocko) image for the Raspberry Pi

The goal of this tutorial is to build a Yocto Rocky image for the Raspberry Pi with packages that allow for Mono (.NET) development. Basic tutorial was taken from [Building Raspberry Pi Systems with Yocto](http://www.jumpnowtek.com/rpi/Raspberry-Pi-Systems-with-Yocto.html). The goal is to create aminimal image with the following functionality:
- WPA Supplicant for WiFi support
- Nano for text editing
- Mono as a .NET Runtime
- WiringPi Libraries for GPIO Access
- raspi-config For Configuration
- raspistill for taking pictures
- raspivid for taking video
- SSH Daemon for remote access
- DHCP Client for automatic network configuration
- A package manager, possibly ```apt-get```
- Netcat ```nc``` for streaming video if necessary

## Setting up the environment
I am using Ubuntu 16 LTS for this build. Start by 
```bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential chrpath diffstat libncurses5-dev texinfo python2.7
```
