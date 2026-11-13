# Roadmap / ideas

Things worth considering, none of them applied. Add your own as they come up.

## Multi-cursor

Removed in `39b87e6` because it was unused and its default mappings lived in the
leader namespace (`\\A`, `\\/`, `\\gS`). Re-add when you actually want it:

```lua
{ "mg979/vim-visual-multi", lazy = false },
```

Key usage if you do: `<C-n>` adds a cursor at the next match of the word under
the cursor (`n`/`N` to step, `q` to leave multi-cursor mode), `<C-Down>`/`<C-Up>`
stack cursors vertically, and in visual mode `\a` adds a cursor per line, `\A`
one per occurrence, `\c` block cursors, `\/` regex. Alternatives worth a look:
`brenton-leighton/multiple-cursors.nvim` (smaller, no leader squatting),
`jake-stewart/multicursor.nvim`.

## Worth doing

- **`which-key.nvim`**: the keymap list is growing; this makes `<leader>` and
  `[`/`]` prefixes discoverable instead of memorised. Fits a keyboard-driven
  setup better than any keymap cheatsheet.
- **Space leader**: `\` puts every plugin's `<leader>x` default (NERDCommenter,
  gitsigns, visual-multi) into the same namespace. Changing `mapleader` to `" "`
  is a one-line change plus relearning a few habits.
- **`conform.nvim` instead of `neoformat`**: format-on-save per filetype with
  fallbacks, no vimscript. Related: widen `autoformat_filetypes` in
  `lua/lsp.lua` once you know which formatters exist on a machine.

## Maybe, evaluate later

- **In-editor AI**: CodeCompanion (0.12+, plenary) has per-hunk accept/reject and
  a review window that works on changes made *outside* Neovim, which fits the
  tmux + Crush loop. Its ACP adapters cover Claude Code, Codex, Gemini CLI,
  opencode and others, but not Crush (Crush has no ACP support). Avante is the
  Cursor-style sidebar alternative and needs a build step.
- **`blink.cmp` instead of `nvim-cmp`**: faster, less config, but a rewrite of
  the completion setup in `lua/lsp.lua`.
- **Outline / symbol navigation**: `trouble.nvim` (symbols + quickfix) or
  `aerial.nvim`, if `<leader>dd` + `gr` stop being enough.
- **`snacks.nvim`**: picker, terminal, notifications and lazygit in one plugin.
  Replaces telescope and floaterm, so only worth it as a deliberate swap.
- **`overseer.nvim` / `neotest`**: run the build or test suite from the editor
  instead of a tmux pane. Useful if the project's test command is stable.
