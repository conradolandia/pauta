#!/usr/bin/env lua

-- [[ Customization ]]
--
-- Strings used all around
local space = " "
local intro = "Processing the file "
local separator = "\n"
local error_message = space .. "failed to complete"
local success_message = space .. "completed successfully"

-- Build tree
local base_folder = "/context/third/pauta/"
local build_folder = "tex" .. base_folder
local docs_folder = "doc" .. base_folder

-- Generate documentation with Pandoc
local docs_command = "pandoc"

-- Process with LMTX
local build_command = "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/context"
local build_path = "--path=" .. docs_folder .. "," .. build_folder

-- Show the build log in the terminal?
local show_log = false

-- Delete log files in the root folder, or keep them?
local delete_logs = true

-- Build modes for LMTX
local build_modes = {
	h = "--mode=letter:h",
	v = "--mode=letter:v",
}

-- [[ Internal functions ]]
--
-- Create full options string for the build command with optional mode
-- I use a table because it seems easier than just concatenating strings and spaces
local function create_options(mode)
	local build_options = {}
	-- Show log?
	if show_log then
		table.insert(build_options, "--noconsole")
	end
	-- Delete logs?
	if delete_logs then
		table.insert(build_options, "--purgeall")
	end
	-- Insert extra paths
	if build_path then
		table.insert(build_options, build_path)
	end
	-- Insert LMTX build mode
	if mode then
		table.insert(build_options, mode)
	end
	-- Return table as concatenated string
	return table.concat(build_options, space)
end

-- [[ Task Class ]]
local Task = {}
Task.__index = Task

function Task:new(name, command, options, input, after, output, postprocess)
	local self = setmetatable({}, Task)
	self.name = name
	self.command = command
	self.options = options
	self.input = input
	self.after = after
	self.output = output
	self.postprocess = postprocess
	return self
end

function Task:execute(show_output)
	print("Executing [ " .. self.name .. " ]")

	local command = self.command
	if self.options then
		command = command .. space .. self.options
	end
	if self.input then
		command = command .. space .. self.input
	end
	if self.after then
		command = command .. space .. self.after
	end
	if self.output then
		command = command .. space .. self.output
	end

	print("Calling: " .. command)

	local handle = io.popen(command)
	local output = handle:read("*a")

	if show_output then
		print(output)
	end

	local message = success_message
	if handle then
		message = success_message
	end

	print(intro .. self.input .. message)

	if self.postprocess ~= nil then
		local success, tag, code = os.execute(self.postprocess)
		if success then
			print("Postprocessing: " .. self.postprocess .. separator)
		end
	else
		print(separator)
	end
end

-- [[ Tasks ]]
local tasks = {
	Task:new(
		"Build documentation from README.md",
		docs_command,
		"--from=markdown --to=context+ntb --wrap=none --top-level-division=chapter --section-divs",
		"README.md",
		"-o",
		docs_folder .. "README.tex"
	),
	Task:new(
		"Typeset example",
		build_command,
		create_options(build_modes.h),
		docs_folder .. "pauta-example.tex",
		nil,
		nil,
		"mv pauta-example.pdf " .. docs_folder
	),
	Task:new(
		"Typeset documentation",
		build_command,
		create_options(build_modes.v),
		docs_folder .. "pauta.tex",
		nil,
		nil,
		"mv pauta.pdf " .. docs_folder
	),
}

-- Build each task in the list
for key, task in ipairs(tasks) do
	io.write("[" .. key .. "/" .. #tasks .. "] -> ")
	task:execute(show_log)
end
