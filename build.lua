#!/usr/bin/env lua

-- [[ Customization ]]
-- Build command(s) and variables
local docs_command = "pandoc"
local docs_folder = "doc/context/third/pauta/"
local build_command = "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/context"
local build_folder = "tex/context/third/pauta/"
local build_paths = {build_folder, docs_folder}
local build_options = {"--purgeall", "--noconsole", "--path=" .. table.concat(build_paths, ",")}
local build_modes = {
    h = "--mode=letter:h",
    v = "--mode=letter:v"
}

-- Messages used all around
local space = " "
local intro = "Processing the file "
local separator = "\n"
local error_message = space .. "failed to complete"
local success_message = space .. "completed successfully"

-- Create full options string for the build command with optional mode
local function create_options(mode)
    return table.concat(build_options, space) .. space .. mode
end

-- Tasks to execute and options
local tasks = {{
    command = docs_command,
    options = "--from=markdown --to=context+ntb --wrap=none --top-level-division=section --section-divs",
    input = "README.md",
    after = "-o",
    output = "README.tex"
}, {
    command = build_command,
    options = create_options(build_modes.h),
    input = docs_folder .. "pauta-example.tex"
}, {
    command = build_command,
    options = create_options(build_modes.v),
    input = docs_folder .. "pauta.tex"
}}

-- [[ Internal functions ]]

-- Function to build a task
local function execute(task)
    print("Building [ " .. task.input .. " ]")

    local command = task.command

    if task.options then
        command = command .. space .. task.options
    end

    if task.input then
        command = command .. space .. task.input
    end

    if task.after then
        command = command .. space .. task.after
    end

    if task.output then
        command = command .. space .. task.output
    end

    print("Executing: " .. command)

    local handle = io.popen(command)
    local output = handle:read("*a")
    local message

    if handle then
        message = success_message
    end

    print(intro .. task.input .. message .. separator)
end

-- Build each task in the list
for key, task in ipairs(tasks) do
    io.write("[" .. key .. "/" .. #tasks .. "] -> ")
    execute(task)
end
