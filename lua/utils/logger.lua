-- ====================================================================
--                       SISTEMA DE LOGS
-- ====================================================================

local M = {}

-- Niveis de log
M.levels = {
  DEBUG = vim.log.levels.DEBUG,
  INFO = vim.log.levels.INFO,
  WARN = vim.log.levels.WARN,
  ERROR = vim.log.levels.ERROR,
}

-- Configuracao
M.config = {
  enabled = true,
  level = M.levels.INFO,
  show_timestamp = true,
}

-- Funcao auxiliar para formatar mensagem
local function format_message(level_name, message)
  local timestamp = M.config.show_timestamp and os.date("[%H:%M:%S] ") or ""
  return string.format("%s[%s] %s", timestamp, level_name, message)
end

-- Log generico
function M.log(level, message, notify_user)
  if not M.config.enabled then return end
  if level < M.config.level then return end

  local level_names = { "DEBUG", "INFO", "WARN", "ERROR" }
  local level_name = level_names[level] or "UNKNOWN"

  -- Sempre loga no arquivo
  local log_file = vim.fn.stdpath("log") .. "/custom.log"
  local file = io.open(log_file, "a")
  if file then
    file:write(format_message(level_name, message) .. "\n")
    file:close()
  end

  -- Notifica usuario se solicitado
  if notify_user then
    vim.notify(message, level)
  end
end

-- Atalhos
function M.debug(message)
  M.log(M.levels.DEBUG, message, false)
end

function M.info(message, notify)
  M.log(M.levels.INFO, message, notify or false)
end

function M.warn(message, notify)
  M.log(M.levels.WARN, message, notify or true)
end

function M.error(message, notify)
  M.log(M.levels.ERROR, message, notify or true)
end

-- Funcao para ler logs
function M.show_logs()
  local log_file = vim.fn.stdpath("log") .. "/custom.log"
  if vim.fn.filereadable(log_file) == 1 then
    vim.cmd("edit " .. log_file)
  else
    vim.notify("Arquivo de log nao encontrado", vim.log.levels.WARN)
  end
end

-- Limpar logs
function M.clear_logs()
  local log_file = vim.fn.stdpath("log") .. "/custom.log"
  local file = io.open(log_file, "w")
  if file then
    file:close()
    vim.notify("Logs limpos com sucesso", vim.log.levels.INFO)
  end
end

return M
