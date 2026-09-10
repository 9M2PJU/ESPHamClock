# 9M2PJU HamClock (Open HamClock - OHB Edition) — Project Progress & Reference Notes

**Repository:** `https://github.com/9M2PJU/9M2PJU-HamClock-Installer`  
**Maintainer:** 9M2PJU (`9m2pju@hamradio.my` | [HamRadio.my](https://hamradio.my))  
**Backend:** Open HamClock Backend (`ohb.hamclock.app:80`)  
**Version:** `4.32`

---

## 1. Project Overview & Architecture
This project is the definitive open-source installer, multi-platform packaging suite, and web deployment for **HamClock (v4.32)**, configured natively to connect with the **Open HamClock Backend (OHB)** without `/etc/hosts` workarounds.

### Supported Platforms & Targets:
- **1-Line Universal Installer (`install.sh`)**: Linux (Debian, Ubuntu, RPi OS, Arch, Fedora), macOS (Intel/Apple Silicon), and FreeBSD.
- **Android via Termux (`termux/install.sh`)**: Low-power (<3W) touch clock display using Termux + Fully Kiosk Browser.
- **Windows (`scripts/install.ps1`)**: Windows 10/11 with WSLg GUI window or Docker Desktop.
- **Native Windows Executable (MinGW-w64 cross-compile)**: Statically linked PE32+ `.exe` running the `_WEB_ONLY` backend natively on Windows 10/11 without WSL, Docker, or X11. Built from Linux with `make mingw-all-web`.
- **Docker Multi-Arch Container (`ghcr.io/9m2pju/9m2pju-hamclock-docker:latest`)**: `linux/amd64`, `linux/arm64`, `linux/arm/v7`.
- **Arch User Repository (`hamclock-git`)**: Native AUR package on `aur.archlinux.org`.
- **Pre-Built Linux Packages**: Multi-arch `.deb`, `.rpm`, `.AppImage` on GitHub Releases.
- **App Store Submissions**:
  - **Snap Store**: Snapcraft package descriptor (`hamclock`) configured and published.

---

## 2. Key Accomplishments & Changes Summary

### A. Author & Contact Standardization
- Header comments added across all 14 installation/build/service scripts:
  - `Author: 9M2PJU (https://hamradio.my)`
  - `Contact / Support Email: 9m2pju@hamradio.my`
- Synchronized maintainer contact info in `aur/PKGBUILD`, `snap/snapcraft.yaml`, `packaging/build-deb.sh`, and `packaging/hamclock.spec`.

### B. Docker Container Renaming
- Renamed GitHub Container Registry image to:
  `ghcr.io/9m2pju/9m2pju-hamclock-docker:latest`
- Updated all occurrences across `.github/workflows/docker-publish.yml`, `docker-compose.yml`, `install-docker.sh`, `scripts/install.ps1`, and all markdown documentation.
- Deleted obsolete legacy packages (`9m2pju-esphamclock-installer` and `9m2pju-hamclock-installer`) via GitHub API.

### C. Android & Termux Optimizations
- **Photo Embedded**: Added verified real-world photo (`docs/images/9m2pju-hamclock-android.jpg`) showing HamClock running on Android via Termux + Fully Kiosk Browser.
- **Battery Saver Instructions**: Documented setting Termux battery mode to **"Unrestricted"** and running `termux-wake-lock && hamclock -k &`.
- **Browser Focus**: Standardized documentation exclusively on **Fully Kiosk Browser** as the best auto-fit fullscreen experience for Android.

### D. Package Manager vs 1-Liner Resolution Handling
- **1-Liner**: Interactive resolution menu or environment variable (`TARGET=1600x960`) compiling a single chosen binary.
- **Package Managers (`yay` / AUR, `.deb`, `.rpm`, `Snap`)**:
  - Non-interactive (unattended) build compiling all 6 resolutions (`800x480`, `1600x960`, `2400x1440`, `3200x1920`, `web-800x480`, `web-1600x960`) into `/usr/lib/hamclock/`.
  - Runtime launcher switching via `hamclock -r 1600x960`, `hamclock-1600x960`, or `export HAMCLOCK_RES=1600x960`.
- Documented across `README.md`, `docs/INSTALLATION.md`, and `docs/index.html`.

### E. Packaging & GitHub Actions Enhancements
- Created `packaging/build-in-container.sh` to cleanly build multi-arch binaries inside Docker containers without YAML quoting conflicts.
- Fixed GNU linker library ordering (`LIBS="-lpthread -larduino -lzlib-hc -lws -lX11"`) for Debian Bookworm containers.
- Configured multi-arch Snapcraft builds for `amd64`, `arm64`, and `armhf` on `amd64` runners.

### F. Sponsorship & Funding
- Created `.github/FUNDING.yml`:
  ```yaml
  github: [9M2PJU]
  buy_me_a_coffee: 9m2pju
  custom: ['https://wise.com/pay/me/faizulz13']
  ```
- Added sponsor badges and interactive support sections to `README.md` and GitHub Pages (`docs/index.html`).

### G. GitHub Pages Layout Repairs
- Fixed mobile responsiveness and flex wrapping in install tabs (`.install-tabs`).
- Removed out-of-box floating badges to keep the UI clean and compartmentalized.
- Added dynamic interactive command hints and sponsor anchor navigation.

### H. Auto-Start on Login (All OSes) — Added 2026-08-22
- Added interactive auto-start prompt (step `[5/5]`) to `install.sh` and `scripts/install.sh`.
- Per-OS support:
  - **Linux**: XDG autostart (`~/.config/autostart/hamclock.desktop`) or systemd user service (`~/.config/systemd/user/hamclock.service` with `Restart=on-failure`).
  - **macOS**: launchd LaunchAgent (`~/Library/LaunchAgents/local.hamclock.plist` with `KeepAlive=true`).
  - **FreeBSD**: XDG autostart or `~/.xinitrc` (for `startx` sessions).
  - **Android (Termux)**: Uses Termux:Boot (documented separately in `docs/ANDROID.md`).
- Non-interactive override via `AUTOSTART` env var: `none`, `xdg`, `systemd`, `launchd`, `xinitrc` (or numeric `1`/`2`/`3`).
- Same TTY/no-TTY fallback as resolution prompt; `curl | bash` won't hang.
- Final summary prints `Auto-start:` line showing chosen mode.
- Step labels renumbered from `[1/4]`-`[4/4]` to `[1/5]`-`[5/5]`.

### I. ASCII Art Banners in Installer — Added 2026-08-22
- **Startup banner**: "HamClock" ASCII art (cyan, figlet small font) followed by "9M2PJU Installer - OHB Edition".
- **Completion banner**: "73 DE 9M2PJU" ASCII art (green, figlet small font) followed by cyan-bordered info box with install details (target, binary path, auto-start mode, backend).
- ASCII art generated with `figlet -f small` and verified to render correctly.

### J. Post-Install Run & Issue Reporting — Added 2026-08-22
- After successful install, script prints how to run HamClock (`hamclock`) and links to GitHub Issues (`https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues`).
- Updated `README.md`: added "Running HamClock" and "Support & Reporting Issues" sections.
- Updated `docs/INSTALLATION.md`: added "Running HamClock After Install" and "Reporting Issues" subsections.
- Updated `docs/index.html`: added "Report Issues" link in footer, updated native hint to mention running hamclock and reporting issues.

### K. README ASCII Art Removal — Added 2026-08-22
- Removed 4 ASCII art blocks from `README.md` (HamClock logo, memorial box, repository tree, "73" sign-off).
- Converted memorial box to markdown blockquote, repository tree to bullet list, "73" sign-off to italic text.
- ASCII art kept only in the installer script (`install.sh`) where it renders in terminal.

### L. Documentation Fixes — Added 2026-08-22
- Fixed `docs/INSTALLATION.md` TOC/section numbering mismatch (was missing section 7 "Package Managers & Pre-Built Distributions", causing duplicate #9 for FreeBSD).
- Fixed broken pipe syntax in all non-interactive examples: `TARGET=... curl | bash` (wrong) changed to `curl ... | TARGET=... bash` (correct) across `README.md`, `docs/INSTALLATION.md`, `docs/index.html`.
- Split headless systemd service into its own section (#12) separate from desktop autostart (#11).

### M. Snap Package (Existing, Verified) — Verified 2026-08-22
- Snap package `hamclock` (v4.32, publisher `faizul`) installed and verified on CachyOS.
- Built only with `1600x960` target (binary is `hamclock-1600x960`).
- Command at `/var/lib/snapd/snap/bin/hamclock` (on PATH after `hash -r` or new terminal).
- Must run from graphical session (X11 app, needs `DISPLAY` set).

### N. Native Windows Executable (MinGW-w64 Cross-Compile) - Added 2026-08-22
- **Goal**: Produce a native Windows `.exe` that runs the HamClock web-only backend without WSL, Docker, X11, or any Linux subsystem.
- **Toolchain**: MinGW-w64 (`x86_64-w64-mingw32-g++` 16.2.0), installed via `mingw-w64-gcc` on Arch Linux.
- **Build targets**: `make mingw-web-800x480`, `make mingw-web-1600x960`, `make mingw-web-2400x1440`, `make mingw-web-3200x1920`, `make mingw-all-web`, `make mingw-clean`.
- **Output**: Statically linked PE32+ executables (`mingw-web-*.exe`, ~14 MB each) that only depend on Windows system DLLs (KERNEL32, WS2_32, Windows Universal CRT). No MinGW runtime DLLs need to be shipped.
- **Runtime**: Run the `.exe` on Windows 10/11, then open `http://localhost:8081/live.html` in any browser.
- **Compatibility layer** (`include/win32_compat.h`):
  - Winsock initialization (`WSAStartup` via `hc_winsock_init()`).
  - POSIX function shims: `gmtime_r`, `localtime_r`, `timegm`, `strcasestr`, `strsep`, `mmap`/`munmap`, `mkdir`, `pipe`, `flock`, `getuid`/`getgid`/`geteuid`/`fchown`/`chown`, `wait`/`waitpid`, `setenv`.
  - Windows macro undefs: `INPUT`, `OUTPUT`, `IN`, `OUT` (conflict with Arduino and P13.h identifiers).
  - `_USE_MATH_DEFINES` for `M_PI` and other math constants.
- **Stubbed/disabled features on Windows** (rely on POSIX/Linux APIs):
  - I2C sensors (BME280, LTR329, MCP23X17): stubbed, return no data.
  - NMEA GPS serial input: stubbed, returns no data.
  - OTA self-update (download and rebuild from source): stubbed, returns failure.
  - CPU temperature: not available (Linux sysfs and macOS powermetrics only).
  - Display brightness control: not available (Linux DSI/backlight only).
  - WiFi scanning (SSID, RSSI, channel): not available (Linux wireless ioctls only).
  - System reboot/shutdown from menu: not available.
- **Files changed**:
  - New: `include/win32_compat.h`.
  - Build system: `Makefile`, `ArduinoLib/Makefile`, `zlib-hc/Makefile` (overridable `AR`/`RANLIB` for cross-compilation; `wsServer/Makefile` already had overridable `AR`).
  - Headers: `include/HamClock.h`, `ArduinoLib/Arduino.h`, `ArduinoLib/WiFiClient.h`, `ArduinoLib/WiFiUdp.h`, `ArduinoLib/Wire.h`, `wsServer/include/ws.h`.
  - Sources: `ArduinoLib/Arduino.cpp`, `ArduinoLib/WiFiClient.cpp`, `ArduinoLib/WiFiServer.cpp`, `ArduinoLib/WiFiUdp.cpp`, `ArduinoLib/Wire.cpp`, `ArduinoLib/i2cdriver.cpp`, `ArduinoLib/ESP8266WiFi.cpp`, `ArduinoLib/ESP8266httpUpdate.cpp`, `ArduinoLib/Adafruit_RA8875.cpp`, `ArduinoLib/EEPROM.cpp`, `src/nmea.cpp`, `src/fsfree.cpp`, `src/mapmanage.cpp`, `src/ESPHamClock.cpp`, `src/brightness.cpp`, `src/liveweb.cpp`, `wsServer/src/ws.cpp`.
  - Docs: `docs/WINDOWS.md` (Method 0), `README.md` (Windows section + build matrix), `docs/index.html` (Windows .exe tab), `PROGRESS.md`.
- **Verification**: All four resolution variants built successfully. `file` confirms PE32+ executable for MS Windows, x86-64. Native Linux build (`make hamclock-web-800x480`) verified still works after changes.
- **Key decisions**:
  - Static linking (`-static`) chosen so users do not need to ship MinGW runtime DLLs alongside the `.exe`.
  - Windows-specific changes guarded with `_WIN32` to preserve existing Linux/macOS/FreeBSD build behavior.
  - NMEA stubs in `src/nmea.cpp` only define functions not also defined in `src/setup.cpp` (avoids duplicate-definition link errors).
  - Library link order fixed: object files first, then `-larduino -lzlib-hc -lws -lpthread -lws2_32 -lwinpthread` (Winsock symbols resolved after the objects that reference them).

---

## 3. Important URLs & References
- **Live Website**: [https://hamclock.hamradio.my/](https://hamclock.hamradio.my/)
- **Backend**: [https://ohb.hamclock.app](https://ohb.hamclock.app)
- **GitHub Repo**: [https://github.com/9M2PJU/9M2PJU-HamClock-Installer](https://github.com/9M2PJU/9M2PJU-HamClock-Installer)
- **Android APK Releases**: [https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases](https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases)
- **AUR Package**: [https://aur.archlinux.org/packages/hamclock-git](https://aur.archlinux.org/packages/hamclock-git)
- **Snapcraft**: [https://snapcraft.io/hamclock](https://snapcraft.io/hamclock)
- **Buy Me a Coffee**: [https://buymeacoffee.com/9m2pju](https://buymeacoffee.com/9m2pju)
- **Wise**: [https://wise.com/pay/me/faizulz13](https://wise.com/pay/me/faizulz13)
- **GitHub Issues**: [https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues](https://github.com/9M2PJU/9M2PJU-HamClock-Installer/issues)

---

## 4. Session Log

### 2026-08-30 Session
- **Goal**: Update documentation, landing pages, and guides across the project to add the official standalone Android App (.apk) download links (`https://github.com/9M2PJU/9M2PJU-HamClock-Android-Releases/releases`) and add the DuitNow/TNG donation QR code to the sponsor section.
- **Files updated**:
  - `docs/images/9m2pju-donation-qr.png`: Added Malaysian National DuitNow / Touch 'n Go QR donation image.
  - `docs/index.html`: Added Android App navigation link, hero badge, install tab (`apk`), updated feature grid, enhanced Android showcase section with download buttons, highlights, footer link, and DuitNow / TNG QR donation card in the sponsor section.
  - `README.md`: Updated Android badge, table of contents, Quick Install section (APK + Termux), pre-built packages table, expanded Android support section, and embedded donation QR code in the sponsor section.
  - `docs/ANDROID.md`: Restructured into Method 1 (Official Standalone APK - Recommended) and Method 2 (Termux & Fully Kiosk Browser CLI).
  - `docs/INSTALLATION.md`: Updated TOC and Section 4 to detail both Native APK and Termux methods.
  - `termux/README.md`: Added top callout pointing to official standalone Android APK releases.
  - `PROGRESS.md`: Updated references and session log.

### 2026-08-22 Session
- **Commit**: `2324b5c` - "feat(install): add auto-start prompt, ASCII banners, and run/issue instructions"
- **Files changed**: `install.sh`, `scripts/install.sh`, `README.md`, `docs/INSTALLATION.md`, `docs/index.html`
- **CI builds**: Both passed (Deploy GitHub Pages: 19s, Build and Publish Docker Images: 32m54s)
- **Key decisions**:
  - Auto-start prompt defaults to "none" (opt-in, not opt-out).
  - `AUTOSTART` env var must be set for `bash` (right side of pipe), not `curl`.
  - ASCII art kept in installer script (renders in terminal) but removed from README (doesn't render well on GitHub).
  - Completion banner uses "73 DE 9M2PJU" (ham radio sign-off) instead of generic "DONE!".
  - `scripts/install.sh` is a duplicate of root `install.sh` and must be kept in sync.
