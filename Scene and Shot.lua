-- Mac OS X:
-- - All users: /Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
-- - Specific user: /Users/<UserName>/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
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
print("---- Scenes and Takes by Romp ----")
local project = assert(resolve:GetProjectManager():GetCurrentProject(), "Couldn't get current project")
local media_pool = assert(project:GetMediaPool(), "Could not load media pool")
local resolve = Resolve()

local function compareClipName(a, b)
    return a:GetClipProperty("File Name") < b:GetClipProperty("File Name")
end

local function processFolders(folder)
    -- gather clips and sort

    print("Processing Folder: " .. folder:GetName())
    local clips = folder:GetClipList()
    table.sort(clips, compareClipName)

    local sceneDB = {}

    local sceneMemory = ""
    local shotMemory = ""

    for _, clip in ipairs(clips) do
        local scene = clip:GetMetadata("Scene")
        local shot = clip:GetMetadata("Shot")
        local take = clip:GetMetadata("Take")

        -- replaces scene if empty
        scene = scene == "" and sceneMemory or scene
        shot = shot == "" and shotMemory or shot

        -- format scene
        local sceneNum = tonumber(scene:match("^%d+") or 999)
        local sceneLetter = scene:match("%a+$") or ""

        scene = string.format("%02d%s", sceneNum, sceneLetter)

        if scene ~= sceneMemory then
            take = take == "" and 1 or tonumber(take)
        else
            if shot ~= shotMemory then
                take = take == "" and 1 or tonumber(take)
            else
                print("sceneDB " .. scene)
                take = sceneDB[scene] + 1 or 1

            end
        end
        sceneDB[scene] = take


        take = string.format("%03d", tonumber(take))

        clip:SetMetadata("Scene", scene)
        clip:SetMetadata("Take", take)

        print("Clip: " .. clip:GetName())
        print(" - Scene: " .. scene)
        print(" - Shot: " .. shot)
        print(" - Take: " .. take)
        print(" - Scene Count: " .. sceneDB[scene])
        print(" - Last scene: " .. sceneMemory)

        sceneMemory = scene
    end
end




local current_folder = media_pool:GetCurrentFolder()
processFolders(current_folder)

print("---- Simplify Bins - All Done ---")
