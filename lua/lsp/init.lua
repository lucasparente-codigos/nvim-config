-- ====================================================================
--                       LSP PRINCIPAL
-- ====================================================================

local logger = require("utils.logger")
local handlers = require("lsp.handlers")
local lsp_utils = require("lsp.utils")

handlers.setup()
lsp_utils.setup_commands()

-- Mapeamento de filetypes para servidores
local ft_to_server = {
  go = "gopls",
  python = "pyright",
  javascript = "ts_ls",
  typescript = "ts_ls",
  typescriptreact = "ts_ls",
  javascriptreact = "ts_ls",
  html = "html",
  css = "cssls",
  php = "intelephense",
}

-- Markers de root_dir por servidor
local server_markers = {
  gopls = { "go.mod", "go.work", ".git" },
  pyright = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
  ts_ls = { "package.json", "tsconfig.json", ".git" },
  html = { "package.json", ".git" },
  cssls = { "package.json", ".git" },
  intelephense = { "composer.json", ".git", "index.php" },
}

-- Função para iniciar um LSP
local function start_lsp_server(bufnr, server_name)
  if lsp_utils.is_lsp_active(bufnr, server_name) then
    logger.debug(string.format("LSP %s já ativo no buffer %d", server_name, bufnr))
    return
  end

  if not lsp_utils.executable_exists(server_name) and server_name ~= "ts_ls" then
    logger.warn(
      string.format("Executável '%s' não encontrado. Instale via :MasonInstall %s", server_name, server_name),
      true
    )
    return
  end

  local markers = server_markers[server_name] or { ".git" }
  local root_dir = lsp_utils.find_root_dir(bufnr, markers)

  logger.info(string.format("Iniciando LSP %s para buffer %d", server_name, bufnr))

  -- Config extra para cada servidor
  local extra_config = {}

  -- Correção especial para ts_ls (TypeScript)
  if server_name == "ts_ls" then
    extra_config.cmd = { "typescript-language-server", "--stdio" }
  end

  -- Configuração custom para Intelephense
  if server_name == "intelephense" then
    extra_config = vim.tbl_deep_extend("force", extra_config, {
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
  end

  -- Config final
  local config = vim.tbl_deep_extend("force", {
    name = server_name,
    cmd = { server_name }, -- sobrescrito por extra_config.cmd quando necessário
    root_dir = root_dir,
    capabilities = handlers.get_capabilities(),
    on_attach = handlers.on_attach,
  }, extra_config)

  local success, error_msg = pcall(vim.lsp.start, config)

  if not success then
    logger.error(string.format("Erro ao iniciar %s: %s", server_name, error_msg), true)
  end
end

-- Auto comando para iniciar LSP automaticamente
vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.tbl_keys(ft_to_server),
  callback = function(args)
    local server = ft_to_server[vim.bo[args.buf].filetype]
    if server then
      vim.defer_fn(function()
        start_lsp_server(args.buf, server)
      end, 100)
    end
  end,
})

-- Configura JDTLS separadamente
local ok, jdtls_config = pcall(require, "lsp.servers.jdtls")
if ok then
  jdtls_config.setup(handlers)
else
  logger.warn("Configuração JDTLS não encontrada")
end

logger.info("LSP inicializado")

return {}
