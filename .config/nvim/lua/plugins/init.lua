return {
	"tpope/vim-sleuth",

	-- TODO: treesj
	-- TODO: LSP zero
	-- TODO: LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
		-- used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		specs = {
			{
				"Bilal2453/luvit-meta",
				lazy = true,
			},
		},
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{
					path = "luvit-meta/library",
					words = { "vim%.uv" },
				},
			},
		},
	},

	require("kickstart.plugins.debug"),
	require("kickstart.plugins.indent_line"),
	-- require 'kickstart.plugins.lint',
	require("kickstart.plugins.autopairs"),
	require("kickstart.plugins.neo-tree"),
	-- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    This is the easiest way to modularize your config.
	--
	--  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- { import = 'custom.plugins' },
	--
	-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
	-- Or use Telescope!
	-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
	-- you can continue same window with `<space>sr` which resumes last Telescope search
}
