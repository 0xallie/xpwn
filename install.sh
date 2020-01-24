#!/bin/bash

# Thanks to the people behind https://github.com/mozilla/libdmg-hfsplus for fixing the dmg binary!
# And of course, thanks to planetbeing for making xpwn!

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

# Not sure if there will ever be more than one version inside /usr/local/Cellar/openssl, but at least check if 1.0.2t exists.

if [ -e /usr/local/Cellar/openssl/1.0.2t ]; then
	cmake -DOPENSSL_ROOT_DIR=/usr/local/Cellar/openssl/1.0.2t -DOPENSSL_LIBRARIES=/usr/local/Cellar/openssl/1.0.2t/lib ..
else
	echo -e "OpenSSL 1.0.2 is required! Installing via brew."
	brew install https://github.com/tebelorg/Tump/releases/download/v1.0.0/openssl.rb
	cmake -DOPENSSL_ROOT_DIR=/usr/local/Cellar/openssl/1.0.2t -DOPENSSL_LIBRARIES=/usr/local/Cellar/openssl/1.0.2t/lib ..
fi

make clean
make package # (makes all of the important stuff and creates a zip archive)

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
