#!/bin/bash

# Install zlib
# see http://www.linuxfromscratch.org/lfs/view/development/chapter06/zlib.html
ZLIB_VERSION=1.2.11
ZLIB_TAR="zlib-${ZLIB_VERSION}.tar.gz"
ZLIB_SITE="https://zlib.net"
if build_step && { force_build || { [ "${REBUILD_ZLIB:-}" = "1" ]; }; }; then
    rm -rf $SDK_HOME/lib/libz.* || true
    rm -f $SDK_HOME/lib/pkgconfig/zlib.pc || true
fi
if build_step && { force_build || { [ ! -s "$SDK_HOME/lib/libz.so.1" ]; }; }; then
    start_build
    download "$ZLIB_SITE" "$ZLIB_TAR"
    untar "$SRC_PATH/$ZLIB_TAR"
    pushd "zlib-${ZLIB_VERSION}"
    env CFLAGS="$BF" CXXFLAGS="$BF" ./configure --prefix="$SDK_HOME"
    make -j${MKJOBS}
    make install
    popd
    rm -rf "zlib-${ZLIB_VERSION}"
    end_build
fi

