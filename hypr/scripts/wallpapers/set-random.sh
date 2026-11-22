#!/bin/bash

RANDOM_SCRIPT="$HOME/.config/hypr/scripts/wallpapers/random.sh"
SET_SCRIPT="$HOME/.config/hypr/scripts/wallpapers/set.sh"

# Get random wallpaper
RANDOM_WALL=$($RANDOM_SCRIPT)

if [ -n "$RANDOM_WALL" ] && [ -f "$RANDOM_WALL" ]; then
    $SET_SCRIPT "$RANDOM_WALL"
    echo "Wallpaper changed to: $RANDOM_WALL"
else
    echo "Error: No wallpaper found in $HOME/.config/wallpapers/"
    exit 1
fi