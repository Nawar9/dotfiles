local utils = require("utils")
local builtin = require("telescope.builtin")

local M = {}

local _capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities = {}
function M.capabilities.add(new)
	_capabilities = vim.tbl_deep_extend("force", _capabilities, new)
end

function M.capabilities.get()
	return _capabilities
end

M.keymaps = {
	{ lhs = "gd", callback = builtin.lsp_definitions, desc = "[g]o to [d]efinition", ufo_trace = true },
	{ lhs = "gD", callback = vim.lsp.buf.declaration, desc = "[g]o to [D]eclaration", ufo_trace = true },
	{ lhs = "gI", callback = builtin.lsp_implementations, desc = "[g]o to [I]mplementation", ufo_trace = true },
	{ lhs = "gr", callback = builtin.lsp_references, desc = "[g]o to [r]eferences", ufo_trace = true },
	{ lhs = "gy", callback = builtin.lsp_type_definitions, desc = "[g]o to t[y]pe definition", ufo_trace = true },

	{ lhs = "<Leader>ds", callback = builtin.lsp_document_symbols, desc = "[d]ocument [s]ymbols", ufo_trace = false },
	{
		lhs = "<Leader>ws",
		callback = builtin.lsp_dynamic_workspace_symbols,
		desc = "[w]orkspace [s]ymbols",
		ufo_trace = false,
	},

	{ lhs = "<Leader>rn", callback = vim.lsp.buf.rename, desc = "[r]e[n]ame", mode = { "n", "x" }, ufo_trace = true },
	{
		lhs = "<Leader>ca",
		callback = vim.lsp.buf.code_action,
		desc = "[c]ode [a]ction",
		mode = { "n", "x" },
		ufo_trace = true,
	},

	{
		lhs = "<Leader>th",
		callback = function()
			local state = not vim.lsp.inlay_hint.is_enabled()
			vim.lsp.inlay_hint.enable(state)
			utils.notify_toggle("Inlay Hints", state)
		end,
		desc = "[t]oggle inlay [h]ints",
		ufo_trace = false,
	},
}

for _, keymap in ipairs(M.keymaps) do
	keymap.desc = "LSP: " .. keymap.desc
end

return M
