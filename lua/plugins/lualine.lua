-- ====================================================================
--                       LUALINE (Barra de Status Minimalista)
-- ====================================================================

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Para ícones (se o usuário quiser)
  config = function()
    local ok, lualine = pcall(require, "lualine")
    if not ok then return end

    lualine.setup({
      options = {
        icons_enabled = true,
        theme = "auto", -- Usa o tema do colorscheme atual
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "NvimTree", "lazy" },
        always_divide_middle = true,
        globalstatus = true, -- Usa uma única barra de status para todas as janelas
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- Apenas o nome do arquivo
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "nvim-tree" },
    })
  end,
}
