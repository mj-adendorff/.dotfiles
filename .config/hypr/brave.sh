#!/usr/bin/env bash

container="$1"

if [[ -z "$container" ]]; then
    echo "Usage: $0 <container-name>"
    exit 1
fi

active_class="$(hyprctl activewindow -j | jq -r '.class')"

if [[ "$active_class" =~ [Bb]rave ]]; then
    brave \
        --profile-directory='Profile 1' \
        --container="$container" \
        . >/dev/null 2>&1 &

    sleep 0.2

    hyprctl dispatch 'hl.dsp.send_shortcut({ mods = "CTRL", key = "L", window = "activewindow" })'
fi
