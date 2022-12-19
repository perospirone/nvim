function map(mode, lhs, rhs, opts)
	local options = {
		noremap = true,
		silent = true
	}

	if opts then options = vim.tbl_extend('force', options, opts) end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function nmap(lhs, rhs, opts)
	map('n', lhs, rhs, opts)
end

function nimap(lhs, rhs, opts)
	map('n', lhs, rhs, opts)
	map('i', lhs, rhs, opts)
end

--nmap('q', '<Cmd>q<CR>')
--nmap('Q', '<Cmd>q!<CR>')
nmap('H', 'gT')
nmap('L', 'gt')
nimap('<F4>', '<Cmd>:noh<CR>')
nmap('<leader>ct', '<Cmd>tabnew<CR>')

nimap('<C-s>', '<Cmd>w<CR>')

-- NvimTree
nmap('<C-o>', '<Cmd>NvimTreeToggle<CR>')
nmap('<leader>r', '<Cmd>NvimTreeRefresh<CR>')

-- Trouble
--map('n', '<C-x>', '<Cmd>TroubleToggle<CR>')

-- Lspsaga
map('n', '[e', '<Cmd>Lspsaga diagnostic_jump_next<CR>')
map('n', ']e', '<Cmd>Lspsaga diagnostic_jump_prev<CR>')
map('n', 'gv', '<Cmd>Lspsaga preview_definition<CR>')
map('n', 'gb', '<Cmd>Lspsaga hover_doc<CR>')
map('n', 'gs', '<Cmd>Lspsaga show_line_diagnostics<CR>')

-- Telescope
nimap('<C-t>', [[<Cmd>:lua require 'telescope.builtin'.lsp_code_actions(require 'telescope.themes'.get_cursor{})<CR>]])
map('v', '<C-t>', [[<Cmd>:lua require 'telescope.builtin'.lsp_range_code_actions(require 'telescope.themes'.get_cursor{})<CR>]])
map('n', '<leader>ff', '<Cmd>Telescope find_files<CR>')
map('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>')
map('n', '<leader>gf', '<Cmd>Telescope git_files<CR>')
map('n', '<leader>rf', '<Cmd>Telescope oldfiles<CR>') -- recent files
map('n', '<leader>hl', '<Cmd>Telescope highlights<CR>')

map('n', '<C-k>', '<Cmd>Telescope keymaps<CR>') -- look at keybinds
map('n', '<C-f>', '<Cmd>Telescope current_buffer_fuzzy_find<CR>')
