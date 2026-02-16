#!/bin/bash
set -e

SERVICES=(
  welcome-html-fetch.service
  welcome-framebuffer.service
)

echo "Reloading systemd units..."
sudo systemctl daemon-reload

for SERVICE in "${SERVICES[@]}"; do
  echo "Restarting $SERVICE..."
  sudo systemctl restart "$SERVICE"
  sudo systemctl --no-pager status "$SERVICE"
  echo
done

