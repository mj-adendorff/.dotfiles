#!/bin/bash


FILE_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
source "$FILE_DIR/../utils/sessions.sh"


Tmux_create_session "nvim-nordic"\
    "$HOME/.local/share/nvim/lazy/nordic.nvim/lua/nordic"
