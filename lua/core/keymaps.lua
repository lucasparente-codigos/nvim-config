-- ====================================================================
--                       KEYMAPS
-- ====================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Atalhos de Modo Normal
-- Salvar e Sair
map("n", "<leader>w", "<cmd>w<cr>", opts)
map("n", "<leader>q", "<cmd>q<cr>", opts)
map("n", "<leader>Q", "<cmd>qa!<cr>", opts)

-- Navegação entre buffers
map("n", "<S-l>", "<cmd>bnext<cr>", opts)
map("n", "<S-h>", "<cmd>bprevious<cr>", opts)
map("n", "<leader>bd", "<cmd>bd<cr>", opts) -- Fechar buffer

-- Navegação em janelas (splits)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Redimensionar janelas
map("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
map("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Mover linhas
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Atalhos de Modo Visual
-- Manter o texto selecionado após a indentação
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Atalhos de Plugins (Lazy-loaded)
-- Nvim-tree
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- LSP
map("n", "<leader>vd", "<cmd>Telescope diagnostics<cr>", opts)
map("n", "<leader>vws", "<cmd>Telescope lsp_workspace_symbols<cr>", opts)
map("n", "<leader>vds", "<cmd>Telescope lsp_document_symbols<cr>", opts)

-- Outros
map("n", "<leader>o", "<cmd>Noice<cr>", opts) -- Se Noice estiver instalado
map("n", "<leader>t", "<cmd>ToggleTerm<cr>", opts) -- Se ToggleTerm estiver instalado

-- Atalhos de Modo de Inserção
-- Mapeamento para sair do modo de inserção com 'jk'
map("i", "jk", "<ESC>", opts)
