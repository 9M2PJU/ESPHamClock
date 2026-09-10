#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock AppImage Generator
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Usage: ./packaging/build-appimage.sh <arch> [output_dir]
# Supported arch: x86_64, aarch64, armhf
# ==============================================================================

set -e

ARCH="${1:-x86_64}"
VERSION="4.32"
OUT_DIR="${2:-./dist}"
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

APPDIR="$(mktemp -d /tmp/hamclock-appdir-XXXXXX)"
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/lib/hamclock"
mkdir -p "$APPDIR/usr/share/icons/hicolor/128x128/apps"
mkdir -p "$OUT_DIR"

# 1. Copy desktop file and icon
cp "$TOP_DIR/deploy/hamclock.desktop" "$APPDIR/"
cp "$TOP_DIR/deploy/hamclock.png" "$APPDIR/"
cp "$TOP_DIR/deploy/hamclock.png" "$APPDIR/.DirIcon"
cp "$TOP_DIR/deploy/hamclock.png" "$APPDIR/usr/share/icons/hicolor/128x128/apps/"

# 2. Copy binaries
for target in hamclock-800x480 hamclock-1600x960 hamclock-2400x1440 hamclock-3200x1920 hamclock-web-800x480 hamclock-web-1600x960; do
  if [ -f "$TOP_DIR/$target" ]; then
    cp "$TOP_DIR/$target" "$APPDIR/usr/lib/hamclock/"
    chmod 755 "$APPDIR/usr/lib/hamclock/$target"
  fi
done

# 3. Copy launcher
cp "$TOP_DIR/packaging/hamclock-launcher.sh" "$APPDIR/usr/bin/hamclock"
chmod 755 "$APPDIR/usr/bin/hamclock"

# 4. Create AppRun entrypoint
cat << 'EOF' > "$APPDIR/AppRun"
#!/usr/bin/env bash
HERE="$(dirname "$(readlink -f "${0}")")"
export PATH="${HERE}/usr/bin:${PATH}"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${HERE}/usr/lib/hamclock:${LD_LIBRARY_PATH}"
export XDG_DATA_DIRS="${HERE}/usr/share:${XDG_DATA_DIRS}"

exec "${HERE}/usr/bin/hamclock" "$@"
EOF
chmod 755 "$APPDIR/AppRun"

# 5. Build AppImage using appimagetool
APPIMAGE_NAME="HamClock-${VERSION}-${ARCH}.AppImage"
export ARCH="$ARCH"

if command -v appimagetool >/dev/null 2>&1; then
  appimagetool "$APPDIR" "$OUT_DIR/$APPIMAGE_NAME"
elif [ -x "/tmp/appimagetool" ]; then
  /tmp/appimagetool "$APPDIR" "$OUT_DIR/$APPIMAGE_NAME"
else
  echo "Downloading appimagetool..."
  curl -fsSL -o /tmp/appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-${ARCH}.AppImage" || \
  curl -fsSL -o /tmp/appimagetool "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
  chmod +x /tmp/appimagetool
  /tmp/appimagetool "$APPDIR" "$OUT_DIR/$APPIMAGE_NAME"
fi

rm -rf "$APPDIR"
echo "Successfully created AppImage: $OUT_DIR/$APPIMAGE_NAME"
