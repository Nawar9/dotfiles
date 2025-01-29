-- INFO: dead code
local M = {}

function M.get_parent_win_id(win_id)
	if not win_id then
		win_id = vim.api.nvim_get_current_win()
	elseif not vim.api.nvim_win_is_valid(win_id) then
		return nil
	end

	local win_config = vim.api.nvim_win_get_config(win_id)

	if win_config.relative == "win" and vim.api.nvim_win_is_valid(win_config.win) then
		return win_config.win
	end

	return nil
end

function M.get_root_win_id(win_id)
	local parent_win_id = win_id or vim.api.nvim_get_current_win()

	while parent_win_id ~= nil do
		win_id = parent_win_id
		parent_win_id = M.get_parent_win_id(win_id)
	end

	return win_id
end

return M
