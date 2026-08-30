# 🚀 HamClock Installation Guide

Comprehensive installation instructions for **HamClock (Open HamClock / OHB Edition)** across all supported operating systems and hardware platforms.

---

## 📑 Table of Contents
1. [One-Liner Quick Install (Linux/macOS/FreeBSD)](#1-one-liner-quick-install)
2. [Pre-Built Linux Packages (AUR, .deb, .rpm, .AppImage)](#2-pre-built-linux-packages-aur-deb-rpm-appimage)
3. [Windows Installation (WSL2 & Docker)](#3-windows-installation-wsl2--docker)
4. [Android Installation (Native APK & Termux)](#4-android-installation-native-apk--termux)
5. [Docker & Containerized Setup](#5-docker--containerized-setup)
6. [Raspberry Pi & Inovato Quadra Setup](#6-raspberry-pi--inovato-quadra-setup)
7. [Package Managers & Pre-Built Distributions](#7-package-managers--pre-built-distributions)
8. [Linux Native Source Compilation](#8-linux-native-source-compilation)
9. [macOS Installation (Apple Silicon & Intel)](#9-macos-installation)
10. [FreeBSD Installation](#10-freebsd-installation)
11. [Auto-Start on Login (All OSes)](#11-auto-start-on-login-all-oses)
12. [Headless Web Server Systemd Service](#12-headless-web-server-systemd-service)

---

## 1. One-Liner Quick Install

The universal installer automatically detects your operating system, installs any missing build packages, compiles HamClock, sets up desktop shortcuts, and optionally configures auto-start on login.

```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

### Selecting Resolution / Target Non-Interactively:
```bash
# Large Desktop (1600x960)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | TARGET=1600x960 bash

# Headless Web Server (1600x960)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | TARGET=web-1600x960 bash

# Raspberry Pi Touchscreen Framebuffer (/dev/fb0)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | TARGET=fb0-800x480 bash
```

### Selecting Auto-Start Non-Interactively:
```bash
# Linux: XDG autostart
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=xdg bash

# Linux: systemd user service
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=systemd bash

# macOS: launchd LaunchAgent
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=launchd bash

# FreeBSD: ~/.xinitrc
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=xinitrc bash
```

Combine target and auto-start:
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | TARGET=1600x960 AUTOSTART=xdg bash
```

### Running HamClock After Install

Start HamClock by running:
```bash
hamclock
```

If the `hamclock` command is not found, run `hash -r` or open a new terminal. To launch a specific resolution (package manager installs):
```bash
hamclock -r 1600x960      # Recommended for 1080p monitors
hamclock -r 2400x1440     # 2K displays
hamclock -r 3200x1920     # 4K displays
hamclock -r 800x480       # Small touchscreens
```

For headless / web-only builds, access the web UI at `http://localhost:8081/live.html`.

### Reporting Issues

If you encounter any problems, please [open an issue on GitHub](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues). Include your OS, architecture, the install command you ran, and any error output.

---

## 2. Pre-Built Linux Packages (AUR, .deb, .rpm, .AppImage)

For quick installation without building from source, download pre-compiled packages directly from [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/releases) or install via package managers:

### 📦 Snap Store (Ubuntu / Universal Linux)
```bash
sudo snap install hamclock
```

### 🏹 Arch Linux / Manjaro / EndeavourOS / CachyOS (AUR)
```bash
# Using yay
yay -S hamclock-git

# Using paru
paru -S hamclock-git
```

### 🐧 Debian / Ubuntu / Raspberry Pi OS (`.deb`)
Supports `amd64`, `arm64` (RPi 4/5), and `armhf` (RPi 2/3, 32-bit):
```bash
# Download and install
sudo dpkg -i hamclock_4.29-1_amd64.deb    # or _arm64.deb / _armhf.deb
sudo apt-get install -f                   # resolve dependencies
```

### 🎩 Fedora / RHEL / openSUSE (`.rpm`)
Supports `x86_64`, `aarch64`, and `armhfp`:
```bash
sudo rpm -Uvh hamclock-4.29-1.x86_64.rpm  # or .aarch64.rpm
```

### 🚀 Universal AppImage (Runs on ANY Linux distro without installation)
Supports `x86_64`, `aarch64`, and `armhf`:
```bash
chmod +x HamClock-4.29-x86_64.AppImage
./HamClock-4.29-x86_64.AppImage

# Launch with specific resolution
./HamClock-4.29-x86_64.AppImage -r 1600x960
```

---

## 3. Windows Installation (WSL2 & Docker)

See the full [Windows Installation Guide](WINDOWS.md) for complete instructions.

### 1-Click Automated PowerShell Installer:
```powershell
irm https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/scripts/install.ps1 | iex
```

---

## 4. Android Installation (Native APK & Termux)

See the full [Android Installation Guide](ANDROID.md) for complete APK and Termux instructions, battery saver settings, and autostart configurations.

### Option A: Official Standalone Android App (.apk) [Recommended] ⭐

The standalone native Android APK contains the full embedded C++ engine. No Termux, root, or Linux chroot required!

- [📥 **Download Universal APK (`9M2PJU-HamClock.apk`)**](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases/latest)
- **All Architectures & Releases:** [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases) (`arm64-v8a`, `armeabi-v7a`, `x86_64`, `x86`)

#### Quick Start (APK):
1. Download `9M2PJU-HamClock.apk` to your Android device and tap to install.
2. Open **HamClock** and configure your Callsign and Grid Square in the Setup screen.
3. *(Optional)* Enable **Foreground Service** and **Start on Boot** in app settings.

---

### Option B: 1-Line Automated Termux Installer (CLI)

Open the **Termux** app and run:
```bash
pkg update -y && pkg install -y curl && bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"
```

#### Quick Start (Termux):
1. Prevent Android from sleeping (disable Battery Saver) and start HamClock:
   ```bash
   termux-wake-lock
   hamclock -k &
   ```
   *(Ensure Android **Settings ➔ Apps ➔ Termux ➔ Battery** is set to **"Unrestricted"**)*.
2. For the best **Full-Screen & Auto-Fit** display, install [**Fully Kiosk Browser**](https://play.google.com/store/apps/details?id=de.ozerov.fully&hl=en) from Google Play and open:
   ```text
   http://localhost:8081/live.html
   ```

---

## 5. Docker & Containerized Setup

For servers, NAS devices (Synology, TrueNAS, Unraid), and headless Raspberry Pis.

### Option A: 1-Line Docker Automated Deployment
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install-docker.sh | bash
```

### Option B: Docker Compose
Create a `docker-compose.yml` file:
```yaml
services:
  hamclock:
    image: ghcr.io/9m2pju/9m2pju-hamclock-docker:latest
    container_name: hamclock
    restart: unless-stopped
    ports:
      - "8080:8080" # REST API & Screenshot (/live.png)
      - "8081:8081" # Real-time Interactive Web UI (/live.html)
      - "8082:8082" # Read-Only Web Monitor
    environment:
      - RESOLUTION=1600x960  # Options: 800x480, 1600x960, 2400x1440, 3200x1920
      - EXTRA_ARGS=-k
    volumes:
      - hamclock_data:/home/hamclock/.hamclock

volumes:
  hamclock_data:
```
Launch with:
```bash
docker compose up -d
```

---

## 6. Raspberry Pi & Inovato Quadra Setup

### Standalone Kiosk Mode (Direct Linux Framebuffer)
If you are running a Raspberry Pi or Inovato Quadra without a heavy desktop environment (e.g. Raspberry Pi OS Lite):
```bash
sudo apt update && sudo apt install -y build-essential make g++ libgpiod-dev curl
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
make hamclock-fb0-800x480 -j$(nproc)
sudo make install
```
Start in kiosk mode:
```bash
sudo hamclock -k -f on
```

---

## 7. Package Managers & Pre-Built Distributions

### Arch Linux / CachyOS / Manjaro (AUR)
Install the official AUR package with `yay` or `paru`:
```bash
yay -S hamclock-git
```

> [!NOTE]
> **Resolution in Package Managers:**
> The AUR package builds and installs all 6 resolutions (`800x480`, `1600x960`, `2400x1440`, `3200x1920`, and web versions) at once into `/usr/lib/hamclock/`.
> 
> To launch your desired resolution:
> ```bash
> hamclock -r 1600x960    # Launch 1600x960 (recommended for PC)
> hamclock-1600x960       # Direct alias
> hamclock -r 2400x1440   # Launch 2K
> hamclock -r 3200x1920   # Launch 4K
> ```
> Or set a permanent default in `~/.bashrc`:
> ```bash
> export HAMCLOCK_RES=1600x960
> ```

### Pre-Built Packages (Debian, Fedora, AppImage)
Download the latest binaries from [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/releases):

- **Ubuntu / Debian / Raspberry Pi OS (`.deb`)**:
  ```bash
  sudo dpkg -i hamclock_4.29-1_amd64.deb   # (or arm64 / armhf)
  ```
- **Fedora / RHEL / openSUSE (`.rpm`)**:
  ```bash
  sudo rpm -Uvh hamclock-4.29-1.x86_64.rpm  # (or aarch64 / armhfp)
  ```
- **Universal Linux (`.AppImage`)**:
  ```bash
  chmod +x HamClock-4.29-x86_64.AppImage
  ./HamClock-4.29-x86_64.AppImage
  ```

---

## 8. Linux Native Source Compilation

### Debian / Ubuntu / Mint / Raspberry Pi OS Desktop
```bash
sudo apt update
sudo apt install -y build-essential make g++ libx11-dev libgpiod-dev curl unzip pkg-config
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
make hamclock-1600x960 -j$(nproc)
sudo make install
```

### Fedora / RHEL / AlmaLinux
```bash
sudo dnf install -y gcc-c++ make libX11-devel libgpiod-devel curl unzip
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
make hamclock-1600x960 -j$(nproc)
sudo make install
```

---

## 9. macOS Installation

Requires [Homebrew](https://brew.sh/) and [XQuartz](https://www.xquartz.org/):

```bash
brew install make gcc
brew install --cask xquartz
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
make hamclock-1600x960 -j$(sysctl -n hw.ncpu)
sudo make install
```

---

## 10. FreeBSD Installation

```bash
sudo pkg install -y gmake gcc libX11 libgpio curl unzip
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
gmake hamclock-1600x960
sudo gmake install
```

---

## 11. Auto-Start on Login (All OSes)

The 1-liner installer asks whether to auto-start HamClock on login. The available options depend on your OS:

| OS | Auto-Start Methods |
| :--- | :--- |
| **Linux** | XDG autostart (`~/.config/autostart/hamclock.desktop`), systemd user service (`~/.config/systemd/user/hamclock.service`) |
| **macOS** | launchd LaunchAgent (`~/Library/LaunchAgents/local.hamclock.plist`) |
| **FreeBSD** | XDG autostart (`~/.config/autostart/hamclock.desktop`), `~/.xinitrc` (for `startx` sessions) |
| **Android (Termux)** | Use [Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot); see [Android & Termux Guide](ANDROID.md) |

### Linux: XDG Autostart (Desktop Login)
Starts HamClock when you log into your desktop environment (GNOME, KDE, XFCE, etc.):
```bash
mkdir -p ~/.config/autostart
cp ~/.local/share/applications/hamclock.desktop ~/.config/autostart/
```

### Linux: Systemd User Service (Auto-Restart on Crash)
Creates a user-level systemd service that restarts on failure:
```bash
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/hamclock.service <<'EOF'
[Unit]
Description=HamClock
After=graphical-session.target

[Service]
ExecStart=%h/.local/bin/hamclock
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now hamclock.service
```

> [!NOTE]
> For systemd user services to survive reboot without an active login session:
> ```bash
> loginctl enable-linger $USER
> ```

### macOS: launchd LaunchAgent
Starts HamClock on login and keeps it alive (auto-restarts on crash):
```bash
mkdir -p ~/Library/LaunchAgents
cat > ~/Library/LaunchAgents/local.hamclock.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>local.hamclock</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/hamclock</string>
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

launchctl load ~/Library/LaunchAgents/local.hamclock.plist
```

### FreeBSD: ~/.xinitrc (startx Sessions)
Appends HamClock to your X11 startup script:
```bash
echo '/usr/local/bin/hamclock &' >> ~/.xinitrc
```

### Removing Auto-Start
```bash
# Linux (XDG)
rm -f ~/.config/autostart/hamclock.desktop

# Linux (systemd)
systemctl --user disable --now hamclock.service
rm -f ~/.config/systemd/user/hamclock.service
systemctl --user daemon-reload

# macOS (launchd)
launchctl unload ~/Library/LaunchAgents/local.hamclock.plist
rm -f ~/Library/LaunchAgents/local.hamclock.plist

# FreeBSD (~/.xinitrc)
# Edit ~/.xinitrc and remove the HamClock line manually
```

---

## 12. Headless Web Server Systemd Service

For headless servers running the web-only build (`hamclock-web-*`), create a system-level systemd service.

Create `/etc/systemd/system/hamclock.service`:
```ini
[Unit]
Description=HamClock Web Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=pi
ExecStart=/usr/local/bin/hamclock -k -d /home/pi/.hamclock
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```
Enable and start the service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hamclock
sudo systemctl status hamclock
```
