-- ====================================================================
--                       TREESITTER (Realce de Sintaxe Moderno)
-- ====================================================================

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local ok, ts = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    ts.setup({
      -- Garante que as linguagens essenciais sejam instaladas
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "yaml",
        "markdown",
        "bash",
        "go",
        "python",
        "java",
        "php",
      },
      
      -- Configuração de realce de sintaxe
      highlight = {
        enable = true,
        disable = {},
      },
      
      -- Configuração de indentação
      indent = { enable = true },
      
      -- Configuração de texto-objetos (opcional, mas útil)
      textobjects = { enable = true },
    })
  end,
}
