#!/bin/bash

# Just a disclaimer, this can be made better and more logical, but I just have it compile everything.
# You can find all of the binaries inside their respective folders, for example, "dmg" will be located
# in the dmg folder. The "ipsw" binary will be located in ipsw-patch and etc. 

# Command to use openssl 1.0.x

cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.0 -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.0/lib .

make clean
make all

# If libxpwn.a does not exist

if [ ! -e /usr/local/lib/libxpwn.a ]; then
	make libXPwn.a
else
	cp -rnv ipsw-patch/libxpwn.a /usr/local/lib
fi
	
# If libcommon.a does not exist

if [ ! -e /usr/local/lib/libcommon.a ]; then
	make common
else
	cp -rnv common/libcommon.a /usr/local/lib
fi

# The modified headers just have the header paths fixed. Replaced "<>" with quotes.

if [ ! -e /usr/local/include/xpwn ]; then
	echo -e "Installing the modifided headers from includes to /usr/local/include for programs like libipatcher so they can find these headers"
	mkdir -p /usr/local/include/xpwn
	unzip -d /usr/local/include/xpwn xpwn-modified-headers.zip
else
	echo -e "Headers already installed!"
fi

