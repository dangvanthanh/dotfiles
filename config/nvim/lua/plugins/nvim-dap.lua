return {
	{
		"mfussenegger/nvim-dap",
		config = function() end,
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			-- TODO: Path to debuggy
			require("dap-python").setup("")
		end,
	},
}