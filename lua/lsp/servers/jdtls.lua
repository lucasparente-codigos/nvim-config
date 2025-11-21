-- ====================================================================
--                       JDTLS (Java Language Server)
-- ====================================================================

local M = {}
local logger = require("utils.logger")

-- Adiciona a dependência do plugin nvim-jdtls para garantir que ele seja carregado
-- e que o JDTLS seja configurado corretamente.
-- Este arquivo será carregado pelo lsp.lua (plugins)

function M.setup(handlers)
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    logger.error("JDTLS nao encontrado. Instale via :MasonInstall jdtls", true)
    return
  end

  local home = os.getenv("HOME")
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

  -- Funcao para encontrar root_dir (mantida)
  local function get_java_root(bufnr)
    -- Usando vim.fs.root diretamente, já que lsp.utils foi removido
    local ok, root = pcall(vim.fs.root, bufnr, { '.project', 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' })
    if ok and root then
      logger.debug(string.format("Root dir encontrado: %s", root))
      return root
    end

    local fallback = vim.fn.getcwd()
    logger.warn(string.format("Root dir não encontrado, usando fallback: %s", fallback))
    return fallback
  end

  -- Detecta sistema operacional (mantida)
  local function get_config_os()
    if vim.fn.has("mac") == 1 then
      return "config_mac"
    elseif vim.fn.has("win32") == 1 then
      return "config_win"
    else
      return "config_linux"
    end
  end

  -- Auto-comando para iniciar JDTLS (chamado pelo lspconfig)
  -- A lógica de inicialização foi movida para o handler do lspconfig no lsp.lua

  local bufnr = vim.api.nvim_get_current_buf()
  local root_dir = get_java_root(bufnr)
  local workspace_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. workspace_name

  -- Verifica instalacao (mantida)
  local launcher_jar = vim.fn.glob(mason_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
  if launcher_jar == "" then
    -- Tenta o caminho alternativo, que é mais comum em instalações recentes do Mason
    launcher_jar = vim.fn.glob(mason_path .. "/org.eclipse.equinox.launcher_*.jar")
  end
  if launcher_jar == "" then
    logger.error(
      string.format("JDTLS nao encontrado em %s. Execute :MasonInstall jdtls", mason_path),
      true
    )
    return
  end

  logger.info(string.format("Iniciando JDTLS para workspace: %s", workspace_name))

  local config = {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "-Xmx2G",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",
      "-jar", launcher_jar,
      "-configuration", mason_path .. "/" .. get_config_os(),
      "-data", workspace_dir,
    },
    root_dir = root_dir,
    capabilities = handlers.get_capabilities(),
    on_attach = handlers.on_attach,
    settings = {
      java = {
        eclipse = { downloadSources = true },
        configuration = { updateBuildConfiguration = "interactive" },
        maven = { downloadSources = true },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        references = { includeDecompiledSources = true },
        format = { enabled = true },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.Assume.*",
          "org.junit.jupiter.api.Assertions.*",
        },
      },
    },
    init_options = {
      bundles = {},
    },
  }

  -- Inicia JDTLS
  local success, error_msg = pcall(jdtls.start_or_attach, config)
  if not success then
    logger.error(string.format("Erro ao iniciar JDTLS: %s", error_msg), true)
  end
end

return M
