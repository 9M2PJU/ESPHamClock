#!/bin/bash
# ==============================================================================
# HamClock Standalone Build Helper for Android Termux
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Builds HamClock without permanently modifying upstream source files.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$SCRIPT_DIR"

TARGET="${1:-hamclock-web-1600x960}"
NPROCS=$(nproc 2>/dev/null || echo 2)

echo "==> Preparing Android Termux build for $TARGET ($NPROCS cores)..."

# Apply Termux patches temporarily
for p in "$SCRIPT_DIR"/termux/patches/*.patch; do
    if [ -f "$p" ]; then
        echo "Applying $(basename "$p")..."
        patch -p1 -N < "$p" || true
    fi
done

# Compile disable-fdsan helper
clang -c "$SCRIPT_DIR/termux/disable-fdsan.c" -o "$SCRIPT_DIR/termux/disable-fdsan.o"

# Compile target with clang++ and include disable-fdsan.o in linking
echo "==> Compiling $TARGET..."
make "$TARGET" CXX="clang++" LDXXFLAGS="-LArduinoLib -LwsServer -Lzlib-hc -g -pthread $SCRIPT_DIR/termux/disable-fdsan.o -ldl" -j"$NPROCS"

# Revert patches so the git working tree stays 100% pristine
for p in "$SCRIPT_DIR"/termux/patches/*.patch; do
    if [ -f "$p" ]; then
        patch -p1 -R -s < "$p" || true
    fi
done

echo "==> Build successful: $SCRIPT_DIR/$TARGET"
