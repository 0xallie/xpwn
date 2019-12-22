#!/bin/bash

cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.0 -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.0/lib .
make clean
make libXPwn.a common
cp -rnv ipsw-patch/libxpwn.a /usr/local/lib
cp -rnv common/libcommon.a /usr/local/lib
