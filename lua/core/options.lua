-- ====================================================================
--                       OPCOES DO EDITOR
-- ====================================================================

local opt = vim.opt

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Identacao
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Interface
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.colorcolumn = "80"

-- Comportamento
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 300
opt.timeoutlen = 500

-- Divisoes
opt.splitright = true
opt.splitbelow = true

-- Scroll
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Busca
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Backup e swap
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Performance
opt.lazyredraw = false
opt.ttyfast = true

-- Seguranca
opt.modeline = false     -- Desativa modeline para evitar execucao de comandos arbitrários
opt.exrc = false         -- Desativa leitura de .exrc e .vimrc no diretório atual

return {}
