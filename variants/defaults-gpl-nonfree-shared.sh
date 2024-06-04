#!/bin/bash
source "$(dirname "$BASH_SOURCE")"/defaults-gpl-nonfree.sh
FF_CONFIGURE+=" --enable-shared --disable-static"
