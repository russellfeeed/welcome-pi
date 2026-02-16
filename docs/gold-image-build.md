# Gold Image Build

Use this checklist when preparing a reusable Raspberry Pi image:

1. Install required runtime packages (`curl`, `fbi`, and `systemd` defaults).
2. Copy this repository to `/opt/welcome`.
3. Install service files from `systemd/` into `/etc/systemd/system/`.
4. Place environment-specific pairing code at `/etc/welcome/pairing-code.txt`.
5. Enable services:
   - `sudo systemctl enable welcome-html-fetch.service`
   - `sudo systemctl enable welcome-framebuffer.service`
6. Reboot and validate the display loop.
