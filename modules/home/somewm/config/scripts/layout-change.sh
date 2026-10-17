#!/usr/bin/env bash
set -euo pipefail

layouts=(
  "carousel"
  "cornernw"
  "dwindle"
  "fairh"
  "fairv"
  "floating"
  "fullscreen"
  "magnifier"
  "max"
  "spiral"
  "tile"
  "tilebottom"
  "tileleft"
  "tiletop"
)

for cmd in somewm-client rofi notify-send; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    printf 'Required command not found: %s\n' "$cmd" >&2
    exit 1
  fi
done

tag_output="$(somewm-client tag current 2>&1)" || {
  notify-send "SomeWM Layout" "Could not read the active tag: $tag_output"
  exit 1
}

tag="$(printf '%s\n' "$tag_output" | awk 'NF { value=$0 } END { gsub(/[[:space:]]/, "", value); print value }')"

if [[ ! "$tag" =~ ^[0-9]+$ ]]; then
  notify-send "SomeWM Layout" "Could not determine active tag. Output: $tag_output"
  exit 1
fi

layout_output="$(somewm-client tag layout "$tag" 2>&1 || true)"
current=""

for layout in "${layouts[@]}"; do
  if grep -Eq "(^|[^[:alnum:]_])${layout}([^[:alnum:]_]|$)" <<<"$layout_output"; then
    current="$layout"
  fi
done

options=()
for layout in "${layouts[@]}"; do
  if [[ "$layout" == "$current" && -n "$current" ]]; then
    options+=("✓  $layout")
  else
    options+=("   $layout")
  fi
done

choice="$(printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Layout (tag $tag)" -no-custom)" || exit 0
[[ -n "$choice" ]] || exit 0

selected="$(sed 's/^[[:space:]✓]*//' <<<"$choice")"
valid=false

for layout in "${layouts[@]}"; do
  [[ "$selected" == "$layout" ]] && valid=true
done

[[ "$valid" == true ]] || exit 0

if result="$(somewm-client tag layout "$tag" "$selected" 2>&1)"; then
  notify-send "SomeWM Layout" "Tag $tag layout changed to: $selected"
else
  notify-send "SomeWM Layout" "Failed to set layout: $selected. $result"
  exit 1
fi
