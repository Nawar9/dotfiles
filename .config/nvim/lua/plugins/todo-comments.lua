return {
	"folke/todo-comments.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local todo = require("todo-comments")
		todo.setup({
			signs = true,
			highlight = {
				before = "fg",
				pattern = [[<((KEYWORDS)%(\(.*\))?)\s*:]],
				keyword = "wide",
				comments_only = false,
			},
			search = { pattern = [[\b(KEYWORDS)(?:\(.*\))?\s*:]] },
		})

		vim.keymap.set("n", "]t", function()
			todo.jump_next()
		end, { desc = "Next [t]odo comment" })
		vim.keymap.set("n", "[t", function()
			todo.jump_prev()
		end, { desc = "Previous [t]odo comment" })
		vim.keymap.set("n", "<Leader>st", "<Cmd>TodoTelescope<CR>", { desc = "[s]earch [t]odo comments" })
	end,
}
