#!/usr/bin/env bash
# ==============================================================================
# 9M2PJU HamClock Installer - 1-Line Docker Installer
# Author: 9M2PJU (https://hamradio.my)
# Contact / Support Email: 9m2pju@hamradio.my
# Runs HamClock in Docker with multi-resolution support & persistent storage.
# ==============================================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}      9M2PJU HamClock Docker Installer           ${NC}"
echo -e "${GREEN}         (Open HamClock - OHB Edition)              ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Check for Docker
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${YELLOW}Docker is not installed.${NC}"
    read -r -p "Would you like to install Docker now using the official script? [y/N]: " INSTALL_DOCKER
    if [[ "$INSTALL_DOCKER" =~ ^[Yy]$ ]]; then
        curl -fsSL https://get.docker.com | sudo sh
        sudo usermod -aG docker "$USER" || true
        echo -e "${GREEN}Docker installed successfully!${NC}"
    else
        echo -e "${RED}Please install Docker first, then re-run this script.${NC}"
        exit 1
    fi
fi

# Ensure Docker daemon is accessible
if ! docker info >/dev/null 2>&1; then
    if sudo docker info >/dev/null 2>&1; then
        DOCKER_CMD="sudo docker"
    else
        echo -e "${RED}Error: Docker daemon is not running or accessible.${NC}"
        echo "Please start Docker with: sudo systemctl start docker"
        exit 1
    fi
else
    DOCKER_CMD="docker"
fi

IMAGE="ghcr.io/9m2pju/9m2pju-hamclock-docker:latest"
RAW_RES="${RESOLUTION:-${HAMCLOCK_RES:-$1}}"

if [ -z "$RAW_RES" ]; then
    echo -e "\n${YELLOW}Select HamClock Resolution:${NC}"
    echo "  1) 1600x960  (Recommended for Tablets, iPads, and 1080p Screens) [Default]"
    echo "  2) 800x480   (Standard Definition / Compact Displays)"
    echo "  3) 2400x1440 (High-DPI / 2K Monitors)"
    echo "  4) 3200x1920 (4K UHD Screens)"

    read -r -p "Enter choice [1-4, default: 1]: " RES_CHOICE
    RES_CHOICE=${RES_CHOICE:-1}

    case "$RES_CHOICE" in
        1) CHOSEN_RES="1600x960" ;;
        2) CHOSEN_RES="800x480" ;;
        3) CHOSEN_RES="2400x1440" ;;
        4) CHOSEN_RES="3200x1920" ;;
        *) CHOSEN_RES="1600x960" ;;
    esac
else
    case "$RAW_RES" in
        *800*|800x480)   CHOSEN_RES="800x480" ;;
        *1600*|1600x960) CHOSEN_RES="1600x960" ;;
        *2400*|2400x1440) CHOSEN_RES="2400x1440" ;;
        *3200*|3200x1920) CHOSEN_RES="3200x1920" ;;
        *)               CHOSEN_RES="$RAW_RES" ;;
    esac
fi

echo -e "\n${CYAN}[1/3] Pulling latest HamClock Docker image...${NC}"
$DOCKER_CMD pull "$IMAGE"

echo -e "\n${CYAN}[2/3] Setting up persistent storage and removing previous container...${NC}"
$DOCKER_CMD rm -f hamclock 2>/dev/null || true

echo -e "\n${CYAN}[3/3] Launching HamClock container (${CHOSEN_RES})...${NC}"
$DOCKER_CMD run -d \
    --name hamclock \
    --restart unless-stopped \
    -p 8080:8080 \
    -p 8081:8081 \
    -p 8082:8082 \
    -e RESOLUTION="$CHOSEN_RES" \
    -e EXTRA_ARGS="-k" \
    -v hamclock_data:/home/hamclock/.hamclock \
    "$IMAGE"

# Detect local IP
LOCAL_IP="localhost"
if command -v hostname >/dev/null 2>&1 && hostname -I >/dev/null 2>&1; then
    LOCAL_IP=$(hostname -I | awk '{print $1}')
fi

echo -e "\n${GREEN}====================================================${NC}"
echo -e "${GREEN}  HamClock Docker Deployment Successful!           ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo -e "Access HamClock in your browser:"
echo -e "  🌐 Live Interactive Screen: ${YELLOW}http://${LOCAL_IP}:8081/live.html${NC}"
echo -e "  📺 Read-Only Monitor:       ${YELLOW}http://${LOCAL_IP}:8082/live.html${NC}"
echo -e "  📷 REST API / Screenshot:   ${YELLOW}http://${LOCAL_IP}:8080/live.png${NC}"
echo -e "\nTo switch resolution anytime:"
echo -e "  ${CYAN}RESOLUTION=800x480 ./install-docker.sh${NC} (or 1600x960, 2400x1440, 3200x1920)"
echo -e "To view logs:"
echo -e "  ${CYAN}$DOCKER_CMD logs -f hamclock${NC}\n"
