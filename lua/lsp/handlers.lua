-- ====================================================================
--                       HANDLERS LSP
-- ====================================================================

local M = {}
local logger = require("utils.logger")

-- Configuracao de capabilities
function M.get_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  logger.warn("cmp_nvim_lsp nao encontrado, usando capabilities padrao")
  return vim.lsp.protocol.make_client_capabilities()
end

-- On_attach global
function M.on_attach(client, bufnr)
  logger.info(string.format("LSP '%s' anexado ao buffer %d", client.name, bufnr))

  -- Keymaps especificos do LSP
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, bufopts)

  -- Highlight de referencias ao cursor
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      group = group,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- Notificacao visual
  vim.notify(
    string.format("LSP %s ativo", client.name),
    vim.log.levels.INFO,
    { timeout = 2000 }
  )
end

-- Configura diagnosticos
function M.setup_diagnostics()
  local signs = {
    { name = "DiagnosticSignError", text = "E" },
    { name = "DiagnosticSignWarn", text = "W" },
    { name = "DiagnosticSignHint", text = "H" },
    { name = "DiagnosticSignInfo", text = "I" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = ">>",
      spacing = 4,
    },
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  logger.debug("Diagnosticos configurados")
end

-- Inicializacao
function M.setup()
  M.setup_diagnostics()
  logger.debug("Handlers LSP inicializados")
end

return M
