local cmp = require("cmp")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Completion icons
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

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Only these filetypes get formatted through the LSP on save
local autoformat_filetypes = { "go", "rust", "typescript", "javascript", "lua" }

local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

  if client.supports_method("textDocument/formatting") then
    if vim.tbl_contains(autoformat_filetypes, vim.bo[bufnr].filetype) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end

  -- ts_ls formats badly; let a dedicated formatter win
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
end

-- nvim-cmp
cmp.setup({
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-5),
    ["<C-f>"] = cmp.mapping.scroll_docs(5),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
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

require("lsp_signature").setup({
  bind = true,
  handler_opts = { border = "rounded" },
  hint_enable = false,
})

local capabilities = cmp_nvim_lsp.default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

vim.lsp.config("*", {
  flags = { debounce_text_changes = 150 },
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Servers are installed by mason (see mason-lspconfig ensure_installed in
-- lua/plugins.lua); keep both lists in sync when adding a server.
local servers = {
  "gopls",
  "clangd",
  "zls",
  "ts_ls",
  "phpactor",
  "ocamllsp",
  "dartls",
  "eslint",
  "tailwindcss",
  "lua_ls",
  "rust_analyzer",
  "pyright",
  "jsonls",
  "html",
  "cssls",
}

vim.lsp.enable(servers)

-- LSP keymaps (global, not tied to a specific buffer)
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gd", vim.lsp.buf.definition)
map("n", "K", vim.lsp.buf.hover)
map("i", "<C-k>", vim.lsp.buf.signature_help)
map("n", "gi", vim.lsp.buf.implementation)
map("n", "<space>D", vim.lsp.buf.type_definition)
map("n", "<space>rn", vim.lsp.buf.rename)
map("n", "<space>ca", vim.lsp.buf.code_action)
map("n", "gr", vim.lsp.buf.references)
map("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end)
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
map("n", "<space>e", vim.diagnostic.open_float)
map("n", "<space>q", vim.diagnostic.setloclist)

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
