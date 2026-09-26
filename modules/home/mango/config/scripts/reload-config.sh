#!/usr/bin/env bash

mmsg dispatch reload_config

pkill waybar
sleep 0.2
waybar &

notify-send \
  -a "MangoWM" \
  -u low \
  -t 3000 \
  -h string:x-canonical-private-synchronous:mango-reload \
  -i "$HOME/.config/mango/assets/mango.png" \
  "󱁽 Config Reloaded" \
  "Mango configuration reloaded"
