return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			spec = {
				{ "<Leader>c", group = "[c]ode", mode = { "n", "x" } },
				{ "<Leader>d", group = "[d]ocument" },
				{ "<Leader>r", group = "[r]ename", mode = { "n", "x" } },
				{ "<Leader>s", group = "[s]earch" },
				{ "<Leader>w", group = "[w]orkspace" },
				{ "<Leader>t", group = "[t]oggle" },
				{ "<Leader>g", group = "[g]it", mode = { "n", "x" } },
				{ "<Leader>n", group = "Swap [n]ext" },
				{ "<Leader>p", group = "Swap [p]revious" },
				{ "<Leader>x", group = "E[x]ecute" },
			},
		})

		vim.keymap.set("n", "g?", "<Cmd>WhichKey<CR>", { desc = "[?] Show all Keymaps" })
	end,
}
