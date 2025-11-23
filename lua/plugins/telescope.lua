-- ====================================================================
--                       TELESCOPE
-- ====================================================================

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Adicionado para ícones
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }, -- Adicionado para performance
  },
  config = function()
    local ok_telescope, telescope = pcall(require, 'telescope')
    if not ok_telescope then
      vim.notify("Erro ao carregar telescope", vim.log.levels.ERROR)
      return
    end

    local ok_actions, actions = pcall(require, 'telescope.actions')
    if not ok_actions then
      vim.notify("Erro ao carregar telescope.actions", vim.log.levels.ERROR)
      return
    end

    telescope.setup({
      defaults = {
        -- Argumentos para ripgrep
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob=!.git/',
        },

        -- Caracteres ASCII simples (mantido o minimalismo)
        prompt_prefix = '> ',
        selection_caret = '> ',
        entry_prefix = '  ',
        multi_icon = '+',

        -- Bordas ASCII simples (mantido o minimalismo)
        borderchars = { '-', '|', '-', '|', '+', '+', '+', '+' },

        -- Comportamento
        path_display = { "truncate" },
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "target/",
          "*.class",
        },

        -- Layout
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            prompt_position = "top",
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },

        -- Sorting
        sorting_strategy = "ascending",
        file_sorter = require('telescope.sorters').get_fuzzy_file,
        generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,

        -- Keymaps dentro do telescope
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-x>"] = actions.delete_buffer,
            ["<Esc>"] = actions.close,
            ["<C-u>"] = false, -- Limpa prompt
          },
          n = {
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["q"] = actions.close,
          },
        },
      },

      pickers = {
        find_files = {
          find_command = {
            'rg',
            '--files',
            '--hidden',
            '--glob=!.git/',
            '--glob=!node_modules/',
          },
          previewer = true,
        },

        live_grep = {
          only_sort_text = true,
          previewer = true,
        },

        buffers = {
          sort_lastused = true,
          previewer = false,
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },

        git_files = {
          previewer = true,
        },

        lsp_references = {
          show_line = false,
          previewer = true,
        },

        lsp_definitions = {
          previewer = true,
        },
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Carrega a extensão fzf
    telescope.load_extension("fzf")


  end,
}
