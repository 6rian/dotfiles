# Neovim

My config for Neovim 0.12: kickstart.nvim, split into lazy.nvim specs and
tuned for working next to a coding agent in another tmux pane. Buffers
reload when the agent edits files, gitsigns reviews a branch against its
base, and keys yank or send `path#L<n>` references to the agent.

## Where things live

| Want to change… | File |
|---|---|
| Startup order, leader, Node PATH fallback | `init.lua` → `keymaps`, `options`, `lazy-init`, `agent-review` |
| Which plugins load | `lua/plugins/init.lua` (commented-out imports are off) |
| An option | `lua/options.lua` |
| A general keymap | `lua/keymaps.lua` |
| Picker, git, terminal, toggle keys | `lua/plugins/editor/snacks.lua` |
| Hunk keys, review base | `lua/plugins/editor/gitsigns.lua` |
| LSP keys, servers, Mason tools, diagnostics | `lua/plugins/coding/lsp.lua` |
| Formatters | `lua/plugins/formatting/conform.lua` |
| Treesitter parsers | `lua/plugins/coding/highlights.lua` |
| Operators, mini.clue group labels | `lua/plugins/editor/mini.lua` |
| Agent keys, checktime, format-on-save toggles | `lua/agent-review.lua` |
| `<leader>tt`, lazygit `e` helpers | `lua/utils/` |

Not loaded: `lua/custom/` (incl. `plugins.bak/`), `lua/kickstart/`, `doc/kickstart.txt`,
and the commented-out specs in `plugins/` (avante, opencode, bufferline,
neo-tree, fine-cmdline, obsidian, the other colorschemes).

## Install

`install.sh` links `~/.config/nvim` → `nvim/`. lazy.nvim bootstraps itself
and installs plugins on first start; Mason installs the LSP servers and tools.

| Needs | For |
|---|---|
| Node (mise on the Mac, v24 on devbox) | Mason's JS-based servers, prettierd, copilot.vim. `init.lua` falls back to the newest `~/.nvm` Node if `node` isn't on PATH |
| `tree-sitter` CLI | Building parsers. On devbox it lives in `~/.cargo/bin`, which must be on PATH when a new parser is added |
| `lazygit` | `<leader>gg` |
| `gh` | The GitHub issue/PR pickers |

## Settings

Only the non-default, noteworthy ones (`lua/options.lua`):

- **ui2 is on** (`require('vim._core.ui2').enable()`): no "Press ENTER"
  prompts, highlighted cmdline, `:messages` in a pager.
- **`clipboard=unnamedplus`**, and over SSH `vim.g.clipboard = 'osc52'` (see below).
- **Treesitter folding:** `foldmethod=expr` with `vim.treesitter.foldexpr()`,
  `foldlevelstart=99`, so files open unfolded. `za` toggles a fold.
- **`winborder=rounded`:** every float without its own border (hover,
  diagnostics, blink, Mason, gitsigns preview, mini.clue) gets one rounded border.
- `fillchars` `diff:╱`: hatched filler lines in diff mode.
- Relative numbers, `cursorline`, `signcolumn=yes`, `scrolloff=10`,
  `showtabline=2`, `undofile`, `confirm`, `inccommand=split`, smartcase,
  2-space `expandtab` (guess-indent overrides per file), `updatetime=250`,
  `timeoutlen=300`.
- Diagnostics: sorted by severity, virtual text always shows the source,
  only errors are underlined.

## Noteworthy decisions

- **Clipboard over SSH is OSC 52.** Neovim writes and reads the Mac's
  clipboard through the terminal (Ghostty, through tmux). Paste needs
  Ghostty's `clipboard-read = allow` and tmux's `get-clipboard request`.
  Locally on macOS the pbcopy provider wins.
- **tmux.nvim's `copy_sync` is off.** It replaced `vim.g.clipboard` with
  tmux's paste buffer (so `p` never saw the system clipboard) and remapped
  `p`/`P`/`"`/`<C-r>`. tmux.nvim only does navigation and resizing.
- **`d`, `c`, `x` and `D`/`C`/`X` use the black-hole register.** Only yanks
  reach the clipboard, so deleting doesn't overwrite the Mac's clipboard.
- **The `gr` story.** mini.operators' replace used to be on `gr`. That deleted
  nvim's built-in `gr*` LSP maps and was itself shadowed by the buffer-local
  `grr`/`gri`/`grt`. Replace is now on `gR` (built-in virtual replace is
  lost), so the built-in `grn`/`gra`/`grx` work, and the LSP config overrides
  `grr`/`gri`/`grt` with Snacks pickers. Exchange is on `cx` (vim-exchange's
  convention), so `gx` opens URLs again.
- **Format on save can be toggled** per buffer (`<leader>uf`) or globally
  (`<leader>uF`), so saving an agent-written file doesn't reformat all of it.
  `swf` saves once without formatting.
- **prettierd comes from Mason** (`mason-tool-installer`), not Ansible or
  Homebrew. conform uses it for JS/TS(X), JSON, CSS, YAML and Markdown,
  falling back to prettier. Lua uses stylua.
- **Treesitter parsers are a fixed list** in `highlights.lua` (nvim-treesitter's
  `main` branch), not auto-installed. Add a language there.
- **Files changed on disk reload by themselves:** `:checktime` runs on
  `FocusGained`, `BufEnter`, `CursorHold` and `TermLeave`. A buffer you've
  modified warns instead.
- **lazygit's `e` opens the file in the window you came from**, not a new tab
  (custom `os.edit` in `snacks.lua` + `utils/lazygit.lua`).
- **`<leader>ghc` reviews against the base branch:** gitsigns diffs every
  buffer against the merge-base of `HEAD` and `origin/HEAD` (else `main`,
  else `master`), so commits that landed on the base later don't show up as
  reversed hunks. `<leader>ghC` goes back to the index.
- **`<leader>gB` copies the GitHub URL** (OSC 52) instead of opening a browser, which devbox lacks.
- **LSP:** typescript-tools handles TS/JS, so `ts_ls` is excluded; pyright
  only (`pylsp` excluded). mason-lspconfig enables every other installed server.

## Keymaps

Leader is `Space`. mini.clue pops up the possible next keys after
`<leader>`, `g`, `z`, `<C-w>`, marks and registers.

### Find and search (Snacks picker)

| Keys | Action |
|---|---|
| `<leader>F` | Smart find files |
| `<leader>ff` / `<leader>fg` / `<leader>fr` | Files / git files / recent files |
| `<leader>fc` / `<leader>fp` | Config files / projects |
| `<leader>,` or `<leader>fb` | Buffers |
| `<leader>/` or `<leader>sg` | Grep |
| `<leader>sw` | Grep word, or the selection (n, x) |
| `<leader>sb` / `<leader>sB` | Lines in this buffer / grep open buffers |
| `<leader>:` or `<leader>sc` | Command history |
| `<leader>sC` / `<leader>sk` / `<leader>sa` | Commands / keymaps / autocmds |
| `<leader>sh` / `<leader>sM` / `<leader>sp` | Help / man pages / plugin specs |
| `<leader>s"` / `<leader>s/` / `<leader>sj` / `<leader>sm` | Registers / search history / jumps / marks |
| `<leader>sl` / `<leader>sq` / `<leader>sd` / `<leader>sD` | Location list / quickfix / diagnostics / buffer diagnostics |
| `<leader>sH` / `<leader>si` / `<leader>su` | Highlights / icons / undo history |
| `<leader>sR` / `<leader>sP` | Resume last picker / list all pickers |
| `<leader>e` | File explorer (replaces netrw) |

### Buffers, windows, scratch

| Keys | Action |
|---|---|
| `<leader>bd` / `<leader>bo` | Delete buffer / delete all other buffers |
| `<leader>\|` / `<leader>-` | Vertical / horizontal split |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | Move between splits **and tmux panes** (tmux.nvim) |
| `<M-h>` `<M-j>` `<M-k>` `<M-l>` | n: resize split/pane (tmux.nvim). x: move the selection (mini.move) |
| `<M-C-h>` `<M-C-j>` `<M-C-k>` `<M-C-l>` | Swap with the neighbouring split (tmux.nvim) |
| `<leader>z` / `<leader>Z` | Zoom / zen mode |
| `<leader>.` / `<leader>S` | Toggle scratch buffer / pick a scratch buffer |
| `<leader>n` / `<leader>un` | Notification history / dismiss notifications |
| `<leader>N` | Neovim news |
| `<leader>tt` | Jump between a source file and its test/spec |

### Git

| Keys | Action |
|---|---|
| `<leader>gg` or `<leader>lg` | lazygit (float; `e` opens in the current window) |
| `<leader>gs` / `<leader>gb` / `<leader>gz` | Status / branches / stash pickers |
| `<leader>gl` / `<leader>gL` / `<leader>gf` | Log / log for this line / log for this file |
| `<leader>gD` | Diff (hunks) picker |
| `<leader>gi` / `<leader>gI` | GitHub issues: open / all |
| `<leader>gp` / `<leader>gP` | GitHub PRs: open / all |
| `<leader>gB` | Copy the GitHub URL of the file/selection (n, x) |
| `<leader>gdo` / `<leader>gdc` | diffview: uncommitted changes / close |
| `<leader>gdb` | diffview: this branch against a base (prompts, default `main`) |
| `<leader>gdh` / `<leader>gdH` | diffview: file history / repo history |

**gitsigns** (buffer-local in tracked files):

| Keys | Action |
|---|---|
| `]c` / `[c` | Next / previous hunk (diff mode: the built-in `]c`/`[c`) |
| `<leader>ghs` / `<leader>ghr` | Stage / reset hunk (n, or the selected lines in x) |
| `<leader>gS` / `<leader>gR` | Stage / reset buffer |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` / `<leader>ghB` | Blame line / blame the whole buffer |
| `<leader>gtb` | Toggle current-line blame |
| `<leader>ghw` | Toggle word diff |
| `<leader>ghq` / `<leader>ghQ` | Hunks → quickfix: buffer / all files (follows the base) |
| `<leader>ghc` / `<leader>ghC` | Diff against the base branch's merge-base / back to the index |
| `ih` | Hunk text object (o, x) |

### LSP and diagnostics

| Keys | Action |
|---|---|
| `grr` / `gri` / `grt` | References / implementations / type definition (Snacks pickers, buffer-local) |
| `grd` / `grD` | Definition (picker) / declaration |
| `gd` / `gD` / `gI` / `gy` | Same as above, global Snacks maps: definition / declaration / implementation / type |
| `grn` / `gra` / `grx` | Built-in: rename / code action (n, x) / run codelens |
| `gO` / `gW` | Document / workspace symbols (picker) |
| `<leader>ss` / `<leader>sS` | LSP symbols / workspace symbols |
| `<leader>ci` | Incoming calls |
| `<leader>th` | Toggle inlay hints (when the server supports them) |
| `]]` / `[[` | Next / previous reference to the word under the cursor (n, t) |
| `<leader>qd` / `<leader>qc` | Diagnostics → location list / close quickfix |
| `<leader>ld` / `<leader>lb` | Trouble: diagnostics / buffer diagnostics |
| `<leader>ls` / `<leader>ll` / `<leader>lq` | Trouble: symbols / LSP definitions+references / quickfix |
| `<leader>cR` | Rename the file (updates imports via LSP) |

### Point the agent at code

Paths are relative to the git root (works in linked worktrees), else the cwd.
Everything goes to `+`, so over SSH it lands in the Mac's clipboard.

| Keys | Action |
|---|---|
| `<leader>yf` | Yank `relpath#L<n>`; in x, `relpath#L<a>-L<b>` |
| `<leader>yp` | Yank the absolute path |
| `<leader>cc` | x: copy `relpath#L<a>-L<b>` plus the lines as a fenced code block |
| `<leader>ys` | Type `@relpath line N ` (x: `lines A-B `) into the last tmux pane, without Enter |

### Toggles (`<leader>u`)

| Keys | Action |
|---|---|
| `<leader>uf` / `<leader>uF` | Format on save: buffer / global |
| `<leader>ud` / `<leader>uh` / `<leader>uT` | Diagnostics / inlay hints / treesitter highlight |
| `<leader>ut` | Treesitter context (sticky scope header) |
| `<leader>us` / `<leader>uw` / `<leader>uc` | Spelling / wrap / conceal |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>ug` / `<leader>uD` / `<leader>ub` | Indent guides / dimming / dark background |
| `<leader>uC` | Colorscheme picker |

### Terminal

| Keys | Action |
|---|---|
| `<C-/>` (also `<C-_>`) | Toggle the Snacks terminal |
| `<leader>To` / `<leader>Tt` | Open a new floating terminal / toggle the current one |
| `<leader>Tn` / `<leader>Tp` / `<leader>Tk` | Next / previous / kill floating terminal |
| `<Esc><Esc>` | t: leave terminal mode |

### Editing

| Keys | Action |
|---|---|
| `jk` | i: leave insert mode |
| `<Esc>` | Clear search highlight |
| `x` `X` `d` `D` `c` `C` | Black-hole register (`x`, `d`, `c` in n and x) |
| `cx` / `cxx` | Exchange: mark a text object (`cxiw`), then the second one; they swap. x: `cx` |
| `gR` / `gRR` | Replace a text object / line with the register. x: `gR` |
| `g=` / `g==` | Evaluate (Lua) and replace. x: `g=` |
| `gm` / `gmm` | Duplicate. x: `gm` |
| `gs` / `gss` | Sort. x: `gs` |
| `gst` / `gsp` / `gsj` | Toggle / split / join arguments (mini.splitjoin, n, x) |
| `gx` | Built-in: open the URL or path under the cursor (n, x) |
| `<leader>f` | Format buffer (or selection) with conform |
| `swf` | Save without formatting (`noautocmd write`) |
| `<leader>xa` | Strip pasted ANSI escapes (`^[[27;5;106~`) and split the line there |
| `<leader>ca` / `<leader>cd` | Colorizer: attach / detach for this buffer |
| `<leader>ct` / `<leader>cr` | Colorizer: toggle / reload all buffers |

### Plugin default keys (not configured here)

| Plugin | Keys |
|---|---|
| mini.surround | `sa` add, `sd` delete, `sr` replace, `sf`/`sF` find, `sh` highlight (`l`/`n` suffix: previous/next) |
| mini.ai | `a`/`i` text objects, plus `an`/`in`/`al`/`il` (next/last); `g[`/`g]` jump to the edge of an `a` object |
| mini.bracketed | `[x`/`]x` back/forward and `[X`/`]X` first/last, for b(uffer), c(omment), d(iagnostic), f(ile), i(ndent), j(ump), l(ocation), o(ldfile), q(uickfix), t(reesitter), u(ndo), w(indow), x (conflict), y(ank) |
| marks.nvim | `m{a-z}` set, `m,` next free, `m;` toggle, `m]`/`m[` jump, `m:` preview, `m0`–`m9` bookmarks, `dm…` delete |
| copilot.vim | i: `<Tab>` accept, `<C-]>` dismiss, `<M-]>`/`<M-[>` next/previous, `<M-\>` suggest, `<M-Right>` accept word, `<M-C-Right>` accept line |

## Renamed keys

From the 2026-11 cleanup (dotfiles PRs #12 and #13), for muscle memory:

| Was | Now | Why |
|---|---|---|
| `<leader>gS` (stash picker) | `<leader>gz` | `<leader>gS` is gitsigns' stage buffer |
| `<leader>gd` (diff picker) | `<leader>gD` | `<leader>gd` is the diffview prefix |
| `<leader>q` (diagnostics) | `<leader>qd` | `<leader>q` is now the quickfix group |
| `to` `tt` `tn` `tp` `tk` | `<leader>To` `<leader>Tt` `<leader>Tn` `<leader>Tp` `<leader>Tk` | They hijacked the `t{char}` motion |
| `gx` `gxx` (exchange) | `cx` `cxx` | `gx` opens URLs again |
| `gr` `grr` (replace) | `gR` `gRR` | Frees the LSP `gr*` maps; loses virtual replace |
| global `gr` (references) | `grr` | The global `gr` was dead |

## Plugins

Generated from `require('lazy').plugins()`; dependencies included.

| Plugin | For |
|---|---|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [snacks.nvim](https://github.com/folke/snacks.nvim) | Picker, explorer, lazygit, terminal, notifier, dashboard, toggles, scratch, zen, gitbrowse, indent guides, smooth scroll, bigfile, words |
| [mini.nvim](https://github.com/echasnovski/mini.nvim) | ai, bracketed, clue (key hints), colors, icons, move, operators, splitjoin, surround |
| [blink.cmp](https://github.com/saghen/blink.cmp) | Completion: LSP, path, snippets, buffer, npm |
| [blink-cmp-npm.nvim](https://github.com/alexandre-abrioux/blink-cmp-npm.nvim) | npm package/version completion in `package.json` |
| [blink-cmp-tmux](https://github.com/mgalliou/blink-cmp-tmux) | Words from tmux panes. Configured but not in the default sources, so unused |
| [copilot.vim](https://github.com/github/copilot.vim) | Inline AI suggestions |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP configs: html, cssls, jsonls, tailwindcss, pyright, lua_ls |
| [mason.nvim](https://github.com/mason-org/mason.nvim), [mason-lspconfig.nvim](https://github.com/mason-org/mason-lspconfig.nvim), [mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim) | Install the servers plus stylua and prettierd; enable installed servers |
| [typescript-tools.nvim](https://github.com/pmizio/typescript-tools.nvim) | TS/JS language server (tsserver), instead of ts_ls |
| [lazydev.nvim](https://github.com/folke/lazydev.nvim) | Neovim API types for lua_ls (spec in `lazy-init.lua`) |
| [fidget.nvim](https://github.com/j-hui/fidget.nvim) | LSP progress messages |
| [conform.nvim](https://github.com/stevearc/conform.nvim) | Formatting and format on save |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Parsers, highlighting, indent (`main` branch) |
| [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) | Sticky header showing the current scope |
| [nvim-ts-autotag](https://github.com/windwp/nvim-ts-autotag) | Auto-close and auto-rename HTML/JSX tags |
| [trouble.nvim](https://github.com/folke/trouble.nvim) | Diagnostics/symbols/quickfix lists (`<leader>l…`) |
| [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) | Highlights `TODO`/`FIX`/`NOTE` comments |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Git signs, hunks, blame, review base |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | Side-by-side diffs and file history |
| [tmux.nvim](https://github.com/aserowy/tmux.nvim) | `<C-hjkl>` across splits and panes, `<M-hjkl>` resize |
| [guess-indent.nvim](https://github.com/NMAC427/guess-indent.nvim) | Detects each file's indentation |
| [marks.nvim](https://github.com/chentoast/marks.nvim) | Shows marks in the sign column |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Statusline |
| [tabby.nvim](https://github.com/nanozuki/tabby.nvim) | Tabline: tabs on the left, the tab's windows on the right |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Renders Markdown in the buffer |
| [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) | Colors hex/CSS color values |
| [xeno.nvim](https://github.com/kyzabuilds/xeno.nvim) | Active colorscheme: generates `xeno-cyberpunk-v2` (matches tmux/Ghostty) |
| [catppuccin](https://github.com/catppuccin/nvim) | Alternative colorscheme, not active (pick it with `<leader>uC`) |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons), [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) | Dependencies (lualine; todo-comments, typescript-tools) |

## Gotchas

- **`c` and `d` are mapped and are also prefixes** (`cx`, marks' `dm`), so
  after a bare `c`/`d` Neovim waits for `timeoutlen`. It only shows if you
  pause after the key.
- **mini.bracketed's `]c`/`[c` (comments)** are shadowed by gitsigns' hunk
  jumps in tracked files.
- **`<M-hjkl>` in normal mode** is claimed by both tmux.nvim (resize) and
  mini.move (move line); which wins varies between startups.
- **`gs` (sort) is also the prefix of `gst`/`gsp`/`gsj`**, so a bare `gs`
  waits for `timeoutlen` (300 ms).
