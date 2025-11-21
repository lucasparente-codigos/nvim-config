-- ====================================================================
--                       INIT.LUA (Ponto de Entrada)
-- ====================================================================

-- Define o caminho para o lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Bootstrap do lazy.nvim (instala se não existir)
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Carregamento de módulos base (síncrono)
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Configuração e inicialização do lazy.nvim
require("lazy").setup({
  -- Importa todas as especificações de plugins de lua/plugins/*.lua
  spec = {
    { import = "plugins" },
  },
  
  -- Opções de performance e UI
  defaults = {
    lazy = true,
    version = "*",
  },
  
  -- Eventos de carregamento
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      -- Desabilita plugins que não serão usados
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Carregamento lazy do LSP (agora gerenciado pelo lazy.nvim)
-- O lspconfig será carregado via evento FileType
-- O arquivo lsp/init.lua original foi removido e sua lógica movida para lsp.lua (plugin)

-- Configuração do colorscheme (exemplo minimalista)
vim.cmd.colorscheme("tokyonight")

-- Configuração do JDTLS (se o plugin for carregado)
local ok, jdtls_config = pcall(require, "lsp.servers.jdtls")
if ok then
  -- O setup do JDTLS será chamado pelo lspconfig no evento FileType
  -- Apenas garante que o módulo está disponível
end
