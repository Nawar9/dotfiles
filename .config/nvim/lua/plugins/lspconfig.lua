local lsp = require("utils.lsp")

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
		{
			"j-hui/fidget.nvim",
			opts = {},
		},
	},
	config = function()
		for _, keymap in ipairs(lsp.keymaps) do
			vim.keymap.set(keymap.mode or "n", keymap.lhs, keymap.callback, { desc = keymap.desc })
		end

		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "Add LSP highlights autocommands",
			group = vim.api.nvim_create_augroup("nvconfig-lsp-attach", { clear = true }),
			callback = function(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local lsp_highlight_augroup =
						vim.api.nvim_create_augroup("nvconfig-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						desc = "Highlight similar words using LSP",
						group = lsp_highlight_augroup,
						buffer = event.buf,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						desc = "Clear LSP highlights",
						group = lsp_highlight_augroup,
						buffer = event.buf,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						desc = "Remove LSP highlights autocommands",
						group = vim.api.nvim_create_augroup("nvconfig-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = lsp_highlight_augroup, buffer = event2.buf })
						end,
					})
				end
			end,
		})

		-- TODO: deprecated, see: "/usr/share/nvim/runtime/lua/vim/diagnostic.lua":1283
		local signs = { Error = "", Warn = "", Info = "", Hint = "󰌵" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		local lsp_servers = {
			lua_ls = {
				settings = {
					Lua = {
						hint = { enable = true },
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
		}

		local formatters = {
			"stylua",
		}

		require("mason").setup()

		require("mason-lspconfig").setup({
			-- TODO: auto start `LspStart`? using `local orig_bufnr = vim.fn.bufnr('#')`
			handlers = {
				function(server_name)
					local server = lsp_servers[server_name] or {}

					if server.capabilities then
						lsp.capabilities.add(server.capabilities)
					end

					server.capabilities = lsp.capabilities.get()

					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- TODO: manage through system and do if not executable
		local ensure_installed = vim.tbl_keys(lsp_servers or {})
		vim.list_extend(ensure_installed, formatters)
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
	end,
}
