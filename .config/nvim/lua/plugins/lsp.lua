return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = true,
    config = false,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    opts = {},
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    fix_pairs = true,
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'copilot',  group_index = 2 },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    init = function()
      -- Reserve a space in the gutter
      -- This will avoid an annoying layout shift in the screen
      vim.opt.signcolumn = 'yes'
    end,
    config = function()
      local lsp_defaults = require('lspconfig').util.default_config

      -- Add cmp_nvim_lsp capabilities settings to lspconfig
      -- This should be executed before you configure any language server
      lsp_defaults.capabilities = vim.tbl_deep_extend(
        'force',
        lsp_defaults.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- LspAttach is where you enable features that only work
      -- if there is a language server active in the file
      vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP actions',
        callback = function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set({ 'n', 'v' }, '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
          vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set('n', '<space>f', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
          vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
          vim.keymap.set('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        end,
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buffer,
        callback = function()
          vim.lsp.buf.format { async = false }
        end
      })

      require('mason-lspconfig').setup({
        ensure_installed = { 'ts_ls', 'eslint@4.8.0', 'lua_ls', 'jsonls', 'biome', 'gopls' },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        }
      })
    end
  }
}
