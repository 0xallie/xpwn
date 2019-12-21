#!/bin/bash

cmake -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.0 -DOPENSSL_LIBRARIES=/usr/local/opt/openssl@1.0/lib .
make
make libXPwn.a
