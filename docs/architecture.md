# Architecture

This repository is organized into a small set of operational layers:

- `scripts/`: runtime scripts for fetching and displaying welcome content.
- `systemd/`: unit files that run and supervise the scripts.
- `config/`: example and template configuration values used during provisioning.
- `docs/`: high-level operational and lifecycle documentation.

## Runtime flow

1. `welcome-html-fetch.service` continuously downloads fresh HTML into the local content directory.
2. `welcome-framebuffer.service` cycles through image-based pages tied to the configured pairing code.
3. `reload-welcome.sh` helps operators reload systemd units and restart services after changes.
