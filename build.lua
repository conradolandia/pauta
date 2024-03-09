#!/usr/bin/env lua

-- Define the build program(s)
local build_program = "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/context"
local docs_program = "pandoc"

-- Extensions to clean if `--clean` is used
local clean_extensions = {".pdf", ".tuc", ".log"}

-- Build options and files to build (files are processed by table order)
local build_files = {{
    program = docs_program,
    options = "--from=markdown --to=context+ntb --wrap=none --top-level-division=section --section-divs",
    name = "README.md",
    after = "-o",
    exit = "readme.tex"
}, {
    program = build_program,
    options = "--mode=letter:h --purgeall --noconsole",
    name = "pauta-example.tex"
}, {
    program = build_program,
    options = "--mode=letter:v --purgeall --noconsole",
    name = "pauta.tex"
}}

-- Messages
local space = " "
local intro = "Processing "
local separator = "\n"
local error_message = space .. "failed to complete"
local success_message = space .. "completed successfully"

-- Clean function
local function clean_file(file)
    for _, extension in pairs(clean_extensions) do
        local removable, amount = file.name:gsub("%.tex$", extension)
        if amount > 0 then
            local success = os.remove(removable)
            if success == true then
                print(removable .. space .. "removed")
            end
        end
    end
end

-- Function to build a file
local function build_file(file)
    print("Building [ " .. file.name .. " ]:")

    local command = file.program

    if file.options then
        command = command .. space .. file.options
    end

    if file.name then
        command = command .. space .. file.name
    end

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

    print(intro .. file.name .. message .. separator)
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
    for key, file in ipairs(build_files) do
        io.write("[" .. key .. "/" .. #build_files .. "] -> ")
        build_file(file)
    end
end
