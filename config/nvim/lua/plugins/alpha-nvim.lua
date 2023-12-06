return {
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "███    ██ ███████  ██████  ██    ██ ██ ███    ███",
        "████   ██ ██      ██    ██ ██    ██ ██ ████  ████",
        "██ ██  ██ █████   ██    ██ ██    ██ ██ ██ ████ ██",
        "██  ██ ██ ██      ██    ██  ██  ██  ██ ██  ██  ██",
        "██   ████ ███████  ██████    ████   ██ ██      ██",
      }
      dashboard.section.header.opts.hl = "DashboardHeader"
      dashboard.section.footer.opts.hl = "DashboardFooter"

    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
      dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
      dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
      dashboard.button("c", " " .. " Config",          "<cmd> lua require('lazyvim.util').telescope.config_files()() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.config.layout = {
        { type = "padding", val = vim.fn.max({ 2, vim.fn.floor(vim.fn.winheight(0) * 0.125) }) },
        dashboard.section.header,
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }
      dashboard.config.opts.noautocmd = true
      return dashboard
    end,
  },
}