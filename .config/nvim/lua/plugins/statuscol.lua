-- INFO: Done
return {
	"luukvbaal/statuscol.nvim",

	opts = function()
		local builtin = require("statuscol.builtin")

		-- HACK: https://github.com/luukvbaal/statuscol.nvim/issues/150
		-- and fix status git and diagnostic signs `Cul` when changing theme and remove Cul overrides from catppuccine
		for _, win_id in ipairs(vim.api.nvim_list_wins()) do
			local numberwidth = vim.wo[win_id].numberwidth - 1
			if numberwidth > 0 then
				vim.wo[win_id].numberwidth = numberwidth
			end
		end

		return {
			thousands = false,
			relculright = false,
			clickmod = "c",

			segments = {
				{
					sign = {
						name = { ".*" },
						namespace = { ".*" },
						maxwidth = 1,
						colwidth = 2,
						foldclosed = true,
					},
					condition = {
						function(args)
							return args.nu or args.rnu
						end,
					},
					click = "v:lua.ScSa",
				},

				{
					text = {
						builtin.lnumfunc,
						" ",
					},
					condition = {
						true,
						function(args)
							return args.nu or args.rnu
						end,
					},
					click = "v:lua.ScLa",
				},

				{
					sign = {
						namespace = { "gitsigns_signs_" },
						maxwidth = 1,
						colwidth = 1,
						auto = true,
						wrap = true,
						foldclosed = true,
						fillcharhl = "FoldColumn",
					},
					click = "v:lua.ScSa",
				},

				{
					text = {
						function(args)
							local fold_col = builtin.foldfunc(args)
							return fold_col == "" and fold_col or fold_col:sub(1, -3) .. " " .. fold_col:sub(-2)
						end,
					},
					click = "v:lua.ScFa",
				},
			},
		}
	end,
}
