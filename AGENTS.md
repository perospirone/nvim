# AGENTS.md

Personal Neovim configuration (lazy.nvim). No build step, test suite, CI, or
Makefile: "correct" means Neovim starts with no Lua errors and the intended
behavior appears at runtime.

## Verification

`luac -p` is the only offline check; Neovim 0.11+ is required
(`vim.lsp.config` / `vim.lsp.enable` in `lua/lsp.lua`; 0.12.6 here).

```sh
luac -p init.lua lua/*.lua     # parse-only syntax check
```

To exercise the real config without touching `~/.config/nvim` (which on this
machine is a separate LazyVim install) point Neovim at a throwaway state dir and
symlink the repo in as the config dir:

```sh
mkdir -p /tmp/nvtest/config && ln -sfn "$PWD" /tmp/nvtest/config/nvim
export XDG_DATA_HOME=/tmp/nvtest/data XDG_STATE_HOME=/tmp/nvtest/state \
       XDG_CACHE_HOME=/tmp/nvtest/cache XDG_CONFIG_HOME=/tmp/nvtest/config \
       GIT_TERMINAL_PROMPT=0 GIT_ASKPASS=/bin/true
nvim --headless "+Lazy! sync" +qa < /dev/null   # first run only, installs plugins
nvim --headless +qa < /dev/null                 # startup errors show up on stderr
nvim --headless "+Lazy! load all" +qa < /dev/null   # force-loads every lazy plugin
```

`nvim -u init.lua` does **not** work for testing: `-u` sets the vimrc but does not
add the repo to `runtimepath`, so `require("plugins")` fails. The symlink is what
makes `require` resolve.

Pass `GIT_TERMINAL_PROMPT=0` and `</dev/null` when testing. A dead plugin URL or a
missing credential helper otherwise blocks the run on an interactive password
prompt; never provide credentials for these installs.

Headless runs skip mason installs on purpose: `mason-lspconfig` guards
`ensure_installed` behind `not platform.is_headless`, so an empty
`stdpath("data")/mason/packages` in a headless test is expected, not a bug.
Treesitter parser installs are asynchronous, so a headless run that exits
immediately installs nothing; wait for it (`vim.wait`) before judging.

## Layout

| File | Responsibility |
| --- | --- |
| `init.lua` | leader, vimscript plugin globals, lazy.nvim bootstrap, loads the modules |
| `lua/options.lua` | options and autocmds |
| `lua/plugins.lua` | the entire lazy.nvim spec, one returned list |
| `lua/lsp.lua` | nvim-cmp setup, LSP capabilities/servers/diagnostics, LSP keymaps |
| `lua/treesitter.lua` | parser list + per-buffer `vim.treesitter.start` |
| `lua/keybinds.lua` | non-LSP keymaps |
| `lua/theme.lua` | rose-pine config, called from the rose-pine plugin spec |
| `lua/foldconfig.lua` | treesitter folding |
| `AGENTS.md` | conventions and gotchas for this repo |
| `AI_WORKFLOW.md` | review process for agent-written changes |
| `ROADMAP.md` | ideas that are documented but not installed |

Load order matters: `init.lua` sets `vim.g.*` globals **before**
`require("lazy").setup(...)` because vimscript plugins (`vim-closetag`) read them
as they load. Plugins with `config` hooks (`theme`, `lsp`, `treesitter`, `gitsigns`)
are initialized by lazy, so those modules are *not* `require`d directly from
`init.lua`.

## Gotchas

- **lazy.nvim spec fields differ from packer's.** `as`, `run`, and `rtp` do not
  exist in lazy.nvim and unknown keys are *silently ignored*. Use `name`, `build`,
  and an `init` that appends to `runtimepath`. `vlime` needs exactly that trick
  (`vim/` subdirectory). `rose-pine` uses `name = "rose-pine"`.
- **rose-pine is pinned to `version = "^1"`** because `lua/theme.lua` uses the v1
  API (`dark_variant`, `groups.border`). v2/v3 renamed those options, so
  dropping the pin changes the theme silently rather than erroring.
- **nvim-treesitter follows `branch = "main"`.** `main` (= 0.12+) has no
  `require("nvim-treesitter.configs")`, no `highlight`/`auto_install` options and
  does not start highlighting by itself; `lua/treesitter.lua` installs parsers
  with `require("nvim-treesitter").install{...}` and starts the highlighter from
  a `FileType` autocmd. `master` is locked to Neovim <= 0.11, and plugins written
  against it (`nvim-treesitter.ts_utils`, `configs`) fail here. Folding uses the
  builtin `v:lua.vim.treesitter.foldexpr()`, not `nvim_treesitter#foldexpr()`.
- **`stdpath("data")` is shared with another config.** `~/.config/nvim` used to
  be a LazyVim install and its `~/.local/share/nvim/lazy` clones are still what
  lazy.nvim reuses. That is why a `branch`/`version` pin can appear ignored: the
  existing clone wins. A `lazy-lock.json` was deliberately not committed, because
  restoring it here would also downgrade the other config's plugins. Use
  `NVIM_APPNAME` to fully separate the two.
- **Two keymap helpers share a name.** `lua/keybinds.lua` defines global `map`,
  `nmap`, `nimap` using `vim.keymap.set` (they accept Lua function rhs, and
  did not before). `lua/lsp.lua` defines a *local* `map` with the same shape.
  Adding a mapping in `lua/lsp.lua` uses the local one; anywhere else uses the
  globals.
- **Adding an LSP server takes two edits**: the `servers` list in `lua/lsp.lua`
  (enables it) and `ensure_installed` in `lua/plugins.lua` (installs it via mason).
  The lists are intentionally duplicated; keep them in sync. Only
  `autoformat_filetypes` in `lua/lsp.lua` (`go`, `rust`, `typescript`,
  `javascript`, `lua`) get format-on-save, and `ts_ls` formatting is disabled
  there on purpose.
- **Removed on purpose, do not re-add**: `packer.nvim` (unmaintained; the
  committed `plugin/packer_compiled.lua` had another machine's absolute paths),
  `phaazon/mind.nvim` (repository deleted, so cloning it triggers a GitHub auth
  prompt), `wakatime` (explicitly removed by the owner), `impatient.nvim`,
  `nvim-lsp-installer`, `tami5/lspsaga.nvim` (archived fork; `[e`/`]e`/`gs`/`gb`/`gv`
  now use native `vim.diagnostic` / `vim.lsp.buf`), `lsp-status.nvim`,
  `lsp-colors.nvim`, `trouble.nvim` (unused: its keymap was commented out),
  `xit.nvim` (requires `nvim-treesitter.ts_utils`, which the `main` branch removed),
  `vim-gitgutter` and `blamer` (both shell out to `git` synchronously, blamer on
  every `CursorMoved` after a 500 ms debounce; gitsigns replaces them), and
  `vim-visual-multi` (unused, and its defaults occupy the leader namespace).
- **gitsigns ships no default keymaps** in the installed version: `]c`/`[c` and
  the `<leader>h*` maps are defined in its `on_attach` in `lua/plugins.lua`. It is
  `lazy = false` on purpose, because loading it on `BufReadPre` registers the
  attach autocmds too late for the first buffer opened from the command line.
- **Never run a headless test that modifies a tracked buffer.** `vim.o.confirm`
  is on, so `+qa` answers the "save changes?" prompt with yes and writes the
  buffer. Use a scratch file under `/tmp` when exercising buffer mutations.
- **Directory exclusions live in two places.** Telescope (`--glob` in
  `vimgrep_arguments` and `find_files.find_command`) and nvim-tree
  (`filters.custom`) both skip `vendor/` and `node_modules/`. Add a new excluded
  directory to both. For telescope use `--glob`: post-filtering with
  `file_ignore_patterns` still lets ripgrep walk the tree, which is what froze
  the editor in projects with a large `vendor/`.
- **`presence.nvim` is gated** by a `cond` that checks for the Discord socket, so
  it stays silent when Discord is not running. Do not remove the gate: the
  plugin otherwise logs a connection error on every startup.
- **`vim.tbl_flatten is deprecated` on startup comes from plugins**
  (`lsp_signature`, `nvim-colorizer`, `nvim-autopairs`), not from these files.
  It is not a reason to edit the config.
- Formatting-on-save is client-driven: the `BufWritePre` autocmd is created in
  `on_attach`. A server that attaches without `textDocument/formatting`, or a
  filetype outside the whitelist, simply never formats.

## Conventions

- 2-space indent, double quotes in Lua modules; `lua/keybinds.lua` still uses the
  original single-quote style, match the file you are editing.
- `vim.o` / `vim.opt` / `vim.api` over `vim.cmd`; `vim.cmd` only for highlights,
  `colorscheme`, and legacy `let g:` syntax. `vim.o.winborder = "rounded"`
  replaces the old per-handler border tables for all floating windows.
- Prefer lazy-loading (`event`, `ft`, `cmd`, `keys`) for plugins that are not
  needed at startup; `lazy = false` is reserved for the theme, cmp, lspconfig,
  treesitter, colorizer, neoscroll and gitsigns, which must be active
  immediately.
- User-facing documentation (keymap table, install steps) lives in `README.md`;
  keep it in sync when adding keymaps or servers. Uninstalled ideas go to
  `ROADMAP.md`, never straight into `lua/plugins.lua`.
