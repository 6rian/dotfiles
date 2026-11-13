# tmux

My tmux setup: `C-Space` prefix, vim-style navigation shared with Neovim,
popups for everything (sessions, files, scratch shell), a cyberpunk status
bar matched to the Neovim/kitty/Ghostty theme, and sessions that survive
reboots.

```
tmux/
├── .tmux.conf        # the whole config
├── plugins/tmux2k/   # vendored status-bar theme (loaded manually, not via TPM)
└── setup.sh          # legacy standalone bootstrap (prefer ../install.sh)
```

## Install

`install.sh` at the repo root (or the homelab Ansible playbooks) handles it:

| Link | Target |
|---|---|
| `~/.tmux.conf` | `tmux/.tmux.conf` |
| `~/.config/tmux/plugins` | `tmux/plugins` (for tmux2k) |

The config clones TPM itself on first start and installs the plugins. After
adding or removing a plugin, use `prefix I` to install or `prefix U` to update.

### External tools

| Tool | Used by | Notes |
|---|---|---|
| `fzf` ≥ 0.53 | sessionx | On Linux, mise's fzf has to come before apt's (0.29) on tmux's `PATH` |
| `zoxide` | sessionx, file picker | Typing a name that isn't a session falls through to zoxide |
| `sesh` | `prefix L` | Only used for "last session" now (see below) |
| `tmux-file-picker` | `prefix f` / `F` | In `~/.local/bin` |
| `workmux` | `prefix a` | `Brewfile`: `raine/workmux/workmux` |

## Core behavior

- **Prefix:** `C-Space` (press `C-Space C-Space` to send it through to the app).
- Windows and panes are numbered **from 1**, and windows renumber when one closes.
- **The status bar is at the top.**
- **`detach-on-destroy off`:** closing the last window of a session switches
  you to another session instead of detaching.
- **New splits open in the current pane's directory.**
- **Mouse on, vi copy mode, 100k lines of scrollback, `escape-time 0`.**
- **Clipboard over OSC 52, both ways.** Yanks reach the outer terminal, and
  paste requests (e.g. from nvim) ask the outer terminal, so the system
  clipboard works over SSH.
- **Extended keys are on** (`xterm*:extkeys`), so modified keys reach nvim intact.
- **`focus-events off`** because it breaks Claude Code.

## Keymaps

`prefix` = `C-Space`. Press `prefix ?` (which-key) for a browsable menu of everything.

### Sessions

| Keys | Action |
|---|---|
| `prefix s` | **sessionx**: fuzzy session picker with pane preview |
| `prefix S` | New session (prompts for a name) |
| `prefix L` | Jump to the last session (`sesh last`) |
| `prefix (` / `prefix )` | Previous / next session |
| `prefix d` | Detach |
| `prefix C-s` / `prefix C-r` | Save / restore sessions now (resurrect) |

**Inside sessionx:**

| Keys | Action |
|---|---|
| `Enter` | Switch to the session, or create one from the typed name or zoxide match |
| `Alt-Backspace` | Kill the selected session |
| `C-r` | Rename the session |
| `C-w` | List windows instead of sessions |
| `C-t` | Show a tree of sessions and windows |
| `C-f` | List zoxide directories |
| `C-x` | Browse `~/repos` |
| `C-e` | Browse subdirectories of the current directory |
| `C-b` | Back to the session list |
| `?` | Show or hide the preview |

### Windows

| Keys | Action |
|---|---|
| `prefix c` | New window |
| `Shift-←` / `Shift-→` | Previous / next window (no prefix) |
| `prefix 1`…`9` | Go to window N |
| `prefix l` | Last window |
| `prefix ,` | Rename window |
| `prefix w` | Window/session tree |

### Panes

| Keys | Action |
|---|---|
| `prefix v` / `prefix -` | Split top/bottom |
| `prefix h` / `prefix \|` | Split left/right |
| `C-h` `C-j` `C-k` `C-l` | Move between panes **and nvim splits** (vim-tmux-navigator; `C-←`/`C-→` also work) |
| `prefix C-l` | Clear screen (since `C-l` is taken by navigation) |
| `M-h` `M-j` `M-k` `M-l` | Resize the pane by 8 (passed through to nvim when nvim is focused) |
| `prefix z` | Zoom / unzoom |
| `prefix x` | Kill the pane (no confirmation) |
| `prefix *` | Kill a hung process in the pane (cowboy) |
| `prefix Space` | Cycle layouts |
| `prefix !` | Break the pane out into its own window |

### Popups and tools

| Keys | Action |
|---|---|
| `prefix t` | **floax**: floating scratch shell (90%, follows the current directory) |
| `prefix P` | floax menu (resize, embed into the window, etc.) |
| `prefix f` | Fuzzy-pick a **file** and insert its path into the pane |
| `prefix F` | Fuzzy-pick a **directory** and insert its path |
| `prefix a` | workmux dashboard |
| `prefix \` | tmux-menus (mouse-friendly menus for everything) |
| `prefix ?` | which-key menu |

### Copy mode (vi)

| Keys | Action |
|---|---|
| `prefix [` | Enter copy mode (or scroll up with the mouse) |
| `Space` / `Enter` | Start selection / copy (goes to the system clipboard via OSC 52) |
| `v` | Toggle rectangle selection |
| `M-h` `M-j` `M-k` `M-l` | Resize the pane by 5 |

### Config and plugins

| Keys | Action |
|---|---|
| `prefix r` | Reload `~/.tmux.conf` |
| `prefix I` | TPM: install plugins |
| `prefix U` | TPM: update plugins |
| `prefix M-u` | TPM: remove plugins no longer in the config |

## Plugins

Managed by [TPM](https://github.com/tmux-plugins/tpm) unless noted:

| Plugin | Purpose |
|---|---|
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sane defaults |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Same `C-hjkl` moves across nvim and tmux. Its `C-\` and `C-Space` bindings are removed so they don't clash with the prefix |
| [tmux-sessionx](https://github.com/omerxx/tmux-sessionx) | Session picker (`prefix s`). Hides floax's `scratch` session |
| [tmux-floax](https://github.com/omerxx/tmux-floax) | Floating scratch pane (`prefix t`) |
| [tmux-cowboy](https://github.com/tmux-plugins/tmux-cowboy) | Kill a hung process (`prefix *`) |
| [tmux-menus](https://github.com/jaclu/tmux-menus) | Popup menus (`prefix \`) |
| [tmux-which-key](https://github.com/alexwforsythe/tmux-which-key) | Key discovery (`prefix ?`; its default `prefix Space` is given back to `next-layout`) |
| [tmux2k](https://github.com/2KAbhishek/tmux2k) | Status bar, **vendored** in `plugins/tmux2k` |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) + [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) | Autosave every 15 minutes, auto-restore on server start |

## Status bar

tmux2k with the `cyberpunk` theme, and every color overridden to match the
`xeno-cyberpunk-v2` palette used by Neovim and kitty (background `#0b0d10`,
accent `#e8e34a`, indigo `#7E4AE6`, green `#7EA929`, magenta `#F11FCB`).

- **Left:** session · git · cwd
- **Right:** cpu · ram · battery · network · time

Segment foregrounds were picked for WCAG contrast. The comments in
`.tmux.conf` explain the choices and an upstream tmux2k bug where `pink`
reads `@tmux2k-light-purple`.

## Gotchas

- **resurrect/continuum must stay the last plugins.** continuum's autosave
  hooks into `status-right` and silently stops if tmux2k overwrites it
  afterwards.
- **The resurrect save dir is pinned** to `~/.local/share/tmux/resurrect`, so
  it's the same on every host.
- **`prefix L` uses sesh,** because tmux's native last-session loses track of
  the previous session once one is closed with `detach-on-destroy off`.
- **`extkeys` is set at a fixed index** (`terminal-features[90]`), not
  appended, so `prefix r` doesn't add a duplicate entry on every reload.
