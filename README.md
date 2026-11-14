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

## Features

| Area | Plugin | What you get |
| --- | --- | --- |
| Theme | rose-pine (v1) | dark rose-pine with transparent background and statusline |
| Statusline | lualine | defaults: mode, git branch, file info, cursor position |
| File tree | nvim-tree | `<C-o>` to toggle, `<leader>r` to refresh, git and diagnostic icons |
| Fuzzy find | telescope | files, live grep, git files, recent files, buffer, diagnostics, keymaps; skips `vendor/` and `node_modules/` at the source |
| Syntax | nvim-treesitter (`main`) | highlighting for the parsers listed in `lua/treesitter.lua` |
| Folding | treesitter | `foldmethod=expr`, starts unfolded (`foldlevel=99`), `zR`/`zM` work |
| Language servers | nvim-lspconfig + mason | 15 servers preconfigured, installed through mason |
| Completion | nvim-cmp + vsnip | LSP, snippet, path and buffer sources, signature help |
| Git hunks | gitsigns | signs, hunk navigation, stage/reset/preview, blame line, file diff |
| Git review | diffview | whole working-tree diff, file history, tree-style file panel |
| Comments | NERDCommenter | `<leader>c*` mappings, works in normal and visual mode |
| Pairs and tags | nvim-autopairs, vim-closetag, nvim-ts-autotag | auto-close brackets and HTML/JSX tags, rename matching tags on edit |
| Surround | vim-surround | `ys`, `cs`, `ds`, visual `S` |
| HTML expansion | emmet-vim | `<C-y>,` expands abbreviations |
| Formatting | LSP + neoformat | format-on-save for go/rust/ts/js/lua, `:Neoformat` on demand |
| Diagnostics | built-in LSP | virtual text, signs, floats, loclist |
| Terminals | vim-floaterm | `:FloatermNew`, `:FloatermToggle`, `:FloatermKill` |
| Color preview | nvim-colorizer | hex/rgb colors highlighted in all buffers |
| Scrolling | neoscroll | smooth `<C-u>`/`<C-d>`/`<C-b>`/`<C-e>`/`<C-y>` and `zt`/`zz`/`zb` (`<C-f>` is taken by telescope here) |
| Todos | todo-comments | highlights TODO/FIXME/HACK/NOTE comments |
| Markdown | markdown-preview | `:MarkdownPreview` / `:MarkdownPreviewStop` in markdown buffers |
| Language extras | go.nvim, rust.vim, idris2-nvim, vlime | Go commands, rustfmt, Idris2 and Common Lisp support |
| Discord presence | presence.nvim | only loads when a Discord socket exists |
| Habit guard | hardtime.nvim | warns on repeated hjkl and arrow-key spam |

## Keymaps

`<leader>` is `\`. `<C-k>` opens `:Telescope keymaps`, which lists everything
active at runtime, including plugin defaults not repeated here (Neovim 0.12 also
ships its own `[`/`]` defaults, see `:help default-mappings`).

### Files and search

| Key | Action |
| --- | --- |
| `<C-o>` | toggle the file tree |
| `<leader>r` | refresh the file tree |
| `<leader>ff` | find files |
| `<leader>fg` | live grep |
| `<leader>gf` | git files |
| `<leader>rf` | recent files |
| `<leader>hl` | telescope highlights |
| `<C-f>` | fuzzy find in the current buffer |
| `<C-k>` | telescope keymaps |
| `<leader>dd` | telescope diagnostics (whole project) |

### Git and review

| Key | Action |
| --- | --- |
| `]c` / `[c` | next / previous hunk |
| `<leader>hp` | preview the hunk under the cursor |
| `<leader>hs` | stage the hunk (visual mode: stage the selection) |
| `<leader>hr` | reset the hunk |
| `<leader>hb` | blame the current line (full) |
| `<leader>hd` | diff the current file |
| `<leader>tb` | toggle inline blame |
| `<leader>gd` | diffview: review the whole working-tree diff |

### Editing

| Key | Action |
| --- | --- |
| `<C-s>` | write, in normal and insert mode |
| `H` / `L` | previous / next tab |
| `<leader>ct` | new tab |
| `<leader>vr` | widen the current vertical split by 10 |
| `<F4>` | clear search highlighting (`:noh`) |
| `<leader>cc` | comment line/selection (NERDCommenter) |
| `<leader>cu` | uncomment |
| `<leader>ci` | toggle comment |
| `<leader>cs` | "sexy" comment (boxed) |
| `<leader>cn` | nested comment |
| `<leader>cy` | yank and comment |
| `<leader>c<space>` | toggle comment |
| `<C-y>,` | expand emmet abbreviation |
| `<C-y>;` | expand word as emmet abbreviation |
| `<C-y>n` / `<C-y>N` | next / previous emmet edit point |
| `<C-y>u` | update the tag at the cursor |
| `<C-y>a` / `<C-y>A` | anchorize URL / anchorize summary |
| `<C-y>k` | remove the tag |
| `<C-y>j` | split/join tag |
| `<C-y>m` | merge lines |
| `<C-y>i` | update image size |
| `<C-y>d` / `<C-y>D` | balance tag inward / outward |
| `<C-y>/` | toggle the comment of the tag |

### LSP

| Key | Action |
| --- | --- |
| `gd` | go to definition |
| `gD` | go to declaration |
| `gi` | go to implementation |
| `gr` | references |
| `gv` | go to definition (was Lspsaga's preview) |
| `K` / `gb` | hover documentation |
| `<C-k>` (insert) | signature help |
| `<space>rn` | rename symbol |
| `<space>ca` / `<C-t>` | code actions (visual `<C-t>`: range code actions) |
| `<space>f` | format buffer |

### Diagnostics

| Key | Action |
| --- | --- |
| `[d` / `]d` | previous / next diagnostic |
| `[e` / `]e` | previous / next diagnostic (same, kept from Lspsaga) |
| `<space>e` | diagnostic float for the current line |
| `gs` | diagnostic float (same as above) |
| `<space>q` | send diagnostics to the loclist |
| `<leader>dd` | all project diagnostics in telescope |

### Completion (insert mode)

| Key | Action |
| --- | --- |
| `<C-Space>` | trigger completion |
| `<CR>` | confirm the selected item |
| `<Tab>` / `<S-Tab>` | next / previous item, or the usual tab |
| `<C-e>` | abort completion |
| `<C-b>` / `<C-f>` | scroll the documentation window |
| `<C-k>` | signature help |

Format on save is enabled for `go`, `rust`, `typescript`, `javascript` and `lua`
through the LSP (see `autoformat_filetypes` in `lua/lsp.lua`).

## Commands worth knowing

| Command | Purpose |
| --- | --- |
| `:Lazy` | plugin manager UI (sync, update, clean, profile) |
| `:Mason` | language server and tool installer |
| `:checkhealth` | verify the whole setup |
| `:TSUpdate` | update treesitter parsers |
| `:NvimTreeToggle` | file tree |
| `:Telescope` | pickers (files, grep, diagnostics, keymaps, ...) |
| `:DiffviewOpen`, `:DiffviewFileHistory`, `:DiffviewClose` | diff views |
| `:Gitsigns` | gitsigns actions and status |
| `:Neoformat` | format the buffer with an external formatter |
| `:FloatermNew`, `:FloatermToggle`, `:FloatermKill` | floating terminals |
| `:MarkdownPreview`, `:MarkdownPreviewStop`, `:MarkdownPreviewToggle` | markdown preview (markdown buffers) |
| `:ColorizerToggle`, `:ColorizerAttachToBuffer` | color highlighting |
| `:TransparentToggle`, `:TransparentEnable`, `:TransparentDisable` | background transparency |

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
- Telescope and nvim-tree exclude `vendor/` and `node_modules/`. Telescope does it
  with `--glob` so ripgrep never walks those trees; filtering results afterwards
  would still pay the scan, which is what makes large projects lag.
- Plugins live in `stdpath("data")/lazy`, shared with any other Neovim config on
  this machine (a LazyVim setup also uses that directory). Run this config under
  its own `NVIM_APPNAME` if you want the two to stop sharing plugin clones.
