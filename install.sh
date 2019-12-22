#!/bin/bash

cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.0 -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.0/lib .
make clean
make libXPwn.a common
cp -rnv ipsw-patch/libxpwn.a /usr/local/lib
cp -rnv common/libcommon.a /usr/local/lib
# The modified headers just have the header paths fixed. Replaced "<>" with quotes.
echo -e "Installing the modifided headers from includes to /usr/local/include for programs like libipatcher so they can find these headers"
mkdir -p /usr/local/include/xpwn
unzip -d /usr/local/include/xpwn xpwn-modified-headers.zip
