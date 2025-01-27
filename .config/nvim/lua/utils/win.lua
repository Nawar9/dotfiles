-- INFO: dead code
local M = {}

function M.get_parent_win(win)
	if not win then
		win = vim.api.nvim_get_current_win()
	elseif not vim.api.nvim_win_is_valid(win) then
		return nil
	end

	local win_config = vim.api.nvim_win_get_config(win)

	if win_config.relative == "win" and vim.api.nvim_win_is_valid(win_config.win) then
		return win_config.win
	end

	return nil
end

function M.get_root_win(win)
	local parent_win = win or vim.api.nvim_get_current_win()

	while parent_win ~= nil do
		win = parent_win
		parent_win = M.get_parent_win(win)
	end

	return win
end

return M
