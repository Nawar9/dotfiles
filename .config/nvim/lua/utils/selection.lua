local M = {}

M.blockwise_visual = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)

local function get_visual_pos(mode)
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")

	local start_virt_col = vim.fn.virtcol("v", true)
	local end_virt_col = vim.fn.virtcol(".", true)

	if start_line > end_line then
		start_line, end_line = end_line, start_line
		start_virt_col, end_virt_col = end_virt_col, start_virt_col
	end

	if (mode == M.blockwise_visual or start_line == end_line) and start_virt_col[1] > end_virt_col[1] then
		start_virt_col, end_virt_col = end_virt_col, start_virt_col
	end

	return { start_line, start_virt_col[1] }, { end_line, end_virt_col[2] }
end

local function trim_end(line, line_nr, end_virt_col)
	local end_byte_col = vim.fn.virtcol2col(0, line_nr, end_virt_col)

	if line ~= "" then
		line = line:sub(1, end_byte_col + vim.str_utf_end(line, end_byte_col))
	end

	return line
end

local function trim_start(line, line_nr, start_virt_col)
	local start_byte_col = vim.fn.virtcol2col(0, line_nr, start_virt_col)

	line = line:sub(start_byte_col)

	if start_virt_col >= vim.fn.virtcol({ line_nr, "$" }) then
		line = ""
	end

	return line
end

-- TODO: consider using vim.fn.getregionpos() and inline it and remove `require("utils.selection")`
function M.get(mode)
	local start_pos, end_pos = get_visual_pos(mode)

	local start_line, start_virt_col = unpack(start_pos)
	local end_line, end_virt_col = unpack(end_pos)

	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	if mode == "v" then
		lines[#lines] = trim_end(lines[#lines], end_line, end_virt_col)
		lines[1] = trim_start(lines[1], start_line, start_virt_col)
	elseif mode == M.blockwise_visual then
		for i = 1, #lines do
			lines[i] = trim_end(lines[i], start_line + i - 1, end_virt_col)
			lines[i] = trim_start(lines[i], start_line + i - 1, start_virt_col)
		end
	end

	return lines
end

return M
