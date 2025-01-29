local highlight = require("utils.highlight")

return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	enabled = false,

	init = function()
		vim.cmd.colorscheme("catppuccin-mocha")
	end,

	opts = {
		dim_inactive = {
			enabled = true,
			shade = "light",
			percentage = 0.4,
		},
		highlight_overrides = {
			mocha = function(colors)
				local num_col_bg = colors.surface0

				return {
					FloatBorder = { bg = colors.mantle },
					FloatTitle = { fg = colors.red, bg = colors.mantle },

					WinSeparator = { fg = colors.mantle, bg = colors.mantle },
					MsgSeparator = { link = "Question" },

					IncSearch = { bg = colors.peach },

					Folded = { fg = colors.text, bg = highlight.Folded.bg },
					UfoPreviewCursorLine = highlight.FoldedCurserLine,
					UfoPreviewVisual = highlight.FoldedVisual,

					LineNr = { fg = colors.overlay0, bg = num_col_bg },
					CursorLineNr = { bg = num_col_bg },
					SignColumn = { bg = num_col_bg },

					DiagnosticSignError = { bg = num_col_bg },
					DiagnosticSignWarn = { bg = num_col_bg },
					DiagnosticSignInfo = { bg = num_col_bg },
					DiagnosticSignHint = { bg = num_col_bg },

					GitSignsChangedelete = { fg = colors.peach },

					GitSignsChangedeleteCul = { link = "GitSignsChangedelete" },

					GitSignsAddNr = { fg = colors.green, bg = num_col_bg },
					GitSignsChangeNr = { fg = colors.yellow, bg = num_col_bg },
					GitSignsDeleteNr = { fg = colors.red, bg = num_col_bg },
					GitSignsTopdeleteNr = { fg = colors.red, bg = num_col_bg },
					GitSignsChangedeleteNr = { fg = colors.peach, bg = num_col_bg },
					GitSignsUntrackedNr = { fg = colors.green, bg = num_col_bg },

					GitSignsAddInline = { fg = colors.base, bg = colors.green },
					GitSignsChangeInline = { fg = colors.base, bg = colors.yellow },
					GitSignsDeleteInline = { fg = colors.base, bg = colors.red },

					GitSignsAddLnInline = { link = "DiffAdd" },
					GitSignsChangeLnInline = { link = "DiffText" },
					GitSignsDeleteLnInline = { link = "DiffDelete" },

					GitSignsAddVirtLnInline = { link = "GitSignsAddInline" },
					GitSignsChangeVirtLnInline = { link = "GitSignsChangeInline" },
					GitSignsDeleteVirtLnInline = { link = "GitSignsDeleteInline" },
				}
			end,
		},
		-- NOTE: not perfect
		integrations = {
			indent_blankline = {
				enabled = true,
				scope_color = "red",
				colored_indent_levels = true,
			},
		},
	},
}
