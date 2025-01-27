vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight yanked text",
	group = vim.api.nvim_create_augroup("nvconfig-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local original_hl
local original_cursor

local select_pattern = "[sS" .. vim.api.nvim_replace_termcodes("<C-s>", true, true, true) .. "]"
local highlight_select_augroup = vim.api.nvim_create_augroup("nvconfig-highlight-select", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
	desc = "Change highlight and cursor of select mode",
	group = highlight_select_augroup,
	pattern = "*:" .. select_pattern,

	callback = function()
		original_hl = vim.api.nvim_get_hl(0, { name = "Visual", link = true })
		original_hl.default = nil
		vim.api.nvim_set_hl(0, "Visual", { link = "Substitute" })

		original_cursor = vim.opt.guicursor
		vim.opt.guicursor = { "a:blinkwait700-blinkoff400-blinkon250" }
	end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	desc = "Restore highlight and cursor after select mode",
	group = highlight_select_augroup,
	pattern = select_pattern .. ":*",

	callback = function()
		vim.api.nvim_set_hl(0, "Visual", original_hl)

		vim.opt.guicursor = original_cursor
	end,
})
