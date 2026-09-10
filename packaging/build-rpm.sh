#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock .rpm Package Generator
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Usage: ./packaging/build-rpm.sh <arch> [output_dir]
# Supported arch: x86_64, aarch64, armhfp
# ==============================================================================

set -e

RPM_ARCH="${1:-x86_64}"
VERSION="4.32"
OUT_DIR="${2:-./dist}"
TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Map Fedora arch names to Debian/Ubuntu rpm-compatible target arches.
# Ubuntu's rpm lacks "armhfp" in its arch_compat table, so %{_arch} does not
# expand and rpmbuild fails with "No compatible architectures found for build".
# armv7hl is the actual hard-float armv7 arch that both Fedora and Ubuntu rpm understand.
RPM_BUILD_ARCH="$RPM_ARCH"
if [ "$RPM_BUILD_ARCH" = "armhfp" ]; then
    RPM_BUILD_ARCH="armv7hl"
fi

RPM_ROOT="$(mktemp -d /tmp/rpm-build-XXXXXX)"
mkdir -p "$RPM_ROOT/BUILD" "$RPM_ROOT/RPMS" "$RPM_ROOT/SOURCES" "$RPM_ROOT/SPECS" "$RPM_ROOT/SRPMS"
mkdir -p "$OUT_DIR"

# Copy sources to SOURCES
cp "$TOP_DIR/packaging/hamclock-launcher.sh" "$RPM_ROOT/SOURCES/"
if [ -f "$TOP_DIR/deploy/hamclock.desktop" ]; then
  cp "$TOP_DIR/deploy/hamclock.desktop" "$RPM_ROOT/SOURCES/"
fi
if [ -f "$TOP_DIR/deploy/hamclock.png" ]; then
  cp "$TOP_DIR/deploy/hamclock.png" "$RPM_ROOT/SOURCES/"
fi
if [ -f "$TOP_DIR/deploy/hamclock.1" ]; then
  cp "$TOP_DIR/deploy/hamclock.1" "$RPM_ROOT/SOURCES/"
fi

for target in hamclock-800x480 hamclock-1600x960 hamclock-2400x1440 hamclock-3200x1920 hamclock-web-800x480 hamclock-web-1600x960; do
  if [ -f "$TOP_DIR/$target" ]; then
    cp "$TOP_DIR/$target" "$RPM_ROOT/SOURCES/"
  fi
done

cp "$TOP_DIR/packaging/hamclock.spec" "$RPM_ROOT/SPECS/"

rpmbuild --define "_topdir $RPM_ROOT" \
         --target "$RPM_BUILD_ARCH" \
         --define "__strip /bin/true" \
         -bb "$RPM_ROOT/SPECS/hamclock.spec"

# Copy built RPMs to output dir, renaming to the requested arch if it was mapped.
find "$RPM_ROOT/RPMS" -type f -name "*.rpm" | while read -r rpm; do
    out_name="$(basename "$rpm")"
    if [ "$RPM_ARCH" != "$RPM_BUILD_ARCH" ]; then
        out_name="${out_name%.${RPM_BUILD_ARCH}.rpm}.${RPM_ARCH}.rpm"
    fi
    cp "$rpm" "$OUT_DIR/$out_name"
done
rm -rf "$RPM_ROOT"

echo "Successfully created RPM package in $OUT_DIR"
