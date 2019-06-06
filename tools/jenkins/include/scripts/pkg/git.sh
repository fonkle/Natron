#!/bin/bash

# Install git (requires curl and pcre)
# see http://www.linuxfromscratch.org/blfs/view/svn/general/git.html
GIT_VERSION=2.17.0
GIT_TAR="git-${GIT_VERSION}.tar.xz"
GIT_SITE="https://www.kernel.org/pub/software/scm/git"
if build_step && { force_build || { [ ! -s "$SDK_HOME/bin/git" ] || [ "$("${SDK_HOME}/bin/git" --version)" != "git version $GIT_VERSION" ] ; }; }; then
    start_build
    download "$GIT_SITE" "$GIT_TAR"
    untar "$SRC_PATH/$GIT_TAR"
    pushd "git-${GIT_VERSION}"
    env CFLAGS="$BF" CXXFLAGS="$BF" ./configure --prefix="$SDK_HOME"
    make -j${MKJOBS}
    make install
    popd
    rm -rf "git-${GIT_VERSION}"
    end_build
fi
