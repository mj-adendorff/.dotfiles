#!/usr/bin/env bash

id=$(hyprctl activeworkspace -j | jq .id)
name=$(rofi -dmenu -l 0 -p "Rename workspace $id" </dev/null)
[[ -z "$name" ]] && exit

# Escape for a Lua double-quoted string literal
name=${name//\\/\\\\}
name=${name//\"/\\\"}

hyprctl dispatch "hl.dsp.workspace.rename({ workspace = $id, name = \"$id:$name\" })"
