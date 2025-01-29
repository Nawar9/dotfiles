vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.base46_cache = vim.fn.stdpath("cache") .. "/base46_cache/"

-- TODO: remove terminal offset (https://nvchad.com/docs/recipes)
-- TODO: messages line numbers (https://youtu.be/GMS0JvS7W1Y?t=479)
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("config.lazy")
