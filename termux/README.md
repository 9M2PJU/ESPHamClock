# HamClock for Android (Termux)

> 💡 **Looking for the Official Android App?**  
> An official standalone **Android App (.apk)** is available with 100% native embedded C++ engine (no Termux or command line required).  
> 👉 [**Download Android APK from GitHub Releases**](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases)

This directory contains standalone installers, build helpers, and service scripts to build and run **HamClock** natively on Android devices via **Termux**, without altering any upstream source code.

<p align="center">
  <img src="../docs/images/9m2pju-hamclock-android.jpg" alt="HamClock running on Android Phone using Termux with Fully Kiosk Browser" width="600" />
</p>

## Quick One-Liner Install

Open Termux on Android and paste:

```bash
pkg update -y && pkg install -y curl && bash -c "$(curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/termux/install.sh)"
```

## Files in this Directory

| File | Description |
| :--- | :--- |
| [`install.sh`](install.sh) | Full-featured interactive installer for Termux (packages, build, path setup) |
| [`build.sh`](build.sh) | Standalone build helper passing `CXX=clang++` to GNU make |
| [`disable-fdsan.c`](disable-fdsan.c) | Runtime constructor to disable Android Bionic libc `fdsan` socket aborts |
| [`patches/`](patches/) | Standalone patches applied only during the Termux build |
| [`hamclock-service.sh`](hamclock-service.sh) | 24/7 background launcher with automatic `termux-wake-lock` |

## How It Works

HamClock is built using Clang with `-D_WEB_ONLY` target (e.g. `hamclock-web-1600x960`), enabling it to run as a high-performance, standalone web daemon. 

### Accessing the Touch Interface
- **Interactive Touch Screen**: `http://localhost:8081/live.html` (Port 8081)
- **LAN Remote Access**: `http://<PHONE-IP>:8081/live.html`
- **Read-Only Monitor Screen**: `http://localhost:8082/live.html` (Port 8082)
- **Backend RESTful API**: `http://localhost:8080/` (Port 8080)

### Best Full-Screen & Fit-to-Screen Display
1. Start HamClock: `termux-wake-lock && hamclock -k &`
2. Install [**Fully Kiosk Browser**](https://play.google.com/store/apps/details?id=de.ozerov.fully&hl=en) from Google Play.
3. Set Start URL to `http://localhost:8081/live.html` for edge-to-edge borderless display with automatic screen fitting and keep-screen-on support.
