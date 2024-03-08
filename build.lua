#!/usr/bin/env lua

-- Define the build program, the build options and the files to build
local build_program = "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/context"
local docs_program = "pandoc"

local build_files = {{
    name = "pauta-example.tex",
    program = build_program,
    options = "--mode=letter:h --purgeall"
}, {
    name = "_pauta_pendragon.tex",
    program = build_program,
    options = "--purgeall"
}, {
    name = "readme.md",
    program = docs_program,
    options = "--from=markdown --to=context+ntb --wrap=none --top-level-division=section --section-divs",
    after = "-o",
    exit = "readme.tex"
}}

-- Messages
local space = " "
local intro = "Processing "
local separator = "\n"
local error_message = space .. "failed to complete"
local success_message = space .. "completed successfully"

-- Clean function
local function clean_file(file)
    local extensions = {".pdf", ".tuc", ".log"}
    for _, extension in pairs(extensions) do
        local removable = file.name:gsub("%.tex$", extension)
        local success = os.remove(removable)
        if success then
            print(removable .. space .. "removed")
        end
    end
end

-- Function to build a file
local function build_file(file)
    print(separator)
    print("Building [ " .. file.name .. " ]:")

    local command = file.program .. space .. file.options .. space .. file.name

    if file.after then
      command = command .. space .. file.after
    end

    if file.exit then
      command = command .. space .. file.exit
    end

    local success, exit, code = os.execute(command)
    local message

    if success then
        message = success_message
    else
        message = error_message .. " (" .. exit .. ": " .. code .. ")"
    end

    print(intro .. file.name .. message)
end

-- Check for the --clean flag
local clean_flag_present = false
for _, arg in ipairs(arg) do
    if arg == "--clean" then
        clean_flag_present = true
        break
    end
end

if clean_flag_present then
    -- Clean results for each file in the list
    for _, file in ipairs(build_files) do
        clean_file(file)
    end
else
    -- Build each file in the list
    for _, file in ipairs(build_files) do
        build_file(file)
    end
end
