-- Mac OS X:
-- - Command + Shift + G
-- - All users: /Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
-- - Specific user: ~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
-- Windows:
-- - All users: %PROGRAMDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Scripts
-- - Specific user: %APPDATA%\Roaming\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts
-- Linux:
-- - All users: /opt/resolve/Fusion/Scripts (or /home/resolve/Fusion/Scripts/ depending on installation)
-- - Specific user: $HOME/.local/share/DaVinciResolve/Fusion/Scripts

local regex = "^%D+%d+.*"
local regex_date = "^%d%d%d%d%-%d%d%-%d%d.*"
local regex_ascmhl = "^ascmhl$"

print()
print("---- Simplify Bins by Romp ----")
local project = assert(resolve:GetProjectManager():GetCurrentProject(), "Couldn't get current project")
local media_pool = assert(project:GetMediaPool(), "Could not load media pool")
local resolve = Resolve()

local function getSubFolderClips(folder, root)
    local allClips = {}
    local subFolders = folder:GetSubFolderList()
    for _, subFolder in ipairs(subFolders) do
        local clips = subFolder:GetClipList()
        print("Root: " .. folder:GetName() .. " | " .. subFolder:GetName() .. " | Number of clips: " .. #clips)
        for _, clip in ipairs(clips) do
            table.insert(allClips, clip)
        end
        local subFolderClips = getSubFolderClips(subFolder, root) -- Recursive call
        for _, clip in ipairs(subFolderClips) do
            table.insert(allClips, clip)
        end
    end
    return allClips
end

local function processFolders(root)

    local folders = root:GetSubFolderList()

    for _, folder in ipairs(folders) do
        print("Processing " .. folder:GetName())

        if folder:GetName():match(regex_ascmhl) then
            print("-- ascmhl Folder Detected")
            media_pool:DeleteFolders(folder)
        elseif folder:GetName():match(regex_date) then
            print("-- Date Folder Detected: " .. folder:GetName())
            processFolders(folder)
            -- for _, sub in ipairs(folder:GetSubFolderList()) do
            --     processFolders(sub)
            -- end
            goto continue
        end

        if not folder:GetName():match(regex) then
            print("Not matching regex: " .. folder:GetName())
            goto continue
        end

        -- Perform actions for folders matching the regex
        print("Root: " .. folder:GetName() .. " ---------- ")
        local clips = getSubFolderClips(folder, folder)
        print("Root: " .. folder:GetName() .. " | Number of clips: " .. #clips)
        print("Moving " .. #clips .. " clips")
        media_pool:MoveClips(clips, folder)

        -- delete subfolders
        media_pool:DeleteFolders(folder:GetSubFolderList())
        print()

        ::continue::
    end

    ::continueProcessFolder::
end
local current_folder = media_pool:GetCurrentFolder()
local folders = current_folder:GetSubFolderList()

-- if current_folder:GetName():match(regex) then
--     print("Processing current folder: " .. current_folder:GetName())
--     folders = {current_folder}
-- else
--     print("Capturing subfolders")
-- end


processFolders(current_folder)

print("---- Simplify Bins - All Done ---")
