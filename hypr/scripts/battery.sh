#!/bin/bash
cap=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)
if [ -z "$cap" ]; then
    echo ""
    exit 0
fi
if [ "$cap" -ge 80 ]; then icon=""
elif [ "$cap" -ge 60 ]; then icon=""
elif [ "$cap" -ge 40 ]; then icon=""
elif [ "$cap" -ge 20 ]; then icon=""
else icon=""; fi
printf '%s %s%%\n' "$icon" "$cap"