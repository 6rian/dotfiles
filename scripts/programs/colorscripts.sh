#!/bin/bash

git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install

# Create a symlink for the script
sudo ln -s /bin/colorscript /opt/shell-color-scripts/colorscript.sh

# optional for zsh completion
sudo cp completions/_colorscript /usr/share/zsh/site-functions

# Removal
# sudo make uninstall
