#!/bin/bash
if pgrep -x hyprlock >/dev/null; then
    exit 0
fi
hyprlock --no-fade-in