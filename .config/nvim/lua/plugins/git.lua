return {
  'airblade/vim-gitgutter',
  'tpope/vim-fugitive',
  config = function()
    vim.cmd("GitGutterLineNrHighlightsEnable")
  end,
}
