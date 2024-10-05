#!/usr/bin/env lua

-- [[ Customization ]]
--
-- Strings used all around
local space = " "
local intro = "Processing the file" .. space
local separator = "\n"
local error_message = space .. "failed to complete"
local success_message = space .. "completed successfully"

-- Process with LMTX
local context_path = os.getenv("LMTX_PATH") or "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/"
local build_command = context_path .. "context"
local build_path = "doc/context/third/pauta,tex/context/third/pauta"

-- Show the build log in the terminal?
local hide_log = false

-- Delete log files in the root folder, or keep them?
local delete_logs = true

-- Build modes for LMTX
local build_modes = {
	h = "--mode=letter:h",
	v = "--mode=letter:v",
}

-- Create full options string for the build command with optional mode
-- I use a table because it seems easier than just concatenating strings and spaces
local function create_options(mode)
	local build_options = {}
	-- Show log?
	if hide_log then
		table.insert(build_options, "--noconsole")
	end
	-- Delete logs?
	if delete_logs then
		table.insert(build_options, "--purgeall")
	end
	-- Insert extra paths
	if build_path then
		table.insert(build_options, "--path=" .. build_path)
	end
	-- Insert LMTX build mode
	if mode then
		table.insert(build_options, mode)
	end
	-- Return table as concatenated string
	return table.concat(build_options, space)
end

-- [[ Internal functions ]]
--

-- [[ Task Class ]]
local Task = {}
Task.__index = Task

--- [[ Task metatable constructor ]]
---@param name string: A descriptive name for the task
---@param command string: Command to run
---@param options string | nil: Options for the command
---@param input string | nil: Input file
---@param afterinput string | nil: Options after the input file
---@param output string | nil: Output file
---@param postprocess string | nil: Another command to run after finishing the main command
--
function Task:new(name, command, options, input, afterinput, output, postprocess)
	local self = setmetatable({}, Task)
	self.name = name
	self.command = command
	self.options = options
	self.input = input
	self.afterinput = afterinput
	self.output = output
	self.postprocess = postprocess
	return self
end

--- [[ Task execution method ]]
function Task:execute()
	print("Executing task [ " .. self.name .. " ]")

	local command = self.command

	if command == nil then
		error("There is no command to run!")
	end

	if self.options then
		command = command .. space .. self.options
	end
	if self.input then
		command = command .. space .. self.input
	end
	if self.afterinput then
		command = command .. space .. self.afterinput
	end
	if self.output then
		command = command .. space .. self.output
	end

	print("Calling: " .. command)

	local handle, t, c = os.execute(command)
	local message

	if handle then
		message = success_message
	else
		message = error_message .. " (" .. t .. "/" .. c .. ")"
	end

	print(intro .. self.input .. message)

	if self.postprocess then
		local success, tag, code = os.execute(self.postprocess)
		if success then
			print("Postprocessing: " .. self.postprocess .. separator)
		else
			print("Could not run postprocessing: [" .. command .. " (" .. tag .. "/" .. code .. ")]")
		end
	else
		print(separator)
	end
end

-- [[ Tasks ]]
local tasks = {
	Task:new(
		"Typeset example",
		build_command,
		create_options(build_modes.h),
		"doc/context/third/pauta/pauta-example.tex",
		nil,
		nil,
		"rm -f *.log && rm -f *.tuc && mv pauta-example.pdf doc/context/third/pauta/"
	),
}

-- Build each task in the list
for key, task in ipairs(tasks) do
	io.write("[" .. key .. "/" .. #tasks .. "] -> ")
	task:execute()
end
