#!/usr/bin/env bash

if pgrep -x wl-screenrec >/dev/null; then
    pkill -SIGINT wl-screenrec &&
        notify-send -u normal -t 4000 \
        "Recording Saved" \
        "Video written to $HOME/Videos"
else
    FILE="$HOME/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4"

    REGION=$(slurp) || exit 0

    wl-screenrec --geometry "$REGION" -f "$FILE" &

    notify-send -u critical -t 3000 \
        "Recording in Progress" \
        "Press Shift+Print again to stop"
fi
