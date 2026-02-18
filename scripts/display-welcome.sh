#!/bin/bash

PAIRING_CODE_FILE="/etc/welcome/pairing-code.txt"
BASE_URL="https://bqidijvuhdscpfwnxlpb.supabase.co/storage/v1/object/public/tv-pages"
WORKDIR="/tmp/welcome-pages"
DISPLAY_TIME=8   # seconds per page
SETUP_URL="https://lv-welcome-scr.feeed.com"

mkdir -p "$WORKDIR"

print_setup_instructions() {
  echo "Set up this TV at $SETUP_URL"
  if [[ -n "$PAIRING_CODE" ]]; then
    echo "Pairing code: $PAIRING_CODE"
  fi
}

generate_pairing_code() {
  local generated_code
  generated_code=$(tr -dc 'A-Z0-9' < /dev/urandom | head -c 6)

  mkdir -p "$(dirname "$PAIRING_CODE_FILE")"
  printf "%s\n" "$generated_code" > "$PAIRING_CODE_FILE"

  PAIRING_CODE="$generated_code"
  echo "Pairing code generated and saved to $PAIRING_CODE_FILE"
  print_setup_instructions
}

PAIRING_CODE=""
if [[ -f "$PAIRING_CODE_FILE" ]]; then
  PAIRING_CODE=$(tr -d '[:space:]' < "$PAIRING_CODE_FILE")
fi

if [[ -z "$PAIRING_CODE" ]]; then
  generate_pairing_code
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
    print_setup_instructions

    # Optional: display fallback image
    if [[ -f "/opt/welcome/default.png" ]]; then
      fbi -T 1 -d /dev/fb0 -noverbose -a /opt/welcome/default.png
    fi
    sleep 10
  fi

done

