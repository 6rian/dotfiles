# Source of truth for this dotfiles setup's Homebrew formulae/casks on a
# Mac. Two ways this gets used:
#   - Managed hosts: the cyberdelia.lab homelab repo's `base_mac` Ansible
#     role runs `brew bundle` against this file directly out of this
#     cloned repo (infra/ansible/roles/base_mac/tasks/homebrew.yml) --
#     edit here, then re-run that role's `homebrew` tagged task.
#   - Unmanaged hosts (e.g. a work laptop that will never run this
#     project's Ansible): run `brew bundle --file=Brewfile` by hand from
#     this repo's root -- see this repo's own README.md.
#
# Additive only: `brew bundle` installs anything listed here that's
# missing, but never removes anything installed that ISN'T listed (no
# `--cleanup`) -- see the homelab repo's
# context/tasks/2026-09-16-base-mac-role/plan.md's "Brewfile reconcile
# mode" decision.
#
# Curated from the homelab repo's
# context/tasks/2026-09-16-base-mac-role/{homebrew-formulae,applications}.md
# after Brian's own pruning pass over what's actually used.
#
# Casks with a real cask match that still need an interactive sudo/pkg
# prompt (expressvpn, openvpn-connect, protonvpn, viscosity,
# karabiner-elements, realvnc-connect-viewer, windows-app, zoom) are
# deliberately NOT listed here -- `brew bundle` can't satisfy them
# non-interactively, on a managed host or otherwise. See the homelab
# repo's infra/ansible/roles/base_mac/README.md "Has a cask, but needs an
# interactive install" section for the one-time manual install command and
# why each one needs it.

# Shell / CLI ergonomics
brew "bat"
brew "bc"
brew "fzf"
brew "fd"
brew "gawk"
brew "gnu-sed"
brew "grc"
brew "htop"
brew "btop"
brew "jq"
brew "ripgrep"
brew "starship"
brew "tree-sitter-cli"
brew "tmux"
brew "zoxide"
brew "zsh-autosuggestions"
brew "bash"
brew "coreutils"
brew "wget"

# Git / GitHub
brew "gh"
brew "lazygit"
brew "mkcert"

# Terminal UI / dashboard eye-candy
# neofetch removed (2026-09-17): no longer exists in homebrew-core --
# confirmed live on nurv, upstream's archived and Homebrew dropped the
# formula. nerdfetch already covers the same job and installs fine.
brew "chafa"
brew "nerdfetch"

# Infra / networking
brew "ansible"
brew "actionlint"
brew "awscli"
brew "iproute2mac"
brew "nmap"

# Editors / docs
brew "neovim"
brew "glow"
brew "hugo"
brew "poppler"
brew "exiftool"

# GUI apps
cask "1password"
cask "alt-tab"
cask "chatgpt"
cask "claude"
cask "claude-code"
cask "copilot-cli"
cask "discord"
cask "docker-desktop"
cask "figma"
cask "firefox"
cask "ghostty"
cask "google-chrome"
cask "insomnia"
cask "kitty"
cask "notion"
cask "obsidian"
cask "opera"
cask "pgadmin4"
cask "raycast"
cask "redis-insight"
cask "slack"
cask "spotify"
cask "steam"
cask "tailscale-app"
cask "todoist-app"
cask "utm"
cask "visual-studio-code"
cask "vivaldi"
cask "whatsapp"
