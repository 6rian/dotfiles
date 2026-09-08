#!/usr/bin/env bash
# Symlinks this repo into place. Works two ways:
#   - Run directly on any host: git clone ... && ~/repos/dotfiles/install.sh
#   - Called by Ansible's `dotfiles` role (infra/ansible/roles/dotfiles/tasks/main.yml
#     in the cyberdelia.lab repo), which owns cloning/updating this repo first.
#
# Idempotent: a clean re-run reports changed=0. Self-heals two kinds of
# staleness left over from a repo reorg (see context/research/dotfiles-symlinks.md
# and context/tasks/2026-09-08-dotfiles-install-script/plan.md in cyberdelia.lab
# for the full design rationale):
#   - a managed symlink pointing at the wrong (old-layout) source -> relinked
#   - a managed "real directory" destination that's actually a stale symlink
#     from before it needed to hold a mix of managed + unmanaged content
#     (e.g. ~/.config/tmux, ~/.claude) -> symlink removed, real dir created
#
# Only ever touches destinations named in the manifest below - never scans
# $HOME for unrelated dangling symlinks.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="${HOME}"

changed=0
unchanged=0

# kind:src (relative to REPO_DIR, empty for "dir"):dest (relative to $HOME)
MANIFEST=(
  "link:.zshrc:.zshrc"
  "link:tmux/.tmux.conf:.tmux.conf"
  "link:nvim:.config/nvim"
  "link:starship.toml:.config/starship.toml"
  "dir::.config/tmux"
  "link:tmux/plugins:.config/tmux/plugins"
  "link:.gitconfig:.gitconfig"
  "dir::.claude"
  "link:.claude/settings.json:.claude/settings.json"
  "link:.claude/statusline-command.sh:.claude/statusline-command.sh"
)

log() {
  printf '%s\n' "$1"
}

ensure_link() {
  local src="$REPO_DIR/$1"
  local dest="$TARGET_HOME/$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  [ -d "$dest_dir" ] || mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$src" ]; then
      log "[ok] $2"
      unchanged=$((unchanged + 1))
      return
    fi
    rm "$dest"
    ln -s "$src" "$dest"
    log "[removed-stale] $2 (was -> $current)"
    changed=$((changed + 1))
    return
  fi

  if [ -e "$dest" ]; then
    rm -rf "$dest"
    ln -s "$src" "$dest"
    log "[replaced-non-symlink] $2"
    changed=$((changed + 1))
    return
  fi

  ln -s "$src" "$dest"
  log "[changed] $2"
  changed=$((changed + 1))
}

ensure_real_dir() {
  local dest="$TARGET_HOME/$1"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    rm "$dest"
    mkdir -p "$dest"
    log "[removed-stale] $1 (was a symlink -> $current, now a real directory)"
    changed=$((changed + 1))
    return
  fi

  if [ -d "$dest" ]; then
    log "[ok] $1"
    unchanged=$((unchanged + 1))
    return
  fi

  mkdir -p "$dest"
  log "[changed] $1"
  changed=$((changed + 1))
}

for entry in "${MANIFEST[@]}"; do
  IFS=':' read -r kind src dest <<< "$entry"
  case "$kind" in
    link) ensure_link "$src" "$dest" ;;
    dir) ensure_real_dir "$dest" ;;
    *)
      log "[error] unknown manifest kind: $kind"
      exit 1
      ;;
  esac
done

log "changed=${changed} unchanged=${unchanged}"
