#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock .deb Package Generator
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Usage: ./packaging/build-deb.sh <arch> [output_dir]
# Supported arch: amd64, arm64, armhf
# ==============================================================================

set -e

ARCH="${1:-amd64}"
VERSION="4.32"
REVISION="1"
PKG_NAME="hamclock"
OUT_DIR="${2:-./dist}"
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PKG_ROOT="$(mktemp -d /tmp/deb-build-XXXXXX)"
mkdir -p "$PKG_ROOT/DEBIAN"
mkdir -p "$PKG_ROOT/usr/bin"
mkdir -p "$PKG_ROOT/usr/lib/hamclock"
mkdir -p "$PKG_ROOT/usr/share/applications"
mkdir -p "$PKG_ROOT/usr/share/icons/hicolor/128x128/apps"
mkdir -p "$PKG_ROOT/usr/share/man/man1"
mkdir -p "$OUT_DIR"

# 1. Generate DEBIAN/control
cat <<EOF > "$PKG_ROOT/DEBIAN/control"
Package: $PKG_NAME
Version: $VERSION-$REVISION
Section: hamradio
Priority: optional
Architecture: $ARCH
Depends: libx11-6, libc6, libgcc-s1, libstdc++6
Recommends: libgpiod2 | libgpiod-dev
Provides: esphamclock
Replaces: esphamclock
Maintainer: 9M2PJU <9m2pju@hamradio.my>
Homepage: https://hamclock.hamradio.my
Description: Portable space weather, propagation and telemetry dashboard for radio amateurs
 9M2PJU HamClock (Open HamClock - OHB Edition) is a dashboard suite for
 amateur radio operators providing VOACAP propagation modeling, live SDO/NOAA space
 weather, satellite tracking, ADIF log broadcasting, and rotator/radio CAT control.
 Includes pre-built 800x480, 1600x960, 2400x1440, 3200x1920 and Web resolutions.
EOF

# 2. Copy binaries
for target in hamclock-800x480 hamclock-1600x960 hamclock-2400x1440 hamclock-3200x1920 hamclock-web-800x480 hamclock-web-1600x960; do
  if [ -f "$TOP_DIR/$target" ]; then
    cp "$TOP_DIR/$target" "$PKG_ROOT/usr/lib/hamclock/"
    chmod 755 "$PKG_ROOT/usr/lib/hamclock/$target"
  fi
done

# 3. Copy launcher
cp "$TOP_DIR/packaging/hamclock-launcher.sh" "$PKG_ROOT/usr/bin/hamclock"
chmod 755 "$PKG_ROOT/usr/bin/hamclock"

# Create resolution convenience symlinks
ln -sf /usr/bin/hamclock "$PKG_ROOT/usr/bin/hamclock-800x480"
ln -sf /usr/bin/hamclock "$PKG_ROOT/usr/bin/hamclock-1600x960"

# 4. Copy Desktop file and Icons
if [ -f "$TOP_DIR/deploy/hamclock.desktop" ]; then
  cp "$TOP_DIR/deploy/hamclock.desktop" "$PKG_ROOT/usr/share/applications/"
fi
if [ -f "$TOP_DIR/deploy/hamclock.png" ]; then
  cp "$TOP_DIR/deploy/hamclock.png" "$PKG_ROOT/usr/share/icons/hicolor/128x128/apps/"
fi
if [ -f "$TOP_DIR/deploy/hamclock.1" ]; then
  gzip -c "$TOP_DIR/deploy/hamclock.1" > "$PKG_ROOT/usr/share/man/man1/hamclock.1.gz"
fi

# 5. Build .deb package
DEB_FILENAME="${PKG_NAME}_${VERSION}-${REVISION}_${ARCH}.deb"
dpkg-deb --build --root-owner-group "$PKG_ROOT" "$OUT_DIR/$DEB_FILENAME"

rm -rf "$PKG_ROOT"
echo "Successfully created Debian package: $OUT_DIR/$DEB_FILENAME"
