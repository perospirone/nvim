local parsers = {
  "lua", "go", "c", "cpp", "rust", "javascript", "typescript", "fish",
  "dockerfile", "gomod", "json", "elixir", "php", "tsx", "haskell",
  "dart", "commonlisp",
}

-- No-op for parsers that are already installed
require("nvim-treesitter").install(parsers)

-- The `main` branch does not enable highlighting on its own; start it per buffer.
-- Prompt/terminal/quickfix buffers (telescope, lazy, ...) have no parser and must
-- be skipped; `get_lang` falls back to the filetype name, which is not a language.
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    if vim.bo[buf].buftype ~= "" then
      return
    end
    local language = vim.treesitter.language.get_lang(filetype)
    if not language then
      return
    end
    pcall(vim.treesitter.start, buf, language)
  end,
})
