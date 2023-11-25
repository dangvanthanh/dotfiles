-- colorscheme
return {
  -- gruvbox configuration
  { "ellisonleao/gruvbox.nvim" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
      priority = 1000,
      config = true,
    },
  },
}
