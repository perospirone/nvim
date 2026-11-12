local parsers = {
  "lua", "go", "c", "cpp", "rust", "javascript", "typescript", "fish",
  "dockerfile", "gomod", "json", "elixir", "php", "tsx", "haskell",
  "dart", "commonlisp",
}

-- No-op for parsers that are already installed
require("nvim-treesitter").install(parsers)

-- The `main` branch does not enable highlighting on its own; start it per buffer
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local buf, filetype = args.buf, args.match
    local language = vim.treesitter.language.get_lang(filetype)
    if not language or not pcall(vim.treesitter.language.add, language) then
      return
    end
    vim.treesitter.start(buf, language)
  end,
})
