# 6rian's dotfiles

## Dev Env Setup Process

On a host managed by the `cyberdelia.lab` homelab repo (`github.com/6rian/cyberdelia.lab`, private), this repo is cloned and symlinked into place by Ansible. On any other host (e.g. a work laptop that will never run this project's Ansible), `install.sh` in this repo does the same symlinking on its own — see "Manual setup" below. Either way, an SSH key registered with GitHub is a real prerequisite, since this repo itself is private:

- [ ] `ssh-keygen -t ed25519 -C "wbgriffin@pm.me"`
- [ ] [add the public key to GitHub](https://github.com/settings/keys)

### Ansible (managed hosts)

Run the relevant playbook out of `infra/ansible/` in the homelab repo:

- **Linux (`devbox`):** `ansible-playbook playbooks/devbox.yml` — installs everything from scratch (packages, Neovim, tmux, mise, and this repo's clone/symlinks).
- **Mac:** `ansible-playbook playbooks/mac.yml` — runs against the `macs` group (localhost and any other Mac added to it, e.g. a second remote Mac reachable over SSH), handles mise, this repo's Homebrew formulae/casks (`Brewfile`, below — additive only), and this repo's clone/symlinks.

Both are idempotent — safe to re-run any time; a clean run reports `changed=0`.

### Manual setup (unmanaged hosts)

```sh
git clone git@github.com:6rian/dotfiles.git ~/repos/dotfiles
~/repos/dotfiles/install.sh
```

`install.sh` only symlinks this repo into place — it doesn't install
Neovim/tmux/mise/Homebrew packages/etc. Same idempotency guarantee as the
Ansible path (a clean re-run reports `changed=0`), and it self-heals
symlinks left over from an old repo layout rather than leaving them
stale. See the homelab repo's `context/research/dotfiles-symlinks.md` and
`context/tasks/2026-09-08-dotfiles-install-script/plan.md` for the full
design rationale.

On a Mac, also install this repo's Homebrew formulae/casks by hand —
additive only, same guarantee as the Ansible path (never uninstalls
anything not listed):

```sh
brew bundle --file=~/repos/dotfiles/Brewfile
```

A handful of casks need their own interactive sudo/`.pkg` install prompt
and are deliberately left out of the Brewfile entirely (`brew bundle`
can't satisfy them non-interactively either way) — see the homelab repo's
`infra/ansible/roles/base_mac/README.md` for the list and the one-time
manual install command.

> [!IMPORTANT] Your terminal must have a [Nerd Font](https://www.nerdfonts.com/) installed.


## Mac Setup

### System Settings

Most Dock/Mission Control/Accessibility settings, and the Caps Lock ->
Control remap, are automated — the former by the homelab repo's
`base_mac` Ansible role (`infra/ansible/roles/base_mac/tasks/dock_settings.yml`,
runs on any host that runs `playbooks/mac.yml`), the latter by this
repo's own `karabiner.json` (a device-level remap, live as soon as it's
symlinked into place — no Ansible required, see `karabiner/README.md`).
What's left is what genuinely has no automated equivalent —
either because changing it isn't a simple `defaults write` (default
browser), or because it lives in a settings pane Ansible doesn't touch
(global keyboard shortcuts):

- Open 9 workspaces before opening system settings
- Desktop & Dock -> Default Web Browser: Vivaldi
- Keyboard -> Keyboard Shortcuts -> Mission Control ->
    - Turn Do Not Disturb On/Off: Shift+Cmd+D
    - Check everything.

