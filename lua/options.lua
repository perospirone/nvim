local opt = vim.opt

opt.hidden = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.preserveindent = true
opt.autoindent = true
opt.copyindent = true
opt.smartindent = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.scrolloff = 8
opt.completeopt = "menuone,noselect"
opt.autoread = true
opt.wrap = false
opt.ruler = false
opt.showmode = false
opt.confirm = true
opt.updatetime = 250
opt.cursorline = true
opt.mouse = "" -- disable mouse
opt.list = true
opt.winborder = "rounded" -- rounded borders for all floating windows

opt.number = true
opt.relativenumber = true

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.php" },
  command = "lua vim.o.autoindent = true",
})

vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  command = "set guicursor=a:hor20-blinkon350",
})
