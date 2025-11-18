-- ====================================================================
--                       LSP PRINCIPAL
-- ====================================================================

local logger = require("utils.logger")
local handlers = require("lsp.handlers")
local lsp_utils = require("lsp.utils")

-- Inicializa handlers
handlers.setup()

-- Configura comandos utilitarios
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
}

-- Markers de root_dir por servidor
local server_markers = {
  gopls = { "go.mod", "go.work", ".git" },
  pyright = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
  ts_ls = { "package.json", "tsconfig.json", ".git" },
  html = { "package.json", ".git" },
  cssls = { "package.json", ".git" },
}

-- Funcao para iniciar LSP generico
local function start_lsp_server(bufnr, server_name)
  -- Verifica se ja esta ativo
  if lsp_utils.is_lsp_active(bufnr, server_name) then
    logger.debug(string.format("LSP %s ja ativo no buffer %d", server_name, bufnr))
    return
  end

  -- Verifica se o executavel existe
  if not lsp_utils.executable_exists(server_name) then
    logger.warn(
      string.format("Executavel '%s' nao encontrado. Instale via :MasonInstall %s", server_name, server_name),
      true
    )
    return
  end

  -- Encontra root_dir
  local markers = server_markers[server_name] or { ".git" }
  local root_dir = lsp_utils.find_root_dir(bufnr, markers)

  logger.info(string.format("Iniciando LSP %s para buffer %d", server_name, bufnr))

  -- Inicia LSP
  local success, error_msg = pcall(vim.lsp.start, {
    name = server_name,
    cmd = { server_name },
    root_dir = root_dir,
    capabilities = handlers.get_capabilities(),
    on_attach = handlers.on_attach,
  })

  if not success then
    logger.error(string.format("Erro ao iniciar %s: %s", server_name, error_msg), true)
  end
end

-- Auto-comando para iniciar LSP servers
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

-- Configura JDTLS separadamente (tem configuracao especial)
local ok, jdtls_config = pcall(require, "lsp.servers.jdtls")
if ok then
  jdtls_config.setup(handlers)
else
  logger.warn("Configuracao JDTLS nao encontrada")
end

logger.info("LSP inicializado")

return {}
