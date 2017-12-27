#!/bin/bash

# Trap the term signal so we can exit from a function
trap "exit 1" TERM;
export TOP_PID=$$;

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

# Prompts the user for yes or exit. The default is Yes. 
# Takes 1 argument which is the user prompt itself
# Returns 1 if the user entered yes. 0 if the user entered no
function PromptYesOrExit {
	local default="Y";
	local yn;
	while true; do
		printf "${1} ${CYellow}[Y/x]${CReset}: ";
   	read -s -n 1 yn;
   	if [ -z "${yn}" ]
   	then 
   		yn="${default}";
   	fi
   		
    	case $yn in
      	[Yy]* ) echo -e "\n${CGreen}  Yes ${CReset}"; return 0;;
      	[Xx]* ) echo -e "\n${CRed}  Exit ${CReset}"; kill -s TERM $TOP_PID;;
      	* ) echo -e "\n${CYellow}  Please enter [y]es or e[x]it.${CReset}";;
    	esac
	done
}

clear
echo -e "Welcome to the ${CGreen}MonoPi${CReset} Image Builder.";
echo -e "    This builder will work in Ubuntu 16 LTS x64";
echo;

PromptYesOrNo "1. Check dependencies are installed?";
if [ $PromptResult -ne 0 ]; then
	sudo apt-get update;
	sudo apt-get upgrade;
	sudo apt-get install build-essential chrpath diffstat libncurses5-dev texinfo python2.7 git gawk gcc-multilib g++-multilib;
fi

PromptYesOrNo "2. Point /usr/bin/python to Python 2.7?"; 
if [ $PromptResult -ne 0 ]; then
	sudo ln -sf /usr/bin/python2.7 /usr/bin/python;
fi

PromptYesOrNo "3. Reconfigure dash to bash (Select No when prompted)?"; 
if [ $PromptResult -ne 0 ]; then
	sudo dpkg-reconfigure dash;
fi

PromptYesOrNo "4. Clone basic recipes?"; 
if [ $PromptResult -ne 0 ]; then
	if [ ! -d "${BasePath}/poky-rocko" ]; then	
		cd ${BasePath};
		git clone -b rocko git://git.yoctoproject.org/poky.git poky-rocko;

		cd poky-rocko;
		git clone -b rocko git://git.openembedded.org/meta-openembedded;
		git clone -b rocko git://git.yoctoproject.org/meta-security;
		git clone -b rocko git://git.yoctoproject.org/meta-raspberrypi;
		git clone -b rocko https://github.com/meta-qt5/meta-qt5;
		
		# Checkout specific commit of the meta-browser recipes		
		#git clone -b master https://github.com/OSSystems/meta-browser;
		#cd meta-browser
		#git checkout 8cc24caa56f254e09ccb2311b59d054d1f016014
		#cd ..
		
		# Checkout mono for the rocko branch
		cd meta-openembedded;
		git clone -b rocko git://git.yoctoproject.org/meta-mono;
		cd ${BasePath};
	else
		echo -e "Directory '${BasePath}/poky-rocko' already exists. Skipping."
	fi
fi

PromptYesOrNo "5. Clone Jumpnow RPI recipes?";
if [ $PromptResult -ne 0 ]; then
	if [ ! -d "${BasePath}/rpi" ]; then	
		cd ${BasePath};
		mkdir rpi;
		cd rpi;
		git clone -b rocko git://github.com/jumpnow/meta-rpi;
		mkdir build;
		cd build;
		mkdir conf;
		cd ${BasePath};
	else
		echo -e "Directory '${BasePath}/rpi' already exists. Skipping."
	fi
fi

PromptYesOrNo "6. Inject Configuration Files?";
if [ $PromptResult -ne 0 ]; then
	cd ${BasePath};
	
	if [ ! -d "${BasePath}/oe-sources" ]; then
		mkdir oe-sources;
	fi

	if [ ! -d "${BasePath}/sstate-cache" ]; then
		mkdir sstate-cache;
	fi
	
	if [ ! -d "${BasePath}/tmp-rocko" ]; then
		mkdir tmp-rocko;
	fi	

	cp "${BasePath}/local.conf" "${BasePath}/rpi/build/conf/local.conf"
	cp "${BasePath}/bblayers.conf" "${BasePath}/rpi/build/conf/bblayers.conf"
	cp "${BasePath}/monopi-image.bb" "${BasePath}/rpi/meta-rpi/images/monopi-image.bb"
	#cp "${BasePath}/chromium-gn.inc" "${BasePath}/poky-rocko/meta-browser/recipes-browser/chromium/chromium-gn.inc"
fi

PromptYesOrNo "7. Build the MonoPi Image?";
if [ $PromptResult -ne 0 ]; then
	cd ${BasePath};
	source "${BasePath}/poky-rocko/oe-init-build-env" "${BasePath}/rpi/build";
	
	# Troubleshooting: Sometimes image building fails because of low memory or out of order builds.
	# The solution is to attempt individual package building with bitbake PACKAGENAME
	#bitbake -c cleansstate monopi-image
	#bitbake boost;
	#bitbake binutils;
	#bitbake qtbase;
	#bitbake qt3d;
	#bitbake qtcharts;
	#bitbake qtvirtualkeyboard;

	bitbake monopi-image;
fi

echo "All tasks done.";

