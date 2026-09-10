# 📦 Canonical Snap Package Guide

**9M2PJU HamClock (Open HamClock - OHB Edition)** can be published and installed directly from Canonical's **Snap Store** across Ubuntu, Debian, Fedora, Arch Linux, openSUSE, and Manjaro.

---

## ⚡ User Installation

The snap is published on the `stable` channel:

```bash
# Install from the stable channel
sudo snap install hamclock

# Launch HamClock
hamclock

# Launch with specific resolution
hamclock -r 1600x960
```

---

## 🛠️ Maintainer Guide: Registering & Publishing to Snap Store

To publish `hamclock` under your Canonical developer account (**9M2PJU**):

### 1. Register the Name on Snapcraft
Visit [snapcraft.io/register-snap](https://snapcraft.io/register-snap) or run:
```bash
snapcraft login
snapcraft register hamclock
```

### 2. Generate Store Credentials for GitHub Actions
Export a secure deployment token:
```bash
snapcraft export-login --snaps=hamclock --channels=edge,beta,candidate,stable snapcraft.token
```

### 3. Add to GitHub Secrets
1. Go to your repository: **Settings $\to$ Secrets and variables $\to$ Actions**.
2. Click **New repository secret**.
3. Name: `SNAPCRAFT_STORE_CREDENTIALS`
4. Value: Paste the contents of `snapcraft.token`.

Every new release tag (e.g. `v4.32`) pushed to GitHub will automatically compile multi-architecture snaps (`amd64`, `arm64`, `armhf`) and release them to the Snap Store `stable` channel!
