local icons = require("utils.icons")

return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = icons.left_one_quarter_block,
				tab_char = icons.left_one_quarter_block,
			},
		},
	},
}
