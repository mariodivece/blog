#!/bin/bash

# Get the BasePath
BasePath=${PWD}

# Define some colors
CReset='\033[0m';
CRed='\033[0;31m';
CGreen='\033[0;32m';
CYellow='\033[0;33m';

# Define a prompt result
PromptResult=1;

# Prompts the user for yes or no. The default is Yes. 
# Takes 1 argument which is the user prompt itself
# Returns 1 if the user entered yes. 0 if the user entered no
function PromptYesOrNo {
	local default="Y";
	local yn;
	while true; do
		printf "${1} ${CYellow}[Y/n]${CReset}: ";
   	read -s -n 1 yn;
   	if [ -z "${yn}" ]
   	then 
   		yn="${default}";
   	fi
   		
    	case $yn in
      	[Yy]* ) echo -e "\n${CGreen}  Yes ${CReset}"; PromptResult=1; return 0;;
      	[Nn]* ) echo -e "\n${CRed}  No ${CReset}"; PromptResult=0; return 0;; 
      	* ) echo -e "\n${CYellow}  Please enter [y]es or [n]o.${CReset}";;
    	esac
	done
}

clear;
echo -e "This utility writes an embedded image to an SD card";

lsblk;
read -p "Device Identifier:" device;
	
PromptYesOrNo "Format the SD Card?";
if [ $PromptResult -ne 0 ]; then
	sudo ./rpi/meta-rpi/scripts/mk2parts.sh ${device};
fi

if [ ! -d "/media/card" ]; then
	sudo mkdir /media/card;
	echo -e "Created /media/card temporary directory";
fi

# export environment variables required
# note: Machine is raspberrypi2 even for raspberrypi3
export OETMP="${BasePath}/tmp-rocko";
export MACHINE=raspberrypi3;

echo "Environment variables set:";
echo -e "OETMP:   ${OETMP}";
echo -e "MACHINE: ${MACHINE}";
echo -e "SD Card: ${device}";

PromptYesOrNo "Deploy the boot partition?";
if [ $PromptResult -ne 0 ]; then
	cp ./config.txt ./rpi/meta-rpi/scripts/config.txt;
	cp ./cmdline.txt ./rpi/meta-rpi/scripts/cmdline.txt;
	./rpi/meta-rpi/scripts/copy_boot.sh ${device};
fi

PromptYesOrNo "Deploy the Root FS?";
if [ $PromptResult -ne 0 ]; then
	./rpi/meta-rpi/scripts/copy_rootfs.sh ${device} monopi monopi;
fi

if [ -d "/media/card" ]; then
	sudo rm -r /media/card;
	echo -e "Deleted /media/card temporary directory";
fi

echo "All tasks finished";