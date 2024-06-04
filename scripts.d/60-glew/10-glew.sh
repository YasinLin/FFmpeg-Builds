#!/bin/bash

SCRIPT_REPO="https://github.com/YasinLin/glew.git"
SCRIPT_COMMIT="493a611576a9d370eac2be772f87ece2c5a94ff5"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    # mkdir cmbuild && cd cmbuild
    # cmake -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
    #     -DGLEW_EGL=ON \
    #     -DBUILD_SHARED_LIBS=OFF ../build/cmake
    if [[ -z "$COMPILER_SYSROOT" ]]; then
        COMPILER_SYSROOT="$(${CC} -print-sysroot)/usr/${FFBUILD_TOOLCHAIN}"
    fi
    export HTTP_PROXY=http://172.17.0.1:7890 \
    HTTPS_PROXY=http://172.17.0.1:7890 \
    NO_PROXY=localhost,127.0.0.1,.coding.net,.tencentyun.com,.myqcloud.com,harbor.bsgchina.com,git.libssh.org \
    GLEW_PREFIX="$FFBUILD_PREFIX" \
    GLEW_DEST="$FFBUILD_PREFIX"
    GLEW_LIB="${COMPILER_SYSROOT}/lib"
    GLEW_STATIC=on
    echo "$GLEW_LIB"
    if [[ $TARGET == win64 ]]; then
        GLEW_SYSTEM=linux-mingw64
    elif [[ $TARGET == win32 ]]; then
        GLEW_SYSTEM=linux-mingw32
    fi
    make -C auto
    # echo "$LDFLAGS"
    LDFLAGS+=" -L${GLEW_LIB}"
    make SYSTEM=$GLEW_SYSTEM GLEW_LIB=$GLEW_LIB glew.lib.static
    make SYSTEM=$GLEW_SYSTEM GLEW_LIB=$GLEW_LIB install
    rm "$FFBUILD_PREFIX/lib/glew32.dll"
    # cd build
    # cmake ./cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN"  -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DCMAKE_INSTALL_LIBDIR=lib -DCMAKE_INSTALL_BINDIR=bin -DCMAKE_INSTALL_INCLUDEDIR=include -DENABLE_SHARED=OFF -DENABLE_STATIC=ON -DBUILD_SHARED_LIBS=OFF -DUSE_STATIC_LIBSTDCXX=ON
    # make -j$(nproc)
    # make install
}

ffbuild_libs() {
    echo -lglew32 -lopengl32
}

ffbuild_unlibs() {
	return 0
}