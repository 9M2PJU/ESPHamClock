#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock Universal Launcher
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Compatible with: Standard FHS installs, AppImage, and Standalone Folders
# ==============================================================================

SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$SNAP" ] && [ -d "$SNAP/lib/hamclock" ]; then
  LIB_DIR="$SNAP/lib/hamclock"
elif [ -n "$FLATPAK_ID" ] && [ -d "/app/lib/hamclock" ]; then
  LIB_DIR="/app/lib/hamclock"
elif [ -d "/usr/lib/hamclock" ]; then
  LIB_DIR="/usr/lib/hamclock"
elif [ -d "/usr/local/lib/hamclock" ]; then
  LIB_DIR="/usr/local/lib/hamclock"
elif [ -d "$SELF_DIR/../lib/hamclock" ]; then
  LIB_DIR="$(cd "$SELF_DIR/../lib/hamclock" && pwd)"
elif [ -d "$SELF_DIR/../lib" ]; then
  LIB_DIR="$(cd "$SELF_DIR/../lib" && pwd)"
else
  LIB_DIR="$SELF_DIR"
fi

RES="${HAMCLOCK_RES:-800x480}"
TARGET_ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--resolution|--res)
      RES="$2"
      shift 2
      ;;
    --list-resolutions|-l)
      echo "Available HamClock resolutions:"
      echo "  - 800x480   (Standard definition / touchscreens)"
      echo "  - 1600x960  (Full HD / recommended for desktop)"
      echo "  - 2400x1440 (2K Quad HD)"
      echo "  - 3200x1920 (4K Ultra HD)"
      echo "  - web-800x480 (Headless web server)"
      echo "  - web-1600x960 (Headless web server large)"
      exit 0
      ;;
    *)
      TARGET_ARGS+=("$1")
      shift
      ;;
  esac
done

case "$RES" in
  *web*800*|web-800x480)   BIN="$LIB_DIR/hamclock-web-800x480" ;;
  *web*1600*|web-1600x960) BIN="$LIB_DIR/hamclock-web-1600x960" ;;
  *1600*|1600x960)         BIN="$LIB_DIR/hamclock-1600x960" ;;
  *2400*|2400x1440)        BIN="$LIB_DIR/hamclock-2400x1440" ;;
  *3200*|3200x1920)        BIN="$LIB_DIR/hamclock-3200x1920" ;;
  *800*|800x480|*)         BIN="$LIB_DIR/hamclock-800x480" ;;
esac

if [ ! -x "$BIN" ]; then
  # Fallback: search for any hamclock executable in LIB_DIR or SELF_DIR
  BIN=$(find "$LIB_DIR" "$SELF_DIR" -maxdepth 2 -name "hamclock-*" -type f -perm -111 2>/dev/null | grep -v "hamclock-launcher" | head -n 1)
fi

if [ ! -x "$BIN" ]; then
  echo "Error: HamClock binary ($BIN) not found in $LIB_DIR." >&2
  exit 1
fi

exec "$BIN" "${TARGET_ARGS[@]}"
