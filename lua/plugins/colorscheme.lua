-- ====================================================================
--                       COLORSCHEME (tokyonight)
-- ====================================================================

return {
  "folke/tokyonight.nvim",
  lazy = false, -- Carrega imediatamente para definir o tema
  priority = 1000,
  opts = {
    style = "night", -- Ou 'storm', 'day', 'moon'
    transparent = false,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = {},
      variables = {},
      -- Mais configurações de estilo aqui
    },
    -- Configurações de destaque (highlight)
    highlights = {
      -- Exemplo: Fundo mais escuro para o nvim-tree
      NvimTreeNormal = { bg = "#1f2335" },
    },
  },
}
