#!/bin/bash

# Check if tmux exists
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed or not found in PATH"
    exit 1
fi

# Check if git exists
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed or not found in PATH"
    exit 1
fi

# Install tmux package manager
echo "Installing tmux package manager..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Create symlink to tmux config
echo "Creating symlink to tmux config..."
ln -sf "$PWD/.tmux.conf" "$HOME/.tmux.conf"

echo "Setup complete!"
