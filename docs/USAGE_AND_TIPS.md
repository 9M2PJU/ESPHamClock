# 💡 HamClock Usage Guide, Tips & Shortcuts (v4.32)

Learn how to get the most out of your **HamClock** dashboard in the shack.

---

## 🖱️ Interactive Touch & Mouse Controls

Every element on the HamClock screen is interactive:

| Element | Interaction | Action |
| :--- | :--- | :--- |
| **World Map** | Click anywhere | Instantly sets target DX location, computes short-path (SP) / long-path (LP) bearing, distance, and turns rotator (if Auto enabled). |
| **Pane Boxes (1 to 4)** | Tap top title | Opens selector menu to change what is displayed in that box (Space Weather, DX Spots, APRS, HAB, HamAlert, Satellites, VOACAP, etc.). |
| **View Button (Map)** | Click `View` | Cycles map styles (Core, Topographic, Street, Night Light, Weather). |
| **Borders Button** | Click `Borders` | Cycles political boundaries, CQ Zones, ITU Zones, and Maidenhead grids. |
| **Callsign Banner** | Click Callsign | Opens on-screen virtual keyboard to edit callsign or broadcast message. |
| **DX Spot / HamAlert Rows** | Click a spot | Displays DX details and prompts to QSY / tune transceiver (via `rigctld` / `flrig`). |
| **HAB Balloon Marker** | Click marker | Shows telemetry popup: balloon callsign, altitude (m/ft), ascent rate, and ground speed. |
| **APRS Station Marker** | Click marker | Displays packet comment, path, and last heard timestamp. |
| **QR Code Icon** | Click QR | Generates on-screen QR code for instant mobile browsing of news feeds or station links. |

---

## ⌨️ Command Line Flags Reference

```text
Usage: hamclock [options]

  -k           Skip initial setup countdown and boot directly to clock.
  -g           Auto-initialize DE station location using IP-based geolocation.
  -b <host:port> Override default backend server (default: ohb.hamclock.app:80).
  -f on|off    Force initial fullscreen display mode.
  -d <dir>     Specify working and NVRAM directory (default: ~/.hamclock).
  -e <port>    RESTful web server port (default: 8080).
  -w <port>    Read-write interactive live web server port (default: 8081).
  -r <port>    Read-only live web server port (default: 8082).
  -t <percent> Throttle maximum CPU usage (e.g. -t 50).
  -m           Demo mode.
  -v           Show version information.
  -h           Show comprehensive help.
```

---

## 🌐 Remote Web Access

Connect to HamClock from any browser on your network:

- **Interactive Canvas (Read/Write)**: `http://<hamclock-ip>:8081/live.html`  
  Provides a fully interactive, touch/click-enabled web interface with sub-second WebSocket updates. Perfect for iPads and tablets on your operating desk!
- **Monitoring Screen (Read-Only)**: `http://<hamclock-ip>:8082/live.html`  
  Great for secondary displays, clubrooms, and public web dashboards without risk of accidental touch clicks.
- **RESTful Snapshot**: `http://<hamclock-ip>:8080/live.png`  
  Provides a real-time full-resolution PNG snapshot.

---

## 🎈 Live High-Altitude Balloon (HAB) Telemetry

1. Tap any pane title and choose **HAB**.
2. HamClock connects via the OHB Sondehub feed to track active meteorological and amateur radio balloon launches.
3. Active balloons are rendered with dedicated flight paths and payload icons on the world map.
4. Click any balloon on the map to inspect live altitude, ascent rate, telemetry frequencies, and burst predictions.

---

## 📡 Live APRS Cluster Integration

1. Tap any pane title and choose **APRS**.
2. Real-time APRS packets received in your region are displayed in the pane list and plotted onto the world map.
3. Filter by station callsign, tactical call, or distance from your home station (DE).

---

## 🛰️ Satellite Tracking & Pass Predictions

1. Tap a pane box and select **Satellites**.
2. Select your desired satellite from the active catalog (e.g. `ISS`, `SO-50`, `AO-91`, `RS-44`, `IO-117`).
3. HamClock automatically downloads current two-line element (TLE) orbital data from the OHB backend.
4. The pane shows:
   - Next pass rise time, azimuth, and duration.
   - Real-time elevation and Doppler shift transmit/receive frequencies.
   - Ground track footprint live on the world map.
5. If rotator control is enabled, HamClock tracks the satellite across the sky in real-time!
