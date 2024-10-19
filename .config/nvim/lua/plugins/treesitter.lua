return {
    'nvim-treesitter/nvim-treesitter', 
    build = ":TSUpdate",
    config = function()
        require('nvim-treesitter.configs').setup({
            ensure_installed = { 'javascript', 'typescript', 'c', 'lua', 'vim', 'vimdoc', 'query' },
            sync_install = false,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            autotag = {
              enable = true,
            }
        })
    end
}
