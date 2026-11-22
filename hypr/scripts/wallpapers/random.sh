#!/bin/bash

WALLPAPERS_DIR="$HOME/.config/wallpapers"
# Pilih random file gambar (jpg, png, jpeg, gif, webp)
NEW_WALL=$(find "$WALLPAPERS_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)

echo "$NEW_WALL"