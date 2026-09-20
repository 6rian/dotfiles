# Karabiner-Elements

`karabiner.json` is symlinked to `~/.config/karabiner/karabiner.json` by
`install.sh` (and by Ansible on managed hosts). Karabiner-Elements picks up
changes to that file automatically — no reload step needed, though a rule
that shells out (`shell_command`) may need its target process to hold
Accessibility permission separately (see the Xnip entry below).

## Keymaps

### ⌘ + Space → Raycast

Launches Raycast (`open -a Raycast`) instead of Spotlight.

### ⌘ + Ctrl + H/J/K/L → arrow keys, Fn combos → text navigation

One rule bundling several related bindings:

- `⌘+Ctrl+H/J/K/L` → left/down/up/right arrow
- `Fn+U` / `Fn+I` → Home / End
- `Fn+F` / `Fn+G` → word left / word right (`⌥+←/→`)
- `Fn+A/S/D/W` → line-wise selection (`⇧+←/↓/↑/→`... `D` is `⇧+→`)
- `Fn+Q/E` → word-wise selection (`⌥⇧+←/→`)
- `Fn+'` → Caps Lock

### ⌘ + ⇧ + X → take a screenshot

**Intent is "take a screenshot," not "open Xnip."** Xnip is the current
tool behind it, triggered via `osascript` clicking its menu bar item's
"Start Capture" entry (Xnip has no documented URL scheme or CLI, and its
own built-in hotkey is deliberately left disabled — this keymap is the
single source of truth for the binding). If Xnip is ever replaced, update
this rule's `shell_command` to whatever the new tool's equivalent trigger
is; the key combo and its meaning should stay the same.

Requires Accessibility permission for whatever process actually runs the
`osascript` call (check System Settings → Privacy & Security →
Accessibility if the shortcut stops firing after a macOS update or a
Karabiner reinstall — look for an `osascript`/`karabiner_grabber` entry).

### Double-tap left ⌘ → message MindChuk

Opens the Messages conversation with MindChuk
(`open 'imessage://+12175713385'`) on two quick taps of the left Command
key alone. Uses Karabiner's standard double-tap pattern (a variable plus a
400ms `to_delayed_action` window); a single tap or a held Command still
works normally as a modifier.

### Double-tap right ⌘ → open ChatGPT

Opens the ChatGPT desktop app (`open -a ChatGPT`) on two quick taps of the
right Command key alone. Same double-tap pattern as the left ⌘ → MindChuk
rule above, mirrored onto `right_command` with its own variable
(`right_command_double_tap`) so the two don't interfere; a single tap or a
held right Command still works normally as a modifier.

### Caps Lock → Control

Device-level `simple_modifications` remap, applied to any keyboard
(`is_keyboard: true`) — not part of `complex_modifications`.

## Not managed here

- `Shift+Cmd+D` (toggle Do Not Disturb) is bound via native macOS Keyboard
Shortcuts (System Settings → Keyboard → Keyboard Shortcuts → Mission
Control), documented in the top-level `README.md`'s Mac Setup section —
deliberately not duplicated in Karabiner.
## Managed outside of Karabiner

- `Cmd + Tab` launches [AltTab](https://alt-tab-macos.netlify.app/), replacing
  the native macOS App Switcher.
