-- ====================================================================
--                       NVIM-CMP
-- ====================================================================

return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'nvim-tree/nvim-web-devicons', -- Para ícones no CMP e outros plugins
    -- 'mfussenegger/nvim-jdtls', -- Removido, deve ser dependência do JDTLS
  },
  config = function()
    local ok, cmp = pcall(require, 'cmp')
    if not ok then
      vim.notify("Erro ao carregar nvim-cmp", vim.log.levels.ERROR)
      return
    end

    cmp.setup({
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },
        { name = 'buffer', priority = 800 },
        { name = 'path', priority = 600 },
      }),

      mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
      }),

      completion = {
        completeopt = 'menu,menuone,noselect',
      },

      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = '[LSP]',
            buffer = '[BUF]',
            path = '[PATH]',
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
    })
  end,
}
