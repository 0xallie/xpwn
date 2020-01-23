#!/bin/bash

# Just a disclaimer, this can be made better and more logical, but I just have it compile everything.
# You can find all of the binaries inside their respective folders, for example, "dmg" will be located
# in the dmg folder. The "ipsw" binary will be located in ipsw-patch and etc. 

if [ -e yeet ]; then
	cd yeet
else
	mkdir -p yeet
	cd yeet
fi

if brew ls cmake > /dev/null; then
  # cmake is installed
	:
else
  	brew install cmake
fi

if brew ls libpng > /dev/null; then
  # libpng is installed
	:
else
  	brew install libpng
fi

# These commands are being executed inside the folder yeet. Using "make" will only work in that folder.

cmake -DOPENSSL_ROOT_DIR=/usr -DOPENSSL_LIBRARIES=/usr/lib .. # Apple already has given us working OpenSSL libraries, just use them instead...
make clean
make package #(makes all of the important stuff and creates a zip archive)

# If /usr/local/lib/libcommon.a does not exist

if [ ! -e /usr/local/lib/libcommon.a ]; then
	# If common/libcommon.a exists
	if [ -e common/libcommon.a ]; then
		cp -rnv common/libcommon.a /usr/local/lib
	fi
fi

# If /usr/local/lib/libxpwn.a does not exist

if [ ! -e /usr/local/lib/libxpwn.a ]; then
	# If ipsw-patch/libxpwn.a exists
	if [ -e ipsw-patch/libxpwn.a ]; then
		cp -rnv ipsw-patch/libxpwn.a /usr/local/lib
	fi
fi

# The modified headers just have the header paths fixed. Replaced "<>" with quotes.

if [ ! -e /usr/local/include/xpwn ]; then
	echo -e "Installing the modified headers from includes to /usr/local/include for programs like libipatcher so they can find these headers"
	mkdir -p /usr/local/include/xpwn
	unzip -d /usr/local/include/xpwn xpwn-modified-headers.zip
fi

# We are still inside yeet
mv -v XPwn-0.5.8-Darwin.zip ..
cd ..
rm -rf yeet
echo -e "All of your files are contained in the zip archive XPwn-0.5.8-Darwin.zip. Just unzip it and all of the binaries and firmware bundles will be inside. Have fun!"
