#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
    printf '♪ %s\n' "$(playerctl metadata --format '{{ artist }} — {{ title }}' 2>/dev/null | cut -c1-60)"
fi