#!/bin/bash

PAIRING_CODE_FILE="/etc/welcome/pairing-code.txt"
BASE_URL="https://bqidijvuhdscpfwnxlpb.supabase.co/storage/v1/object/public/tv-pages"
WORKDIR="/tmp/welcome-pages"
DISPLAY_TIME=8   # seconds per page

mkdir -p "$WORKDIR"

# Read pairing code
if [[ ! -f "$PAIRING_CODE_FILE" ]]; then
  echo "Pairing code not found"
  sleep 10
  exit 1
fi

PAIRING_CODE=$(cat "$PAIRING_CODE_FILE" | tr -d '[:space:]')

if [[ -z "$PAIRING_CODE" ]]; then
  echo "Empty pairing code"
  sleep 10
  exit 1
fi

while true; do
  PAGE=1
  FOUND_ANY=false

  while true; do
    IMAGE_URL="$BASE_URL/$PAIRING_CODE/page${PAGE}.png?ts=$(date +%s)"
    LOCAL_IMAGE="$WORKDIR/page${PAGE}.png"

    # Try to fetch image
    HTTP_CODE=$(curl -s -L -o "$LOCAL_IMAGE" -w "%{http_code}" "$IMAGE_URL")

    if [[ "$HTTP_CODE" != "200" ]]; then
      rm -f "$LOCAL_IMAGE"
      break
    fi

    FOUND_ANY=true

    # Display image
    fbi -T 1 -d /dev/fb0 -noverbose -a "$LOCAL_IMAGE"
    sleep "$DISPLAY_TIME"

    PAGE=$((PAGE + 1))
  done

  if [[ "$FOUND_ANY" = false ]]; then
    # Optional: display fallback image
    if [[ -f "/opt/welcome/default.png" ]]; then
      fbi -T 1 -d /dev/fb0 -noverbose -a /opt/welcome/default.png
    fi
    sleep 10
  fi

done

