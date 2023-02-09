require 'plugins'
require 'theme'
require 'keybinds'
require 'lsp/lspconfig'

vim.o.hidden = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.preserveindent = true
vim.o.termguicolors = true
vim.g.smartindent = true
vim.cmd('set t_Co=256')
vim.o.clipboard = 'unnamedplus'
vim.o.scrolloff = 8
vim.o.completeopt = 'menuone,noselect' -- rever esse item
vim.opt.ci = true -- rever esse item
vim.o.autoread = true
vim.o.wrap = false -- rever esse item
vim.o.ruler = false -- rever esse item
vim.o.showmode = false -- rever esse item
vim.o.confirm = true
vim.o.updatetime = 250
vim.o.cursorline = true
vim.o.mouse = '' -- disable mouse
vim.o.autoindent = true

-- Buffer 
vim.wo.number = true
vim.wo.relativenumber = true

--  Plugins
vim.g.gitgutter = true

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.php"},
  command = "lua vim.o.autoindent = true",
})

vim.cmd('let g:blamer_enabled = 1')
vim.cmd('let g:blamer_delay = 500')
vim.cmd('let g:blamer_show_in_visual_modes = 0')

vim.cmd
[[
au VimLeave,VimSuspend * set guicursor=a:hor20-blinkon350
]]

vim.opt.termguicolors = true
--vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
--vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
  show_end_of_line = true,
}

--require("indent_blankline").setup {
  --space_char_blankline = " ",
  --char_highlight_list = {
    --"IndentBlanklineIndent1",
    --"IndentBlanklineIndent2",
    --"IndentBlanklineIndent3",
    --"IndentBlanklineIndent4",
    --"IndentBlanklineIndent5",
    --"IndentBlanklineIndent6",
    --},
    --}

require ('colorizer').setup {
  '*'; 
  css = { rgb_fn = true; }
}

vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.js'

require('go').setup()

require('neoscroll').setup()
require'mind'.setup()
-- NeoOrg
-- Load custom tree-sitter grammar for org filetype
