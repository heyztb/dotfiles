local set = vim.opt_local

set.wrap = true
set.linebreak = true
set.spell = true
set.textwidth = 80
set.colorcolumn = ""

local function with_lines(start_line, end_line, transform)
	local lines = vim.fn.getline(start_line, end_line)
	local updated = transform(lines)
	if updated then
		vim.fn.setline(start_line, lines)
	end
end

local function current_line_range()
	local line = vim.fn.line(".")
	return line, line
end

local function visual_line_range()
	return vim.fn.line("'<"), vim.fn.line("'>")
end

local function toggle_task_state(lines)
	local changed = false

	for i, line in ipairs(lines) do
		if line:match("^%s*[-*+]%s*%[ %]") then
			lines[i] = line:gsub("(%[) (])", "%1x%2")
			changed = true
		elseif line:match("^%s*[-*+]%s*%[[xX]%]") then
			lines[i] = line:gsub("(%[)[xX](])", "%1 %2")
			changed = true
		end
	end

	return changed
end

local function smart_list_toggle(lines)
	local has_numbers = false
	local has_checkboxes = false
	local has_bullets = false

	for _, line in ipairs(lines) do
		if line:match("^%s*%d+%.%s") then
			has_numbers = true
		elseif line:match("^%s*[-*+]%s*%[.%]%s") then
			has_checkboxes = true
		elseif line:match("^%s*[-*+]%s") then
			has_bullets = true
		end
	end

	if has_numbers then
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^%s*%d+%.%s*", "")
		end
		return true
	end

	if has_checkboxes then
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^(%s*)[-*+]%s*%[.%]%s*", "%1")
			if not lines[i]:match("^%s*$") then
				lines[i] = i .. ". " .. lines[i]
			end
		end
		return true
	end

	if has_bullets then
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^(%s*)[-*+]%s*", "%1- [ ] ")
		end
		return true
	end

	for i, line in ipairs(lines) do
		if not line:match("^%s*$") then
			lines[i] = "- " .. line
		end
	end

	return true
end

local function apply_to_range(range_fn, transform)
	return function()
		local start_line, end_line = range_fn()
		with_lines(start_line, end_line, transform)
	end
end

vim.keymap.set("n", "tt", apply_to_range(current_line_range, toggle_task_state), {
	buffer = true,
	desc = "Toggle markdown task state",
})

vim.keymap.set("v", "tt", function()
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)
	apply_to_range(visual_line_range, toggle_task_state)()
end, {
	buffer = true,
	desc = "Toggle markdown task state",
})

vim.keymap.set("n", "tl", apply_to_range(current_line_range, smart_list_toggle), {
	buffer = true,
	desc = "Toggle markdown list style",
})

vim.keymap.set("v", "tl", function()
	local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)
	apply_to_range(visual_line_range, smart_list_toggle)()
end, {
	buffer = true,
	desc = "Toggle markdown list style",
})

vim.keymap.set("n", "<leader>tc", function()
	vim.cmd([[silent keepjumps %g/^\s*[-*+]\s\+\[\s\]/s/\[\s\]/[x]/]])
end, {
	buffer = true,
	desc = "Mark all markdown tasks done",
	silent = true,
})

vim.keymap.set("n", "<leader>tu", function()
	vim.cmd([[silent keepjumps %g/^\s*[-*+]\s\+\[[xX]\]/s/\[[xX]\]/[ ]/]])
end, {
	buffer = true,
	desc = "Mark all markdown tasks undone",
	silent = true,
})
