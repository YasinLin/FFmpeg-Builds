#!/bin/bash

SCRIPT_REPO="https://github.com/xiph/rav1e.git"
SCRIPT_COMMIT="054823271c4b4923a87f1e02f7f0fd282f0b29e1"

ffbuild_enabled() {
    [[ $TARGET == win32 ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --target="${FFBUILD_RUST_TARGET}"
        --library-type=staticlib
        --crt-static
        --release
    )

    # Pulls in target-libs for host tool builds otherwise.
    # Luckily no target libraries are needed.
    unset PKG_CONFIG_LIBDIR

    export HTTP_PROXY=http://172.17.0.1:7890 HTTPS_PROXY=http://172.17.0.1:7890 NO_PROXY=localhost,127.0.0.1,.coding.net,.tencentyun.com,.myqcloud.com,harbor.bsgchina.com,git.libssh.org

    cargo cinstall -v "${myconf[@]}"

    chmod 644 "${FFBUILD_PREFIX}"/lib/*rav1e*
}

ffbuild_configure() {
    echo --enable-librav1e
}

ffbuild_unconfigure() {
    echo --disable-librav1e
}
