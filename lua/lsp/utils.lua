-- ====================================================================
--                          UTILIDADES LSP
-- ====================================================================

local M = {}
local logger = require("utils.logger")

-- Verifica se um executável existe no PATH
function M.executable_exists(name)
  return vim.fn.executable(name) == 1
end

-- Encontra root_dir baseado em markers
function M.find_root_dir(bufnr, markers)
  local ok, root = pcall(vim.fs.root, bufnr, markers)

  if ok and root then
    logger.debug(string.format("Root dir encontrado: %s", root))
    return root
  end

  -- fallback seguro
  local fallback = vim.fn.getcwd()
  logger.warn(string.format("Root dir não encontrado, usando fallback: %s", fallback))
  return fallback
end

-- Verifica se um cliente LSP já está rodando no buffer
function M.is_lsp_active(bufnr, server_name)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = server_name })
  return #clients > 0
end

-- Para todos os clientes LSP de um buffer
function M.stop_buffer_clients(bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    logger.info(string.format("Parando LSP: %s (id=%d)", client.name, client.id))
    vim.lsp.stop_client(client.id)
  end
end

-- Formata documento via LSP
function M.format_document()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    logger.warn("Nenhum LSP disponível para formatação", true)
    return
  end

  vim.lsp.buf.format({
    async = false,
    timeout_ms = 2000,
  })

  logger.info("Documento formatado")
end

-- Exibe info dos clients ativos
function M.show_lsp_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    print("Nenhum LSP client ativo neste buffer")
    return
  end

  print("LSP clients ativos neste buffer:\n")

  for _, client in ipairs(clients) do
    print(string.format("- %s (id: %d)", client.name, client.id))
    print(string.format("  root_dir: %s", client.config.root_dir or "N/A"))

    if client.config.filetypes then
      print(string.format("  filetypes: %s", table.concat(client.config.filetypes, ", ")))
    end

    print("")
  end

  print(string.format("LSP log file: %s", vim.lsp.get_log_path()))
end

-- Reinicia LSP para o buffer atual
function M.restart_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    logger.warn("Nenhum LSP client para reiniciar", true)
    return
  end

  M.stop_buffer_clients(bufnr)

  -- delay curto para evitar race conditions
  vim.defer_fn(function()
    vim.cmd("edit")
    logger.info("LSP reiniciado", true)
  end, 100)
end

-- Cria comandos utilitários
function M.setup_commands()
  vim.api.nvim_create_user_command("LspInfo", M.show_lsp_info, {})
  vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.edit(vim.lsp.get_log_path())
  end, {})
  vim.api.nvim_create_user_command("LspRestart", M.restart_lsp, {})
  vim.api.nvim_create_user_command("LspFormat", M.format_document, {})

  logger.debug("Comandos LSP registrados")
end

return M
