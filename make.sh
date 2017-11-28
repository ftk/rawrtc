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

export PREFIX="$PWD/prefix"
SRCDIR="$PWD"

[ -z "$jobs" ] && jobs=4

mkdir -p $PREFIX

set -v


mkdir -p build
cd build


mkdir -p usrsctp
cd usrsctp

cmake $SRCDIR/dep/usrsctp -DCMAKE_INSTALL_PREFIX="$PREFIX" -Dsctp_debug=$DEBUG -Dsctp_werror=0 "$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=$build_type
[ "$clean" == 1 ] && make clean
make -j $jobs install 

cd ..

[ "$clean" == 1 ] && make -C $SRCDIR/dep/re PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y clean
make -C $SRCDIR/dep/re PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j $jobs install

[ "$clean" == 1 ] && make -C $SRCDIR/dep/rew PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y clean
make -C $SRCDIR/dep/rew PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j $jobs install


cmake $SRCDIR/ -DCMAKE_INSTALL_PREFIX="$PREFIX"  "$CMAKE_FLAGS"  -DCMAKE_BUILD_TYPE=$build_type
[ "$clean" == 1 ] && make clean
make -j $jobs install

cd ..



