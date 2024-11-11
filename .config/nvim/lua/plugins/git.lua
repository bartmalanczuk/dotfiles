return {
  {
    'airblade/vim-gitgutter',
    config = function()
      vim.cmd("GitGutterLineNrHighlightsEnable")
    end
  },
  'tpope/vim-fugitive',
  {'akinsho/git-conflict.nvim',
    version = "*",
    opts = {
      default_mappings = true,
    }
  }
}
