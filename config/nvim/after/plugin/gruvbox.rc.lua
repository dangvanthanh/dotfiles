local status, n = pcall(require, 'gruvbox')
if (not status) then return end

n.setup({
  italic = true
})

vim.cmd("colorscheme gruvbox")
