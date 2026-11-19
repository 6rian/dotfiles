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
#   - ~/working/repos left over as an empty real directory from before a
#     legacy ~/repos was accounted for -> emptied dir removed, symlink
#     created (see ensure_working_repos below)
#
# Only ever touches destinations named in the manifest below - never scans
# $HOME for unrelated dangling symlinks.
#
# `copy` (not `link`) entries are for files a running app can rewrite in
# place -- Claude Code does this to ~/.claude/settings.json (harmless
# reordering, but it happens just from running the app), and a symlink
# into this git-tracked repo means that rewrite lands directly in the
# working tree, blocking the next clone/pull with "local modifications
# exist". A one-way copy re-applies the repo's version on every run
# instead -- no drift ever accumulates to conflict with git. The repo's
# claude/ directory is deployed to ~/.claude entirely by copy. A `copy`
# src that is a directory is copied file by file. Genuine
# per-machine/runtime state belongs in ~/.claude/settings.local.json
# instead, which is intentionally never tracked or deployed by this
# script at all.
#
# `copy-guarded` entries are `copy` entries whose live destination may
# hold edits worth keeping (e.g. a setting changed via Claude Code's
# /config). If the destination differs from the repo's version, the diff
# is printed and the script exits without touching anything further;
# re-run with -o/--overwrite to replace it.
#
# `seed` entries are the opposite of `copy`: the destination is genuinely
# per-machine state that this repo must never track (e.g.
# ~/.config/sesh/local.toml, which can name work repos), but something
# else hard-fails if it's missing (sesh errors out on a missing `import`).
# The template is copied only when the destination doesn't exist yet, and
# an existing file is never compared or overwritten.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_HOME="${HOME}"

changed=0
unchanged=0
overwrite=0

usage() {
  printf 'Usage: %s [-o|--overwrite]\n' "$(basename "$0")"
}

while [ $# -gt 0 ]; do
  case "$1" in
    -o|--overwrite) overwrite=1 ;;
    -h|--help) usage; exit 0 ;;
    *) usage >&2; exit 1 ;;
  esac
  shift
done

# kind:src (relative to REPO_DIR, empty for "dir"):dest (relative to $HOME)
MANIFEST=(
  "link:.zshrc:.zshrc"
  "link:tmux/.tmux.conf:.tmux.conf"
  "link:nvim:.config/nvim"
  "link:starship.toml:.config/starship.toml"
  "dir::.config/tmux"
  "link:tmux/plugins:.config/tmux/plugins"
  "link:tmux/options.conf:.config/tmux/options.conf"
  "link:tmux/clipboard.conf:.config/tmux/clipboard.conf"
  "link:tmux/bindings.conf:.config/tmux/bindings.conf"
  "link:tmux/popups.conf:.config/tmux/popups.conf"
  "link:tmux/plugins.conf:.config/tmux/plugins.conf"
  "link:tmux/theme.conf:.config/tmux/theme.conf"
  "link:tmux/theme-dark.conf:.config/tmux/theme-dark.conf"
  "link:tmux/theme-light.conf:.config/tmux/theme-light.conf"
  "link:tmux/apply-theme.sh:.config/tmux/apply-theme.sh"
  "link:tmux/after-plugins.conf:.config/tmux/after-plugins.conf"
  "link:.gitconfig:.gitconfig"
  "dir::.claude"
  "copy-guarded:claude/settings.json:.claude/settings.json"
  "copy:claude/statusline-command.sh:.claude/statusline-command.sh"
  "copy:claude/themes:.claude/themes"
  "link:ghostty:.config/ghostty"
  "link:kitty:.config/kitty"
  "link:tuicr:.config/tuicr"
  "link:workmux/config.yaml:.config/workmux/config.yaml"
  "dir::.config/sesh"
  "link:sesh/sesh.toml:.config/sesh/sesh.toml"
  "seed:sesh/local.toml.example:.config/sesh/local.toml"
  "link:karabiner/karabiner.json:.config/karabiner/karabiner.json"
  "dir::working"
  "link:working/README.md:working/README.md"
  "dir::working/tmp"
  "dir::working/ai"
  "repos-compat::working/repos"
  "dir::working/daily-notes"
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

ensure_copy() {
  local src="$REPO_DIR/$1"
  local dest="$TARGET_HOME/$2"

  if [ -d "$src" ]; then
    ensure_copy_dir "$1" "$2"
    return
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"
  [ -d "$dest_dir" ] || mkdir -p "$dest_dir"

  if [ -L "$dest" ]; then
    rm "$dest"
    cp "$src" "$dest"
    log "[migrated-from-symlink] $2"
    changed=$((changed + 1))
    return
  fi

  if [ -f "$dest" ] && cmp -s "$src" "$dest"; then
    log "[ok] $2"
    unchanged=$((unchanged + 1))
    return
  fi

  cp "$src" "$dest"
  log "[changed] $2"
  changed=$((changed + 1))
}

# A destination that's still a symlink from the old `link` layout points
# back into this repo, so copying files into it would write into the
# working tree -- replace it with a real directory first.
ensure_copy_dir() {
  local dest="$TARGET_HOME/$2"

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    rm "$dest"
    log "[removed-stale] $2 (was a symlink -> $current, now a real directory)"
    changed=$((changed + 1))
  fi
  mkdir -p "$dest"

  local file
  while IFS= read -r file; do
    ensure_copy "$1/$file" "$2/$file"
  done < <(cd "$REPO_DIR/$1" && find . -type f | sed 's|^\./||' | sort)
}

ensure_copy_guarded() {
  local src="$REPO_DIR/$1"
  local dest="$TARGET_HOME/$2"

  if [ "$overwrite" -eq 0 ] && [ -f "$dest" ] && [ ! -L "$dest" ] && ! cmp -s "$src" "$dest"; then
    log "[error] $2 differs from the repo's $1 -- pass -o or --overwrite to replace it"
    diff -u "$dest" "$src" || true
    exit 1
  fi

  ensure_copy "$1" "$2"
}

ensure_seed() {
  local src="$REPO_DIR/$1"
  local dest="$TARGET_HOME/$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  [ -d "$dest_dir" ] || mkdir -p "$dest_dir"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    log "[ok] $2"
    unchanged=$((unchanged + 1))
    return
  fi

  cp "$src" "$dest"
  log "[seeded] $2"
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

# Backwards compatibility for hosts/repos that still hardcode ~/repos
# paths: if a legacy ~/repos already exists, point working/repos at it
# instead of creating a second, empty repos directory. TODO once every
# reference to ~/repos is updated to ~/working/repos, delete this function,
# the legacy-~/repos branch's callers, and go back to a plain
# "dir::working/repos" manifest entry.
ensure_working_repos() {
  local dest="$TARGET_HOME/$1"
  local legacy="$TARGET_HOME/repos"

  if [ ! -d "$legacy" ] || [ -L "$legacy" ]; then
    ensure_real_dir "$1"
    return
  fi

  if [ -L "$dest" ]; then
    local current
    current="$(readlink "$dest")"
    if [ "$current" = "$legacy" ]; then
      log "[ok] $1"
      unchanged=$((unchanged + 1))
      return
    fi
    rm "$dest"
    ln -s "$legacy" "$dest"
    log "[removed-stale] $1 (was -> $current)"
    changed=$((changed + 1))
    return
  fi

  if [ -d "$dest" ]; then
    if [ -z "$(ls -A "$dest" 2>/dev/null)" ]; then
      rmdir "$dest"
      ln -s "$legacy" "$dest"
      log "[changed] $1 (empty dir replaced with symlink to ~/repos)"
      changed=$((changed + 1))
      return
    fi
    log "[error] $1 is a non-empty real directory but ~/repos also exists -- resolve manually"
    exit 1
  fi

  if [ -e "$dest" ]; then
    log "[error] $1 exists and is not a directory or symlink -- resolve manually"
    exit 1
  fi

  ln -s "$legacy" "$dest"
  log "[changed] $1 (symlinked to ~/repos)"
  changed=$((changed + 1))
}

ensure_submodules() {
  local status
  status="$(git -C "$REPO_DIR" submodule status)"
  [ -n "$status" ] || return

  local uninitialized
  uninitialized="$(printf '%s\n' "$status" | grep '^-' || true)"

  if [ -z "$uninitialized" ]; then
    log "[ok] git submodules"
    unchanged=$((unchanged + 1))
    return
  fi

  git -C "$REPO_DIR" submodule update --init --recursive
  while IFS= read -r line; do
    log "[changed] submodule $(printf '%s\n' "$line" | awk '{print $2}') initialized"
  done <<< "$uninitialized"
  changed=$((changed + 1))
}

ensure_submodules

for entry in "${MANIFEST[@]}"; do
  IFS=':' read -r kind src dest <<< "$entry"
  case "$kind" in
    link) ensure_link "$src" "$dest" ;;
    dir) ensure_real_dir "$dest" ;;
    copy) ensure_copy "$src" "$dest" ;;
    copy-guarded) ensure_copy_guarded "$src" "$dest" ;;
    seed) ensure_seed "$src" "$dest" ;;
    repos-compat) ensure_working_repos "$dest" ;;
    *)
      log "[error] unknown manifest kind: $kind"
      exit 1
      ;;
  esac
done

log "changed=${changed} unchanged=${unchanged}"
