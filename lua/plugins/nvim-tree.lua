-- ====================================================================
--                       NVIM-TREE
-- ====================================================================

return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Adicionado para ícones
  config = function()
    local ok, nvim_tree = pcall(require, 'nvim-tree')
    if not ok then
      vim.notify("Erro ao carregar nvim-tree", vim.log.levels.ERROR)
      return
    end

    -- Desabilita netrw (explorador nativo do vim)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Configuracao de icones desabilitados (mantido o minimalismo)
    vim.g.nvim_tree_show_icons = {
      git = 0,
      folders = 0,
      files = 0,
    }

    nvim_tree.setup({
      view = {
        width = 35,
        side = "left",
      },

      filters = {
        dotfiles = false,
        custom = { '.git', 'node_modules', '.cache' },
      },

      renderer = {
        -- Desabilita todos os icones (mantendo o feeling minimalista)
        icons = {
          show = {
            file = false,
            folder = false,
            folder_arrow = false,
            git = false,
          },
          glyphs = {
            default = "",
            symlink = "",
            folder = {
              default = "[DIR]",
              open = "[DIR]",
              empty = "[EMPTY]",
              empty_open = "[EMPTY]",
              symlink = "[LINK]",
            },
            git = {
              unstaged = "M",
              staged = "A",
              unmerged = "U",
              renamed = "R",
              untracked = "?",
              deleted = "D",
              ignored = "!",
            },
          },
        },

        -- Caracteres ASCII puros para indentacao
        indent_markers = {
          enable = true,
          icons = {
            corner = "+- ",
            edge = "|  ",
            item = "|  ",
            none = "   ",
          },
        },

        -- Destaca arquivos abertos
        highlight_opened_files = "name",
        highlight_git = true,
      },

      -- Atalhos dentro do nvim-tree
      on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Atalhos padrao
        api.config.mappings.default_on_attach(bufnr)

        -- Atalhos customizados
        vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
      end,

      -- Comportamento
      actions = {
        open_file = {
          quit_on_open = false,
          window_picker = {
            enable = true,
          },
        },
      },

      -- Git integration
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      },

      -- Diagnosticos LSP
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "H",
          info = "I",
          warning = "W",
          error = "E",
        },
      },
    })



    -- Auto-comando para fechar nvim-tree se for o ultimo buffer
    vim.api.nvim_create_autocmd("QuitPre", {
      callback = function()
        local tree_wins = {}
        local floating_wins = {}
        local wins = vim.api.nvim_list_wins()
        for _, w in ipairs(wins) do
          local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
          if bufname:match("NvimTree_") ~= nil then
            table.insert(tree_wins, w)
          end
          if vim.api.nvim_win_get_config(w).relative ~= '' and vim.api.nvim_win_get_config(w).relative ~= 'editor' then
            table.insert(floating_wins, w)
          end
        end
        if 1 == #wins - #floating_wins - #tree_wins then
          for _, w in ipairs(tree_wins) do
            vim.api.nvim_win_close(w, true)
          end
        end
      end
    })
  end,
}
