# 9M2PJU HamClock Installer

<div align="center">

### *The Quintessential Space Weather, Radio Propagation & Telemetry Dashboard for Amateur Radio*

[![HamClock Version](https://img.shields.io/badge/version-4.29-blue.svg?style=for-the-badge&logo=cplusplus)](file:///home/x/ESPHamClock/version.cpp)
[![Backend Status](https://img.shields.io/badge/backend-OHB%20(Open%20HamClock%20Backend)-brightgreen.svg?style=for-the-badge&logo=server)](https://ohb.hamclock.app)
[![AUR package](https://img.shields.io/aur/version/hamclock-git?color=1793D1&label=AUR&logo=archlinux&style=for-the-badge)](https://aur.archlinux.org/packages/hamclock-git)
[![Snap Store](https://img.shields.io/badge/Snap%20Store-Stable-E95420.svg?style=for-the-badge&logo=snapcraft&logoColor=white)](https://snapcraft.io/hamclock)
[![Windows Support](https://img.shields.io/badge/Windows-Native%20.exe%20%7C%20WSL2%20%7C%20Docker-0078D6.svg?style=for-the-badge&logo=windows&logoColor=white)](docs/WINDOWS.md)
[![Android Support](https://img.shields.io/badge/Android-APK%20App%20%7C%20Termux-3DDC84.svg?style=for-the-badge&logo=android&logoColor=white)](docs/ANDROID.md)
[![Docker Image](https://img.shields.io/badge/docker-ghcr.io%2F9m2pju%2F9m2pju--hamclock--docker-2496ED.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/pkgs/container/9m2pju-hamclock-docker)
[![Buy Me a Coffee](https://img.shields.io/badge/Buy_Me_a_Coffee-9M2PJU-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/9m2pju)
[![Wise](https://img.shields.io/badge/Wise-faizulz13-163300?style=for-the-badge&logo=wise&logoColor=white)](https://wise.com/pay/me/faizulz13)
[![License](https://img.shields.io/badge/license-Custom%20Amateur%20Radio-purple.svg?style=for-the-badge)](file:///home/x/ESPHamClock/LICENSE)

<br/>

<p align="center">
  <img src="docs/images/9m2pju-hamclock-ohb.png" alt="9M2PJU HamClock OHB Backend Screenshot" width="850" />
</p>

---

[Origin & Tribute](#-origin--the-silent-key-legacy) •
[OHB Migration](#-the-open-hamclock-backend-ohb-era) •
[Features](#-feature-matrix) •
[Quick Install](#-one-liner-quick-install) •
[Android App](#-android-support-native-apk--termux) •
[Windows](#-windows-support-native-exe-powershell--wsl2) •
[Docker Setup](#-docker--docker-compose) •
[Rotator & Radio](#-rotator--radio-cat-integration) •
[Docs](#-documentation-library) •
[Manual Build](#-manual-compilation--build-matrix) •
[CLI & Web Server](#-remote-web-interface--rest-api)

---

</div>

## 🕊️ Origin & The Silent Key Legacy

**HamClock** was conceived, architected, and brought to life by **Elwood Downey (WB0OEW)** under the banner of **Clear Sky Institute**. 

Elwood—an accomplished astronomer, software architect (renowned creator of *XEphem*), and passionate radio amateur—originally designed HamClock as a compact, self-contained microcontroller project for the **Adafruit Feather HUZZAH ESP8266** paired with an Adafruit RA8875 TFT driver. 

As the project gained massive popularity across the global amateur radio community, Elwood continuously expanded its capabilities, developing an elegant POSIX abstraction layer ([`ArduinoLib`](file:///home/x/ESPHamClock/ArduinoLib)) that allowed the exact same codebase to compile natively on **Linux, Raspberry Pi, Inovato Quadra, macOS, and FreeBSD**. For years, Elwood personally financed and hosted the high-reliability Clear Sky Institute backend servers that parsed NOAA space weather, satellite TLEs, VOACAP models, and solar imagery for tens of thousands of clocks worldwide.

With Elwood Downey becoming **Silent Key (SK)**, the original Clear Sky Institute infrastructure ceased operations. Rather than letting this indispensable amateur radio instrument fade into history, the worldwide ham radio community mobilized to keep his legacy alive.

> **In Memory of Elwood Downey, WB0OEW (Silent Key - SK)**
> *"His signals continue to propagate across the globe."*

---

## 🌐 The Open HamClock Backend (OHB) Era

To ensure HamClock remains fully functional, reliable, and open for future generations of radio operators, an international collective of amateur radio enthusiasts developed the **Open HamClock Backend (OHB)**.

### What Changed in Version 4.24+ (Current: 4.29)

- **Hard-Coded Community Backend**: HamClock now connects directly to `ohb.hamclock.app:80` by default.
- **No Switching Scripts or DNS Redirection Required**: Older transitional scripts (`sudo ohb`, `sudo fix-hosts`, `sudo csi`) and manual `/etc/hosts` modifications are no longer required.
- **Seamless Upgrade**: Full backward compatibility with existing user configurations, callsign profiles, and NVRAM settings in `~/.hamclock/`.
- **Modern Service Restorations**: Space weather feeds, NOAA alerts, SDO solar imagery, VOACAP HF propagation models, DX cluster spots, satellite orbital TLEs, and contest calendars are completely restored and maintained on high-availability community servers.

---

## 📊 Feature Matrix

<div align="center">

| Subsystem | Capabilities & Integrations |
| :--- | :--- |
| **☀️ Space Weather** | Live Solar Flux Index (SFI), Sunspot Number (SSN), Planetary Kp & Ap indices, X-ray solar flare flux, solar wind velocity & density, interplanetary magnetic field ($B_z$ / $B_t$), NOAA alerts, and real-time Solar Dynamics Observatory (SDO) EUV imagery. |
| **📻 Propagation & Bands** | VOACAP point-to-point HF propagation prediction engine, real-time 80m–10m band condition matrix, Take-Off Angle (TOA) adjustments, and live synchronized NCDXF/IARU international beacon monitoring. |
| **🗺️ Cartography & Grayline** | High-resolution Mercator, Robinson, and Azimuthal (Great Circle / beam heading) projections centered on your DE (QTH). Live day/night terminator (grayline) mapping, Maidenhead 6-character grid overlays, CQ zones, and ITU zones. |
| **📡 DX Cluster & Digital Modes** | Live DX cluster telnet/web ingestion, PSK Reporter FT8/FT4/CW real-time spot pins on the globe, callsign DXCC prefix database lookup, and custom callsign watchlists with audio/visual alerts. |
| **🛰️ Satellites, EME & Rotators** | Orbit calculation via Plan-13 algorithm for ISS and amateur satellites, next pass predictions, Doppler shift estimation, Earth-Moon-Earth (EME) mutual visibility windows, and automated Az/El antenna rotor/gimbal control (rotctld, Yaesu, Easycomm). |
| **📜 Logbook & Rig Control** | Real-time ADIF log ingestion from WSJT-X, N1MM Logger+, and standard loggers; on-air QSO pins plotted live; Flrig and rigctld CAT transceiver tracking. |
| **⏱️ Clocks & Geolocation** | Dual DE/DX local timezones, UTC precision display, sub-second NTP synchronization, hardware NMEA GPS & `gpsd` daemon support, IP geolocation, and stopwatch/timer controls. |
| **🌐 Built-in Web Server** | Interactive WebSocket remote mirror (port `8081`) for touch/click browser control, read-only monitor (port `8082`), and RESTful HTTP API (port `8080`) for screenshots and automation. |

</div>

---

## ⚡ One-Liner Quick Install

Use the universal automated installation script to install build dependencies, compile the optimized binary for your hardware, create application menu shortcuts, and optionally configure auto-start on login:

### Linux / Raspberry Pi / Inovato Quadra / Ubuntu / Debian / Arch / Fedora
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

### macOS (Apple Silicon & Intel)
> *Requires [Homebrew](https://brew.sh/) and [XQuartz](https://www.xquartz.org/).*
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

### Android (Official Native App - APK) ⭐
> *100% Native Embedded C++ Engine — No Termux or root required.*
Download the latest APK directly from [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases):
- [📥 **Download Universal APK (`9M2PJU-HamClock.apk`)**](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases/latest)

### Android (Termux CLI)
> *Turns any Android phone or tablet into a dedicated, low-power (<3W) touch clock via Termux.*
```bash
pkg update -y && pkg install -y curl && bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"
```

### FreeBSD
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

### Local Execution
```bash
git clone https://github.com/9M2PJU/9M2PJU-HamClock-Installer.git
cd 9M2PJU-HamClock-Installer
./install.sh
```

---

### 🔁 Auto-Start on Login

The installer asks whether to auto-start HamClock on login. The available options depend on your OS:

| OS | Auto-Start Methods |
| :--- | :--- |
| **Linux** | XDG autostart (`~/.config/autostart/hamclock.desktop`), systemd user service (`~/.config/systemd/user/hamclock.service`) |
| **macOS** | launchd LaunchAgent (`~/Library/LaunchAgents/local.hamclock.plist`) |
| **FreeBSD** | XDG autostart (`~/.config/autostart/hamclock.desktop`), `~/.xinitrc` (for `startx` sessions) |
| **Android (Termux)** | Use [Termux:Boot](https://wiki.termux.com/wiki/Termux:Boot); see [Android & Termux Guide](docs/ANDROID.md) |

#### Non-Interactive Auto-Start Selection

Skip the prompt by setting the `AUTOSTART` environment variable. Note: the variable must be set for `bash` (the right side of the pipe), not `curl`:

```bash
# Linux: XDG autostart
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=xdg bash

# Linux: systemd user service
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=systemd bash

# macOS: launchd LaunchAgent
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=launchd bash

# FreeBSD: ~/.xinitrc
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=xinitrc bash

# Disable auto-start (default)
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | AUTOSTART=none bash
```

You can combine with target/resolution selection:
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | TARGET=1600x960 AUTOSTART=xdg bash
```

#### Removing Auto-Start

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

### ▶️ Running HamClock

After installation, start HamClock by running:

```bash
hamclock
```

If the `hamclock` command is not found, run `hash -r` or open a new terminal, then try again. You can also launch a specific resolution directly (if installed via package manager):

```bash
hamclock -r 1600x960      # Recommended for 1080p monitors
hamclock -r 2400x1440     # 2K displays
hamclock -r 3200x1920     # 4K displays
hamclock -r 800x480       # Small touchscreens
```

For headless / web-only builds, access the web UI at `http://localhost:8081/live.html`.

---

### 🐛 Support & Reporting Issues

If you encounter any problems, bugs, or have feature requests, please [open an issue on GitHub](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues):

```
https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues
```

Please include your OS, architecture, the install command you ran, and any error output. 73!

---

## 📦 Pre-Built Linux Packages (.deb, .rpm, .AppImage)

For instant installation without compiling from source, pre-built binary packages are available directly from [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/releases) for **amd64**, **arm64**, and **armhf**:

<div align="center">

| Package Format | Target Operating Systems | Supported Architectures |
| :--- | :--- | :--- |
| **`Android (.apk)`** | Android Phones, Tablets, Android TV Boxes (Android 5.0+) | Universal, `arm64-v8a`, `armeabi-v7a`, `x86_64`, `x86` |
| **`AUR`** | Arch Linux, Manjaro, EndeavourOS, CachyOS | `x86_64`, `aarch64`, `armv7h` |
| **`Snap`** | Ubuntu, Debian, Fedora, Arch Linux, Manjaro, openSUSE | `amd64`, `arm64`, `armhf` |
| **`.deb`** | Debian, Ubuntu, Raspberry Pi OS, Armbian, Linux Mint | `amd64`, `arm64`, `armhf` |
| **`.rpm`** | Fedora, RHEL, CentOS, Rocky Linux, openSUSE | `x86_64`, `aarch64`, `armhfp` |
| **`.AppImage`** | **Universal** (Runs on any Linux distribution) | `x86_64`, `aarch64`, `armhf` |

</div>

### 📦 Snap Store (Ubuntu / Universal Linux)
> ```bash
> sudo snap install hamclock
> ```
>
> Track build: [GitHub Actions — Snap Build](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/actions/workflows/snap.yml)

### 🏹 Arch Linux (AUR)
```bash
# Using yay
yay -S hamclock-git

# Using paru
paru -S hamclock-git
```

### 🐧 Debian / Ubuntu / Raspberry Pi OS (`.deb`)
```bash
# Download and install for your architecture
sudo dpkg -i hamclock_4.29-1_amd64.deb    # x86_64 PCs
sudo dpkg -i hamclock_4.29-1_arm64.deb    # Raspberry Pi 4/5 / 64-bit ARM
sudo dpkg -i hamclock_4.29-1_armhf.deb    # Raspberry Pi 2/3 / 32-bit Raspbian
sudo apt-get install -f                   # Resolve any missing dependencies
```

### 🎩 Fedora / RHEL / openSUSE (`.rpm`)
```bash
sudo rpm -Uvh hamclock-4.29-1.x86_64.rpm  # x86_64
sudo rpm -Uvh hamclock-4.29-1.aarch64.rpm # ARM64
```

### 🚀 Universal AppImage (Single-File Executable)
```bash
chmod +x HamClock-4.29-x86_64.AppImage
./HamClock-4.29-x86_64.AppImage

# Launch with custom resolution
./HamClock-4.29-x86_64.AppImage -r 1600x960
```

---

## 🪟 Windows Support (Native .exe, PowerShell & WSL2)

HamClock now builds as a **native Windows `.exe`** - no WSL, Docker, or X11 required. The executable runs a headless web server; you view the dashboard in any browser at `http://localhost:8081/live.html`.

### Option A: Download Pre-Built .exe from GitHub Releases

Download the latest `mingw-web-*.exe` from the [GitHub Releases page](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/releases). Four resolutions are available:

| File | Resolution | Use Case |
| :--- | :--- | :--- |
| `mingw-web-800x480.exe` | 800 x 480 | Standard, smaller displays |
| `mingw-web-1600x960.exe` | 1600 x 960 | Large, recommended default |
| `mingw-web-2400x1440.exe` | 2400 x 1440 | Hi-DPI |
| `mingw-web-3200x1920.exe` | 3200 x 1920 | 4K UHD |

Run the `.exe` from Command Prompt or PowerShell, then open `http://localhost:8081/live.html` in any browser. No installation required - the executable is statically linked and only depends on Windows system DLLs.

### Option B: Build from Source (MinGW-w64 Cross-Compile)

Build from Linux using MinGW-w64:

```bash
# Install MinGW-w64 toolchain
# Arch:   sudo pacman -S mingw-w64-gcc
# Debian: sudo apt install g++-mingw-w64-x86-64

# Build all four resolution variants:
make mingw-all-web

# Or build a single resolution:
make mingw-web-800x480
```

Copy the resulting `mingw-web-*.exe` to your Windows machine and run it.

### Option C: PowerShell Installer (WSL2 or Docker)

```powershell
irm https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/scripts/install.ps1 | iex
```

- **WSL2 / WSLg**: Runs as a seamless, hardware-accelerated native desktop window.
- **Docker Desktop**: Deploys the isolated headless container and opens `http://localhost:8081/live.html`.
- For detailed instructions, see the [Windows User Guide](docs/WINDOWS.md).

---

## 📱 Android Support (Native APK & Termux)

Turn spare Android tablets, phones, or TV boxes into permanent, low-power (<3W) **shack touch clocks** with two installation methods:

<p align="center">
  <img src="docs/images/9m2pju-hamclock-android.jpg" alt="HamClock running on Android Phone using Termux with Fully Kiosk Browser" width="700" />
</p>

### Option A: Official Standalone Android App (.apk) [Recommended] ⭐

The official standalone Android APK runs a 100% native embedded C++ engine directly on Android. No Termux, root, or Linux chroot needed!

- **🚀 100% Native Embedded C++ Engine**: Runs the full HamClock backend natively.
- **📍 GPS & Maidenhead Locator Sync**: Auto GPS coordinates acquisition & real-time station DE grid locator sync.
- **📦 Config Backup & Restore (SAF)**: One-tap export/import of station EEPROM, presets, and preferences via ZIP & Share Sheet.
- **🌙 OLED Burn-in Care & Night Dimmer**: Pixel-shift anti-burn-in protection and auto nighttime dimming schedule (10PM–6AM).
- **📺 Android TV & Car Ready**: Full D-Pad remote navigation support and automatic USB charger power wake/sleep.
- **📱 Edge-to-Edge Fullscreen Display**: Hardware-accelerated UI with responsive multi-touch.
- **🔋 24/7 Background Foreground Service**: Built-in WakeLock/WifiLock support to prevent sleep.
- **🌐 Multi-Device LAN Streaming**: View and control HamClock over WiFi at `http://<PHONE-IP>:8081/live.html`.
- **🇲🇾 Bahasa Melayu Localization**: Native Malaysian Malay language translations.
- **🔄 Auto-Start on Boot**: Toggle in settings for dedicated tablet monitors.

📥 **Download Packages from [GitHub Releases](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases):**
- [📥 **Download Universal APK (`9M2PJU-HamClock.apk`)**](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases/latest) *(Recommended — Universal for all devices)*
- **Architecture-Specific APKs:** `arm64-v8a` (64-bit ARM), `armeabi-v7a` (32-bit ARM), `x86_64`, `x86`

---

### Option B: Android via Termux CLI (DIY)

```bash
pkg update -y && pkg install -y curl && bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"
```

#### Quick Non-Interactive Target Selection:
```bash
# 1600x960 (Recommended for Tablets & 1080p Screens)
TARGET=1600x960 bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"

# 800x480 (Recommended for Phones & Compact Screens)
TARGET=800x480 bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"
```

#### Full-Screen & 24/7 Shack Operation:
1. **Background Running & Battery Saver**: Run `termux-wake-lock && hamclock -k &` and set Android **Settings ➔ Apps ➔ Termux ➔ Battery ➔ Unrestricted** (disable Battery Saver so Android does not suspend HamClock).
2. **Best Full-Screen & Auto-Fit View**: Install [**Fully Kiosk Browser**](https://play.google.com/store/apps/details?id=de.ozerov.fully&hl=en) from Google Play and set Start URL to `http://localhost:8081/live.html`.
3. For detailed kiosk settings, autostart on boot, and native X11 guides, see the [Android & Termux Guide](docs/ANDROID.md).

---

## 🐳 Docker & Docker Compose

Docker is the easiest way to deploy HamClock in **Headless / Server Mode** on home servers, NAS devices (Synology, TrueNAS, Unraid), Proxmox, and mini PCs without installing GUI or X11 dependencies.

Multi-architecture images are built automatically via **GitHub Actions** and hosted on GitHub Container Registry (GHCR):
- Supported Architectures: `linux/amd64` (x86_64 PCs & Servers), `linux/arm64` (Raspberry Pi 4/5, Apple Silicon), and `linux/arm/v7` (Raspberry Pi 2/3, 32-bit ARM).

---

### Option A: 1-Line Automated Docker Installer (Quickest)

Run this single command to pull the multi-arch container, select your resolution, and start HamClock:

```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install-docker.sh | bash
```

Or pass your desired resolution directly:
```bash
RESOLUTION=1600x960 curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install-docker.sh | bash
```

---

### Option B: Using Docker Compose

1. Save the [`docker-compose.yml`](file:///home/x/ESPHamClock/docker-compose.yml) file:
   ```yaml
   services:
     hamclock:
       image: ghcr.io/9m2pju/9m2pju-hamclock-docker:latest
       container_name: hamclock
       restart: unless-stopped
       ports:
         - "8080:8080" # RESTful API & Live Screenshot (/live.png)
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

2. Start the container:
   ```bash
   docker compose up -d
   ```

3. Open your browser to [`http://<server-ip>:8081/live.html`](http://localhost:8081/live.html) to interact with HamClock!

---

### Option C: Using Standalone `docker run`

```bash
docker run -d \
  --name hamclock \
  --restart unless-stopped \
  -p 8080:8080 \
  -p 8081:8081 \
  -p 8082:8082 \
  -e RESOLUTION=1600x960 \
  -v hamclock_data:/home/hamclock/.hamclock \
  ghcr.io/9m2pju/9m2pju-hamclock-docker:latest
```

---

## 📐 Resolution Guide & Switching

HamClock supports four distinct display resolutions tailored for different screen sizes:

| Resolution | Width × Height | Best Suited For |
| :--- | :--- | :--- |
| **`800x480`** | 800 × 480 px | Standard definition, smaller 5"–7" Raspberry Pi displays, low-bandwidth web access. |
| **`1600x960`** *(Recommended)* | 1600 × 960 px | Full HD (1080p) monitors, desktop windows, iPads, tablets, and wall dashboard screens. |
| **`2400x1440`** | 2400 × 1440 px | 2K / QHD monitors, high-DPI displays. |
| **`3200x1920`** | 3200 × 1920 px | 4K UHD large televisions and ultra-high-resolution displays. |

### How to Change Resolution in Docker
All four resolutions are **pre-compiled** inside the Docker image. You can switch resolutions instantly by updating the `RESOLUTION` environment variable—no container rebuild needed:

1. Edit `RESOLUTION` in `docker-compose.yml`:
   ```yaml
   environment:
     - RESOLUTION=1600x960   # Choose: 800x480, 1600x960, 2400x1440, 3200x1920
   ```
2. Apply the change:
   ```bash
   docker compose up -d
   ```

---

### How Resolution Works in Package Managers (AUR `yay`, `.deb`, `.rpm`, Snap, AppImage)

> [!NOTE]
> **Why doesn't `yay` / `pacman` / `apt` ask for screen resolution during installation?**
> Standard Linux package managers require **non-interactive, unattended builds** so automated system updates (`yay -Syu`) never hang waiting for user prompts.
> 
> Therefore, package managers build and install **all 6 resolutions simultaneously** into `/usr/lib/hamclock/`. You choose or change your resolution at **runtime** using the universal launcher:

1. **Launch a specific resolution on demand:**
   ```bash
   hamclock -r 1600x960     # Recommended for 1080p Desktop Monitors
   hamclock -r 2400x1440    # 2K Quad HD
   hamclock -r 3200x1920    # 4K Ultra HD
   hamclock -r 800x480      # Standard Definition / Touchscreens
   ```

2. **Or use direct binary symlinks:**
   ```bash
   hamclock-1600x960
   hamclock-800x480
   ```

3. **Set a permanent default resolution in your shell:**
   Add to `~/.bashrc` or `~/.profile`:
   ```bash
   export HAMCLOCK_RES=1600x960
   ```
   Then running `hamclock` will always open in `1600x960` automatically.

4. **List all available resolutions:**
   ```bash
   hamclock --list-resolutions
   ```

---

### How to Change Resolution with One-Liner Script (`install.sh`)

#### Method 1: Interactive Menu
Simply run `./install.sh` and select your preferred resolution target from the numbered prompt:
```bash
./install.sh
```

#### Method 2: Non-Interactive One-Liner (Environment Variable or Argument)
Pass `TARGET` or resolution directly into the command:

```bash
# Desktop X11 1600x960 (Large)
TARGET=1600x960 curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash

# Desktop X11 2400x1440 (2K Hi-DPI)
TARGET=2400x1440 curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash

# Web Server Only 1600x960 (Headless)
TARGET=web-1600x960 curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash

# Raspberry Pi Direct Framebuffer 800x480 (/dev/fb0)
TARGET=fb0-800x480 curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

---

## 📻 Rotator & Radio CAT Integration

HamClock is not just a display—it is a complete, real-time command center for your ham shack. Built by **Elwood Downey (WB0OEW)**—the creator of the renowned *XEphem* astronomical telescope software—HamClock features native TCP/IP socket integration for:

- **🧭 Antenna Rotator Control (`rotctld`)**:
  - Automatically commands 1-axis and 2-axis rotators (Yaesu, AlfaSpid, Easy-Comm, Green Heron, etc.).
  - **Auto-Turn to DX**: Click anywhere on the world map or enter a callsign to immediately point your directional beam antenna to the short-path (SP) or long-path (LP) bearing.
  - **Live Satellite Tracking**: Automatically tracks active amateur satellites (ISS, AO-91, RS-44, IO-117) across both Azimuth and Elevation in real-time.
- **📻 Transceiver CAT Control (`rigctld` / `flrig`)**:
  - **Dynamic VOACAP Band Matching**: Spinning your physical radio's VFO dial instantly switches the on-screen VOACAP propagation map to the active band.
  - **Click-to-Tune (QSY)**: Clicking any DX Cluster, POTA, SOTA, or PSK spot prompts you to QSY, immediately tuning your radio to the spotted frequency.
  - **Live ON AIR Badge**: Visual red transmitter PTT indicator on the clock display when keying the mic.

👉 **Read the complete guide:** [`docs/ROTATOR_AND_RADIO.md`](docs/ROTATOR_AND_RADIO.md)

---

## 📚 Documentation Library

Explore comprehensive guides and documentation in the [`docs/`](docs/) directory:

| Guide | Description |
| :--- | :--- |
| 📖 [**Installation Guide**](docs/INSTALLATION.md) | Step-by-step installation for Linux, Raspberry Pi, Inovato Quadra, macOS, FreeBSD, and Docker. |
| 📱 [**Android & Termux Guide**](docs/ANDROID.md) | Turn Android phones & tablets into dedicated, low-power shack touch clocks. |
| 🪟 [**Windows Setup Guide**](docs/WINDOWS.md) | Setup on Windows 10 & 11 via PowerShell, WSL2/WSLg, and Docker Desktop. |
| 📦 [**Snap Store Guide**](docs/SNAP.md) | Canonical Snap package maintainer and user deployment guide. |
| 📻 [**Rotator & Radio CAT Guide**](docs/ROTATOR_AND_RADIO.md) | Setup and usage for `rotctld`, `rigctld`, `flrig`, satellite tracking, and click-to-tune QSY. |
| ⚙️ [**Configuration & Settings**](docs/CONFIGURATION_AND_SETTINGS.md) | Guide to all setup pages, station coordinates, map layers, DX clusters, and ADIF loggers. |
| 💡 [**Usage, Tips & CLI Reference**](docs/USAGE_AND_TIPS.md) | Touch gestures, mouse controls, keyboard shortcuts, command line options, and REST APIs. |

---

## 🔨 Manual Compilation & Build Matrix

HamClock compiles natively on Unix-like operating systems. You can select your display resolution and output mode depending on your hardware:

### 1. Install Prerequisites

#### Debian / Ubuntu / Raspberry Pi OS / Inovato Quadra
```bash
sudo apt update
sudo apt install -y build-essential make g++ libx11-dev libgpiod-dev curl unzip pkg-config
```

#### Arch Linux / CachyOS / Manjaro
```bash
sudo pacman -Syu --needed base-devel libx11 libgpiod curl unzip
```

#### Fedora / RHEL
```bash
sudo dnf install -y gcc-c++ make libX11-devel libgpiod-devel curl unzip
```

#### macOS
```bash
brew install make gcc
brew install --cask xquartz
```

#### FreeBSD
```bash
sudo pkg install -y gmake gcc libX11 libgpio curl unzip
```

---

### 2. Choose Build Target & Resolution

HamClock provides three output architectures across four resolutions, plus a native Windows cross-compile target:

| Target Resolution | X11 Desktop GUI | Headless Web Server Only | RPi Direct Framebuffer (`/dev/fb0`) | Native Windows `.exe` (MinGW) |
| :--- | :--- | :--- | :--- | :--- |
| **800 × 480** *(Standard)* | `make hamclock-800x480` | `make hamclock-web-800x480` | `make hamclock-fb0-800x480` | `make mingw-web-800x480` |
| **1600 × 960** *(Large)* | `make hamclock-1600x960` | `make hamclock-web-1600x960` | `make hamclock-fb0-1600x960` | `make mingw-web-1600x960` |
| **2400 × 1440** *(Hi-DPI)* | `make hamclock-2400x1440` | `make hamclock-web-2400x1440` | `make hamclock-fb0-2400x1440` | `make mingw-web-2400x1440` |
| **3200 × 1920** *(4K UHD)* | `make hamclock-3200x1920` | `make hamclock-web-3200x1920` | `make hamclock-fb0-3200x1920` | `make mingw-web-3200x1920` |

> **Windows cross-compile** requires the MinGW-w64 toolchain (`mingw-w64-gcc` on Arch, `g++-mingw-w64-x86-64` on Debian/Ubuntu). The resulting `.exe` is a statically linked PE32+ executable that runs the web-only backend natively on Windows 10/11 without WSL or Docker. See [docs/WINDOWS.md](docs/WINDOWS.md) for details.

#### Build Example (800x480 Desktop GUI)
```bash
make clean
make hamclock-800x480 -j$(nproc)
```

#### Install System-Wide
```bash
sudo make install
```
*Copies the binary to `/usr/local/bin/hamclock` with setuid privileges if required for native GPIO/framebuffer access.*

---

## 🕹️ CLI Options & Runtime Flags

```
Purpose: Display space weather, propagation, and telemetry for radio amateurs
Usage:   hamclock [options]
```

| Flag | Argument | Description | Example |
| :--- | :--- | :--- | :--- |
| `-k` | *none* | Skip initial setup countdown and boot immediately | `hamclock -k` |
| `-g` | *none* | Auto-initialize DE location using public IP geolocation *(requires `-k`)* | `hamclock -k -g` |
| `-b` | `<host:port>`| Override backend server *(default: `ohb.hamclock.app:80`)* | `hamclock -b ohb.hamclock.app:80` |
| `-f` | `on` / `off` | Force initial fullscreen display mode | `hamclock -f on` |
| `-d` | `<directory>`| Specify working directory *(default: `~/.hamclock/`)* | `hamclock -d /opt/hamclock_data` |
| `-e` | `<port>` | RESTful web server port *(default: `8080`, `-1` to disable)* | `hamclock -e 8080` |
| `-w` | `<port>` | Read-write live web server port *(default: `8081`, `-1` to disable)* | `hamclock -w 8081` |
| `-r` | `<port>` | Read-only live web server port *(default: `8082`, `-1` to disable)* | `hamclock -r 8082` |
| `-t` | `<percent>` | Throttle maximum CPU usage percentage *(default: `80`)* | `hamclock -t 50` |
| `-m` | *none* | Enable demo mode | `hamclock -m` |
| `-v` | *none* | Display version and build information | `hamclock -v` |
| `-h` | *none* | Display comprehensive help and command options | `hamclock -h` |

---

## 🌐 Remote Web Interface & REST API

When HamClock is running (either locally or on a remote server/Raspberry Pi), open any web browser:

- **Interactive Live Mirror (Read/Write)**:
  ```
  http://<clock-ip-address>:8081/live.html
  ```
  *Provides a real-time, touch- and click-interactive mirror of the screen over WebSocket.*

- **Read-Only Monitor**:
  ```
  http://<clock-ip-address>:8082/live.html
  ```

- **RESTful Snapshot / Image Endpoint**:
  ```
  http://<clock-ip-address>:8080/live.png
  ```

---

## 🔄 Systemd Service & Autostart

### 1. Desktop GUI Autostart
To start HamClock automatically upon graphical desktop login:
```bash
mkdir -p ~/.config/autostart
cp hamclock.desktop ~/.config/autostart/
chmod +x ~/.config/autostart/hamclock.desktop
```

### 2. Headless or Kiosk Systemd Service
To run HamClock automatically in the background at boot:
```bash
sudo cp hamclock.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now hamclock
sudo systemctl status hamclock
```

---

## 📂 Repository Layout

- `src/` - C++ implementation source files (main entry point, telemetry, map engines, rotator and CAT radio controllers, WebSocket and REST servers)
- `include/` - C++ header files and global definitions
- `ArduinoLib/` - POSIX / Linux Arduino hardware abstraction
- `wsServer/` - Real-time WebSocket server library
- `zlib-hc/` - Embedded data decompression library
- `packaging/` - .deb, .rpm, and AppImage package builders
- `deploy/` - Linux desktop launchers, icons, systemd units
- `docker/` - Dockerfile, entrypoint, and compose configs
- `scripts/` - Native and Docker automated 1-line installers
- `termux/` - Dedicated Android Termux installer and build helpers
- `docs/` - Comprehensive documentation library and GitHub Pages
- `Makefile` - Standard POSIX build system

---

## 🛠️ Microcontroller Support (ESP8266)

For legacy standalone microcontroller builds on the **Adafruit Feather HUZZAH ESP8266** with Adafruit RA8875 driver:

1. Install and open the **Arduino IDE**.
2. Install the ESP8266 board definitions and required libraries (`Adafruit_RA8875`, `Adafruit_BME280`).
3. Open [`src/ESPHamClock.cpp`](src/ESPHamClock.cpp) (or `ESPHamClock.ino`).
4. Select `Adafruit Feather HUZZAH ESP8266`, CPU Frequency `160 MHz`, Flash Size `4M (3M SPIFFS)`.
5. Compile and upload.

---

## 🤝 Contributing & Community

Contributions, bug fixes, and feature enhancements are welcome!

1. Fork the repository.
2. Create your feature branch from `Staging` (`git checkout -b feature/my-new-feature`).
3. Commit your changes.
4. Push to your branch and open a Pull Request.

---

## 💖 Sponsor & Support

If you find this installer, packaging suite, and the Open HamClock Backend useful for your amateur radio shack, please consider supporting ongoing maintenance and development:

<div align="center">

<p align="center">
  <img src="docs/images/9m2pju-donation-qr.png" alt="DuitNow / Touch 'n Go QR Donation - 9M2PJU" width="220" />
  <br/>
  <sub><b>🇲🇾 DuitNow / Touch 'n Go (TNG) QR</b> (Scan with any Malaysian Banking / eWallet App)</sub>
</p>

<a href="https://buymeacoffee.com/9m2pju" target="_blank"><img src="https://img.shields.io/badge/Buy_Me_a_Coffee-9M2PJU-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee" /></a>
&nbsp;&nbsp;
<a href="https://wise.com/pay/me/faizulz13" target="_blank"><img src="https://img.shields.io/badge/Wise-faizulz13-163300?style=for-the-badge&logo=wise&logoColor=white" alt="Wise" /></a>

<br/><br/>

Your sponsorship helps cover server costs for the **Open HamClock Backend (OHB)** and ongoing packaging maintenance. Thank you for your support! 73 de 9M2PJU.

</div>

---

## 📄 License & Acknowledgments

- **Original Creator**: Elwood Downey, WB0OEW (Clear Sky Institute).
- **Backend & Community Maintenance**: The Open HamClock (OHB) amateur radio community.
- **License**: Custom Amateur Radio Non-Commercial License (see [`LICENSE`](file:///home/x/ESPHamClock/LICENSE)).

<div align="center">

*73 to all Radio Amateurs worldwide! de 9M2PJU*

</div>
