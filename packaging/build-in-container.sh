#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock Multi-Resolution Binary Generator (Inside Debian Container)
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# ==============================================================================

set -e

echo "=== Installing Container Build Dependencies ==="
apt-get update
apt-get install -y build-essential make g++ libx11-dev libgpiod-dev pkg-config

mkdir -p /tmp/built-bin

targets=(
  "hamclock-800x480"
  "hamclock-1600x960"
  "hamclock-2400x1440"
  "hamclock-3200x1920"
  "hamclock-web-800x480"
  "hamclock-web-1600x960"
)

for t in "${targets[@]}"; do
  echo "=== Compiling target: $t ==="
  make clean
  # Override LIBS to fix link order: -lX11 must come AFTER -larduino (static archive
  # that references X11 symbols), and -lgpiod is required since libgpiod-dev is installed
  # and Adafruit_MCP23X17.cpp references gpiod_* symbols. The Makefile's default link
  # rule puts -lX11 before $(LIBS), which gets dropped by --as-needed on modern Debian.
  make "$t" LIBS="-lpthread -larduino -lzlib-hc -lws -lX11 -lgpiod" -j$(nproc)
  cp "$t" /tmp/built-bin/
done

cp /tmp/built-bin/* ./
echo "=== All HamClock binaries compiled successfully! ==="
