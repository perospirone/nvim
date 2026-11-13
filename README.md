# Neovim Configuration

A small, keyboard-driven Neovim setup: rose-pine theme, telescope, nvim-tree,
treesitter, native LSP (Neovim 0.12+) with nvim-cmp, gitsigns for review, and
lazy.nvim for plugins.

## Requirements

- Neovim **0.12 or newer**. `lua/lsp.lua` uses `vim.lsp.config` / `vim.lsp.enable`
  (0.11+) and `lua/treesitter.lua` targets the `main` branch of nvim-treesitter,
  which requires 0.12.
- `git`, `node`/`npm` (markdown-preview), `rg` and `fd` (telescope search),
  `tree-sitter` CLI >= 0.26.1 and a C compiler (parser builds).
- A Nerd Font for the completion and devicon glyphs.

## Installation

```sh
mv ~/.config/nvim ~/.config/nvim.bak   # if you already have a config
git clone https://github.com/perospirone/nvim ~/.config/nvim
nvim                                   # lazy.nvim bootstraps and installs everything
```

First start downloads plugins plus the treesitter parsers listed in
`lua/plugins.lua`, and mason installs the language servers in the background.
`:Lazy` opens the plugin UI, `:Mason` the server UI, `:checkhealth` verifies
everything.

## Layout

| File | Responsibility |
| --- | --- |
| `init.lua` | leader, plugin globals, lazy.nvim bootstrap, loads the modules below |
| `lua/options.lua` | global options, autocmds |
| `lua/plugins.lua` | lazy.nvim spec (all plugins, one list) |
| `lua/lsp.lua` | nvim-cmp, LSP capabilities, server list, diagnostics, LSP keys |
| `lua/keybinds.lua` | non-LSP keymaps |
| `lua/treesitter.lua` | parser list and per-buffer highlighting |
| `lua/theme.lua` | rose-pine configuration and transparent highlights |
| `lua/foldconfig.lua` | treesitter folding |

## Other docs

| File | Contents |
| --- | --- |
| `AGENTS.md` | conventions and gotchas for an agent working on this repo |
| `AI_WORKFLOW.md` | how to review work done by a coding agent |
| `ROADMAP.md` | ideas that are not installed, e.g. multi-cursor |

## Keymaps

`<leader>` is `\`. The same list is available at runtime with `<C-k>`.

| Key | Action |
| --- | --- |
| `<C-s>` | write (normal + insert) |
| `<C-o>` | toggle nvim-tree |
| `<leader>r` | refresh nvim-tree |
| `<C-f>` | fuzzy find in buffer |
| `<C-t>` | code actions (visual: range code actions) |
| `<leader>ff` / `<leader>fg` | find files / live grep |
| `<leader>gf` / `<leader>rf` | git files / recent files |
| `<leader>hl` | telescope highlights |
| `<C-k>` | telescope keymaps |
| `<leader>dd` | telescope diagnostics (all files) |
| `<leader>gd` | diffview: review the working tree diff |
| `]c` / `[c` | next / previous git hunk |
| `<leader>hp` / `<leader>hs` / `<leader>hr` | preview / stage / reset hunk (visual: stage selection) |
| `<leader>hb` / `<leader>hd` / `<leader>tb` | blame line / diff this file / toggle inline blame |
| `H` / `L` | previous / next tab |
| `<leader>ct` | new tab |
| `gd` / `gD` / `gi` / `gr` | definition / declaration / implementation / references |
| `K`, `gb`, `gv` | hover, hover, definition |
| `<space>rn` / `<space>ca` | rename / code action |
| `<space>f` | format buffer |
| `[d` / `]d`, `[e` / `]e` | previous / next diagnostic |
| `<space>e` / `<space>q`, `gs` | diagnostic float / loclist / line float |
| `<C-k>` (insert) | signature help |

Format on save is enabled for `go`, `rust`, `typescript`, `javascript` and `lua`
through the LSP (see `autoformat_filetypes` in `lua/lsp.lua`).

## Adding a language server

1. Add the server name to the `servers` list in `lua/lsp.lua` (this enables it).
2. Add the same name to `ensure_installed` in `lua/plugins.lua` (this installs it).
3. Restart, or run `:MasonInstall <server>` and `:Lazy reload nvim-lspconfig`.

Server-specific settings belong in `after/lsp/<server>.lua` or a
`vim.lsp.config("<server>", {...})` call, not in this repo's plugin spec.

## Notes

- `nvim-treesitter` follows the `main` branch. There is no
  `require("nvim-treesitter.configs").setup` anymore: parsers are installed with
  `require("nvim-treesitter").install{...}` and highlighting is started per
  buffer in `lua/treesitter.lua`. The old `master` branch is locked to Neovim
  <= 0.11 and cannot be mixed with a `main` checkout.
- Formatting providers are deliberately disabled for `ts_ls`.
- Plugins live in `stdpath("data")/lazy`, shared with any other Neovim config on
  this machine (a LazyVim setup also uses that directory). Run this config under
  its own `NVIM_APPNAME` if you want the two to stop sharing plugin clones.
