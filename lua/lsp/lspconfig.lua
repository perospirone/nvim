local nvim_lsp = require('lspconfig')
local protocol = require('vim.lsp.protocol')
local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

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

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help,
    { border = border, focus = false, close_events = { "CursorMoved", "BufHidden", "InsertCharPre" } }),
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

-- Use buffer source for `/` and `:` (if you enabled `native_menu`, this won't work)
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Get capabilities from cmp_nvim_lsp
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

-- Server-specific settings
local server_settings = {
  rust_analyzer = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
        features = "all",
      },
      procMacro = {
        enable = true
      },
      checkOnSave = {
        command = "clippy",
      },
    }
  },
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  gopls = {
    gopls = {
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

-- Setup language servers
local servers = {
  'gopls',
  'clangd',
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

-- Setup all servers
for _, server in ipairs(servers) do
  local config = {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
  }

  -- Add server-specific settings if they exist
  if server_settings[server] then
    config.settings = server_settings[server]
  end

  -- Special cases for certain servers
  if server == "clangd" then
    config.cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    }
  end

  nvim_lsp[server].setup(config)
end

-- Optional: Set up null-ls for additional formatters and linters
local has_null_ls, null_ls = pcall(require, "null-ls")
if has_null_ls then
  null_ls.setup({
    on_attach = on_attach,
    sources = {
      -- Add formatters and linters as needed
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.gofmt,
      null_ls.builtins.diagnostics.eslint,
      null_ls.builtins.code_actions.gitsigns,
    },
  })
end

-- Optional: Set up mason.nvim for easier LSP installation
local has_mason, mason = pcall(require, "mason")
if has_mason then
  mason.setup()

  local has_mason_lspconfig = pcall(require, "mason-lspconfig")
  if has_mason_lspconfig then
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })
  end
end
