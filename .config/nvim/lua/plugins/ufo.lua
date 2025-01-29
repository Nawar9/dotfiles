-- INFO: Done
local highlight = require("utils.highlight")
local lsp = require("utils.lsp")
local icons = require("utils.icons")

local hover_desc = "Hover"

local function hover()
	local function fallback_hover()
		if vim.tbl_isempty(vim.lsp.get_clients({ bufnr = 0 })) then
			vim.api.nvim_feedkeys("K", "nx", false)
		else
			vim.lsp.buf.hover()
		end
	end

	local win_id = require("ufo").peekFoldedLinesUnderCursor(false, false)

	if win_id then
		vim.api.nvim_set_option_value(
			"winhighlight",
			"Normal:Folded,CursorLine:UfoPreviewCursorLine,Visual:UfoPreviewVisual",
			{ scope = "local", win = win_id }
		)

		local buf_nr = vim.api.nvim_win_get_buf(win_id)
		local keys = { "a", "i", "o", "A", "I", "O" }

		for _, key in ipairs(keys) do
			-- TODO: ignore which key?
			local desc = vim.fn.maparg(key, "n", false, true).desc
			vim.keymap.set("n", key, "<CR>" .. key, { desc = desc, buffer = buf_nr, remap = true })
		end

		for _, keymap in ipairs(lsp.keymaps) do
			vim.keymap.set(keymap.mode or "n", keymap.lhs, keymap.ufo_trace and function()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "x", false)
				keymap.callback()
			end or function()
				vim.api.nvim_win_close(win_id, false)
				keymap.callback()
			end, { desc = keymap.desc, buffer = buf_nr, remap = keymap.ufo_trace })
		end

		vim.keymap.set("n", "K", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "x", false)
			fallback_hover()
		end, { desc = hover_desc, buffer = buf_nr })
	else
		fallback_hover()
	end
end

local function fold_virt_text_handler(virt_text, lnum, end_lnum, width, truncate)
	local suffix_left = " " .. icons.midline_horizontal_ellipsis .. " "
	local suffix_right = "    (" .. end_lnum - lnum .. " lines) "

	local target_width = width - vim.fn.strdisplaywidth(suffix_right) - vim.fn.strdisplaywidth(suffix_left)
	local cur_width = 0

	local new_virt_text = {}

	for _, chunk in ipairs(virt_text) do
		local chunk_text = chunk[1]
		local chunk_width = vim.fn.strdisplaywidth(chunk_text, cur_width)

		if target_width > cur_width + chunk_width then
			table.insert(new_virt_text, chunk)

			cur_width = cur_width + chunk_width
		else
			chunk_text = truncate(chunk_text, target_width - cur_width)
			table.insert(new_virt_text, { chunk_text, chunk[2] })

			chunk_width = vim.fn.strdisplaywidth(chunk_text, cur_width)
			cur_width = cur_width + chunk_width
			break
		end
	end

	table.insert(new_virt_text, { suffix_left, "Comment" })
	table.insert(new_virt_text, { (" "):rep(target_width - cur_width), "UfoFoldedFg" })
	table.insert(new_virt_text, { suffix_right, "UfoFoldedFg" })

	return new_virt_text
end

return {
	"kevinhwang91/nvim-ufo",

	-- WARNING: lazy loading ruins keymaps sometimes (K)
	dependencies = { "kevinhwang91/promise-async" },

	init = function()
		highlight.add("UfoPreviewVisual", { link = "Visual", default = true })
		highlight.add("UfoPreviewWinBar", { link = "UfoPreviewVisual" })
	end,

	opts = function()
		local ufo = require("ufo")

		vim.keymap.set("n", "]Z", ufo.goNextClosedFold, { desc = "Next closed fold" })
		vim.keymap.set("n", "[Z", ufo.goPreviousClosedFold, { desc = "Previous closed fold" })

		-- TODO: remove zr and zm?(if there are others using Nvconfig.g.wkignore ore something)
		vim.keymap.set("n", "zR", ufo.openAllFolds)
		vim.keymap.set("n", "zM", ufo.closeAllFolds)

		vim.keymap.set("n", "K", hover, { desc = hover_desc })

		return {
			open_fold_hl_timeout = 300,
			fold_virt_text_handler = fold_virt_text_handler,

			provider_selector = function()
				return { "treesitter", "indent" }
			end,

			preview = {
				win_config = {
					border = "none",
					winhighlight = "",
					winblend = 10,
					maxheight = 20,
				},

				mappings = {
					scrollB = "<C-b>",
					scrollF = "<C-f>",
					scrollU = "<C-u>",
					scrollD = "<C-d>",
					scrollE = "<C-E>",
					scrollY = "<C-Y>",
					jumpTop = "[[",
					jumpBot = "]]",
					switch = "K",
					trace = "<CR>",
					close = "<Esc>",
				},
			},
		}
	end,
}
