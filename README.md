# Hyprland Dotfiles II

My personal Hyprland setup, synced straight from the machine that runs it.

- **Compositor:** Hyprland 0.56.2
- **Bar:** Waybar + swaync (notifications)
- **Terminal:** ghostty (kitty + alacritty configs kept)
- **Launcher:** wofi
- **Wallpaper:** awww + pywal (border/text colors), hyprpaper as fallback
- **Lock/Idle:** hyprlock + hypridle (auto-lock disabled, manual `Super+L`)

## Layout

```
hypr/
  hyprland.conf      # entry point, sources the files below
  hyprcolors.conf    # gaps, borders (sources pywal colors)
  animations.conf    # beziers + animation curves
  keybinds.conf      # all keybinds
  input.conf         # keyboard/touchpad
  windowrule.conf    # window + layer rules (0.5x syntax)
  autostart.conf     # exec-once services
  hypridle.conf      # idle daemons (lock disabled)
  hyprlock.conf      # lock screen, pywal themed
  hyprpaper.conf     # static wallpaper fallback
  scripts/           # status scripts + wallpaper picker
ghostty/  waybar/  wofi/  kitty/  alacritty/  cava/
fastfetch/  gtk-3.0/  qt5ct/  swaylock/  mako/  wallpapers/
```

## Dependencies

```bash
sudo pacman -S hyprland hyprpaper hypridle hyprlock waybar swaync wofi ghostty \
  kitty alacritty cava fastfetch qt5ct cliphist hyprshot brightnessctl \
  pavucontrol network-manager-applet polkit-kde-agent wl-clipboard

yay -S awww python-pywal16 nwg-look
```

Fonts: `ttf-jetbrains-mono-nerd` (waybar, ghostty, kitty).
Cursor: `Bibata-Modern-Ice` (`hyprland.conf` sets `XCURSOR_THEME`).

## Install

```bash
git clone https://github.com/Raditfiransah/Hyprland-Dotfiles-II
cd Hyprland-Dotfiles-II
cp -r ./* ~/.config/
```

Then reload: `hyprctl reload`. Log out and back in for env vars (cursor theme, Nvidia).

Wallpapers live in `~/.config/wallpapers`. The random-wallpaper script picks one, applies
it with `awww`, and regenerates pywal colors from it.

## Keybinds (selected)

| Bind | Action |
|---|---|
| `Super+T` | ghostty |
| `Super+A` | wofi launcher |
| `Super+E` | thunar |
| `Super+Q` | kill active |
| `Super+L` | lock |
| `Super+W` | wallpaper picker |
| `Super+R` / `Super+Shift+R` | random wallpaper / restart hyprpaper + random |
| `Super+U` | cava visualizer toggle |
| `Super+V` | clipboard history (cliphist + wofi) |

Full list: `hypr/keybinds.conf`.
