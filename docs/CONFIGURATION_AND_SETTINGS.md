# ⚙️ HamClock Configuration & Settings Guide (v4.32)

HamClock stores all station settings, callsign profiles, and peripheral configurations in `~/.hamclock/hamclock.nvram` (or specified via the `-d` command-line option).

---

## 🛠️ Accessing Setup

You can access the Setup screens through any of these methods:
1. **Padlock Icon**: Click or touch the small lock icon on the main clock interface.
2. **Key / Shortcut**: Press `Spacebar` while focused on the clock window.
3. **Startup Countdown**: Run `hamclock` without `-k` to trigger the 10-second interactive countdown prompt (*"Click anywhere to enter Setup"*).
4. **Android App**: Touch anywhere on screen during the initial launch countdown or tap the setup button in the app overlay.

---

## ⌨️ On-Screen Modal Virtual Keyboard (v4.32)

HamClock v4.32 introduces a built-in touchscreen virtual keyboard. Whenever an input field (callsign, Wi-Fi SSID, password, DX cluster host, or coordinates) is selected on a touchscreen or web client:
- An on-screen QWERTY modal appears with Shift, Caps, Symbols, and Backspace keys.
- Allows full station configuration directly from touch tablets and kiosks without a physical keyboard attached.

---

## 📄 Setup Pages Overview

### Page 1: Station Identification & Geographic Coordinates
- **Call sign**: Your amateur radio callsign (displayed on the main clock banner).
- **DE Lat / Long / Grid**: Your home transmitter station location (e.g. `3.1390 N, 101.6869 E` or Maidenhead grid `OJ03ue`).
  - *Tip:* Use `-g` CLI option on launch for automatic IP-based geolocation initialization.
- **DX Lat / Long / Grid**: Target / partner station coordinates for great-circle path calculations, bearing, and distance.
- **Time Offsets**: Configure UTC vs. local timezone offsets, 12/24 hour display formats, and epoch counters.
- **GPS / NTP Time Sync**: Set preferred time sources (`pool.ntp.org`, local GPS NMEA serial, or `gpsd`).

---

### Page 2: Peripherals, Rig & Rotator Control
- **`Radio?`**:
  - `rigctld`: Enable Hamlib radio control (Default Port: `4532`).
  - `flrig`: Enable FLDIGI suite radio control (Default Port: `12345`).
- **`rotctld?`**: Enable Hamlib rotator azimuth/elevation control (Default Port: `4533`).
- **`BME280?` / Sensors**: Enable local ambient environmental telemetry (temperature, barometric pressure, humidity) via I2C sensors.
- **GPIO Pins / Relays**: Configure Raspberry Pi GPIO triggers for external hardware switching.

---

### Page 3: Display, Map Layers & Panes
- **Map Projections**:
  - `Mercator`: Classic cylindrical projection.
  - `Azimuthal`: Polar / great-circle projection centered directly on your home station (DE).
  - `Robinson / Mollweide`: Equal-area global maps.
- **Day / Night Terminator**: Select line style and night-side shading style (Civil, Nautical, Astronomical twilight).
- **Auroral Oval & Solar Terminator**: Enable real-time NOAA solar terminator and visual aurora oval predictions.
- **Borders & Grid Lines**: Toggle political boundaries, Maidenhead grid squares, and CQ/ITU zones.
- **Overlays**: Toggle active weather, live satellite tracks, and QSO pins.

---

### Page 4: Data Sources, DX Cluster & Telemetry Feeds
- **Backend Host**: Hardcoded to `ohb.hamclock.app:80` (Open HamClock Backend).
- **DX Cluster**:
  - Server hostname (e.g. `dxc.nc7j.com` or your local cluster node).
  - Port (default: `7300`).
  - Callsign and login credentials for auto-filtering.
- **ADIF Live Log Feed**:
  - UDP port for receiving broadcast QSOs from WSJT-X, N1MM Logger+, or Log4OM (default: `2237`).
- **Space Weather & Solar Images**:
  - Choose between SDO (Solar Dynamics Observatory) wavelength imagery (e.g. AIA 193Å, 304Å, 171Å) or magnetograms.
- **APRS Cluster & Tracking**:
  - Direct connection to APRS-IS servers for local station, repeater, and telemetry plotting.
- **High-Altitude Balloon (HAB) Feeds**:
  - Ingestion from Sondehub for live amateur radio and meteorological balloon tracking.
- **HamAlert Integration**:
  - Real-time alerts for DXCC, wanted prefixes, and band conditions.

---

## 📊 Configurable Panes in v4.32

HamClock features 4 configurable pane slots that can display any of the following live widgets:

1. **☀️ Space Weather & Solar Indices**: Real-time SFI, SSN, Kp, Ap, Solar Wind, X-ray Flux ($B_z$/$B_t$).
2. **📻 VOACAP Propagation Engine**: Real-time HF reliability predictions for 80m–10m bands between DE and DX.
3. **📡 DX Cluster / Band Spots**: Filtered live DX spots with one-click QSY transceiver tuning.
4. **🎈 Live High-Altitude Balloons (HAB)**: Sondehub balloon tracks with altitude and ascent rate telemetry.
5. **📍 Live APRS Cluster**: Nearby APRS packets, digipeater paths, and telemetry.
6. **🚨 HamAlert & DXCC Watchlist**: Custom spot notifications and wanted callsign alerts.
7. **🛰️ Satellite Tracker**: ISS, amateur satellites, pass predictions, Doppler shift, and rotator tracking.
8. **🔥 Wildfires & Fire Weather**: Live global active wildfire tracking and meteorological hazard alerts.
9. **🌊 Marine Warnings & WEFAX**: Coastal marine storm warnings and weather facsimile chart display.
10. **🌍 USGS Earthquakes**: Live seismic event tracking with epicenter map markers.
11. **🏝️ IOTA / SOTA / POTA Activations**: Real-time island and summit/park activations.
12. **🌦️ Local Environment Telemetry**: BME280 temperature, pressure, humidity, and dew point.

---

## 💾 Configuration Backup & Restore

HamClock preserves all user configuration in a single directory:
- Default location: `~/.hamclock/`
- Configuration file: `~/.hamclock/hamclock.nvram`

### Linux / macOS:
```bash
# Backup
cp ~/.hamclock/hamclock.nvram ~/hamclock_backup.nvram

# Restore
cp ~/hamclock_backup.nvram ~/.hamclock/hamclock.nvram
```

### Android App:
Use the built-in **Backup / Restore (SAF)** in app settings to export or import complete configuration `.zip` archives.
