return {
	"folke/snacks.nvim",
	keys = {
		{ "<leader>e", false },
		{
			"<leader><space>",
			function()
				Snacks.picker.files({
					finder = "files",
					format = "file",
					show_empty = true,
					supports_live = true,
				})
			end,
			desc = "Find Files",
		},
	},
	opts = {
		picker = {
			transform = function(item)
				if not item.file then
					return item
				end
				-- Demote the "lazyvim" keymaps file:
				if item.file:match("lazyvim/lua/config/keymaps%.lua") then
					item.score_add = (item.score_add or 0) - 30
				end
				return item
			end,
			sources = {
				explorer = {
					hidden = true,
					ignored = true,
					exclude = { "node_modules", ".git", ".DS_Store" },
					include = { ".env", ".env.local" },
				},
				files = {
					hidden = true,
					ignored = true,
					exclude = { "node_modules", ".DS_Store" },
				},
			},
			debug = {
				scores = false, -- show scores in the list
			},
			layout = {
				cycle = false,
			},
			matcher = {
				frecency = true,
			},
			win = {
				input = {
					keys = {
						-- to close the picker on ESC instead of going to normal mode,
						-- add the following keymap to your config
						["<Esc>"] = { "close", mode = { "n", "i" } },
						-- I'm used to scrolling like this in LazyGit
						["J"] = { "preview_scroll_down", mode = { "i", "n" } },
						["K"] = { "preview_scroll_up", mode = { "i", "n" } },
						["H"] = { "preview_scroll_left", mode = { "i", "n" } },
						["L"] = { "preview_scroll_right", mode = { "i", "n" } },
					},
				},
			},
			formatters = {
				file = {
					filename_first = true, -- display filename before the file path
					truncate = 80,
				},
			},
		},
		lazygit = {
			theme = {
				selectedLineBgColor = { bg = "CursorLine" },
			},
			win = {
				width = 0,
				height = 0,
			},
		},
		notifier = {
			enabled = true,
			top_down = false, -- place notifications from top to bottom
		},
		styles = {
			snacks_image = {
				relative = "editor",
				col = -1,
			},
		},
		image = {
			enabled = true,
			doc = {
				inline = vim.g.neovim_mode == "skitty" and true or false,
				float = true,
				max_width = vim.g.neovim_mode == "skitty" and 5 or 60,
				max_height = vim.g.neovim_mode == "skitty" and 2.5 or 30,
			},
		},
		dashboard = {
			preset = {
				keys = {
					-- { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					-- { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					-- { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
					-- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					-- {
					--   icon = " ",
					--   key = "c",
					--   desc = "Config",
					--   action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					-- },
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					-- { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = " ", key = "<esc>", desc = "Quit", action = ":qa" },
				},
				-- https://patorjk.com/software/taag
				header = [[
	███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
	████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
	██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
	██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
	██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
	╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},
		},
	},
}
