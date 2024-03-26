-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Highlight YAML front matter
vim.api.nvim_set_var("vim_markdown_frontmatter ", 1)

vim.opt.winbar = "%=%m %f"

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.lazyvim_python_lsp = "basedpyright"