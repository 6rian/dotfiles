#!/usr/bin/env bash
# Switch the tmux status bar to theme-light.conf or theme-dark.conf. Run by
# the client-light-theme / client-dark-theme hooks in theme.conf, which fire
# when the terminal reports a light/dark switch (Ghostty follows macOS).
#
# Usage: apply-theme.sh light|dark
set -euo pipefail

variant=$1
dir="$HOME/.config/tmux"

# Every newly attached client reports its theme once; nothing to do if that
# palette is already applied.
if [ "$(tmux show -gqv @theme-variant)" = "$variant" ]; then
  exit 0
fi

# tmux2k writes the colours into status-left/right and the window formats, so
# it has to run again. That replaces status-right and drops continuum's
# autosave interpolation, so carry it over. (Re-running continuum.tmux
# instead could start a second auto-restore on a freshly started server.)
save=$(tmux show -gqv status-right | grep -o '#([^)]*continuum_save\.sh)' || true)

tmux source-file "$dir/theme-$variant.conf"
"$dir/plugins/tmux2k/main.sh"

if [ -n "$save" ]; then
  tmux set -g status-right "$save$(tmux show -gqv status-right)"
fi
