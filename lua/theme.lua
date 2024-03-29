require('rose-pine').setup({
	---@usage 'main'|'moon'
	dark_variant = 'main',
	bold_vert_split = false,
	dim_nc_background = false,
	disable_background = true,
	disable_float_background = true,
	disable_italics = true,
	---@usage string hex value or named color from rosepinetheme.com/palette
	groups = {
		border = 'highlight_med',
		comment = 'muted',
		link = 'iris',
		punctuation = 'subtle',

		error = 'love',
		hint = 'iris',
		info = 'foam',
		warn = 'gold',

		headings = {
			h1 = 'iris',
			h2 = 'foam',
			h3 = 'rose',
			h4 = 'gold',
			h5 = 'pine',
			h6 = 'foam',
		}
	}
})

-- Set colorscheme after options
vim.cmd('colorscheme rose-pine')
vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
vim.cmd('hi StatusLine guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE')
vim.cmd('hi StatusLineNC guibg=NONE')
vim.cmd('hi Tabline guibg=NONE')
vim.cmd('hi TablineSel guibg=NONE')
vim.cmd('hi TablineFill guibg=NONE')
--vim.cmd('highlight NonText ctermbg=none')

--require('lualine').setup({
  --options = { theme = 'rose-pine'}
--})
