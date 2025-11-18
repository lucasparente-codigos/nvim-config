-- ====================================================================
--                       PLUGINS
-- ====================================================================

-- Retorna uma tabela que concatena as especificações de plugins
return {
  require("plugins.mason"),
  require("plugins.cmp"),
  require("plugins.nvim-tree"),
  require("plugins.telescope"),
}
