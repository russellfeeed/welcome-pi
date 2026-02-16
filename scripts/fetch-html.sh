#!/bin/bash

HTML_URL="https://bqidijvuhdscpfwnxlpb.supabase.co/functions/v1/serve-tv-page?id=3fe7061d-79db-4926-a0de-22b31772a282&format=raw"

TARGET="/home/russell/welcome/index.html"
TMP="/home/russell/welcome/index.tmp"

mkdir -p /home/russell/welcome

while true; do
  if curl -fsS "$HTML_URL" -o "$TMP"; then
    if [ -s "$TMP" ]; then
      mv "$TMP" "$TARGET"
    fi
  fi
  sleep 30
done
