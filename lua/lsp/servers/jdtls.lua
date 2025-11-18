-- ====================================================================
--                       JDTLS (Java Language Server)
-- ====================================================================

local M = {}
local logger = require("utils.logger")
local lsp_utils = require("lsp.utils")

function M.setup(handlers)
  local ok, jdtls = pcall(require, "jdtls")
  if not ok then
    logger.error("JDTLS nao encontrado. Instale via :MasonInstall jdtls", true)
    return
  end

  local home = os.getenv("HOME")
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

  -- Funcao para encontrar root_dir
  local function get_java_root(bufnr)
    return lsp_utils.find_root_dir(
      bufnr,
      { '.project', 'pom.xml', 'build.gradle', 'build.gradle.kts', '.git' }
    )
  end

  -- Detecta sistema operacional
  local function get_config_os()
    if vim.fn.has("mac") == 1 then
      return "config_mac"
    elseif vim.fn.has("win32") == 1 then
      return "config_win"
    else
      return "config_linux"
    end
  end

  -- Auto-comando para iniciar JDTLS
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(args)
      -- Evita multiplas instancias
      if lsp_utils.is_lsp_active(args.buf, "jdtls") then
        logger.debug("JDTLS ja ativo neste buffer")
        return
      end

      local root_dir = get_java_root(args.buf)
      local workspace_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = home .. "/.local/share/jdtls-workspace/" .. workspace_name

      -- Verifica instalacao
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
    end,
  })

  logger.debug("JDTLS configurado")
end

return M
