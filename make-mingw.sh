
set -e
set -v

CMAKE_FLAGS=-G"Unix Makefiles"

if [ "$RELEASE" == "1" ]
then
	build_type="Release"
else
	build_type="Debug"
fi


mkdir -p prefix

[ -z "$jobs" ] && jobs=4

export PREFIX="$PWD/prefix"
SRCDIR="$PWD"

mkdir -p build
cd build


mkdir -p usrsctp
cd usrsctp

cmake $SRCDIR/dep/usrsctp -DCMAKE_INSTALL_PREFIX="$PREFIX" -Dsctp_debug=1 -Dsctp_werror=0 -DCMAKE_C_FLAGS=-D_WIN32_WINNT=0x0601 "$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=$build_type
make -j $jobs install 

cd ..

make -C $SRCDIR/dep/re PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j $jobs install

make -C $SRCDIR/dep/rew PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j $jobs install


cmake $SRCDIR/ -DCMAKE_INSTALL_PREFIX="$PREFIX"  "$CMAKE_FLAGS"  -DCMAKE_BUILD_TYPE=$build_type
make -j $jobs install

cd ..



