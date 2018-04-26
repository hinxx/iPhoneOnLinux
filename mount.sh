#!/bin/bash

IPHONE="$HOME/Code/iphone"
[ ! -d "$IPHONE/usr/src" ] && mkdir -p "$IPHONE/usr/src"
export PKG_CONFIG_PATH="${IPHONE}/usr/lib/pkgconfig:${PKG_CONFIG_PATH}"
export CPATH="${IPHONE}/usr/include:${CPATH}"

export MANPATH="${IPHONE}/usr/share/man:${MANPATH}"

export PATH="${IPHONE}/usr/bin:${PATH}"
export LD_LIBRARY_PATH="${IPHONE}/usr/lib:${LD_LIBRARY_PATH}"

which idevice_id
idevice_id --list || exit 1
idevicepair pair || exit 1
[ -d iPhoneMnt ] || mkdir iPhoneMnt
ifuse iPhoneMnt || exit 1


echo
echo "SUCCESS mounting!"
echo
ls -al iPhoneMnt

