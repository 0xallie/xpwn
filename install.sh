#!/bin/bash

# Just a disclaimer, this can be made better and more logical, but I just have it compile everything.
# You can find all of the binaries inside their respective folders, for example, "dmg" will be located
# in the dmg folder. The "ipsw" binary will be located in ipsw-patch and etc. 


if [ -e /usr/local/opt/openssl@1.0 ]; then
	echo -e "Lucky you! You still have the old openssl libraries, like I did before I lost my mind trying to add version checking and such. Building!"
	cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.0 -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.0 .
else
	echo -e "OpenSSL will be automatically built/installed soon. Having more issues trying to make this work."
fi

make clean
make all

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
