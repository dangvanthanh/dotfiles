return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre", "BufNewFile" },
		cmd = "ConformInfo",
		keys = {
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 1000 })
				end,
				mode = { "n", "v" },
				desc = "Format Injected Langs",
			},
		},
		opts = {
			default_format_ops = {
				timeout_ms = 1000,
				async = false, -- not recommended to change
				quiet = false, -- not recommended to change
				lsp_fallback = true, -- not recommended to change
			},
			formatters_by_ft = {
				["sh"] = { "shfmt" },
				["lua"] = { "stylua" },
				["fish"] = { "fish_indent" },
				["javascript"] = { "biome" },
				["typescript"] = { "biome" },
				["javascriptreact"] = { "biome" },
				["typescriptreact"] = { "biome" },
				["svelte"] = { "biome" },
				["scss"] = { "biome" },
				["css"] = { "biome" },
				["html"] = { "biome" },
				["json"] = { "biome" },
				["jsonc"] = { "biome" },
				["yaml"] = { "biome" },
				["graphql"] = { "biome" },
				["python"] = { "isort", "ruff" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
			},
		},
	},
}
