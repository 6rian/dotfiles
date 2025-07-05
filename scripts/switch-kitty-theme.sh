#!/bin/bash

if [[ "$1" == "dark" ]]; then
  kitty @ set-colors --all ~/.config/kitty/catppuccin-custom.conf
else
  kitty @ set-colors --all ~/.config/kitty/catppuccin-custom-light.conf
fi
