-- ====================================================================
--                          HANDLERS LSP
-- ====================================================================

local M = {}
local logger = require("utils.logger")

-- Capabilities
function M.get_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  logger.warn("cmp_nvim_lsp não encontrado, usando capabilities padrão")
  return vim.lsp.protocol.make_client_capabilities()
end

-- on_attach global
function M.on_attach(client, bufnr)
  logger.info(string.format("LSP '%s' anexado ao buffer %d", client.name, bufnr))

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- Navegação e ações
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)

  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  
  -- Formatação (usando vim.lsp.buf.format, que é mais idiomático)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true }) -- Usando async para não bloquear
  end, bufopts)

  -- Destaque de referências
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight_" .. bufnr, { clear = true })

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = group,
      callback = function()
        pcall(vim.lsp.buf.document_highlight)
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      group = group,
      callback = function()
        pcall(vim.lsp.buf.clear_references)
      end,
    })
  end

  vim.notify(
    string.format("LSP %s ativo", client.name),
    vim.log.levels.INFO,
    { timeout = 1500 }
  )
end

-- Configuração de diagnósticos
function M.setup_diagnostics()
  local signs = {
    { name = "DiagnosticSignError", text = "E" },
    { name = "DiagnosticSignWarn",  text = "W" },
    { name = "DiagnosticSignHint",  text = "H" },
    { name = "DiagnosticSignInfo",  text = "I" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, {
      texthl = sign.name,
      text = sign.text,
      numhl = "",
    })
  end

  vim.diagnostic.config({
    virtual_text = {
      prefix = ">",
      spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  })

  logger.debug("Diagnósticos configurados")
end

-- Inicialização geral (apenas diagnósticos)
function M.setup()
  M.setup_diagnostics()
  logger.debug("Handlers LSP inicializados")
end

return M
