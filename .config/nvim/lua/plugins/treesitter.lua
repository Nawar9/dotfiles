return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	-- TODO: dependency?
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			-- TODO: consider nvim-next
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"printf",
			"diff",
			"gitignore",
			"html",
			"json",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
		},
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<A-u>",
				node_incremental = "<A-u>",
				scope_incremental = "<A-S-u>",
				node_decremental = "<A-d>",
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					-- TODO: add entire buffer text object (preferably outside treesitter)
					["ao"] = { query = "@local.scope", query_group = "locals", desc = "sc[o]pe" },
					["ic"] = { query = "@class.inner", desc = "[i]nner [c]lass" },
					["ac"] = { query = "@class.outer", desc = "[c]lass" },
					["im"] = { query = "@function.inner", desc = "[i]nner [m]ethod" },
					["am"] = { query = "@function.outer", desc = "[m]ethod" },
					["if"] = { query = "@call.inner", desc = "[i]nner [f]unction call" },
					["af"] = { query = "@call.outer", desc = "[f]unction call" },
					["il"] = { query = "@loop.inner", desc = "[i]nner [l]oop" },
					["al"] = { query = "@loop.outer", desc = "[l]oop" },
					["ii"] = { query = "@conditional.inner", desc = "[i]nner [i]f statement" },
					["ai"] = { query = "@conditional.outer", desc = "[i]f statement" },
					["ia"] = { query = "@parameter.inner", desc = "[i]nner [a]rgument" },
					["aa"] = { query = "@parameter.outer", desc = "[a]rgument" },
					["in"] = { query = "@comment.inner", desc = "[i]nner comme[n]t" },
					["an"] = { query = "@comment.outer", desc = "comme[n]t" },
				},
			},
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]c"] = { query = "@class.outer", desc = "Next [c]lass start" },
					["]m"] = { query = "@function.outer", desc = "Next [m]ethod start" },
					["]f"] = { query = "@call.outer", desc = "Next [f]unction call start" },
					["]l"] = { query = "@loop.outer", desc = "Next [l]oop start" },
					["]i"] = { query = "@conditional.outer", desc = "Next [i]f statement start" },
					["]a"] = { query = "@parameter.outer", desc = "Next [a]rgument start" },
					["]n"] = { query = "@comment.outer", desc = "Next comme[n]t start" },
				},
				goto_next_end = {
					["]C"] = { query = "@class.outer", desc = "Next [C]lass end" },
					["]M"] = { query = "@function.outer", desc = "Next [M]ethod end" },
					["]F"] = { query = "@call.outer", desc = "Next [F]unction call end" },
					["]L"] = { query = "@loop.outer", desc = "Next [L]oop end" },
					["]I"] = { query = "@conditional.outer", desc = "Next [I]f statement end" },
					["]A"] = { query = "@parameter.outer", desc = "Next [A]rgument end" },
					["]N"] = { query = "@comment.outer", desc = "Next comme[N]t end" },
				},
				goto_previous_start = {
					["[c"] = { query = "@class.outer", desc = "Previous [c]lass start" },
					["[m"] = { query = "@function.outer", desc = "Previous [m]ethod start" },
					["[f"] = { query = "@call.outer", desc = "Previous [f]unction call start" },
					["[l"] = { query = "@loop.outer", desc = "Previous [l]oop start" },
					["[i"] = { query = "@conditional.outer", desc = "Previous [i]f statement start" },
					["[a"] = { query = "@parameter.outer", desc = "Previous [a]rgument start" },
					["[n"] = { query = "@comment.outer", desc = "Previous comme[n]t start" },
				},
				goto_previous_end = {
					["[C"] = { query = "@class.outer", desc = "Previous [C]lass end" },
					["[M"] = { query = "@function.outer", desc = "Previous [M]ethod end" },
					["[F"] = { query = "@call.outer", desc = "Previous [F]unction call end" },
					["[L"] = { query = "@loop.outer", desc = "Previous [L]oop end" },
					["[I"] = { query = "@conditional.outer", desc = "Previous [I]f statement end" },
					["[A"] = { query = "@parameter.outer", desc = "Previous [A]rgument end" },
					["[N"] = { query = "@comment.outer", desc = "Previous comme[N]t end" },
				},
			},
			swap = {
				enable = true,
				-- TODO: swap word and WORD?
				swap_next = {
					["<leader>nc"] = { query = "@class.outer", desc = "swap [n]ext [c]lass" },
					["<leader>nm"] = { query = "@function.outer", desc = "swap [n]ext [m]ethod" },
					["<leader>na"] = { query = "@parameter.inner", desc = "swap [n]ext [a]rgument" },
				},
				swap_previous = {
					["<leader>pc"] = { query = "@class.outer", desc = "swap [p]revious [c]lass" },
					["<leader>pm"] = { query = "@function.outer", desc = "swap [p]revious [m]ethod" },
					["<leader>pa"] = { query = "@parameter.inner", desc = "swap [p]revious [a]rgument" },
				},
			},
		},
	},
}
