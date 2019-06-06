#!/bin/bash

# Install jasper
# see http://www.linuxfromscratch.org/blfs/view/cvs/general/jasper.html
JASPER_VERSION=2.0.14
JASPER_TAR="jasper-${JASPER_VERSION}.tar.gz"
JASPER_SITE="http://www.ece.uvic.ca/~mdadams/jasper/software"
if build_step && { force_build || { [ "${REBUILD_JASPER:-}" = "1" ]; }; }; then
    rm -rf "$SDK_HOME"/{include,lib}/*jasper* || true
fi
if build_step && { force_build || { [ ! -s "$SDK_HOME/lib/libjasper.so" ]; }; }; then
    start_build
    download "$JASPER_SITE" "$JASPER_TAR"
    untar "$SRC_PATH/$JASPER_TAR"
    pushd "jasper-${JASPER_VERSION}"
    #env CFLAGS="$BF" CXXFLAGS="$BF" ./configure --prefix="$SDK_HOME" --libdir="$SDK_HOME/lib" --enable-shared --disable-static
    mkdir build-natron
    pushd build-natron
    cmake .. -DCMAKE_INSTALL_PREFIX="$SDK_HOME" -DCMAKE_C_FLAGS="$BF" -DCMAKE_CXX_FLAGS="$BF"  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE"
    make -j${MKJOBS}
    make install
    popd
    popd
    rm -rf "jasper-${JASPER_VERSION}"
    end_build
fi
