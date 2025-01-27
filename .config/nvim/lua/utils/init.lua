local M = {}

function M.notify_toggle(name, state)
	vim.notify(name .. ": " .. (state and "On" or "Off"), vim.log.levels.INFO)
end

return M
