-- ====================================================================
--                       MASON
-- ====================================================================

return {
  {
    'williamboman/mason.nvim',
    lazy = false, -- Carregamento imediato
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Adicionado para ícones no UI
    config = function()
      local ok, mason = pcall(require, 'mason')
      if not ok then
        vim.notify("Erro ao carregar Mason", vim.log.levels.ERROR)
        return
      end

      mason.setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "[I]",
            package_pending = "[P]",
            package_uninstalled = "[U]",
          },
        },
      })
    end,
  },

  -- O mason-lspconfig foi movido para o arquivo lsp.lua para melhor organização
}
