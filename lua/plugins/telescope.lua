-- ====================================================================
--                       TELESCOPE
-- ====================================================================

return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
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

        -- Caracteres ASCII simples
        prompt_prefix = '> ',
        selection_caret = '> ',
        entry_prefix = '  ',
        multi_icon = '+',

        -- Bordas ASCII simples
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
        -- Extensoes futuras podem ser adicionadas aqui
      },
    })

    -- Keymaps globais
    local builtin_ok, builtin = pcall(require, 'telescope.builtin')
    if builtin_ok then
      -- Arquivos
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Recent files' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find word under cursor' })

      -- Git
      vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Git files' })
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })

      -- LSP
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'LSP references' })
      vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = 'LSP definitions' })
      vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'LSP document symbols' })
      vim.keymap.set('n', '<leader>lw', builtin.lsp_workspace_symbols, { desc = 'LSP workspace symbols' })

      -- Diagnosticos
      vim.keymap.set('n', '<leader>dd', builtin.diagnostics, { desc = 'Diagnostics' })

      -- Outros
      vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Keymaps' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = 'Resume last search' })
    else
      vim.notify("Erro ao carregar telescope.builtin", vim.log.levels.ERROR)
    end
  end,
}
