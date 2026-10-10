#!/usr/bin/env bash
# xdg-desktop-portal-hyprland custom picker using rofi.
# Input:  $XDPH_WINDOW_SHARING_LIST = repeated "<id>[HC>]<class>[HT>]<title>[HE>]<addr>[HA>]"
# Output: "[SELECTION]{r}/screen:<output>" | "/window:<id>" | "/region:<output>@x,y,w,h"
set -u
flag=""; [[ "${1:-}" == "--allow-token" ]] && flag="r"

menu() {
    hyprctl monitors -j | jq -r '.[] | "[screen] \(.name)  (\(.width)x\(.height))"'
    printf '%s\n' "${XDPH_WINDOW_SHARING_LIST:-}" | sed 's/\[HA>\]/\n/g' | sed -n 's/^\([0-9]*\)\[HC>\]\(.*\)\[HT>\]\(.*\)\[HE>\].*$/[window] \1  \2: \3/p'
    echo '[region] Select a region'
}

choice=$(menu | rofi -dmenu -i -p "Share" -theme ~/.config/rofi/launchers/type-2/style-8.rasi) || exit 0
kind=${choice%%]*}; kind=${kind#[}
rest=${choice#*] }

case "$kind" in
    screen) echo "[SELECTION]$flag/screen:${rest%% *}" ;;
    window) echo "[SELECTION]$flag/window:${rest%% *}" ;;
    region) read -r out x y w h < <(slurp -f "%o %x %y %w %h") || exit 0
            echo "[SELECTION]$flag/region:$out@$x,$y,$w,$h" ;;
esac
