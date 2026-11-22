#!/bin/bash
ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d: -f2)
if [ -n "$ssid" ]; then
    printf ' %s\n' "$ssid"
elif nmcli -t -f WIFI g 2>/dev/null | grep -qi enabled; then
    echo "󰖩"
else
    echo "󰲝"
fi