-- ====================================================================
--                       MASON
-- ====================================================================

return {
  {
    'williamboman/mason.nvim',
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

  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      local ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
      if not ok then
        vim.notify("Erro ao carregar Mason-LSPConfig", vim.log.levels.ERROR)
        return
      end

      mason_lspconfig.setup({
        ensure_installed = {
          "gopls",
          "pyright",
          "ts_ls",
          "html",
          "cssls",
          "jdtls",
        },
        automatic_installation = true,
      })
    end,
  },
}
