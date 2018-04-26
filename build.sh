#!/bin/bash

IPHONE="$HOME/Code/iphone"
[ ! -d "$IPHONE/usr/src" ] && mkdir -p "$IPHONE/usr/src"
export PKG_CONFIG_PATH="${IPHONE}/usr/lib/pkgconfig:${PKG_CONFIG_PATH}"
export CPATH="${IPHONE}/usr/include:${CPATH}"

export MANPATH="${IPHONE}/usr/share/man:${MANPATH}"

export PATH="${IPHONE}/usr/bin:${PATH}"
export LD_LIBRARY_PATH="${IPHONE}/usr/lib:${LD_LIBRARY_PATH}"

cd $IPHONE/usr/src
for x in libplist libusbmuxd usbmuxd libimobiledevice ifuse
do
    if [ ! -d ${x} ]
    then
        git clone https://github.com/libimobiledevice/${x}.git || exit 1
    fi
done

cd $IPHONE/usr/src/libplist
if [ ! -f Makefile ]
then
    ./autogen.sh --prefix="$IPHONE/usr" || exit 1
fi
make || exit 1
make install || exit 1

cd $IPHONE/usr/src/libusbmuxd
if [ ! -f Makefile ]
then
    ./autogen.sh --prefix="$IPHONE/usr" || exit 1
fi
make || exit 1
make install || exit 1

cd $IPHONE/usr/src/libimobiledevice
if [ ! -f Makefile ]
then
    ./autogen.sh --prefix="$IPHONE/usr" || exit 1
fi
make || exit 1
make install || exit 1


cd $IPHONE/usr/src/usbmuxd
if [ ! -f Makefile ]
then
    ./autogen.sh --prefix="$IPHONE/usr" \
        --with-udevrulesdir="$IPHONE/usr/etc" \
        --with-systemdsystemunitdir="$IPHONE/usr/lib/systemd/system" || exit 1
fi
make || exit 1
make install || exit 1

cd $IPHONE/usr/src/ifuse
if [ ! -f Makefile ]
then
    ./autogen.sh --prefix="$IPHONE/usr" || exit 1
fi
make || exit 1
make install || exit 1

echo
echo "SUCCESS building!"
echo
echo "Copy following files to system wide folders:"
echo " sudo cp usr/etc/39-usbmuxd.rules /etc/udev/rules.d/39-usbmuxd.rules"
echo " sudo cp usr/lib/systemd/system/usbmuxd.service >> /lib/systemd/system/usbmuxd.service"
echo
echo "Then do this:"
echo " sudo systemctl daemon-reload"
echo " sudo udevadm control --reload"
echo

