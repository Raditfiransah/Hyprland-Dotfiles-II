#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers"
PICKER="$HOME/.config/hypr/scripts/wallpapers/random-wallpaper.sh"

SELECTED=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) -printf "%f\n" | sort | wofi --dmenu --prompt "Pilih wallpaper" --width 600 --height 400)

[ -z "$SELECTED" ] && exit 1

exec "$PICKER" "$WALLPAPER_DIR/$SELECTED"