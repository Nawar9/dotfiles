local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim/"

if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},

	-- TODO: <Esc> to close?
	lockfile = vim.fn.stdpath("state") .. "/lazy/lazy-lock.json",

	install = {
		colorscheme = { "catppuccin" },
	},

	ui = {
		backdrop = 85,
	},

	headless = {
		task = false,
	},
})
