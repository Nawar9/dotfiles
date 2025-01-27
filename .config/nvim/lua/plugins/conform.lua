return {
	-- TODO: toggle
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- TODO: error message when no formatter found (currently there is a bug that prevents showing the message in conform!)
	keys = {
		{
			"<Leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat code",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
		formatters_by_ft = { lua = { "stylua" } },
	},
}
