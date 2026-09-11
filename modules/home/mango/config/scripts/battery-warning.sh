#!/usr/bin/env bash

CRIT_LOW_ID=9999
CRIT_FULL_ID=9998

ICON_DIR="$HOME/.config/mango/assets"

notified_low=false
notified_full=false

while true; do
    battery=$(acpi -b | grep -P -o '[0-9]+(?=%)')
    status=$(acpi -b | grep -oE 'Charging|Discharging|Full')

    if [ "$status" = "Discharging" ]; then
        if [ "$notified_full" = true ]; then
            notify-send -r $CRIT_FULL_ID -t 1 ""
            notified_full=false
        fi

        if [ "$battery" -le 5 ] && [ "$notified_low" = false ]; then
            notify-send \
                -u critical \
                -r $CRIT_LOW_ID \
                -i "$ICON_DIR/battery-empty.svg" \
                "Critical Battery — ${battery}%" \
                "Charge immediately to prevent shutdown."

            notified_low=true
        fi

    else
        if [ "$notified_low" = true ]; then
            notify-send -r $CRIT_LOW_ID -t 1 ""
            notified_low=false
        fi

        if [ "$battery" -ge 100 ] && [ "$notified_full" = false ]; then
            notify-send \
                -u critical \
                -r $CRIT_FULL_ID \
                -i "$ICON_DIR/battery-full.svg" \
                "Battery Full — ${battery}%" \
                "Unplug to preserve battery health."

            notified_full=true
        fi
    fi

    sleep 10
done
