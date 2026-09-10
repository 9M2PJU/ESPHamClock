#!/bin/bash
# ==============================================================================
# HamClock Dedicated Installer for Android (Termux)
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# https://github.com/9M2PJU/9M2PJU-HamClock-Installer
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}       HamClock Installer for Android (Termux)       ${NC}"
echo -e "${CYAN}=====================================================${NC}"

# Check for Termux environment
if [ -z "$PREFIX" ] && [ ! -d "/data/data/com.termux" ]; then
    echo -e "${YELLOW}Warning: This installer is intended for Termux on Android.${NC}"
fi

# 1. Dependencies
echo -e "\n${YELLOW}[1/4] Installing Required Termux Packages...${NC}"
pkg update -y
pkg install -y clang make git curl

# 2. Resolution Selection
RAW_TARGET="${TARGET:-$1}"
if [ -n "$RAW_TARGET" ]; then
    case "$RAW_TARGET" in
        800x480|*800x480*) MAKE_TARGET="hamclock-web-800x480" ;;
        1600x960|*1600x960*) MAKE_TARGET="hamclock-web-1600x960" ;;
        2400x1440|*2400x1440*) MAKE_TARGET="hamclock-web-2400x1440" ;;
        3200x1920|*3200x1920*) MAKE_TARGET="hamclock-web-3200x1920" ;;
        1) MAKE_TARGET="hamclock-web-1600x960" ;;
        2) MAKE_TARGET="hamclock-web-800x480" ;;
        3) MAKE_TARGET="hamclock-web-2400x1440" ;;
        4) MAKE_TARGET="hamclock-web-3200x1920" ;;
        5)
            pkg install -y x11-repo && pkg install -y libx11
            MAKE_TARGET="hamclock-1600x960"
            ;;
        6)
            pkg install -y x11-repo && pkg install -y libx11
            MAKE_TARGET="hamclock-800x480"
            ;;
        *) MAKE_TARGET="hamclock-web-$RAW_TARGET" ;;
    esac
    echo -e "\n${CYAN}Using specified target: $MAKE_TARGET${NC}"
else
    echo -e "\n${YELLOW}[2/4] Select HamClock Resolution for Android:${NC}"
    echo "  1) Web Browser - 1600x960 (Tablet / Large Screen) [Default]"
    echo "  2) Web Browser - 800x480 (Phone Screen)"
    echo "  3) Web Browser - 2400x1440 (High-DPI Tablet)"
    echo "  4) Web Browser - 3200x1920 (4K / Ultra-High-DPI)"
    echo "  5) X11 GUI - 1600x960 (Requires Termux:X11 app)"
    echo "  6) X11 GUI - 800x480 (Requires Termux:X11 app)"

    if [ -t 0 ]; then
        read -r -p "Enter choice [1-6, default: 1]: " TARGET_CHOICE || TARGET_CHOICE=1
    elif [ -e /dev/tty ] && [ -r /dev/tty ]; then
        echo -n "Enter choice [1-6, default: 1]: "
        read -r -u 3 TARGET_CHOICE 3< /dev/tty 2>/dev/null || TARGET_CHOICE=1
    else
        read -r -p "Enter choice [1-6, default: 1]: " TARGET_CHOICE 2>/dev/null || TARGET_CHOICE=1
    fi
    TARGET_CHOICE=${TARGET_CHOICE:-1}

    case "$TARGET_CHOICE" in
        1) MAKE_TARGET="hamclock-web-1600x960" ;;
        2) MAKE_TARGET="hamclock-web-800x480" ;;
        3) MAKE_TARGET="hamclock-web-2400x1440" ;;
        4) MAKE_TARGET="hamclock-web-3200x1920" ;;
        5)
            pkg install -y x11-repo && pkg install -y libx11
            MAKE_TARGET="hamclock-1600x960"
            ;;
        6)
            pkg install -y x11-repo && pkg install -y libx11
            MAKE_TARGET="hamclock-800x480"
            ;;
        *) MAKE_TARGET="hamclock-web-1600x960" ;;
    esac
fi

# 3. Source & Build
echo -e "\n${YELLOW}[3/4] Compiling $MAKE_TARGET...${NC}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

CLEANUP_BUILD_DIR=0
if [ -f "$SCRIPT_DIR/Makefile" ]; then
    BUILD_DIR="$SCRIPT_DIR"
    cd "$BUILD_DIR"
else
    BUILD_DIR="$(mktemp -d "${TMPDIR:-/data/data/com.termux/files/usr/tmp}/hamclock-build-XXXXXX" 2>/dev/null || mktemp -d /tmp/hamclock-build-XXXXXX)"
    echo "Fetching latest source into temporary directory $BUILD_DIR..."
    git clone --depth 1 https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git "$BUILD_DIR"
    cd "$BUILD_DIR"
    CLEANUP_BUILD_DIR=1
fi

make clean
NPROCS=$(nproc 2>/dev/null || echo 2)

# Apply Termux patches
for p in "$BUILD_DIR"/termux/patches/*.patch; do
    if [ -f "$p" ]; then
        echo "Applying $(basename "$p")..."
        patch -p1 -N < "$p" || true
    fi
done

# Compile disable-fdsan helper
clang -c "$BUILD_DIR/termux/disable-fdsan.c" -o "$BUILD_DIR/termux/disable-fdsan.o"

# Build target with clang++ and disable-fdsan runtime hook
make "$MAKE_TARGET" CXX="clang++" LDXXFLAGS="-LArduinoLib -LwsServer -Lzlib-hc -g -pthread $BUILD_DIR/termux/disable-fdsan.o -ldl" -j"$NPROCS"

# Revert patches if building in local repository directory
if [ "$CLEANUP_BUILD_DIR" -eq 0 ]; then
    for p in "$BUILD_DIR"/termux/patches/*.patch; do
        if [ -f "$p" ]; then
            patch -p1 -R -s < "$p" || true
        fi
    done
fi

# 4. Install Binary & Wrapper
echo -e "\n${YELLOW}[4/4] Installing HamClock into Termux PATH...${NC}"
BIN_DEST="${PREFIX:-/data/data/com.termux/files/usr}/bin"
mkdir -p "$BIN_DEST"
cp -f "$BUILD_DIR/$MAKE_TARGET" "$BIN_DEST/hamclock"
chmod +x "$BIN_DEST/hamclock"

if [ "$CLEANUP_BUILD_DIR" -eq 1 ]; then
    rm -rf "$BUILD_DIR"
fi

# IP Address detection
LOCAL_IP=$(ip -4 addr show 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127.0.0.1' | head -n 1 || echo "YOUR_DEVICE_IP")

echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}      HamClock Installation Completed on Android!   ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "\n${YELLOW}🚀 NEXT STEPS TO RUN HAMCLOCK:${NC}\n"
echo -e "  ${CYAN}Step 1:${NC} Keep Termux running & disable battery saver:
    • Run command: ${YELLOW}termux-wake-lock${NC}
    • Android ${YELLOW}Settings ➔ Apps ➔ Termux ➔ Battery ➔ Unrestricted${NC} (Disable Battery Saver)\n"
echo -e "  ${CYAN}Step 2:${NC} Start HamClock daemon:"
echo -e "    ${YELLOW}hamclock -k &${NC}\n"
echo -e "  ${CYAN}Step 3:${NC} For the best borderless Full-Screen & Auto-Fit shack display:"
echo -e "    Install ${CYAN}Fully Kiosk Browser & Launcher${NC} from Google Play:"
echo -e "    ${CYAN}https://play.google.com/store/apps/details?id=de.ozerov.fully&hl=en${NC}\n"
echo -e "    Set Start URL to: ${GREEN}http://localhost:8081/live.html${NC}\n"
echo -e "-----------------------------------------------------"
echo -e "${CYAN}🌐 Quick Access URLs:${NC}"
echo -e "  Interactive Touch Screen:  ${GREEN}http://localhost:8081/live.html${NC}"
echo -e "  LAN Remote Access:         ${GREEN}http://${LOCAL_IP}:8081/live.html${NC}"
echo -e "  Read-Only Monitor Screen:  ${GREEN}http://localhost:8082/live.html${NC}"
echo -e "  Backend RESTful API:       ${GREEN}http://localhost:8080/${NC}"
echo -e "${GREEN}=====================================================${NC}\n"
