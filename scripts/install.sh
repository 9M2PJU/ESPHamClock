#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock Installer (Open HamClock / OHB Edition)
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Compatible with: Linux (Debian, Ubuntu, Raspberry Pi OS, Arch, Fedora),
#                  macOS (Homebrew + XQuartz), and FreeBSD
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo -e "  _    _                 _____ _            _    "
echo -e " | |  | |               / ____| |          | |   "
echo -e " | |__| | __ _ _ __ ___| |    | | ___   ___| | __"
echo -e " |  __  |/ _\` | '_ \` _ \\ |    | |/ _ \\ / __| |/ /"
echo -e " | |  | | (_| | | | | | | |___| | (_) | (__|   < "
echo -e " |_|  |_|\\__,_|_| |_| |_|\\____|_|\\___/ \\___|_|\\_\\"
echo -e "${NC}"
echo -e "${GREEN}          9M2PJU Installer  -  OHB Edition          ${NC}"
echo -e "${BLUE}====================================================${NC}"

OS="$(uname -s)"
ARCH="$(uname -m)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check command existence
has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Install dependencies if missing
echo -e "\n${YELLOW}[1/5] Checking dependencies...${NC}"

if [ "$OS" = "Linux" ]; then
    if has_cmd g++ && has_cmd make && has_cmd pkg-config && has_cmd git; then
        echo -e "${GREEN}Build dependencies (g++, make, git) are already present.${NC}"
    elif has_cmd apt-get; then
        echo "Detected Debian/Ubuntu/Raspberry Pi OS system. Installing dependencies..."
        sudo apt-get update -y
        sudo apt-get install -y build-essential make g++ libx11-dev libgpiod-dev curl unzip git pkg-config
    elif has_cmd pacman; then
        echo "Detected Arch Linux / CachyOS / Manjaro system. Installing dependencies..."
        sudo pacman -Sy --noconfirm base-devel libx11 libgpiod curl unzip git
    elif has_cmd dnf; then
        echo "Detected Fedora / RHEL system. Installing dependencies..."
        sudo dnf install -y gcc-c++ make libX11-devel libgpiod-devel curl unzip git
    else
        echo "Please ensure g++, make, git, and libX11-dev are installed."
    fi
elif [ "$OS" = "Darwin" ]; then
    echo "Detected macOS."
    if ! has_cmd brew; then
        echo -e "${RED}Homebrew is required on macOS. Please install Homebrew first.${NC}"
        exit 1
    fi
    brew install make gcc git
    if ! [ -d "/opt/X11" ] && ! [ -d "/opt/local" ]; then
        echo "Installing XQuartz for X11 display support..."
        brew install --cask xquartz || true
    fi
elif [ "$OS" = "FreeBSD" ]; then
    echo "Detected FreeBSD."
    sudo pkg install -y gmake gcc libX11 libgpio curl unzip git
fi

# 2. Select build target & resolution
RAW_TARGET="${TARGET:-${RES:-${RESOLUTION:-$1}}}"

if [ -n "$RAW_TARGET" ]; then
    case "$RAW_TARGET" in
        *web*800*|web-800x480)    MAKE_TARGET="hamclock-web-800x480" ;;
        *web*1600*|web-1600x960)  MAKE_TARGET="hamclock-web-1600x960" ;;
        *web*2400*|web-2400x1440) MAKE_TARGET="hamclock-web-2400x1440" ;;
        *web*3200*|web-3200x1920) MAKE_TARGET="hamclock-web-3200x1920" ;;
        *fb*800*|fb0-800x480)     MAKE_TARGET="hamclock-fb0-800x480" ;;
        *fb*1600*|fb0-1600x960)   MAKE_TARGET="hamclock-fb0-1600x960" ;;
        *fb*2400*|fb0-2400x1440)  MAKE_TARGET="hamclock-fb0-2400x1440" ;;
        *fb*3200*|fb0-3200x1920)  MAKE_TARGET="hamclock-fb0-3200x1920" ;;
        *1600*|1600x960)          MAKE_TARGET="hamclock-1600x960" ;;
        *2400*|2400x1440)         MAKE_TARGET="hamclock-2400x1440" ;;
        *3200*|3200x1920)         MAKE_TARGET="hamclock-3200x1920" ;;
        *800*|800x480)            MAKE_TARGET="hamclock-800x480" ;;
        *)                        MAKE_TARGET="$RAW_TARGET" ;;
    esac
    echo -e "\n${CYAN}Using specified target: $MAKE_TARGET${NC}"
else
    echo -e "\n${YELLOW}[2/5] Select HamClock Build Target & Resolution:${NC}"
    echo "  1) Desktop X11 - 800x480 (Standard Desktop GUI) [Default]"
    echo "  2) Desktop X11 - 1600x960 (Large Desktop GUI)"
    echo "  3) Desktop X11 - 2400x1440 (High-DPI Desktop GUI)"
    echo "  4) Desktop X11 - 3200x1920 (Huge 4K Desktop GUI)"
    echo "  5) Web Server Only - 800x480 (Headless / Remote Browser Access)"
    echo "  6) Web Server Only - 1600x960 (Large Headless)"
    echo "  7) Raspberry Pi /dev/fb0 - 800x480 (Standalone Kiosk)"
    echo "  8) Raspberry Pi /dev/fb0 - 1600x960 (Large Standalone Kiosk)"

    if [ -t 0 ]; then
        read -r -p "Enter choice [1-8, default: 1]: " TARGET_CHOICE || TARGET_CHOICE=1
    elif [ -e /dev/tty ] && [ -r /dev/tty ]; then
        echo -n "Enter choice [1-8, default: 1]: "
        read -r -u 3 TARGET_CHOICE 3< /dev/tty 2>/dev/null || TARGET_CHOICE=1
    else
        read -r -p "Enter choice [1-8, default: 1]: " TARGET_CHOICE 2>/dev/null || TARGET_CHOICE=1
    fi
    TARGET_CHOICE=${TARGET_CHOICE:-1}

    case "$TARGET_CHOICE" in
        1) MAKE_TARGET="hamclock-800x480" ;;
        2) MAKE_TARGET="hamclock-1600x960" ;;
        3) MAKE_TARGET="hamclock-2400x1440" ;;
        4) MAKE_TARGET="hamclock-3200x1920" ;;
        5) MAKE_TARGET="hamclock-web-800x480" ;;
        6) MAKE_TARGET="hamclock-web-1600x960" ;;
        7) MAKE_TARGET="hamclock-fb0-800x480" ;;
        8) MAKE_TARGET="hamclock-fb0-1600x960" ;;
        *) MAKE_TARGET="hamclock-800x480" ;;
    esac
fi

# 3. Obtain Source & Build
echo -e "\n${YELLOW}[3/5] Compiling $MAKE_TARGET...${NC}"

CLEANUP_BUILD_DIR=0
if [ -f "$SCRIPT_DIR/Makefile" ]; then
    BUILD_DIR="$SCRIPT_DIR"
    cd "$BUILD_DIR"
else
    BUILD_DIR="$(mktemp -d /tmp/hamclock-build-XXXXXX)"
    echo "Fetching latest source into temporary directory $BUILD_DIR..."
    git clone --depth 1 https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git "$BUILD_DIR"
    cd "$BUILD_DIR"
    CLEANUP_BUILD_DIR=1
fi

make clean
NPROCS=1
if has_cmd nproc; then
    NPROCS=$(nproc)
elif has_cmd sysctl; then
    NPROCS=$(sysctl -n hw.ncpu || echo 1)
fi

make "$MAKE_TARGET" -j"$NPROCS"

# 4. Install binary and desktop shortcuts
echo -e "\n${YELLOW}[4/5] Installing HamClock...${NC}"
if [ "$(id -u)" -eq 0 ]; then
    BIN_DEST="/usr/local/bin"
else
    BIN_DEST="$HOME/.local/bin"
fi

mkdir -p "$BIN_DEST"
cp "$MAKE_TARGET" "$BIN_DEST/hamclock"
chmod +x "$BIN_DEST/hamclock"

# Install desktop shortcut on Linux
if [ "$OS" = "Linux" ]; then
    mkdir -p "$HOME/.local/share/icons" "$HOME/.local/share/applications"
    if [ -f "$BUILD_DIR/deploy/hamclock.png" ]; then
        cp "$BUILD_DIR/deploy/hamclock.png" "$HOME/.local/share/icons/"
    elif [ -f "$BUILD_DIR/hamclock.png" ]; then
        cp "$BUILD_DIR/hamclock.png" "$HOME/.local/share/icons/"
    fi
    if [ -f "$BUILD_DIR/deploy/hamclock.desktop" ]; then
        cp "$BUILD_DIR/deploy/hamclock.desktop" "$HOME/.local/share/applications/"
        sed -i "s|/usr/local/bin/hamclock|$BIN_DEST/hamclock|g" "$HOME/.local/share/applications/hamclock.desktop" || true
    elif [ -f "$BUILD_DIR/hamclock.desktop" ]; then
        cp "$BUILD_DIR/hamclock.desktop" "$HOME/.local/share/applications/"
        sed -i "s|/usr/local/bin/hamclock|$BIN_DEST/hamclock|g" "$HOME/.local/share/applications/hamclock.desktop" || true
    fi
fi

# Cleanup temp build dir if created
if [ "$CLEANUP_BUILD_DIR" = "1" ]; then
    rm -rf "$BUILD_DIR"
fi

# 5. Configure auto-start on login
AUTOSTART_CHOICE="${AUTOSTART:-}"

# Build the per-OS menu options
case "$OS" in
    Linux)
        AUTOSTART_OPTIONS=(
            "1) No, do not auto-start [Default]"
            "2) Yes, via XDG autostart (starts when you log into your desktop)"
            "3) Yes, via systemd user service (starts on login, restarts on crash)"
        )
        AUTOSTART_DEFAULT=1
        ;;
    Darwin)
        AUTOSTART_OPTIONS=(
            "1) No, do not auto-start [Default]"
            "2) Yes, via launchd LaunchAgent (starts on login, restarts on crash)"
        )
        AUTOSTART_DEFAULT=1
        ;;
    FreeBSD)
        AUTOSTART_OPTIONS=(
            "1) No, do not auto-start [Default]"
            "2) Yes, via XDG autostart (starts with X11 desktop session)"
            "3) Yes, via ~/.xinitrc (starts with startx)"
        )
        AUTOSTART_DEFAULT=1
        ;;
    *)
        AUTOSTART_OPTIONS=()
        AUTOSTART_DEFAULT=1
        ;;
esac

if [ -z "$AUTOSTART_CHOICE" ] && [ "${#AUTOSTART_OPTIONS[@]}" -gt 0 ]; then
    echo -e "\n${YELLOW}[5/5] Auto-start HamClock on login?${NC}"
    for opt in "${AUTOSTART_OPTIONS[@]}"; do
        echo "  $opt"
    done

    MAX_CHOICE="${#AUTOSTART_OPTIONS[@]}"
    if [ -t 0 ]; then
        read -r -p "Enter choice [1-$MAX_CHOICE, default: $AUTOSTART_DEFAULT]: " AUTOSTART_CHOICE || AUTOSTART_CHOICE=$AUTOSTART_DEFAULT
    elif [ -e /dev/tty ] && [ -r /dev/tty ]; then
        echo -n "Enter choice [1-$MAX_CHOICE, default: $AUTOSTART_DEFAULT]: "
        read -r -u 3 AUTOSTART_CHOICE 3< /dev/tty 2>/dev/null || AUTOSTART_CHOICE=$AUTOSTART_DEFAULT
    else
        read -r -p "Enter choice [1-$MAX_CHOICE, default: $AUTOSTART_DEFAULT]: " AUTOSTART_CHOICE 2>/dev/null || AUTOSTART_CHOICE=$AUTOSTART_DEFAULT
    fi
    AUTOSTART_CHOICE=${AUTOSTART_CHOICE:-$AUTOSTART_DEFAULT}
fi

AUTOSTART_MODE="none"
if [ "$OS" = "Linux" ]; then
    case "$AUTOSTART_CHOICE" in
        2|xdg|XDG)         AUTOSTART_MODE="xdg" ;;
        3|systemd|SYSTEMD) AUTOSTART_MODE="systemd" ;;
        *)                 AUTOSTART_MODE="none" ;;
    esac
elif [ "$OS" = "Darwin" ]; then
    case "$AUTOSTART_CHOICE" in
        2|launchd|LAUNCHD) AUTOSTART_MODE="launchd" ;;
        *)                 AUTOSTART_MODE="none" ;;
    esac
elif [ "$OS" = "FreeBSD" ]; then
    case "$AUTOSTART_CHOICE" in
        2|xdg|XDG)         AUTOSTART_MODE="xdg" ;;
        3|xinitrc|XINITRC) AUTOSTART_MODE="xinitrc" ;;
        *)                 AUTOSTART_MODE="none" ;;
    esac
fi

if [ "$AUTOSTART_MODE" = "xdg" ]; then
    mkdir -p "$HOME/.config/autostart"
    if [ -f "$HOME/.local/share/applications/hamclock.desktop" ]; then
        cp "$HOME/.local/share/applications/hamclock.desktop" "$HOME/.config/autostart/"
        echo -e "${GREEN}XDG autostart entry installed at ~/.config/autostart/hamclock.desktop${NC}"
    else
        cat > "$HOME/.config/autostart/hamclock.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=HamClock
Exec=$BIN_DEST/hamclock
Icon=hamclock
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
        echo -e "${GREEN}XDG autostart entry installed at ~/.config/autostart/hamclock.desktop${NC}"
    fi
elif [ "$AUTOSTART_MODE" = "systemd" ]; then
    mkdir -p "$HOME/.config/systemd/user"
    cat > "$HOME/.config/systemd/user/hamclock.service" <<EOF
[Unit]
Description=HamClock
After=graphical-session.target

[Service]
ExecStart=$BIN_DEST/hamclock
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable hamclock.service 2>/dev/null || true
    echo -e "${GREEN}systemd user service installed and enabled: ~/.config/systemd/user/hamclock.service${NC}"
    echo -e "${YELLOW}Note: for systemd user services to run after reboot without an active session, you may need:${NC}"
    echo -e "${YELLOW}  loginctl enable-linger \$USER${NC}"
elif [ "$AUTOSTART_MODE" = "launchd" ]; then
    mkdir -p "$HOME/Library/LaunchAgents"
    cat > "$HOME/Library/LaunchAgents/local.hamclock.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>local.hamclock</string>
    <key>ProgramArguments</key>
    <array>
        <string>$BIN_DEST/hamclock</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>ProcessType</key>
    <string>Interactive</string>
</dict>
</plist>
EOF
    launchctl load "$HOME/Library/LaunchAgents/local.hamclock.plist" 2>/dev/null || true
    echo -e "${GREEN}launchd LaunchAgent installed and loaded: ~/Library/LaunchAgents/local.hamclock.plist${NC}"
elif [ "$AUTOSTART_MODE" = "xinitrc" ]; then
    touch "$HOME/.xinitrc"
    chmod +x "$HOME/.xinitrc"
    if grep -q "$BIN_DEST/hamclock" "$HOME/.xinitrc" 2>/dev/null; then
        echo -e "${GREEN}~/.xinitrc already launches HamClock, no change needed.${NC}"
    else
        printf '\n# Auto-start HamClock (added by install.sh)\n%s/hamclock &\n' "$BIN_DEST" >> "$HOME/.xinitrc"
        echo -e "${GREEN}HamClock auto-start appended to ~/.xinitrc${NC}"
    fi
fi

echo -e "\n${GREEN}"
echo -e "  ____ ____  ___  ___   ___ __  __ ___ ___    _ _   _ "
echo -e " |__  |__ / |   \\| __| / _ \\  \\/  |_  ) _ \\_ | | | | |"
echo -e "   / / |_ \\ | |) | _|  \\_, / |\\/| |/ /|  _/ || | |_| |"
echo -e "  /_/ |___/ |___/|___|  /_/|_|  |_/___|_|  \\__/ \\___/ "
echo -e "${NC}"
echo -e "${CYAN}+--------------------------------------------------+${NC}"
echo -e "${CYAN}|${GREEN}  Target:          ${YELLOW}$MAKE_TARGET${NC}"
echo -e "${CYAN}|${GREEN}  Binary Path:     ${YELLOW}$BIN_DEST/hamclock${NC}"
echo -e "${CYAN}|${GREEN}  Auto-start:      ${YELLOW}$AUTOSTART_MODE${NC}"
echo -e "${CYAN}|${GREEN}  Default Backend: ${YELLOW}ohb.hamclock.app:80${NC}"
echo -e "${CYAN}+--------------------------------------------------+${NC}"
echo -e "You can start HamClock by running:\n  ${YELLOW}hamclock${NC}\n"
echo -e "${BLUE}Found a problem? Please report it on GitHub:${NC}"
echo -e "  ${CYAN}https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues${NC}\n"
