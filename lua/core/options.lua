-- ====================================================================
--                       OPTIONS
-- ====================================================================

local opt = vim.opt

-- Configurações de UI
opt.number = true             -- Mostrar número de linha
opt.relativenumber = true     -- Mostrar número de linha relativo
opt.signcolumn = "yes"        -- Sempre mostrar coluna de sinais
opt.termguicolors = true      -- Habilitar cores true-color
opt.cursorline = true         -- Destacar a linha do cursor
opt.scrolloff = 8             -- Linhas de contexto ao rolar
opt.sidescrolloff = 8         -- Colunas de contexto ao rolar lateralmente
opt.wrap = false              -- Desabilitar quebra de linha

-- Configurações de Indentação e Tabulação
opt.expandtab = true          -- Usar espaços em vez de tabs
opt.shiftwidth = 2            -- Número de espaços para indentação
opt.tabstop = 2               -- Número de espaços que um tab ocupa
opt.autoindent = true         -- Manter indentação ao criar nova linha
opt.smartindent = true        -- Indentação inteligente

-- Configurações de Busca
opt.ignorecase = true         -- Ignorar maiúsculas/minúsculas na busca
opt.smartcase = true          -- Sensível a maiúsculas/minúsculas se houver maiúsculas na busca
opt.hlsearch = true           -- Destacar resultados da busca
opt.incsearch = true          -- Busca incremental

-- Configurações de Backup e Swap
opt.backup = false            -- Desabilitar arquivos de backup
opt.writebackup = false       -- Desabilitar writebackup
opt.swapfile = false          -- Desabilitar arquivos swap
opt.undofile = true           -- Habilitar arquivo de undo persistente

-- Configurações de Comportamento
opt.mouse = "a"               -- Habilitar mouse em todos os modos
opt.splitbelow = true         -- Abrir splits horizontalmente abaixo
opt.splitright = true         -- Abrir splits verticalmente à direita
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal" -- Opções de sessão
opt.isfname:append("@-@")     -- Adicionar caracteres para nomes de arquivo
opt.updatetime = 300          -- Tempo para escrever o arquivo swap (usado por plugins)
opt.timeoutlen = 500          -- Tempo limite para mapeamentos de teclas (em ms)
opt.completeopt = "menuone,noselect" -- Opções de autocompletar

-- Configurações de Comando
opt.cmdheight = 1             -- Altura da linha de comando
opt.showmode = false         -- Não mostrar o modo atual (já está na statusline)

-- Configurações de Folding
opt.foldmethod = "manual"     -- Método de folding manual
opt.foldlevel = 99            -- Não fechar folds automaticamente

-- Configurações de Buffer
opt.hidden = true             -- Permite que buffers não salvos sejam escondidos

-- Configurações de Exibição
opt.list = true               -- Mostrar caracteres invisíveis
opt.listchars = {
  tab = "» ",
  trail = "•",
  nbsp = "¤",
  extends = "»",
  precedes = "«",
}

-- Configurações de Título
opt.title = true              -- Mostrar título na janela do terminal

-- Configurações de Histórico
opt.history = 1000            -- Número de comandos para manter no histórico

-- Configurações de Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Configurações de Statusline
opt.laststatus = 3            -- Sempre mostrar a statusline
