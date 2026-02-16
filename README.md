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
