#!/usr/bin/env lua

-- Define the build program, the build options and the files to build
local build_program = "/home/andi/Apps/lmtx/tex/texmf-linux-64/bin/context"
local build_files = {{
    name = "pauta-example.tex",
    options = "--mode=letter:h --noconsole --purgeall"
}, {
    name = "_pauta_pendragon.tex",
    options = "--noconsole --purgeall"
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

    local command = build_program .. space .. file.options .. space .. file.name
    local success, status, signal = os.execute(command)
    local message

    if success then
        message = success_message
    else
        message = error_message .. " (status: " .. status .. ", signal: " .. signal .. ")"
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
