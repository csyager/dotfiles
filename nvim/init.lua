-- Enable standard filetype detection and plugins
vim.cmd("filetype plugin indent on")

-- Enable standard, clean syntax highlighting
vim.cmd("syntax on")

-- Essential editing defaults for Python formatting
vim.opt.number = true         -- Show line numbers
vim.opt.expandtab = true      -- Turn tabs into spaces
vim.opt.shiftwidth = 4        -- Set indentation level to 4 spaces
vim.opt.tabstop = 4           -- Set tab size to 4 spaces

require("config.lazy")

