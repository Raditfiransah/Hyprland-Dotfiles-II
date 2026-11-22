#!/bin/bash
# Toggle cava audio visualizer (floating di pojok kanan-bawah)

W=520
H=220

if hyprctl clients -j 2>/dev/null | grep -q '"class": "cava"'; then
    PID=$(hyprctl clients -j 2>/dev/null | python3 -c "import json,sys
for c in json.load(sys.stdin):
    if c.get('class')=='cava':
        print(c['pid']); break")
    [ -n "$PID" ] && kill "$PID" 2>/dev/null
    exit 0
fi

kitty --config "$HOME/.config/kitty/cava.conf" --class=cava -e cava -p "$HOME/.config/cava/visualizer.conf" >/dev/null 2>&1 &

# Posisikan di pojok kanan-bawah setelah window muncul
for _ in $(seq 1 20); do
    if hyprctl clients -j 2>/dev/null | grep -q '"class": "cava"'; then
        read -r MW MH <<< "$(hyprctl monitors -j | python3 -c "import json,sys; m=[x for x in json.load(sys.stdin) if x.get('focused')][0]; print(m['width'], m['height'])")"
        X=$((MW - W - 15))
        Y=$((MH - H - 15))
        hyprctl dispatch movewindowpixel exact "$X $Y,class:^cava$" >/dev/null 2>&1
        break
    fi
    sleep 0.2
done