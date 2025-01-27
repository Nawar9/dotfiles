local icons = require("utils.icons")

local foldcolumn = 1

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.softtabstop = 0
vim.opt.expandtab = false
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

vim.opt.mouse = "a"

vim.opt.scrolloff = 999
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.virtualedit = "block"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true
vim.opt.showmode = false
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes"

-- TODO: remove for documentation(K)?
vim.opt.breakindent = true
vim.opt.showbreak = icons.rightwards_arrow_with_hook .. " "
vim.opt.whichwrap:append({
	b = true,
	s = true,
	h = true,
	l = true,
	["<"] = true,
	[">"] = true,
	["~"] = true,
	["["] = true,
	["]"] = true,
})

vim.opt.list = true
vim.opt.listchars:append({
	tab = icons.right_pointing_double_angle .. " ",
	nbsp = icons.open_box,
	lead = " ",
	multispace = icons.middle_dot,
	trail = icons.middle_dot,
	extends = icons.horizontal_ellipsis,
	precedes = icons.horizontal_ellipsis,
	conceal = icons.conceal,
})

-- TODO: comments fold
vim.opt.foldlevel = 99
vim.opt.foldcolumn = tostring(foldcolumn)
vim.opt.diffopt:append("foldcolumn:" .. foldcolumn)
vim.opt.fillchars:append({
	fold = " ",
	foldopen = icons.chevron_down,
	foldclose = icons.chevron_right,
	foldsep = " ",
	msgsep = icons.box_drawings_light_horizontal,
	lastline = ".",
	diff = " ",
	eob = " ",
})
