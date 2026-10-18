#!/usr/bin/env bash
set -eu

TERMINAL="wezterm"

sessions="$(tmux list-sessions -F '#S' 2>/dev/null || true)"

if [ -z "${sessions}" ]; then
  notify-send -a "tmux" "No tmux sessions" \
    "There are currently no tmux sessions present."
  exit 0
fi

chosen="$(
  printf '%s\n' "$sessions" |
    rofi -dmenu -i -p 'tmux sessions:' -lines 10 \
      -kb-row-down "Down,Control+n,j" \
      -kb-row-up "Up,Control+p,k"
)"

[ -n "${chosen}" ] || exit 0

if [ -n "${TMUX-}" ]; then
  exec tmux switch-client -t "${chosen}"
fi

client_tty="$(
  tmux list-clients -F '#{client_tty} #{client_termname}' 2>/dev/null |
    awk '$2 ~ /^wezterm/ { print $1; exit }' || true
)"

if [ -n "${client_tty}" ]; then
  tmux switch-client -c "${client_tty}" -t "${chosen}"
  exit 0
fi

exec "${TERMINAL}" start -- tmux attach-session -t "${chosen}"
