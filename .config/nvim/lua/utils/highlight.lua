M = {
	Folded = { bg = "#342E4F" },
	FoldedCurserLine = { bg = "#443E5F" },
	FoldedVisual = { bg = "#544E6F", bold = true },
}

local persistent_hls = {}

function M.add(name, opts)
	persistent_hls[name] = opts
end

local function set_highlights()
	for name, opts in pairs(persistent_hls) do
		vim.api.nvim_set_hl(0, name, opts)
	end
end

vim.api.nvim_create_autocmd("User", {
	desc = "Attach persistent highlights (endure color scheme changes)",
	pattern = "LazyDone",
	once = true,
	callback = function()
		set_highlights()

		vim.api.nvim_create_autocmd("ColorScheme", {
			desc = "Apply persistent highlights (endure color scheme changes)",
			group = vim.api.nvim_create_augroup("nvconfig-persistent-highlights", { clear = true }),
			callback = set_highlights,
		})
	end,
})

return M
