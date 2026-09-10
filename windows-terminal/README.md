# Windows Terminal — Xeno Cyberpunk V2

Color scheme for Windows Terminal (the terminal app WSL actually renders
through — WSL itself has no color config of its own), matching the same
`xeno-cyberpunk-v2` palette as `ghostty/themes/xeno-cyberpunk-v2` and
`kitty/xeno-cyberpunk-v2.conf`: background `#0b0d10`, neon-yellow accent
`#e8e34a`, teal `#089ED9`, green `#7EA929`, indigo `#7E4AE6`, magenta
`#F11FCB`.

Not symlinked/automated by Ansible or `install.sh` — Windows/WSL isn't a
managed host in this project (see the homelab repo's
`context/tasks/2026-09-08-dotfiles-install-script/plan.md`, "explicitly
out of scope"). Install by hand:

1. Open Windows Terminal → Settings → open JSON config (bottom-left icon,
   or `Ctrl+Shift+,`).
2. Copy the contents of `xeno-cyberpunk-v2.json` into the `"schemes"`
   array.
3. On the WSL profile (Settings → your WSL distro → Additional settings →
   Appearance), set **Color scheme** to `Xeno Cyberpunk V2`.

Regenerate this file by hand if the xeno-cyberpunk-v2 palette ever
changes — there's no build step, it's just Windows Terminal's own color
scheme JSON schema (`name` + 16 ANSI colors + `background`/`foreground`/
`cursorColor`/`selectionBackground`).
