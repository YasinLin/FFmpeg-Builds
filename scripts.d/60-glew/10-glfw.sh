#!/bin/bash

SCRIPT_REPO="https://github.com/glfw/glfw.git"
SCRIPT_COMMIT="b35641f4a3c62aa86a0b3c983d163bc0fe36026d"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    mkdir cmbuild && cd cmbuild
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DBUILD_SHARED_LIBS=OFF -DENABLE_EXAMPLES=NO -DENABLE_TESTS=NO -DENABLE_TOOLS=NO ..
    make -j$(nproc)
    make install
}

ffbuild_libs() {
    echo -lglfw3
}

ffbuild_unlibs() {
	return 0
}