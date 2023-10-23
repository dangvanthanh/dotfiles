local status, n = pcall(require, 'gruvbox')
if (not status) then return end

n.setup({
  terminal_colors = true,
  italic = true
})

vim.cmd("colorscheme gruvbox")
