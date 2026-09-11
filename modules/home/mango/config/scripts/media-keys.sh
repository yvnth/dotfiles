#!/usr/bin/env bash

set -euo pipefail

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

case "${1:-}" in
    vol-up)
        wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+
        notify-send \
            -h string:x-canonical-private-synchronous:volume \
            "󰕾 Volume" \
            "$(get_volume)%"
        ;;

    vol-down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        notify-send \
            -h string:x-canonical-private-synchronous:volume \
            "󰕾 Volume" \
            "$(get_volume)%"
        ;;

    vol-mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED; then
            notify-send \
                -h string:x-canonical-private-synchronous:volume \
                "󰝟 Audio" \
                "Muted"
        else
            notify-send \
                -h string:x-canonical-private-synchronous:volume \
                "󰕾 Audio" \
                "$(get_volume)%"
        fi
        ;;

    mic-mute)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

        if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; then
            notify-send \
                -h string:x-canonical-private-synchronous:mic \
                "󰍭 Mic" \
                "Muted"
        else
            notify-send \
                -h string:x-canonical-private-synchronous:mic \
                "󰍬 Mic" \
                "Unmuted"
        fi
        ;;

    bright-up)
        brightnessctl set +5%

        notify-send \
            -h string:x-canonical-private-synchronous:brightness \
            "󰃠 Brightness" \
            "$(brightnessctl -m | cut -d, -f4)"
        ;;

    bright-down)
        brightnessctl set 5%-

        if [ "$(brightnessctl get)" -lt "$(( $(brightnessctl max) / 100 ))" ]; then
            brightnessctl set 1%
        fi

        notify-send \
            -h string:x-canonical-private-synchronous:brightness \
            "󰃠 Brightness" \
            "$(brightnessctl -m | cut -d, -f4)"
        ;;

    *)
        echo "Usage: $0 {vol-up|vol-down|vol-mute|mic-mute|bright-up|bright-down}"
        exit 1
        ;;
esac
