-- ====================================================================
--                       LSP (nvim-lspconfig)
-- ====================================================================

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local handlers = require("lsp.handlers")
      local mason_lspconfig = require("mason-lspconfig")

      -- Configuração dos diagnósticos (mantida em lsp.handlers)
      handlers.setup_diagnostics()

      -- Mapeamento de servidores a serem instalados e configurados
      local servers = {
        "gopls",
        "pyright",
        "tsserver", -- Usando tsserver em vez de ts_ls
        "html",
        "cssls",
        "intelephense",
        "jdtls",
      }

      -- Configuração automática via mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- Configuração dos servidores
      mason_lspconfig.setup_handlers({
        -- 1. Handler padrão para a maioria dos servidores
        function(server_name)
          lspconfig[server_name].setup({
            on_attach = handlers.on_attach,
            capabilities = handlers.get_capabilities(),
            settings = {}, -- Configurações específicas podem ser adicionadas aqui
          })
        end,

        -- 2. Handler específico para JDTLS (mantendo a customização)
        ["jdtls"] = function()
          local jdtls_config = require("lsp.servers.jdtls")
          jdtls_config.setup(handlers)
        end,

        -- 3. Handler específico para Intelephense (mantendo a customização)
        ["intelephense"] = function()
          lspconfig["intelephense"].setup({
            on_attach = handlers.on_attach,
            capabilities = handlers.get_capabilities(),
            settings = {
              intelephense = {
                files = {
                  maxSize = 5000000,
                  associations = { "*.php", "*.phtml" },
                  exclude = {
                    "**/.git/**",
                    "**/.svn/**",
                    "**/.hg/**",
                    "**/CVS/**",
                    "**/.DS_Store/**",
                    "**/node_modules/**",
                    "**/bower_components/**",
                    "**/vendor/**/{Tests,tests}/**",
                  },
                },
                format = {
                  enable = true,
                  braces = "k&r",
                },
                environment = {
                  phpVersion = "8.2.0",
                },
              },
            },
          })
        end,
      })
    end,
  },
}
