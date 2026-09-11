#!/usr/bin/env bash
set -euo pipefail

layouts=(
  center_tile
  deck
  dwindle
  fair
  grid
  monocle
  right_tile
  scroller
  tile
  vertical_deck
  vertical_fair
  vertical_grid
  vertical_scroller
  vertical_tile
)

declare -A layout_map=(
  [CT]="center_tile"
  [K]="deck"
  [DW]="dwindle"
  [F]="fair"
  [G]="grid"
  [M]="monocle"
  [RT]="right_tile"
  [S]="scroller"
  [T]="tile"
  [VK]="vertical_deck"
  [VF]="vertical_fair"
  [VG]="vertical_grid"
  [VS]="vertical_scroller"
  [VT]="vertical_tile"
)

current_code="$(
  mmsg get all-tags |
  jq -r '.all_tags[].tags[] | select(.is_active) | .layout'
)"

current="${layout_map[$current_code]:-}"

selected="$(
  printf '%s\n' "${layouts[@]}" |
  awk -v current="$current" '
    $0 == current { print "✓ " $0; next }
    { print }
  ' |
  rofi -dmenu -i -p "Layout ($current):"
)"

[[ -z "$selected" ]] && exit 0

selected="${selected#✓ }"

mmsg dispatch setlayout,"$selected"

notify-send \
  -a "MangoWM Layout Changed" \
  -u low \
  -t 3000 \
  -h string:x-canonical-private-synchronous:mango-layout \
  -i "$HOME/.config/mango/assets/mango.png" \
  " Layout Changed" \
  "$selected"
