local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'

---- Mappings.
local opts = { noremap=true, silent=true }

---- See `:help vim.lsp.*` for documentation on any of the below functions
vim.api.nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_set_keymap('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

local cmp = require'cmp'

local on_attach = function(client, bufnr)
	protocol.SymbolKind = { }
	protocol.CompletionItemKind = {
		'', -- Text
		'', -- Method
		'', -- Function
		'', -- Constructor
		'', -- Field
		'', -- Variable
		'', -- Class
		'ﰮ', -- Interface
		'', -- Module
		'', -- Property
		'', -- Unit
		'', -- Value
		'', -- Enum
		'', -- Keyword
		'﬌', -- Snippet
		'', -- Color
		'', -- File
		'', -- Reference
		'', -- Folder
		'', -- EnumMember
		'', -- Constant
		'', -- Struct
		'', -- Event
		'ﬦ', -- Operator
		'', -- TypeParameter
	}

	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	cmp.setup({
  	snippet = {
    	-- REQUIRED - you must specify a snippet engine
    	expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				--require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
				--vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    	end,
  	},
  	mapping = {
    	['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-5), { 'i', 'c' }),
    	['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(3), { 'i', 'c' }),
    	['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    	['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    	['<C-e>'] = cmp.mapping({
      	i = cmp.mapping.abort(),
      	c = cmp.mapping.close(),
    	}),
    	['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  	},
  	sources = cmp.config.sources({
    	{ name = 'nvim_lsp' },
    	{ name = 'vsnip' }, -- For vsnip users.
    	-- { name = 'luasnip' }, -- For luasnip users.
    	-- { name = 'ultisnips' }, -- For ultisnips users.
    	-- { name = 'snippy' }, -- For snippy users.
  	}, {
    	{ name = 'buffer' },
  	})
	})

	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline('/', {
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
end


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
--cmp_nvim_lsp.default_capabilities

local servers = { 'gopls', 'ccls', 'ts_ls', 'phpactor', 'ocamllsp', 'dartls', 'eslint', 'tailwindcss' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
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
            },
            procMacro = {
                enable = true
            },
        }
    }
})
