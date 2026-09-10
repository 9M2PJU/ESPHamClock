# 🪟 Windows Installation & User Guide

**9M2PJU HamClock (Open HamClock - OHB Edition)** can be run effortlessly on Windows 10 and Windows 11 using several convenient options.

---

## 🖥️ Method 0: Native Windows Executable (No WSL/Docker required)

HamClock can be cross-compiled to a native Windows `.exe` that runs the web-only backend without WSL, Docker, or any Linux subsystem. The executable serves the dashboard over HTTP/WebSocket; you view it in any browser.

### Option A: Download Pre-Built .exe

Download the latest `mingw-web-*.exe` from the [GitHub Releases page](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/releases). Four resolutions are available (800x480, 1600x960, 2400x1440, 3200x1920). Run the `.exe` from Command Prompt or PowerShell, then open `http://localhost:8081/live.html` in any browser. No installation required.

### Option B: Building (from Linux with MinGW-w64)

Install the MinGW-w64 cross-compiler toolchain, then build:

```bash
# Arch Linux:
sudo pacman -S mingw-w64-gcc

# Debian/Ubuntu:
sudo apt install g++-mingw-w64-x86-64

# Build all four resolution variants:
make mingw-all-web

# Or build a single resolution:
make mingw-web-800x480
make mingw-web-1600x960
make mingw-web-2400x1440
make mingw-web-3200x1920
```

The resulting `mingw-web-*.exe` files are statically linked PE32+ executables that only depend on Windows system DLLs (KERNEL32, WS2_32, and the Windows Universal CRT). No additional runtime DLLs are needed.

### Running on Windows

Copy the `.exe` to your Windows machine and run it from a Command Prompt or PowerShell:

```
hamclock-web-800x480.exe
```

Then open your browser to:
- **Interactive Live Mirror (Read/Write)**: `http://localhost:8081/live.html`
- **Read-Only Monitor**: `http://localhost:8082/live.html`
- **RESTful Snapshot PNG**: `http://localhost:8080/live.png`

### Limitations of the native Windows build

The native Windows build uses the `_WEB_ONLY` backend. The following features are unavailable or stubbed on Windows because they rely on Linux/POSIX-only APIs:

- **I2C sensors** (BME280, LTR329, MCP23X17): stubbed, return no data
- **NMEA GPS** serial input: stubbed, returns no data
- **OTA self-update** (download and rebuild from source): stubbed, returns failure
- **CPU temperature**: not available (Linux/sysfs and macOS powermetrics only)
- **Display brightness control**: not available (Linux DSI/backlight only)
- **WiFi scanning** (SSID, RSSI, channel): not available (Linux wireless ioctls only)
- **System reboot/shutdown** from the menu: not available

All web dashboard features (clock display, maps, propagation, DX cluster, weather, satellites, etc.) work normally since they only require HTTP/WebSocket networking.

---

## ⚡ Method 1: 1-Click Automated PowerShell Installer (Fastest)

Open **PowerShell** (press `Win + X`, then click **Terminal** or **PowerShell**) and paste:

```powershell
irm https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/scripts/install.ps1 | iex
```

The script automatically checks your environment (Docker Desktop or WSL2), sets up HamClock, and opens the live dashboard in your browser.

---

## 🐧 Method 2: Native Windows Desktop App via WSL2 / WSLg (Recommended for GUI)

On modern Windows 10 (Build 19044+) and Windows 11, **WSLg** provides seamless native graphical window rendering on your Windows desktop.

### 1. Enable WSL (If not already installed)
In PowerShell as Administrator:
```powershell
wsl --install
```

### 2. Install HamClock in WSL
Open **Ubuntu** or your WSL terminal and run:
```bash
curl -fsSL https://raw.githubusercontent.com/9M2PJU/9M2PJU-HamClock-Installer/main/install.sh | bash
```

### 3. Launch from Windows
You can launch HamClock directly from Windows PowerShell or the Run dialog (`Win + R`):
```powershell
wsl -e ~/.local/bin/hamclock -r 1600x960
```
A floating native window appears seamlessly on your Windows desktop with high-DPI scaling and hardware acceleration.

---

## 🐳 Method 3: Docker Desktop for Windows

If you use **Docker Desktop**, run the container with persistent configuration:

```powershell
docker run -d `
  --name hamclock `
  --restart unless-stopped `
  -p 8080:8080 `
  -p 8081:8081 `
  -p 8082:8082 `
  -v "$env:USERPROFILE\.hamclock:/root/.hamclock" `
  ghcr.io/9m2pju/9m2pju-hamclock-docker:latest
```

### Accessing the Web Dashboard:
- **Interactive Live Mirror (Read/Write)**: Open Microsoft Edge or Chrome and navigate to:
  ```
  http://localhost:8081/live.html
  ```
- **Read-Only Monitor**: `http://localhost:8082/live.html`
- **RESTful Snapshot PNG**: `http://localhost:8080/live.png`

---

## 🚀 Starting HamClock Automatically on Windows Boot

### For Docker Desktop:
Docker Desktop automatically restarts the container on boot when `--restart unless-stopped` is specified.

### For WSL2 Background Service:
Create a shortcut in your Windows Startup folder (`Win + R` $\to$ `shell:startup`):
- **Target**: `wsl.exe -d Ubuntu -e ~/.local/bin/hamclock -r 1600x960`
