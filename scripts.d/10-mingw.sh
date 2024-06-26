#!/bin/bash

SCRIPT_REPO="https://git.code.sf.net/p/mingw-w64/mingw-w64.git"
SCRIPT_COMMIT="dc42231f0392f75de72e87ba0170ec60fcc6c10b"

ffbuild_enabled() {
    [[ $TARGET == win* ]] || return -1
    return 0
}

ffbuild_dockerlayer() {
    [[ $TARGET == winarm* ]] && return 0
    to_df "COPY --from=${SELFLAYER} /opt/mingw/. /"
    to_df "COPY --from=${SELFLAYER} /opt/mingw/. /opt/mingw"
}

ffbuild_dockerfinal() {
    [[ $TARGET == winarm* ]] && return 0
    to_df "COPY --from=${PREVLAYER} /opt/mingw/. /"
}

ffbuild_dockerdl() {
    echo "export HTTP_PROXY=http://172.17.0.1:7890 HTTPS_PROXY=http://172.17.0.1:7890 NO_PROXY=localhost,127.0.0.1,.coding.net,.tencentyun.com,.myqcloud.com,harbor.bsgchina.com,git.libssh.org"
    echo "retry-tool sh -c \"rm -rf mingw && git clone '$SCRIPT_REPO' mingw\" && cd mingw && git checkout \"$SCRIPT_COMMIT\""
}

ffbuild_dockerbuild() {
    [[ $TARGET == winarm* ]] && return 0

    cd mingw-w64-headers

    unset CFLAGS
    unset CXXFLAGS
    unset LDFLAGS
    unset PKG_CONFIG_LIBDIR

    if [[ -z "$COMPILER_SYSROOT" ]]; then
        COMPILER_SYSROOT="$(${CC} -print-sysroot)/usr/${FFBUILD_TOOLCHAIN}"
    fi

    local myconf=(
        --prefix="$COMPILER_SYSROOT"
        --host="$FFBUILD_TOOLCHAIN"
        --with-default-win32-winnt="0x601"
        --with-default-msvcrt=ucrt
        --enable-idl
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="/opt/mingw"

    cd ../mingw-w64-libraries/winpthreads

    local myconf=(
        --prefix="$COMPILER_SYSROOT"
        --host="$FFBUILD_TOOLCHAIN"
        --with-pic
        --disable-shared
        --enable-static
    )

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install DESTDIR="/opt/mingw"
}

ffbuild_configure() {
    echo --disable-w32threads --enable-pthreads
}
