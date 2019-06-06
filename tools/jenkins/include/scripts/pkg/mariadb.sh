#!/bin/bash

# Install MariaDB (for the Qt mariadb plugin and the python mariadb adapter)
# see http://www.linuxfromscratch.org/blfs/view/svn/server/mariadb.html
MARIADB_VERSION=10.2.24
#MARIADB_VERSION=10.3.15 # fails with "plugin/handler_socket/libhsclient/hstcpcli.cpp:9:10: fatal error: my_global.h: No such file or directory"
MARIADB_TAR="mariadb-${MARIADB_VERSION}.tar.gz"
MARIADB_SITE="http://archive.mariadb.org/mariadb-${MARIADB_VERSION}/source"
if build_step && { force_build || { [ ! -s "$SDK_HOME/bin/mariadb_config" ] || [ "$("${SDK_HOME}/bin/mariadb_config" --version)" != "$MARIADB_VERSION" ] ; }; }; then
    start_build
    download "$MARIADB_SITE" "$MARIADB_TAR"
    untar "$SRC_PATH/$MARIADB_TAR"
    pushd "mariadb-${MARIADB_VERSION}"
    #env CFLAGS="$BF" CXXFLAGS="$BF" ./configure --prefix="$SDK_HOME" --libdir="$SDK_HOME/lib" --enable-shared --disable-static
    mkdir build-natron
    pushd build-natron
    # -DWITHOUT_SERVER=ON to disable building the server, since we only want the client
    cmake .. -DCMAKE_INSTALL_PREFIX="$SDK_HOME" -DCMAKE_C_FLAGS="$BF" -DCMAKE_CXX_FLAGS="$BF"  -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DWITH_EXTRA_CHARSETS=complex -DSKIP_TESTS=ON -DWITHOUT_SERVER=ON
    make -j${MKJOBS}
    make install
    popd
    popd
    rm -rf "mariadb-${MARIADB_VERSION}"
    end_build
fi
