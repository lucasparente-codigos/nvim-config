-- ====================================================================
--                       LOGGER (Utilitário de Log)
-- ====================================================================

local M = {}

-- Níveis de log (padrão do vim.log.levels)
local levels = vim.log.levels

-- Configuração de nível mínimo de log
-- Pode ser ajustado para 'WARN' ou 'ERROR' em produção
local MIN_LEVEL = levels.DEBUG

-- Função de log genérica
local function log(level, message, notify_user)
  if level >= MIN_LEVEL then
    vim.notify(message, level, { title = "NVIM Config", timeout = 5000 })
  end

  if notify_user then
    vim.notify(message, level, { title = "NVIM Config", timeout = 5000 })
  end
end

-- Funções de conveniência
function M.debug(message, notify_user)
  log(levels.DEBUG, "[DEBUG] " .. message, notify_user)
end

function M.info(message, notify_user)
  log(levels.INFO, "[INFO] " .. message, notify_user)
end

function M.warn(message, notify_user)
  log(levels.WARN, "[WARN] " .. message, notify_user)
end

function M.error(message, notify_user)
  log(levels.ERROR, "[ERROR] " .. message, notify_user)
end

return M
