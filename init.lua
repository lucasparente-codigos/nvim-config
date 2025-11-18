local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

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

-- Carregamento de módulos base (sem pcall, se falhar, deve parar para correção)
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Carregamento de plugins
local plugins = require("plugins")
require("lazy").setup(plugins)

-- Carregamento lazy do LSP
vim.defer_fn(function()
  require("lsp")
end, 100)
