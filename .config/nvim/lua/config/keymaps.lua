local utils = require("utils")
local selection = require("utils.selection")
local icons = require("utils.icons")

local function lazyredraw_cmd_map(mode, lhs, cmd, opts)
	vim.keymap.set(mode, lhs, "<Cmd>set lazyredraw<CR>" .. cmd .. "<Cmd>set nolazyredraw<CR>", opts)
end

local function get_indent_cmd_suffix(mode)
	local cmd_suffix = ""

	if vim.fn.getcurpos()[5] == vim.v.maxcol then
		cmd_suffix = cmd_suffix .. "$"
	end

	if mode:sub(-1) == "s" then
		cmd_suffix = cmd_suffix .. vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
	end

	return cmd_suffix
end

local function indent_right()
	local mode = vim.api.nvim_get_mode().mode
	local mode_prefix = mode:sub(1, 1)

	-- TODO: what about multi cursors?
	local cmd = vim.v.count1 .. ">gv"

	if mode_prefix ~= selection.blockwise_visual then
		if vim.fn.col({ vim.fn.line("v"), "$" }) > 1 then
			cmd = cmd .. "o" .. ("l"):rep(vim.v.count1) .. "o"
		end

		if vim.fn.col({ vim.fn.line("."), "$" }) > 1 then
			cmd = cmd .. ("l"):rep(vim.v.count1)
		end
	end

	vim.api.nvim_feedkeys(cmd .. get_indent_cmd_suffix(mode), "nx", false)
end

local function indent_left()
	local function should_move_cursor(mode, line, col)
		return mode ~= selection.blockwise_visual
			and col ~= 1
			and col <= line:len()
			and vim.str_utf_end(line, col) == 0
			and line:match("^%s")
	end

	local mode = vim.api.nvim_get_mode().mode
	local mode_prefix = mode:sub(1, 1)

	local cmd_suffix = get_indent_cmd_suffix(mode)

	for _ = 1, vim.v.count1 do
		local stop = true
		local selected = selection.get(mode_prefix:upper())

		if stop then
			for _, chunk in ipairs(selected) do
				if chunk:match("^%s") then
					stop = false
					break
				end
			end
		end

		if stop then
			break
		end

		-- TODO: what about multi cursors?
		local cmd = "<gv"

		local visual_pos = vim.fn.getpos("v")
		local cursor_pos = vim.fn.getpos(".")

		local visual_line = selected[visual_pos[2] < cursor_pos[2] and 1 or #selected]
		local cursor_line = selected[visual_pos[2] > cursor_pos[2] and 1 or #selected]

		if should_move_cursor(mode_prefix, visual_line, visual_pos[3]) then
			cmd = cmd .. "oho"
		end

		if should_move_cursor(mode_prefix, cursor_line, cursor_pos[3]) then
			cmd = cmd .. "h"
		end

		vim.api.nvim_feedkeys(cmd, "nx", false)
	end

	vim.api.nvim_feedkeys(cmd_suffix, "nx", false)
end

local function new_line(above)
	local cursor_pos = vim.fn.getcurpos()
	local char = "o"

	if above then
		cursor_pos[2] = cursor_pos[2] + vim.v.count1
		char = "O"
	end

	vim.cmd.normal({ vim.v.count1 .. char, bang = true })
	vim.fn.setpos(".", cursor_pos)
end

local function toggle_show_end_of_line()
	local state

	if vim.opt.listchars:get().eol then
		state = false
		vim.opt.listchars:remove("eol")
	else
		state = true
		vim.opt.listchars:append({ eol = icons.downwards_arrow_with_tip_leftwards })
	end

	utils.notify_toggle("End of Line", state)
end

-- TODO: check out rsi.vim
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { desc = "Remove search highlights" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set({ "i", "s" }, "<A-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set({ "i", "s" }, "<A-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set({ "i", "s" }, "<A-j>", "<Down>", { desc = "Move cursor down" })
vim.keymap.set({ "i", "s" }, "<A-k>", "<Up>", { desc = "Move cursor up" })

lazyredraw_cmd_map({ "i", "s" }, "<A-w>", "<C-o>w", { desc = "Next word" })
lazyredraw_cmd_map({ "i", "s" }, "<A-S-w>", "<C-o>W", { desc = "Next WORD" })
lazyredraw_cmd_map({ "i", "s" }, "<A-b>", "<C-o>b", { desc = "Prev word" })
lazyredraw_cmd_map({ "i", "s" }, "<A-S-b>", "<C-o>B", { desc = "Prev WORD" })

lazyredraw_cmd_map("i", "<A-e>", "<Esc>ea", { desc = "Next end of word" })
lazyredraw_cmd_map("s", "<A-e>", "<C-o>e", { desc = "Next end of word" })
lazyredraw_cmd_map("i", "<A-S-e>", "<Esc>Ea", { desc = "Next end of WORD" })
lazyredraw_cmd_map("s", "<A-S-e>", "<C-o>E", { desc = "Next end of WORD" })

lazyredraw_cmd_map({ "i", "s" }, "<A-S-$>", "<C-o>$", { desc = "End of line" })
lazyredraw_cmd_map({ "i", "s" }, "<A-S-^>", "<C-o>^", { desc = "Start of line (non ws)" })
lazyredraw_cmd_map({ "i", "s" }, "<A-0>", "<C-o>0", { desc = "Start of line" })

lazyredraw_cmd_map("s", "<A-o>", "<C-o>o", { desc = "Other corner of highlighted text" })
lazyredraw_cmd_map("s", "<A-S-o>", "<C-o>O", { desc = "Other side of highlighted text" })

lazyredraw_cmd_map("i", "<C-k>", "<C-o>D", { desc = "Delete after the cursor" })

vim.keymap.set("x", "<BS>", "<Del>", { desc = "Delete selected" })
vim.keymap.set("n", "<BS>", "X", { desc = "Delete character before the cursor" })

vim.keymap.set("x", ">", indent_right, { desc = "Indent right" })
vim.keymap.set("x", "<", indent_left, { desc = "Indent left" })

vim.keymap.set("n", "<A-o>", new_line, { desc = "New line below the cursor" })
vim.keymap.set("n", "<A-S-o>", function()
	new_line(true)
end, { desc = "New line above the cursor" })

vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Move focus to the upper window" })

vim.keymap.set("n", "<Leader>l", vim.diagnostic.setloclist, { desc = "Show diagnostics in [l]ocation list" })

vim.keymap.set("n", "<Leader>te", toggle_show_end_of_line, { desc = "[t]oggle show [e]nd of line" })

-- TODO: move to after/ftplugins
-- TODO: try to make something pop up even if no output
-- TODO: take a look at duplicate.nvim and mini-move (and others)
vim.keymap.set("x", "<Leader>x", "<Esc><Cmd>'<,'>lua<CR>", { desc = "E[x]ecute selection" })
vim.keymap.set("n", "<Leader>xx", "<Cmd>.lua<CR>", { desc = "E[x]ecute line" })
vim.keymap.set("n", "<Leader>xf", "<Cmd>source %<CR>", { desc = "E[x]ecute [f]ile" })
