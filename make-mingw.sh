
set -e
set -v

CMAKE_FLAGS=-G"Unix Makefiles"

mkdir -p prefix

export PREFIX="$PWD/prefix"
SRCDIR="$PWD"

mkdir -p build
cd build


mkdir -p usrsctp
cd usrsctp

cmake $SRCDIR/dep/usrsctp -DCMAKE_INSTALL_PREFIX="$PREFIX" -DSCTP_DEBUG=1 -Dsctp_werror=0 "$CMAKE_FLAGS"
make install -j 4

cd ..

make -C $SRCDIR/dep/re PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j 4 install

make -C $SRCDIR/dep/rew PREFIX="$PREFIX" USE_ZLIB= USE_OPENSSL=y -j 4 install


cmake $SRCDIR/ -DCMAKE_INSTALL_PREFIX="$PREFIX"  "$CMAKE_FLAGS"
make -j 4 install

cd ..



