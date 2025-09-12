#!/usr/bin/zsh

if [[ "$(hyprctl monitors)" =~ "\sDP-[0-9]+" ]]; then
  if [[ $1 == "open" ]]; then
    hyprctl keyword monitor "eDP-1,2880x1800@120,auto-down,1.5,vrr,1"
  else
    hyprctl keyword monitor "eDP-1,disable"
  fi
else
  if [[ $1 == "close" ]]; then
	hyprlock
  fi
fi

