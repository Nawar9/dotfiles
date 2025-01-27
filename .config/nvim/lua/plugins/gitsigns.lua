-- NOTE: Done
local utils = require("utils")
local icons = require("utils.icons")

return {
	"lewis6991/gitsigns.nvim",

	opts = function()
		-- TODO: consider nvim-next and vim-repeat
		local gitsigns = require("gitsigns")

		local function map1(mode, lhs, rhs, opts)
			opts.desc = "Git: " .. opts.desc
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		local function map2(mode, lhs, rhs, opts)
			opts.desc = "[g]it: " .. opts.desc
			vim.keymap.set(mode, lhs, rhs, opts)
		end

		vim.keymap.set({ "n", "x", "o" }, "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next", { target = "all" })
			end
		end, { desc = "Next [h]unk" })

		vim.keymap.set({ "n", "x", "o" }, "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev", { target = "all" })
			end
		end, { desc = "Previous [h]unk" })

		map1({ "x", "o" }, "ah", gitsigns.select_hunk, { desc = "[h]unk" })

		map2("x", "<Leader>gs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[s]tage selection" })

		map2("n", "<Leader>gs", gitsigns.stage_hunk, { desc = "[s]tage hunk" })
		map2("n", "<Leader>gS", gitsigns.stage_buffer, { desc = "[S]tage buffer" })

		map2("x", "<Leader>gr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[r]eset selection" })

		map2("n", "<Leader>gr", gitsigns.reset_hunk, { desc = "[r]eset hunk" })
		map2("n", "<Leader>gR", gitsigns.reset_buffer, { desc = "[R]eset buffer" })

		map2("n", "<Leader>gU", gitsigns.reset_buffer_index, { desc = "[U]nstage buffer" })

		map2("n", "<Leader>gb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "[b]lame line" })
		map2("n", "<Leader>gB", gitsigns.blame, { desc = "[B]lame buffer" })

		map2("n", "<Leader>gp", gitsigns.preview_hunk, { desc = "[p]review hunk" })

		map2("n", "<Leader>gd", gitsigns.diffthis, { desc = "[d]iff against index" })
		map2("n", "<Leader>gD", function()
			gitsigns.diffthis("HEAD")
		end, { desc = "[D]iff against HEAD" })

		map2("n", "<Leader>gl", gitsigns.setloclist, { desc = "Show hunks in [l]ocation list" })

		map1("n", "<Leader>tb", function()
			utils.notify_toggle("Blame Line", gitsigns.toggle_current_line_blame())
		end, { desc = "[t]oggle show [b]lame line" })

		map1("n", "<Leader>tl", function()
			utils.notify_toggle("Line Highlights", gitsigns.toggle_linehl())
		end, { desc = "[t]oggle show [l]ine highlights" })

		map1("n", "<Leader>td", function()
			-- NOTE:: deprecated
			utils.notify_toggle("Deleted Lines", gitsigns.toggle_deleted())
		end, { desc = "[t]oggle show [d]eleted lines" })

		map1("n", "<Leader>tw", function()
			utils.notify_toggle("Word Difference", gitsigns.toggle_word_diff())
		end, { desc = "[t]oggle show [w]ord difference" })

		local signs = {
			add = { text = icons.box_drawings_heavy_vertical },
			change = { text = icons.box_drawings_heavy_vertical },
			delete = { text = icons.box_drawings_heavy_vertical },
			topdelete = { text = icons.box_drawings_heavy_vertical },
			changedelete = { text = icons.box_drawings_heavy_vertical },
			untracked = { text = icons.box_drawings_light_triple_dash_vertical },
		}

		return {
			signs = signs,
			signs_staged = signs,

			signs_staged_enable = true,
			attach_to_untracked = true,

			culhl = true,

			current_line_blame = true,
			current_line_blame_formatter = "    <author>, <author_time:%R> - <summary>",
			current_line_blame_formatter_nc = "    <author>",

			current_line_blame_opts = {
				virt_text_pos = "eol",
				delay = 1000,
				virt_text_priority = 10000,
			},

			preview_config = {
				border = "rounded",
				title = " Git Preview ",
				title_pos = "center",
			},
		}
	end,
}
