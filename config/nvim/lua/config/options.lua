-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = false
vim.opt.winbar = "%=%m %f"
vim.opt.conceallevel = 0
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.autoindent = true

vim.g.lazygit_config = false
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_no_inlay_hints = true
vim.g.lazyvim_prettier_needs_config = true
vim.g.lazyvim_blink_main = false
vim.g.lazyvim_picker = "fzf"

vim.api.nvim_set_var("vim_markdown_frontmatter ", 1)