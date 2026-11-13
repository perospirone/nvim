function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true,
    silent = true
  }

  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

function nmap(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
end

function nimap(lhs, rhs, opts)
  map('n', lhs, rhs, opts)
  map('i', lhs, rhs, opts)
end

nmap('H', 'gT')
nmap('L', 'gt')
nimap('<F4>', '<Cmd>noh<CR>')
nmap('<leader>ct', '<Cmd>tabnew<CR>')

nimap('<C-s>', '<Cmd>w<CR>')

-- NvimTree
nmap('<C-o>', '<Cmd>NvimTreeToggle<CR>')
nmap('<leader>r', '<Cmd>NvimTreeRefresh<CR>')

-- Diagnostics (native; replaces the archived Lspsaga commands)
map('n', '[e', function() vim.diagnostic.jump({ count = -1 }) end)
map('n', ']e', function() vim.diagnostic.jump({ count = 1 }) end)
map('n', 'gs', vim.diagnostic.open_float)
map('n', 'gb', vim.lsp.buf.hover)
map('n', 'gv', vim.lsp.buf.definition)

-- Telescope
nimap('<C-t>', [[<Cmd>lua require 'telescope.builtin'.lsp_code_actions(require 'telescope.themes'.get_cursor{})<CR>]])
map('v', '<C-t>',
  [[<Cmd>lua require 'telescope.builtin'.lsp_range_code_actions(require 'telescope.themes'.get_cursor{})<CR>]])
map('n', '<leader>ff', '<Cmd>Telescope find_files<CR>')
map('n', '<leader>fg', '<Cmd>Telescope live_grep<CR>')
map('n', '<leader>gf', '<Cmd>Telescope git_files<CR>')
map('n', '<leader>rf', '<Cmd>Telescope oldfiles<CR>') -- recent files
map('n', '<leader>hl', '<Cmd>Telescope highlights<CR>')

map('n', '<C-k>', '<Cmd>Telescope keymaps<CR>') -- look at keybinds
map('n', '<C-f>', '<Cmd>Telescope current_buffer_fuzzy_find<CR>')

-- Reviewing changes (own edits or an agent's)
map('n', '<leader>dd', '<Cmd>Telescope diagnostics<CR>')
map('n', '<leader>gd', '<Cmd>DiffviewOpen<CR>')

map('n', '<leader>vr', '<Cmd>vertical resize +10<CR>')
