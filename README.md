# 6rian's dotfiles

## Dev Env Setup Process

This repo isn't bootstrapped by hand — it's cloned and symlinked into place by Ansible, from the `cyberdelia.lab` homelab repo (`github.com/6rian/cyberdelia.lab`, private). Ansible's `dotfiles` role needs SSH access to clone this repo, so an SSH key registered with GitHub is still a real prerequisite:

- [ ] `ssh-keygen -t ed25519 -C "wbgriffin@pm.me"`
- [ ] [add the public key to GitHub](https://github.com/settings/keys)

From there, run the relevant playbook out of `infra/ansible/` in the homelab repo:

- **Linux (`devbox`):** `ansible-playbook playbooks/site.yml` — installs everything from scratch (packages, Neovim, tmux, mise, and this repo's clone/symlinks).
- **Mac:** assumes Homebrew, Neovim, and tmux are already installed (not yet automated — see the homelab repo's `context/tasks/2026-08-23-ansible-mac/followups.md`). `ansible-playbook playbooks/mac.yml` — runs against `localhost`, handles mise plus this repo's clone/symlinks.

Both are idempotent — safe to re-run any time; a clean run reports `changed=0`.

> [!IMPORTANT] Your terminal must have a [Nerd Font](https://www.nerdfonts.com/) installed.


## Mac Setup

### System Settings

- Open 9 worskspaces before opening system settings
- Accessibility -> Display -> Check "Reduce motion"
- Desktop & Dock ->
    - Position on screen: Bottom
    - Minimize windows into application icon: Off
    - Automatically hide and show the Dock: On 
    - Animate opening applications: Off
    - Show suggested and recent apps in Dock: Off
    - Stage Manager: Off
    - Default Web Browser: Brave
    - Mission Control ->
        - Automatically rearrange Spaces based on most recent use: Off
        - When switching to an application, switch to a Space with open windows for the application: On
        - Group windows by application: Off
        - Displays have separate Spaces: On
- Keyboard ->
    - Keyboard Shortcuts ->
        - Mission Control ->
            - Turn Do Not Disturb On/Off: Shift+Cmd+D
            - Mission Control -> Check everything.
        - Modifier Keys ->
            - Caps Lock: Control

