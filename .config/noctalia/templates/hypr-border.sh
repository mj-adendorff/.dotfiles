#!/bin/sh

hyprctl eval 'hl.config({
    general = {
        col = {
            active_border = {
                colors = {
                    "rgba({{ colors.secondary.default.hex_stripped }}ee)",
                    "rgba({{ colors.primary.default.hex_stripped }}ee)",
                    "rgba({{ colors.tertiary.default.hex_stripped }}ee)"
                },
                angle = 45
            }
        }
    }
})'
