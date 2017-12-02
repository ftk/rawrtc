#!/bin/bash


# requirements: gcc g++ cmake make bash libssl-dev git


set -e

CMAKE_FLAGS=-G"Unix Makefiles"

if [ "$RELEASE" == "1" ]
then
	build_type="Release"
	DEBUG=0
else
	build_type="Debug"
	DEBUG=1
fi

SRCDIR="$PWD"
[ -z "$PREFIX" ] && PREFIX="$PWD/prefix"
export PREFIX

[ -z "$jobs" ] && jobs=4

mkdir -p $PREFIX

set -v


mkdir -p build
[ "$clean" == 1 ] && rm -r -- build/*
cd build

# usrsctp
mkdir -p usrsctp
cd usrsctp

cmake $SRCDIR/dep/usrsctp -DCMAKE_INSTALL_PREFIX="$PREFIX" -Dsctp_debug=$DEBUG -Dsctp_werror=0 "$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=$build_type
make -j $jobs install 

cd ..

RE_PARAMS="USE_ZLIB=  USE_OPENSSL=y USE_OPENSSL_DTLS=y USE_OPENSSL_RTSP=y"

# re
[ "$clean" == 1 ] && make -C $SRCDIR/dep/re $RE_PARAMS clean
make -C $SRCDIR/dep/re $RE_PARAMS -j $jobs install

# rew
[ "$clean" == 1 ] && make -C $SRCDIR/dep/rew $RE_PARAMS clean
make -C $SRCDIR/dep/rew $RE_PARAMS -j $jobs install

# rawrtc
mkdir -p rawrtc
cd rawrtc

cmake $SRCDIR/ -DCMAKE_INSTALL_PREFIX="$PREFIX"  "$CMAKE_FLAGS"  -DCMAKE_BUILD_TYPE=$build_type
make -j $jobs install

cd ../..
