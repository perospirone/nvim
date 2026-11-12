-- Leader must be set before any keymap is registered. "\" is the Vim default,
-- kept here explicitly so existing muscle memory keeps working; change to " "
-- for a space leader.
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

-- Read by vimscript plugins at load time, so they must be set before lazy.nvim
vim.g.gitgutter = true
vim.g.blamer_enabled = 1
vim.g.blamer_delay = 500
vim.g.blamer_show_in_visual_modes = 0
vim.g.closetag_filenames = "*.html,*.xhtml,*.phtml,*.js"

-- Bootstrap lazy.nvim (replaces packer.nvim, which is unmaintained)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("plugins"), {
  install = { colorscheme = { "rose-pine" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})

require("options")
require("keybinds")
require("foldconfig")
