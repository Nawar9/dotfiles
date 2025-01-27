local highlight = require("utils.highlight")
local lsp = require("utils.lsp")

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	cmd = "CmpStatus",
	dependencies = {
		"onsails/lspkind.nvim",
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
			opts = {
				link_children = true,
				keep_roots = true,
				link_roots = true,
				exit_roots = false,
				update_events = { "TextChanged", "TextChangedI" },
				delete_check_events = { "TextChanged", "InsertLeave" },
			},
		},
		-- TODO: dependencies of luasnip?
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
	},

	init = function()
		highlight.add("CmpItemSource", { link = "DiagnosticWarn", default = true })

		lsp.capabilities.add(require("cmp_nvim_lsp").default_capabilities())
	end,

	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")

		cmp.setup({
			completion = { completeopt = "menu,menuone,noinsert" },

			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				-- TODO: add scroll bar to K(documentation) menu and scroll mapping and style it
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),

				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
						cmp.abort()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
						cmp.abort()
					end
				end, { "i", "s" }),
			}),

			window = {
				completion = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
					col_offset = -3,
					side_padding = 0,
				},
				-- TODO: make K documentation menu same?
				documentation = {
					winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
				},
			},

			formatting = {
				expandable_indicator = true,
				fields = { cmp.ItemField.Kind, cmp.ItemField.Abbr, cmp.ItemField.Menu },
				format = function(entry, vim_item)
					-- TODO: remove magic numbers
					-- TODO: Hide Sources behind a keymap?
					vim_item.menu_hl_group = {
						{ "CmpItemSource", range = { 4, 10 } },
						{ "CmpItemKind" .. vim_item.kind, range = { 11, 100 } },
					}
					vim_item.menu = " (" .. vim_item.kind .. ")" .. (vim_item.menu and " " .. vim_item.menu or "")
					vim_item = lspkind.cmp_format({
						mode = "symbol",
						menu = {
							-- TODO: link with sources somehow and dependencies
							-- TODO: concatinate in a function or metatable
							lazydev = "    " .. "[lazy]",
							luasnip = "    " .. "[snip]",
							nvim_lsp = "    " .. "[LSP]" .. " ",
							path = "    " .. "[path]",
							buffer = "    " .. "[buf]" .. " ",
						},
						maxwidth = {
							menu = 50,
							abbr = 50,
						},
						ellipsis_char = "...",
						show_labelDetails = true,
					})(entry, vim_item)
					vim_item.kind = " " .. vim_item.kind .. " "
					return vim_item
				end,
			},

			sources = {
				-- TODO: emojy source?
				{ name = "lazydev" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "path" },
				{ name = "buffer" },
			},

			experimental = { ghost_text = true },
		})
	end,
}
