# welcome-pi

Utilities and service definitions for a Raspberry Pi welcome display system.

## Repository layout

- `scripts/` – shell scripts for fetching content, displaying pages, and reloading services.
- `systemd/` – service units for background execution.
- `config/` – sample configuration snippets for provisioning.
- `docs/` – architecture notes, build steps, and version history.

## Quick start

1. Copy the repository to the target device (for example, `/opt/welcome`).
2. Install the unit files from `systemd/` to `/etc/systemd/system/`.
3. Add a pairing code file at `/etc/welcome/pairing-code.txt`.
4. Run `scripts/reload-welcome.sh` and then enable services with `systemctl enable`.


# Welcome Pi

**OTA-managed HDMI welcome screen for holiday lets**

Built for **The Barn @ Cob Tree Cottage**.

---

## 🔹 Features

- Direct framebuffer rendering (no X, no Chromium)
- OTA content from Supabase
- Pairing-code based deployment
- Multi-page rotation
- Fallback image support
- Systemd-managed services
- Survives power cuts

---

## 🔹 Architecture

```
Supabase Storage
        ↓
Raspberry Pi (curl)
        ↓
Framebuffer (fbi)
        ↓
HDMI TV
```

---

## 🔹 Installation (Fresh Image)

### 1. Flash OS
Flash **Raspberry Pi OS Lite (64-bit)**.

### 2. Enable SSH
Enable SSH during imaging or via:

```
sudo raspi-config
```

### 3. Clone Repository

```
git clone https://github.com/russellfeeed/welcome-pi.git
cd welcome-pi
```

### 4. Install Dependencies

```
sudo apt update
sudo apt install -y fbi curl
```

### 5. Copy Scripts

```
sudo cp scripts/* /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh
```

### 6. Install systemd Services

```
sudo cp systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable welcome-framebuffer.service
sudo systemctl enable welcome-html-fetch.service
sudo systemctl start welcome-framebuffer.service
sudo systemctl start welcome-html-fetch.service
```

### 7. Add Pairing Code

```
sudo mkdir -p /etc/welcome
sudo nano /etc/welcome/pairing-code.txt
```

Add your unique pairing code inside this file.

---

## 🔹 Pairing Model

Each device is paired via:

```
/etc/welcome/pairing-code.txt
```

Content is pulled from:

```
https://<supabase>/tv-pages/<pairing>/page1.png
```

Multiple pages are supported:

```
page1.png
page2.png
page3.png
...
```

---

## 🔹 Recovery Behaviour

- If no pages exist → fallback image shown  
- If pairing code missing or empty → device auto-generates a new code and saves it to `/etc/welcome/pairing-code.txt`  
- If no pages are fetched → setup instructions are logged with `https://lv-welcome-scr.feeed.com`  
- Infinite loop for resilience  
- Cache busting on each request  
- Survives power loss and auto-recovers via systemd  

---

## 📺 Designed For

Holiday lets, serviced accommodation, and OTA-managed guest welcome screens.

---

## 🏷 Version

Initial release for The Barn @ Cob Tree Cottage.
