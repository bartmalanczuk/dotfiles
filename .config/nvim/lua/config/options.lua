vim.opt.guicursor = ""

--  Prepend each line with index
vim.opt.number = true
vim.opt.relativenumber = true

--  Manage tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.scrolloff = 8


vim.api.nvim_create_autocmd("VimResized", { pattern = "*", command = [[:wincmd =]] })

-- During horizontal split, move coursor to bottom pane
vim.opt.splitbelow = true
-- During vertical split, move coursor to right pane
vim.opt.splitright = true

vim.cmd.colorscheme('rose-pine')
