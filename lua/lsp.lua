local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

-- Setup completion icons
local kind_icons = {
  Text = "", -- Text
  Method = "", -- Method
  Function = "", -- Function
  Constructor = "", -- Constructor
  Field = "", -- Field
  Variable = "", -- Variable
  Class = "", -- Class
  Interface = "", -- Interface
  Module = "", -- Module
  Property = "", -- Property
  Unit = "", -- Unit
  Value = "", -- Value
  Enum = "", -- Enum
  Keyword = "", -- Keyword
  Snippet = "", -- Snippet
  Color = "", -- Color
  File = "", -- File
  Reference = "", -- Reference
  Folder = "", -- Folder
  EnumMember = "", -- EnumMember
  Constant = "", -- Constant
  Struct = "", -- Struct
  Event = "", -- Event
  Operator = "", -- Operator
  TypeParameter = "", -- TypeParameter
}

-- LSP on_attach callback
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Set format on save only for certain filetypes/clients
  if client.supports_method("textDocument/formatting") then
    -- You can customize which clients should format on save
    local autoformat_filetypes = {
      "go", "rust", "typescript", "javascript", "lua"
    }

    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if vim.tbl_contains(autoformat_filetypes, filetype) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end

  -- Disable formatting for certain clients if you prefer another formatter
  -- Example: Use null-ls for formatting instead of ts_ls
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
end

-- nvim-cmp setup
cmp.setup({
  --snippet = {
  --expand = function(args)
  --vim.fn["vsnip#anonymous"](args.body)
  --end,
  --},
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-5),
    ['<C-f>'] = cmp.mapping.scroll_docs(5),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
      -- Source
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        vsnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

local capabilities = cmp_nvim_lsp.default_capabilities()
-- Add additional capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}



vim.lsp.config("*", {
  flags = {
    debounce_text_changes = 150,
  },
  on_attach = on_attach,
  capabilities = capabilities
})

require("lspconfig")

local servers = {
  'gopls',
  'clangd',
  'zls',
  'ts_ls',
  'phpactor',
  'ocamllsp',
  'dartls',
  'eslint',
  'tailwindcss',
  'lua_ls',        -- Added lua_ls for Neovim Lua development
  'rust_analyzer', -- Moved from separate setup to unified approach
  'pyright',       -- Added Python support
  'jsonls',        -- Added JSON support
  'html',          -- Added HTML support
  'cssls',         -- Added CSS support
}

vim.lsp.enable(servers)

-- Define keymapping helper function to reduce repetition
local function map(mode, lhs, rhs, map_opts)
  local options = { noremap = true, silent = true }
  if map_opts then
    options = vim.tbl_extend("force", options, map_opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- LSP Keybindings (using newer vim.keymap.set API instead of nvim_set_keymap)
local function setup_keymaps()
  map('n', 'gD', vim.lsp.buf.declaration)
  map('n', 'gd', vim.lsp.buf.definition)
  map('n', 'K', vim.lsp.buf.hover)
  map('i', '<C-k>', vim.lsp.buf.signature_help)
  map('n', 'gi', vim.lsp.buf.implementation)
  map('n', '<space>D', vim.lsp.buf.type_definition)
  map('n', '<space>rn', vim.lsp.buf.rename)
  map('n', '<space>ca', vim.lsp.buf.code_action)
  map('n', 'gr', vim.lsp.buf.references)
  map('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end)
  map('n', '[d', vim.diagnostic.goto_prev)
  map('n', ']d', vim.diagnostic.goto_next)
  map('n', '<space>e', vim.diagnostic.open_float)
  map('n', '<space>q', vim.diagnostic.setloclist)
end

-- Setup keymaps globally (not dependent on LSP attachment)
setup_keymaps()

-- Configure diagnostics display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Set up border for hover and signature help
local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}
