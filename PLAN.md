# Neovim Upgrade Plan: v0.11.4 → v0.12.3

Researched 2026-06-23. Sources: official Neovim `news.txt`/`deprecated.txt`/`pack.txt`/`lsp.txt` at the v0.12.3 tag, and live GitHub data (commits, releases, READMEs, issues) for every plugin in `lazy-lock.json`.

## TL;DR

- **v0.12.3** (2026-06-10) is the current latest stable release, and it's already bottled in Homebrew (`brew upgrade neovim` gets you there directly — no need to stop at a later 0.11.x patch).
- **One real blocker**: `nvim-treesitter` is **archived** upstream. The branch this config is pinned to (`master`, the legacy config-table API) explicitly states it does **not** support Neovim 0.12, and since the repo is archived, it never will. This must be migrated to the `main` branch (the rewritten API) as part of the upgrade — see [§2](#2-the-one-real-blocker-nvim-treesitter).
- Everything else in the config is compatible with 0.12.3 with no forced changes, though `lsp.lua` uses an LSP-setup pattern that's now deprecated upstream (still works, but should be modernized — [§3](#3-lsp-setup-modernization-recommended)).
- The user's instinct about native features replacing plugins is partly right: Neovim 0.12 ships a native plugin manager (`vim.pack`), but it's missing lazy.nvim's core feature (declarative lazy-loading by event/cmd/ft/keys) — **not worth migrating off lazy.nvim** for an existing config ([§8](#8-why-not-switch-lazynvim--vimpack-right-now)). The bigger, more actionable win is that this config already has **two full-featured fuzzy finders, two lazygit wrappers, and two floating-terminal plugins** doing the same job — that redundancy is worth cutting regardless of the Neovim version ([§6](#6-plugins-to-remove--consolidate)).

---

## 1. Pre-flight backup

The dotfiles repo is currently clean (no uncommitted changes), so the config itself is already safe in git. Back up the *data* that isn't in git before touching anything:

```bash
# Plugin installs, Mason-installed LSP servers/tools, treesitter parsers, etc.
tar czf ~/nvim-data-backup-$(date +%Y%m%d).tar.gz \
  ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim

# Note the exact current binary version for reference
nvim --version | head -1   # NVIM v0.11.4
```

Homebrew keeps the previous version's Cellar keg around until you explicitly run `brew cleanup` — **don't run `brew cleanup` until you've confirmed 0.12.3 works**, so a binary rollback stays one command away (see [§10](#10-rollback-plan)).

---

## 2. The one real blocker: `nvim-treesitter`

This is the single fact that matters most for this upgrade:

- `nvim-treesitter/nvim-treesitter` was **archived (read-only) on 2026-04-03**. No further commits are possible on any branch, ever.
- The repo's default branch is now `main`, which holds a **complete, incompatible rewrite** (its own README: *"Treat this as a different plugin you need to set up from scratch"*). It drops the old `ensure_installed` / `highlight` / `indent` table config in favor of `require('nvim-treesitter').setup{ install_dir = ... }` + `require('nvim-treesitter').install{...}`, and **requires Neovim 0.12.0+**.
- This config's `lazy-lock.json` pins `branch = "master"` — the **legacy** API, exactly matching the table-based config currently in `lua/plugins/coding/highlights.lua`. Master's own README says plainly: *"Neovim 0.10 or 0.11 (Neovim 0.12 is not supported)."* Because the repo is archived, that statement can never be revisited or fixed.

**Action**: as part of this upgrade, migrate `lua/plugins/coding/highlights.lua` from `master` to `main` and rewrite the config to the new API. Concretely:

1. Read the live `main` branch README/migration notes at execution time (the exact API shape is worth re-confirming, since this plugin gets zero further updates and any community migration guides will be the only documentation that ever exists for it).
2. Expect the new shape to look roughly like:
   ```lua
   return {
     'nvim-treesitter/nvim-treesitter',
     branch = 'main',
     build = ':TSUpdate',
     config = function()
       require('nvim-treesitter').setup {}
       require('nvim-treesitter').install {
         'bash', 'c', 'css', 'diff', 'dockerfile', 'gitignore', 'go', 'gomod', 'gosum',
         'html', 'javascript', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline',
         'php', 'python', 'query', 'ssh_config', 'sql', 'tsx', 'typescript', 'vim',
         'vimdoc', 'yaml', 'xml',
       }
       -- Highlighting/indent are enabled per-buffer now (no more `highlight.enable`/`indent.enable`
       -- table flags) — typically via a FileType autocmd calling `vim.treesitter.start()`
       -- and setting `vim.bo.indentexpr`. Confirm exact wiring against the current README.
     end,
   }
   ```
3. `nvim-treesitter-context` and `nvim-ts-autotag` should be unaffected — `nvim-ts-autotag` already calls its own standalone `require('nvim-ts-autotag').setup{...}` (not threaded through `nvim-treesitter.configs`), and `nvim-treesitter-context` calls core `vim.treesitter`/`vim.lsp` APIs directly rather than nvim-treesitter's Lua modules. Re-verify both still attach correctly after the rewrite, since this is inferred from source shape rather than an explicit maintainer guarantee.
4. After switching, delete the stale `nvim-treesitter` entry from `lazy-lock.json` (or run `:Lazy update nvim-treesitter`) so the lockfile records `main` instead of `master`.

---

## 3. LSP setup modernization (recommended)

`lua/plugins/coding/lsp.lua:283` calls `require('lspconfig')[server_name].setup(server)` inside a `mason-lspconfig` handler. This is the classic kickstart.nvim pattern, and it still works — but `nvim-lspconfig`'s own README now states this style is deprecated: *"Calls to `require('lspconfig')` will show a warning, which will later become an error,"* in favor of Neovim's native `vim.lsp.config()` / `vim.lsp.enable()` API (added in 0.11). `mason-lspconfig` v2.3.0 (the version this config already tracks) is built around that native model already.

This isn't a hard break on 0.12.3 — it'll likely just emit a deprecation warning — but since you're touching this file anyway for the treesitter work, it's worth modernizing in the same pass:

- Replace the per-server `mason-lspconfig` `handlers` table with `vim.lsp.config(server_name, server)` + `vim.lsp.enable(server_name)` (or `vim.lsp.enable({...})` once with the full server list).
- Set shared `capabilities` (currently `require('blink.cmp').get_lsp_capabilities()`) via `vim.lsp.config('*', { capabilities = ... })` so it merges into every server automatically, instead of manually merging in the handler.
- Confirm the exact current `mason-lspconfig` option name for "auto-enable installed servers" against its live README — it replaced the old manual `handlers` pattern but the exact field name wasn't independently re-verified during this research pass.

Low-priority, same file: `lsp.lua:81` sets `vim.keymap.set(mode, keys, func, { buffer = event.buf, ... })` — the `buffer` key in keymap opts is deprecated (not removed) in favor of `buf`. Harmless to leave, trivial to rename while in the file.

No other removed/renamed APIs (`vim.diff`, `vim.diagnostic.disable`/`is_disabled`, `semantic_tokens.start`/`stop`, `Query:iter_matches(..., "all")`) showed up anywhere in this config — confirmed by grep. The one `sign_define` hit is in `lua/kickstart/plugins/debug.lua`, which is commented out and not loaded — no action needed.

---

## 4. Other plugin-specific notes for this upgrade

| Plugin | Note |
|---|---|
| `fidget.nvim` | Just released **v2.0.0** (2026-06-21, days before this audit). Breaking changes: removed nvim-tree/xcodebuild integrations (unused here, fine), notification window width now capped + auto text-reflow by default. This config only does `opts = {}`, so low risk, but sanity-check the LSP-progress notification look after upgrading. |
| `blink.cmp` | Pinned `version = '1.*'` — correctly defensive. Upstream's 1.10.0 changelog says *"final 1.x release before 2.0"* and a `v2` branch already exists. No action now; re-evaluate when 2.0 ships. |
| `gitsigns.nvim` | Went through real v1.0 and v2.0 major bumps, but the `signs = {...}` / `on_attach = function(bufnr) ... end` shape used in `lua/plugins/editor/gitsigns.lua` is still the current documented pattern — no rewrite needed. |
| `telescope.nvim` | README now states it requires **Neovim ≥ 0.11.7** — meaning it's already past this config's *current* 0.11.4 floor today (works in practice, but the 0.12.3 target clears it properly either way). Moot if you act on the consolidation in §6a. |
| `typescript-tools.nvim` | No 0.12-specific break, but maintenance has visibly slowed (last meaningful merge ~7 months ago, single maintainer, recurring "is this dead?" issues). Not urgent — see [§7](#7-plugins-to-watch-but-not-act-on-yet). |

---

## 5. Full plugin audit (maintenance status)

Everything below was checked live against GitHub. "Active" = commits/releases within the last ~3 months as of 2026-06-23.

| Plugin | Status | Neovim 0.12 risk |
|---|---|---|
| nvim-treesitter | **Archived**, frozen | **See §2 — action required** |
| nvim-lspconfig | Active | None (deprecation warning only, see §3) |
| mason-org/mason.nvim | Active | None |
| mason-org/mason-lspconfig.nvim | Active | None (requires ≥0.11, satisfied) |
| mason-tool-installer.nvim | Active-ish (~5mo) | None |
| fidget.nvim | Active (v2.0 just shipped) | None — review config (§4) |
| blink.cmp | Very active | None — 2.0 is coming, not yet |
| LuaSnip | Active | None |
| blink-cmp-tmux / -npm / -avante | Active / quiet / quiet | None found |
| lazydev.nvim | Active | None |
| nvim-treesitter-context | Active | None (branch-agnostic by design) |
| nvim-ts-autotag | Active | None (already on standalone API) |
| typescript-tools.nvim | Slowing (~7mo) | None confirmed, but bus-factor risk — §7 |
| conform.nvim | Active | None |
| gitsigns.nvim | Active | None |
| telescope.nvim + fzf-native | Very active | None (min version note in §4) |
| telescope-ui-select.nvim / telescope-symbols.nvim | Quiet since 2024, not abandoned | None found |
| todo-comments.nvim | Quiet (~7mo) | None found |
| trouble.nvim | Quiet (~8mo), good nightly-fix track record | None found |
| mini.nvim | Very active | None |
| snacks.nvim | Active | None (min 0.9.4) |
| catppuccin/nvim | Active | None |
| lualine.nvim / nvim-web-devicons | Active | None |
| marks.nvim | **Stale 13+ months**, 56 open issues | None confirmed, but unmaintained — §7 |
| tabby.nvim | Active (patched deprecation warnings recently) | None |
| guess-indent.nvim | Quiet (~15mo) | None found, low-surface-area plugin |
| which-key.nvim | Active | None |
| kdheepak/lazygit.nvim | Active | None — redundant, see §6b |
| vim-floaterm | Active | None — redundant, see §6c |
| tmux.nvim | Active (incl. a snacks.nvim interop fix) | None |
| vim-tmux-navigator | Active | None |
| norcalli/nvim-colorizer.lua | **Dead since 2021** | None confirmed, but unmaintained — §6d |
| render-markdown.nvim | Active | None |
| copilot.vim | Active (official) | None |
| plenary.nvim | **Pending archival (Q2 2026)** | None now, but watch dependents — §7 |

---

## 6. Plugins to remove / consolidate

None of these are forced by the Neovim upgrade — they're independent cleanup opportunities the audit surfaced, several of which directly answer "what can the latest Neovim/what I already have replace."

### a. `telescope.nvim` (+ `telescope-fzf-native`, `telescope-ui-select`, `telescope-symbols`) → consolidate onto `snacks.picker`

This config runs **two complete fuzzy-finder stacks simultaneously**, and they collide on keybinds today, independent of any Neovim version:

- `<leader>sg`: telescope binds it to `live_grep` (`lua/plugins/editor/telescope.lua:97`), snacks binds it to `Snacks.picker.grep()` (`lua/plugins/editor/snacks.lua:289`). Same intent, different implementation — whichever loads last wins, silently.
- `<leader>sh` (help), `<leader>sk` (keymaps), `<leader>sd` (diagnostics), `<leader>sw` (grep word under cursor) are each bound by **both** plugins to equivalent-but-different pickers.
- `<leader>ss` is bound to *two different things*: telescope's "select a builtin picker" vs. snacks' "LSP symbols" — this one is a genuine functional conflict, not just duplication.

Snacks already covers everything telescope does here (files, grep, buffers, LSP references/definitions/symbols, git, diagnostics, undo history, etc.), and this config already leans on snacks for dashboard/explorer/terminal/notifier/zen. Recommend: drop `telescope.nvim` and its three extensions, then update the LSP-attach keymaps in `lua/plugins/coding/lsp.lua` (`grn`/`gra`/`grr`/`gri`/`grd`/`gO`/`gW`/`grt`) from `require('telescope.builtin').lsp_*` to the equivalent `Snacks.picker.lsp_*` calls already used in `lua/plugins/editor/snacks.lua`. This also removes a `plenary.nvim` dependent (one less thing to worry about when plenary's archival lands).

If you'd rather keep telescope as the *one* finder instead (e.g. you value `telescope-fzf-native`'s native matcher, or some other plugin only exposes a telescope picker extension), the inverse is just as valid: set `picker = { enabled = false }` in `lua/plugins/editor/snacks.lua` and keep telescope. Either direction is fine — running both is the only option that isn't.

### b. `kdheepak/lazygit.nvim` → `Snacks.lazygit()`

Both wrap the `lazygit` CLI in a floating window. `kdheepak/lazygit.nvim` is actively maintained (not a staleness issue), but it's pure duplication: `lua/plugins/editor/lazygit.lua` binds `<leader>lg`, and `lua/plugins/editor/snacks.lua:563` already binds `<leader>gg` to `Snacks.lazygit()`. Drop the dedicated plugin, optionally re-bind `<leader>lg` to `Snacks.lazygit()` if you want to keep that muscle memory.

### c. `voldikss/vim-floaterm` → `Snacks.terminal()`

Same pattern: `vim-floaterm` is actively maintained, but `lua/keymaps.lua:11-15` (`to`/`tt`/`tp`/`tn`/`tk`) duplicates what `Snacks.terminal()` already provides at `<c-/>` (`lua/plugins/editor/snacks.lua:577`). Snacks' terminal supports multiple named/toggleable terminal instances, so the floaterm-specific next/prev semantics aren't actually unique. Consolidate onto Snacks and drop floaterm if you don't have a floaterm-specific feature you rely on that snacks lacks.

### d. `norcalli/nvim-colorizer.lua` → `catgoose/nvim-colorizer.lua` or `mini.hipatterns`

Confirmed dead: last commit 2021-04-29, 68 unaddressed open issues. Two real options:
- Swap to **`catgoose/nvim-colorizer.lua`**, an actively maintained fork (pushed 2026-06-10) that's a drop-in replacement for the same config shape currently in `lua/plugins/ui/colorizer.lua`.
- Or drop the dependency entirely: `mini.nvim` (already installed) has a **`mini.hipatterns`** module that does pattern-based highlighting and is commonly configured for hex/CSS color highlighting via `MiniHipatterns.gen_highlighter.hipatterns()`. This avoids adding a new plugin and uses something already in the config.

Given this config already centers a lot of its editing UX on `mini.nvim` modules, `mini.hipatterns` is the tighter fit; the `catgoose` fork is the lower-effort, closer-to-current-config swap.

### e. `folke/which-key.nvim` → `mini.clue` (optional, low priority)

`which-key.nvim` is healthy and well-maintained — this is purely a "you already have the dependency" consolidation, not a maintenance fix. `mini.nvim` ships a **`mini.clue`** module that does the same job (show pending keybind popups, with built-in clue sets for `g`/`z`/marks/registers). Worth considering only if reducing plugin count matters more than the cost of re-porting the `spec` groups currently defined in `lua/plugins/utils/which-key.lua`.

### f. `LuaSnip` → native `vim.snippet` (optional, low priority)

`LuaSnip` is only used here as `blink.cmp`'s snippet backend (`snippets = { preset = 'luasnip' }` in `lua/plugins/editor/blink.lua:161`) — there's no custom snippet authoring in this config. `blink.cmp` supports a `'default'` snippets preset backed by Neovim's native `vim.snippet` API directly, which would let you drop the `LuaSnip` dependency (and its `make install_jsregexp` build step) entirely. Native snippets only support basic tabstops/placeholders (no choice/dynamic nodes), but since nothing here uses those, there's likely no loss. Skip this if you anticipate writing custom snippets later.

---

## 7. Plugins to watch but not act on yet

- **`typescript-tools.nvim`** — maintenance has slowed (single maintainer, ~7-month gaps between merges, recurring "is this dead?" issues), but it's not abandoned and there's no forced break. The community's common fallback is `vtsls` or plain `ts_ls`, both configured via `nvim-lspconfig` instead of this dedicated plugin. Worth a deliberate decision later, not an urgent migration now.
- **`marks.nvim`** — last commit 2025-05-13 (13+ months), 56 open issues including unresolved interactions with `vim.diagnostic.open_float` and `vim.lsp.buf.format`. No confirmed 0.12 break, but if something does regress here, no one is fixing it. Candidate for replacement if marks-gutter functionality becomes flaky after upgrading.
- **`plenary.nvim`** — a merged upstream PR added a README notice that it will be archived in Q2 2026 (i.e., effectively now). It underpins `telescope.nvim`, `lazygit.nvim`, `todo-comments.nvim`, and `typescript-tools.nvim` in this config. Archived ≠ broken today, but none of those dependents will get plenary-side fixes going forward — worth re-checking in 6-12 months whether they've migrated off it.
- **`telescope-ui-select.nvim`** / **`telescope-symbols.nvim`** — quiet since mid-2024, but small and feature-complete, not flagged as broken. Moot if you act on §6a.

---

## 8. Why not switch lazy.nvim → vim.pack right now

Neovim 0.12 does ship a native plugin manager, `vim.pack` (`vim.pack.add/update/del/get`), and the user's instinct that it could replace something here is reasonable — but it's not a good fit for migrating *this* config today:

- **No declarative lazy-loading.** `vim.pack.add()` loads plugins essentially immediately; there's no equivalent to lazy.nvim's `event=`/`cmd=`/`ft=`/`keys=` spec fields, which this config uses extensively (e.g. `conform.nvim`'s `event = { 'BufWritePre' }`, `lazygit.nvim`'s `keys = {...}`, `trouble.nvim`'s `cmd = 'Trouble'`). Replicating that means hand-rolling autocmd-based lazy-loading per plugin — even Neovim's own maintainers have acknowledged this gap publicly.
- **No declarative build hooks.** This config relies on `build = ':TSUpdate'` (treesitter) and `build = 'make'` (telescope-fzf-native, if kept) and LuaSnip's conditional `make install_jsregexp` step. `vim.pack` has no `build` field — you'd wire `PackChanged`/`PackChangedPre` autocmds and shell out yourself.
- **No `:Lazy`-style UI or profiler.** `vim.pack.update()` opens a plain diff-confirmation buffer; there's nothing like `:Lazy` or `:Lazy profile` for browsing plugins or diagnosing startup time.
- It does have a lockfile (`nvim-pack-lock.json`, analogous to `lazy-lock.json`) and is described in its own docs as "experimental, yet should be stable enough for daily use" — so it's a fine choice for a *new*, minimal config, but migrating ~40 plugins with the lazy-loading/build patterns already in place here would be a regression in capability, not a simplification.

**Recommendation**: keep lazy.nvim. Revisit only if `vim.pack` later adds lazy-loading triggers, which is the actual blocker.

---

## 9. Step-by-step execution plan

1. **Backup** — run the `tar` backup in [§1](#1-pre-flight-backup). Confirm `git status` is clean in this repo (it is, as of this plan).
2. **Upgrade the binary**: `brew upgrade neovim` (installs 0.12.3; old keg stays in Cellar until `brew cleanup`). Verify: `nvim --version`.
3. **Don't open your real config yet.** First sanity-check the new binary launches at all: `nvim --clean`.
4. **Migrate `nvim-treesitter`** ([§2](#2-the-one-real-blocker-nvim-treesitter)) in `lua/plugins/coding/highlights.lua` — switch branch to `main`, rewrite to the new API, confirm against the live README at execution time.
5. **Modernize LSP setup** ([§3](#3-lsp-setup-modernization-recommended)) in `lua/plugins/coding/lsp.lua` — move off `require('lspconfig')[server].setup()` to `vim.lsp.config()`/`vim.lsp.enable()`.
6. **Decide on the consolidations in [§6](#6-plugins-to-remove--consolidate)** — at minimum, resolve the telescope/snacks keymap collision (§6a) one way or the other, since that's an active bug, not just tidiness. The lazygit/floaterm/colorizer/which-key/LuaSnip items are independent and can be done incrementally.
7. **Launch real config**: `nvim`, let `lazy.nvim` sync (`:Lazy sync`), watch for errors on startup and on `:checkhealth`.
8. **Run `:checkhealth`** — specifically `:checkhealth nvim-treesitter`, `:checkhealth lsp`, `:checkhealth mason`, `:checkhealth vim.lsp` (if exposed) to catch anything the manual pass missed.
9. **Smoke-test the workflow checklist in [§11](#11-post-upgrade-verification-checklist)**.
10. Once stable for a few days of real use, `brew cleanup` to reclaim the old keg, and commit the config changes.

---

## 10. Rollback plan

- **Binary**: `brew upgrade` removed the old 0.11.4 keg immediately — there was no `brew cleanup` buffer to fall back on. `brew list --versions neovim` / `ls $(brew --cellar)/neovim` confirm only `0.12.3` remains. Rolling back the binary means reinstalling the old version from scratch, e.g. `brew install neovim@0.11` if a versioned formula exists, or `brew extract --version=0.11.4 neovim homebrew/cask` (or checking out the old formula revision and `brew install` from that) followed by `brew link --overwrite`. There is no quick `brew switch`/relink path anymore.
- **Config**: every change above lands as normal git commits in this repo — `git revert`/`git checkout` any commit to undo.
- **Plugin data**: restore `~/.local/share/nvim`, `~/.local/state/nvim`, `~/.cache/nvim` from the tarball in [§1](#1-pre-flight-backup) if a `:Lazy sync` or treesitter parser rebuild leaves things in a bad state.

---

## 11. Post-upgrade verification checklist

- [ ] `nvim --version` reports 0.12.3
- [ ] `:checkhealth` clean (or only pre-existing warnings)
- [ ] Syntax highlighting + indentation working on a Lua, TS/TSX, and Markdown file (treesitter migration sanity check)
- [ ] LSP attaches and `grn`/`gra`/goto-definition work on a TS file (typescript-tools or ts_ls) and a Lua file (lua_ls)
- [ ] Completion popup + signature help still appear while typing (blink.cmp)
- [ ] Formatting on save still works (conform.nvim)
- [ ] Git gutter signs + `<leader>gh*` hunk actions work (gitsigns)
- [ ] snacks.picker finds files/grep/buffers/LSP symbols without keymap weirdness (telescope.nvim removed)
- [ ] Dashboard, explorer, terminal (Snacks.terminal, vim-floaterm removed), zen mode all still open (snacks.nvim)
- [ ] Colorscheme renders correctly (catppuccin)
- [ ] `mini.clue` pending-keybind popup shows up for `<leader>`, `g`, `z`, etc. (which-key.nvim removed)
- [ ] `Snacks.lazygit()` opens via both `<leader>gg` and `<leader>lg` (kdheepak/lazygit.nvim removed)
- [ ] Snippet expansion still works via native `vim.snippet` in blink.cmp (LuaSnip removed)
- [ ] `catgoose/nvim-colorizer.lua` highlights colors in CSS and other filetypes (norcalli fork replaced)
