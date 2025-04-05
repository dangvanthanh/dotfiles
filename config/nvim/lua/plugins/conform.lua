return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
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
				["javascript"] = { "biome" },
				["typescript"] = { "biome" },
				["javascriptreact"] = { "biome" },
				["typescriptreact"] = { "biome" },
				["json"] = { "biome" },
				["jsonc"] = { "biome" },
				["html"] = { "biome" },
				["svelte"] = { "biome" },
				["scss"] = { "biome" },
				["css"] = { "biome" },
				["yaml"] = { "biome" },
				["markdown"] = { "biome", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "biome", "markdownlint-cli2", "markdown-toc" },
				["graphql"] = { "biome" },
				["lua"] = { "stylua" },
				["fish"] = { "fish_indent" },
				["sh"] = { "shfmt" },
			},
			formatters = {
				injected = { options = { ignore_errors = true } },
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
		},
	},
}
