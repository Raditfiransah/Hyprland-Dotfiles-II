#!/bin/bash

WALLPAPER_PATH="$1"

if [ -f "$WALLPAPER_PATH" ]; then
    # Kill existing swww daemon if running
    pkill swww 2>/dev/null
    # Start swww daemon
    swww init 2>/dev/null
    # Set wallpaper
    swww img "$WALLPAPER_PATH" --transition-type any --transition-fps 60 --transition-duration 1.5
fi