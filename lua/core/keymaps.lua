-- ====================================================================
--                       KEYMAPS GLOBAIS
-- ====================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Salvamento e saida
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<leader>q', ':q<CR>', opts)
keymap('n', '<leader>Q', ':qa!<CR>', opts)

-- Navegacao entre janelas
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Redimensionar janelas
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Navegacao entre buffers
keymap('n', '<S-l>', ':bnext<CR>', opts)
keymap('n', '<S-h>', ':bprevious<CR>', opts)
keymap('n', '<leader>bd', ':bdelete<CR>', opts)

-- Mover linhas no modo visual
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Indentacao no modo visual
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Limpar highlight de busca
keymap('n', '<leader>nh', ':nohl<CR>', opts)

-- Melhor colagem
keymap('v', 'p', '"_dP', opts)

-- Manter cursor centralizado
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)

return {}
