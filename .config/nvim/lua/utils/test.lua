-- INFO: temp
local track = require("lazy.core.util").track

local failed = {}

local function test(name, func, ...)
	vim.notify("Running Test: " .. name .. " ...", vim.log.levels.DEBUG)
	track("name")
	if not func(...) then
		table.insert(failed, name)
	end
	local entry = track()
	vim.notify("Test " .. name .. " took " .. entry.time / 1000 .. " microseconds", vim.log.levels.DEBUG)
end
-- asdfasd f asdf	asdf asdf asdf asdf asdf asdf asdf as;df j;asldkf ah;sdf has;djf has;dlkfj asd;lf kajsd;fl kasjd;f kasjd;f kasjdf; aksdjf ;askdfj ;asdkfj ;asdkf jas;dkf asd;fiasuwefaosiduf;askd;fask lf a;sdf
test("vitcol", function()
	vim.print(vim.fn.virtcol({ 15, 206 }))
	return true
end)

test("vitcol_with_wrap", function()
	vim.wo.wrap = false
	vim.print(vim.fn.virtcol({ 15, 206 }))
	vim.wo.wrap = true
	return true
end)

if not vim.tbl_isempty(failed) then
	local prefix = "Test failed: "
	vim.notify(prefix .. table.concat(failed, "\n" .. prefix), vim.log.levels.ERROR)
else
	vim.notify("All tests passed!", vim.log.levels.INFO)
end
