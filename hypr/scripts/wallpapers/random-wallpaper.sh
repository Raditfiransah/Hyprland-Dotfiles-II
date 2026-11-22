#!/bin/bash

# ============================================
# AWWW Random Wallpaper + PYWAL (Limited)
# Hanya border dan tulisan yang berubah
# Background TETAP
# ============================================

WALLPAPER_DIR="$HOME/.config/wallpapers"
LOG_FILE="/tmp/awww-wallpaper.log"
CACHE_DIR="$HOME/.cache/awww"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "==================================="
log "Starting random wallpaper with awww + pywal"

# Buat cache directory jika belum ada
if [ ! -d "$CACHE_DIR" ]; then
    log "Creating cache directory: $CACHE_DIR"
    mkdir -p "$CACHE_DIR"
fi

# Cek direktori wallpaper
if [ ! -d "$WALLPAPER_DIR" ]; then
    log "ERROR: Wallpaper directory not found: $WALLPAPER_DIR"
    notify "Directory not found!"
    exit 1
fi

# Pilih random image, atau pakai file yang dikirim via argumen (dari wallpaper picker)
if [ -n "$1" ] && [ -f "$1" ]; then
    random_image="$1"
else
    random_image=$(find "$WALLPAPER_DIR" -type f \( \
        -iname "*.jpg" -o \
        -iname "*.jpeg" -o \
        -iname "*.png" -o \
        -iname "*.webp" -o \
        -iname "*.gif" \) | shuf -n 1)
fi

if [ -z "$random_image" ]; then
    log "ERROR: No images found in $WALLPAPER_DIR"
    notify "No images found!"
    exit 1
fi

log "Selected: $(basename "$random_image")"

# ============================================
# STEP 1: SET WALLPAPER DENGAN AWWW
# ============================================

# Pastikan awww daemon running
if ! pgrep -f "awww-daemon" > /dev/null; then
    log "Starting awww-daemon"
    awww-daemon &
    sleep 1
fi

# Set wallpaper dengan awww
log "Setting wallpaper..."
if awww img "$random_image" --transition-step 255 --transition-type random --transition-fps 60 --transition-duration 0.8 2>&1; then
    log "✅ Wallpaper set: $(basename "$random_image")"
else
    log "⚠️ Retrying without transition..."
    if awww img "$random_image" --transition-type none 2>&1; then
        log "✅ Wallpaper set (no transition)"
    else
        log "❌ ERROR: Cannot set wallpaper"
        notify "Failed to change wallpaper!"
        exit 1
    fi
fi

# ============================================
# STEP 2: GENERATE COLOR SCHEME DENGAN PYWAL
# ============================================

log "Generating color scheme..."

# Generate theme (tanpa mengubah background system)
wal -i "$random_image" -n 2>&1 >> "$LOG_FILE"

log "✅ Pywal colors generated"

# ============================================
# STEP 3: UPDATE HYPRLAND BORDER COLOR
# ============================================

# Baca warna dari pywal
COLOR4=$(grep "color4" ~/.cache/wal/colors-waybar.css | cut -d' ' -f2 | tr -d ';')

if [ -n "$COLOR4" ]; then
    # Update hyprland.conf dengan border color baru
    sed -i "s/col.active_border = .*/col.active_border = rgba(${COLOR4}ff) rgba(${COLOR4}aa) 45deg/" ~/.config/hypr/hyprland.conf
    
    log "✅ Hyprland border color updated to: $COLOR4"
    
    # Reload hyprland config
    hyprctl reload 2>/dev/null
else
    log "⚠️ Could not read pywal color"
fi

# ============================================
# STEP 4: UPDATE TERMINAL (HANYA FOREGROUND)
# Background terminal TETAP
# ============================================

# Update Ghostty (hanya foreground, background tetap)
if [ -f ~/.config/ghostty/config ]; then
    FOREGROUND=$(grep "foreground" ~/.cache/wal/colors-waybar.css | cut -d' ' -f2 | tr -d ';')
    
    if [ -n "$FOREGROUND" ]; then
        # Backup config dulu
        cp ~/.config/ghostty/config ~/.config/ghostty/config.bak
        
        # Update atau tambah foreground color
        if grep -q "^foreground =" ~/.config/ghostty/config; then
            sed -i "s/^foreground = .*/foreground = $FOREGROUND/" ~/.config/ghostty/config
        else
            echo "foreground = $FOREGROUND" >> ~/.config/ghostty/config
        fi
        
        log "✅ Ghostty foreground updated (background unchanged)"
    fi
fi

# Update Kitty (hanya foreground)
if command -v kitten &>/dev/null; then
    FOREGROUND=$(grep "foreground" ~/.cache/wal/colors-waybar.css | cut -d' ' -f2 | tr -d ';')
    
    if [ -n "$FOREGROUND" ]; then
        # Buat config kitty dengan warna custom
        cat > ~/.cache/wal/colors-kitty-custom.conf << EOF
# Kitty colors - Hanya foreground yang diambil dari pywal
foreground $FOREGROUND
# Background tetap menggunakan warna default
background #0f1323
EOF
        
        # Apply ke kitty
        kitten @ set-colors -a ~/.cache/wal/colors-kitty-custom.conf 2>/dev/null
        log "✅ Kitty foreground updated (background unchanged)"
    fi
fi

# ============================================
# SELESAI
# ============================================

log "✅ DONE! Border dan tulisan updated, background TETAP"
notify "✅ Theme updated (border + text only)"

# Hapus log lama
tail -100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"