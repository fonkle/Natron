#!/bin/bash

# Install gnutls (for ffmpeg)
# see http://www.linuxfromscratch.org/blfs/view/cvs/postlfs/gnutls.html
GNUTLS_VERSION=3.6.7
GNUTLS_VERSION_MICRO=.1
GNUTLS_VERSION_SHORT=${GNUTLS_VERSION%.*}
GNUTLS_TAR="gnutls-${GNUTLS_VERSION}${GNUTLS_VERSION_MICRO}.tar.xz"
GNUTLS_SITE="ftp://ftp.gnupg.org/gcrypt/gnutls/v${GNUTLS_VERSION_SHORT}"
if build_step && { force_build || { [ ! -s "$SDK_HOME/lib/pkgconfig/gnutls.pc" ] || [ "$(pkg-config --modversion gnutls)" != "$GNUTLS_VERSION" ]; }; }; then
    start_build
    download "$GNUTLS_SITE" "$GNUTLS_TAR"
    untar "$SRC_PATH/$GNUTLS_TAR"
    pushd "gnutls-${GNUTLS_VERSION}"
    env CFLAGS="$BF" CXXFLAGS="$BF" ./configure --prefix="$SDK_HOME" --disable-static --enable-shared --with-default-trust-store-pkcs11="pkcs11:"
    make -j${MKJOBS}
    make install
    popd
    rm -rf "gnutls-${GNUTLS_VERSION}"
    end_build
fi
