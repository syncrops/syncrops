-- SYNCROPS WindUI Script (Fixed & Safe)
-- Perbaikan oleh ChatGPT: Color3.fromHex, Request fallback, remote lookups, file checks, safety pcalls

-- 🔴 Load WindUI (pcall)
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    warn("❌ Failed to load WindUI")
    return
end

-- ---------------------------
-- Utility: Color3.fromHex
-- ---------------------------
if not Color3.fromHex then
    function Color3.fromHex(hex)
        hex = tostring(hex):gsub("#", "")
        if #hex ~= 6 then
            error("Invalid hex length: "..tostring(hex))
        end
        local r = tonumber(hex:sub(1,2), 16) or 0
        local g = tonumber(hex:sub(3,4), 16) or 0
        local b = tonumber(hex:sub(5,6), 16) or 0
        return Color3.fromRGB(r, g, b)
    end
end

-- ---------------------------
-- Utility: Request wrapper (WindUI.Creator.Request or fallbacks)
-- ---------------------------
local HttpService = game:GetService("HttpService")
local function safeRequest(options)
    -- options: {Url=, Method=, Headers=}
    -- Try WindUI.Creator.Request
    if WindUI and WindUI.Creator and type(WindUI.Creator.Request) == "function" then
        local ok, res = pcall(function() return WindUI.Creator.Request(options) end)
        if ok and res then return res end
    end

    -- Try http_request (common in many executors)
    if type(http_request) == "function" then
        local ok, res = pcall(function() return http_request(options) end)
        if ok and res then return res end
    end

    -- Try request (alias)
    if type(request) == "function" then
        local ok, res = pcall(function() return request(options) end)
        if ok and res then return res end
    end

    -- Try HttpService:GetAsync as last resort (may fail due to context)
    if options and options.Url and HttpService then
        local ok, body = pcall(function() return HttpService:GetAsync(options.Url, true) end)
        if ok and body then
            return { Body = body }
        end
    end

    return nil
end

-- ---------------------------
-- Helpers: safe filesystem (writefile/readfile/listfiles/makefolder) wrappers
-- ---------------------------
local function safe_makefolder(path)
    if type(makefolder) == "function" then
        pcall(makefolder, path)
    end
end
local function safe_writefile(path, content)
    if type(writefile) == "function" then
        pcall(writefile, path, content)
        return true
    end
    return false
end
local function safe_isfile(path)
    if type(isfile) == "function" then
        local ok, res = pcall(isfile, path)
        if ok then return res end
    end
    return false
end
local function safe_readfile(path)
    if type(readfile) == "function" then
        local ok, res = pcall(readfile, path)
        if ok then return res end
    end
    return nil
end
local function safe_listfiles(path)
    if type(listfiles) == "function" then
        local ok, res = pcall(listfiles, path)
        if ok and type(res) == "table" then return res end
    end
    return {}
end

-- ---------------------------
-- Add all themes
-- ---------------------------
local themeNames = {
    "Ocean Blue","Forest Green","Minimal Light","Retro Purple","Sunset",
    "Neon Pulse","Steel Phantom","Vaporwave","Deep Sea","Sepia Warmth",
    "Monokai Dark","Solarized Light","Cherry Blossom","Charcoal Gold",
    "Icy Mint","Volcano","Amethyst","Pastel Dream","Coffee Shop","Cyberpunk Red"
}

local themeColors = {
    ["Ocean Blue"] = {Accent="#0B5394", Dialog="#0A3D6B", Outline="#6DACEA", Text="#EBF5FF", Placeholder="#85AECF", Background="#051A2E", Button="#1C67A8", Icon="#A9D5FD"},
    ["Forest Green"] = {Accent="#1A5E2E", Dialog="#114220", Outline="#8AC79B", Text="#E9FCE9", Placeholder="#79A378", Background="#0A2B14", Button="#2B7A42", Icon="#B3E3C1"},
    ["Minimal Light"] = {Accent="#F3F4F6", Dialog="#FFFFFF", Outline="#4B5563", Text="#1F2937", Placeholder="#9CA3AF", Background="#F9FAFB", Button="#E5E7EB", Icon="#4B5563"},
    ["Retro Purple"] = {Accent="#7E22CE", Dialog="#4A148C", Outline="#F0ABFC", Text="#FDF4FF", Placeholder="#BC8FDD", Background="#2D0557", Button="#9333EA", Icon="#F0ABFC"},
    ["Sunset"] = {Accent="#FF8847", Dialog="#CC5500", Outline="#FFD9C0", Text="#FFF7F0", Placeholder="#FFC099", Background="#331A00", Button="#FF7043", Icon="#FFD9C0"},
    ["Neon Pulse"] = {Accent="#00FF00", Dialog="#111111", Outline="#00FFFF", Text="#FFFFFF", Placeholder="#008800", Background="#000000", Button="#39FF14", Icon="#00FFFF"},
    ["Steel Phantom"] = {Accent="#404040", Dialog="#262626", Outline="#A3A3A3", Text="#D4D4D4", Placeholder="#737373", Background="#171717", Button="#525252", Icon="#A3A3A3"},
    ["Vaporwave"] = {Accent="#FF00FF", Dialog="#1B001B", Outline="#00FFFF", Text="#FFFFFF", Placeholder="#FF69FF", Background="#0A0014", Button="#E75480", Icon="#00FFFF"},
    ["Deep Sea"] = {Accent="#008B8B", Dialog="#005A5A", Outline="#80CBC4", Text="#E0FFFF", Placeholder="#4DB6AC", Background="#003636", Button="#00A3A3", Icon="#80CBC4"},
    ["Sepia Warmth"] = {Accent="#7B3F00", Dialog="#5C3200", Outline="#D2B48C", Text="#F5E8D6", Placeholder="#A98F70", Background="#3D291F", Button="#9D5B18", Icon="#D2B48C"},
    ["Monokai Dark"] = {Accent="#F92672", Dialog="#272822", Outline="#66D9EF", Text="#F8F8F2", Placeholder="#75715E", Background="#1C1E1A", Button="#A6E22E", Icon="#66D9EF"},
    ["Solarized Light"] = {Accent="#268BD2", Dialog="#FDF6E3", Outline="#93A1A1", Text="#586E75", Placeholder="#839496", Background="#EEE8D5", Button="#B58900", Icon="#268BD2"},
    ["Cherry Blossom"] = {Accent="#F9BCCB", Dialog="#FFFAFD", Outline="#D96985", Text="#4A1429", Placeholder="#C397A3", Background="#FFF7F9", Button="#E68A9F", Icon="#D96985"},
    ["Charcoal Gold"] = {Accent="#FFD700", Dialog="#2C2C2C", Outline="#C0C0C0", Text="#F5F5F5", Placeholder="#6E6E6E", Background="#1D1D1D", Button="#B8860B", Icon="#FFD700"},
    ["Icy Mint"] = {Accent="#40E0D0", Dialog="#F0FFFF", Outline="#81D4FA", Text="#004D40", Placeholder="#B2DFDB", Background="#E0FFFF", Button="#80CBC4", Icon="#40E0D0"},
    ["Volcano"] = {Accent="#B22222", Dialog="#1C1C1C", Outline="#FF6347", Text="#EBEBEB", Placeholder="#704747", Background="#0A0A0A", Button="#FF4500", Icon="#FF6347"},
    ["Amethyst"] = {Accent="#9966CC", Dialog="#36284C", Outline="#CCFF66", Text="#EDE9F2", Placeholder="#8A72A4", Background="#221A33", Button="#7A52AA", Icon="#CCFF66"},
    ["Pastel Dream"] = {Accent="#FFB3BA", Dialog="#FAF3E0", Outline="#BAE1FF", Text="#333333", Placeholder="#C1B4A5", Background="#FFFFFF", Button="#BAE1FF", Icon="#FFB3BA"},
    ["Coffee Shop"] = {Accent="#795548", Dialog="#F5F5DC", Outline="#A1887F", Text="#3E2723", Placeholder="#BCB0A4", Background="#FFF8E1", Button="#D7CCC8", Icon="#795548"},
    ["Cyberpunk Red"] = {Accent="#FF3333", Dialog="#080008", Outline="#33FFFF", Text="#FDFDFD", Placeholder="#771111", Background="#000000", Button="#CC0000", Icon="#33FFFF"}
}

for name, colors in pairs(themeColors) do
    pcall(function()
        WindUI:AddTheme({
            Name = name,
            Accent = Color3.fromHex(colors.Accent),
            Dialog = Color3.fromHex(colors.Dialog),
            Outline = Color3.fromHex(colors.Outline),
            Text = Color3.fromHex(colors.Text),
            Placeholder = Color3.fromHex(colors.Placeholder),
            Background = Color3.fromHex(colors.Background),
            Button = Color3.fromHex(colors.Button),
            Icon = Color3.fromHex(colors.Icon)
        })
    end)
end

WindUI:SetTheme("Volcano")
WindUI:SetFont("rbxassetid://12187360881")

-- Safe GradientText (handles length 1)
local function GradientText(text, color1, color2)
    text = tostring(text or "")
    if #text == 0 then return "" end
    if #text == 1 then
        local hex = string.format("#%02X%02X%02X", math.floor(color1.R*255), math.floor(color1.G*255), math.floor(color1.B*255))
        return string.format('<font color="%s">%s</font>', hex, text)
    end
    local result = ""
    for i = 1, #text do
        local t = (#text > 1) and ((i - 1) / (#text - 1)) or 0
        local r = color1.R + (color2.R - color1.R) * t
        local g = color1.G + (color2.G - color1.G) * t
        local b = color1.B + (color2.B - color1.B) * t
        local hex = string.format("#%02X%02X%02X", math.clamp(math.floor(r*255),0,255), math.clamp(math.floor(g*255),0,255), math.clamp(math.floor(b*255),0,255))
        result = result .. string.format('<font color="%s">%s</font>', hex, text:sub(i, i))
    end
    return result
end

-- Create Window
local Window = WindUI:CreateWindow({
    Title = GradientText("SYNCROPS", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0)),
    Icon = "rbxassetid://80426684728669",
    IconThemed = true,
    Author = "By @syncrops",
    Size = UDim2.fromOffset(580, 460),
    Resizable = true,
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function() print("User clicked") end,
    },
})

Window:Tag({ Title = "Developer", Color = Color3.fromHex("#30ff6a"), Radius = 10 })
Window:Tag({ Title = "test UI V1.0", Color = Color3.fromHex("#30ff6a"), Radius = 10 })
Window:SetIconSize(50)

Window:EditOpenButton({
    Title = GradientText("SYNCROPS", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0)),
    Icon = "rbxassetid://80426684728669",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({ "Close" })

-- Information Tab + Discord info (safe)
local Info = Window:Tab({Title = "Information", Icon = "info" })
local InviteCode = "SYNCROPS"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response, ErrorMessage = nil, nil
do
    local ok, res = pcall(function()
        local req = safeRequest({ Url = DiscordAPI, Method = "GET", Headers = { ["Accept"] = "application/json" } })
        if req and req.Body then
            return HttpService:JSONDecode(req.Body)
        end
    end)
    if ok and res then
        Response = res
    else
        ErrorMessage = tostring(res) or "Failed to fetch via safeRequest"
        Response = nil
    end
end

if Response and Response.guild then
    local ParagraphConfig = {
        Title = Response.guild.name or "Discord",
        Desc = ' <font color="#52525b">•</font> Member Count: ' .. tostring(Response.approximate_member_count) ..
               '\n <font color="#16a34a">•</font> Online Count: ' .. tostring(Response.approximate_presence_count),
        Image = (Response.guild.icon and ("https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=256")) or nil,
        ImageSize = 42,
        Buttons = {
            {
                Icon = "link",
                Title = "Copy Discord Invite",
                Callback = function()
                    pcall(function() if type(setclipboard) == "function" then setclipboard("https://discord.gg/" .. InviteCode) end end)
                end
            },
            {
                Icon = "refresh-cw",
                Title = "Update Info",
                Callback = function()
                    pcall(function()
                        local req = safeRequest({ Url = DiscordAPI, Method = "GET" })
                        if req and req.Body then
                            local UpdatedResponse = HttpService:JSONDecode(req.Body)
                            if UpdatedResponse and UpdatedResponse.guild and DiscordInfo then
                                DiscordInfo:SetDesc(
                                    ' <font color="#52525b">•</font> Member Count: ' .. tostring(UpdatedResponse.approximate_member_count) ..
                                    '\n <font color="#16a34a">•</font> Online Count: ' .. tostring(UpdatedResponse.approximate_presence_count)
                                )
                            end
                        end
                    end)
                end
            }
        }
    }

    if Response.guild.banner then
        ParagraphConfig.Thumbnail = "https://cdn.discordapp.com/banners/" .. Response.guild.id .. "/" .. Response.guild.banner .. ".png?size=256"
        ParagraphConfig.ThumbnailSize = 80
    end

    local DiscordInfo = Info:Paragraph(ParagraphConfig)
else
    Info:Paragraph({
        Title = "Error when receiving information about the Discord server",
        Desc = ErrorMessage or "Unknown error occurred",
        Image = "triangle-alert",
        ImageSize = 26,
        Color = "Red",
    })
end

-- Game information
Info:Paragraph({
    Title = GradientText("SYNCROPS", Color3.fromRGB(255,0,0), Color3.fromRGB(0,0,0)),
    Desc = "Script made by @syncrops",
    Color = "White",
})

-- Supported games tab
local SupportedGamesTab = Window:Tab({ Title = "Supported Games!", Icon = "gamepad" })
SupportedGamesTab:Button({
    Title = "Cut Trees",
    Desc = "Teleport to Cut Trees!",
    Callback = function()
        local cutTreesID = 16241018808
        pcall(function() game:GetService("TeleportService"):Teleport(cutTreesID, game.Players.LocalPlayer) end)
    end
})
SupportedGamesTab:Button({
    Title = "Fish It!",
    Desc = "Teleport to Fish It!",
    Callback = function()
        local fishItID = 17799431029
        pcall(function() game:GetService("TeleportService"):Teleport(fishItID, game.Players.LocalPlayer) end)
    end
})

-- ===== Auto Fishing & Auto Favorite setup =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = nil
pcall(function() Packages = ReplicatedStorage:WaitForChild("Packages", 3) end)

-- Attempt to require Net & Replion safely
local NetModule, Replion = nil, nil
if Packages then
    pcall(function() NetModule = require(Packages:WaitForChild("Net")) end)
    pcall(function() Replion = require(Packages:WaitForChild("Replion")).Client end)
end

local FavoriteEvent = nil
if NetModule and type(NetModule.RemoteEvent) == "function" then
    pcall(function() FavoriteEvent = NetModule:RemoteEvent("FavoriteItem") end)
end

local DataStore = nil
local InventoryExpect = nil
if Replion and type(Replion.WaitReplion) == "function" then
    pcall(function() DataStore = Replion:WaitReplion("Data") end)
    pcall(function() InventoryExpect = DataStore and DataStore:GetExpect({ "Inventory" }) end)
end

-- fallback: try to locate FavoriteItem event in ReplicatedStorage (best-effort)
if not FavoriteEvent then
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if (v.Name == "FavoriteItem" or v.Name == "Favorite") and (v:IsA("RemoteEvent") or v:IsA("BindableEvent")) then
            FavoriteEvent = v
            break
        end
    end
end

-- categories and rarities
local FavoriteCategories = { "Fishes", "Items", "Potions", "Totems", "Fishing Rods", "Baits" }

local RARITIES = {
    { name = "Common", tier = 1 },
    { name = "Uncommon", tier = 2 },
    { name = "Rare", tier = 3 },
    { name = "Epic", tier = 4 },
    { name = "Legendary", tier = 5 },
    { name = "Mythic", tier = 6 },
    { name = "SECRET", tier = 7 },
}
local TierToName = {}
for _, r in ipairs(RARITIES) do TierToName[r.tier] = r.name end

-- ---------- Auto Fish Tab ----------
local AutoFishTab = Window:Tab({ Title = "Auto Fish", Icon = "fish", Locked = false })
local autoBlatant, autoInstant = false, false
local blatantLoopHandle, instantLoopHandle = nil, nil

-- Helper: find remotes/functions by names (best-effort)
local function findRemoteByNames(names)
    for _, name in ipairs(names) do
        for _, desc in ipairs(ReplicatedStorage:GetDescendants()) do
            if desc.Name == name and (desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction")) then
                return desc
            end
        end
    end
    return nil
end

-- Common remote names to attempt
local EquipTool = findRemoteByNames({"EquipTool", "Equip", "Equip_Item", "EquipToolEvent"})
local ChargeRod = findRemoteByNames({"ChargeRod", "ChargeCast", "Charge"})
local RequestMinigame = findRemoteByNames({"RequestMinigame", "RequestMinigameEvent", "StartFishingMiniGame"})
local FishingDone = findRemoteByNames({"FishingDone", "FinishFishing", "FishingComplete", "FishingDoneEvent"})

-- safe invoke/fire wrappers
local function safeInvoke(rf, ...)
    if not rf or not rf.InvokeServer then return false, "missing remote or not function" end
    local ok, res = pcall(function() return rf:InvokeServer(...) end)
    return ok, res
end
local function safeFire(re, ...)
    if not re or not re.FireServer then return false, "missing event or not function" end
    local ok, res = pcall(function() return re:FireServer(...) end)
    return ok, res
end

-- start/stop helpers
local function stopBlatant()
    autoBlatant = false
    blatantLoopHandle = nil
end
local function stopInstant()
    autoInstant = false
    instantLoopHandle = nil
end

AutoFishTab:Toggle({
    Title = "Blatant Auto Fish",
    Icon = "zap",
    Default = false,
    Callback = function(state)
        if state then
            autoInstant = false
            instantLoopHandle = nil
        end
        autoBlatant = state

        if state then
            blatantLoopHandle = task.spawn(function()
                while autoBlatant do
                    if EquipTool and EquipTool.FireServer then
                        pcall(function() EquipTool:FireServer(1) end)
                    end
                    task.wait(0.4)
                    if ChargeRod and ChargeRod.InvokeServer then
                        pcall(function() ChargeRod:InvokeServer(tick()) end)
                    end
                    if RequestMinigame and RequestMinigame.InvokeServer then
                        pcall(function() RequestMinigame:InvokeServer(-1, 1) end)
                    end
                    task.wait(2.5 + math.random() * 1.5)
                    if FishingDone and FishingDone.FireServer then
                        pcall(function() FishingDone:FireServer() end)
                    end
                    task.wait(1.2)
                end
            end)
        else
            stopBlatant()
        end
    end,
})

AutoFishTab:Toggle({
    Title = "Instant Auto Fish (best-effort)",
    Icon = "bolt",
    Default = false,
    Callback = function(state)
        if state then
            autoBlatant = false
            blatantLoopHandle = nil
        end
        autoInstant = state

        if state then
            instantLoopHandle = task.spawn(function()
                while autoInstant do
                    if EquipTool and EquipTool.FireServer then pcall(function() EquipTool:FireServer(1) end) end
                    task.wait(0.25)
                    if ChargeRod and ChargeRod.InvokeServer then pcall(function() ChargeRod:InvokeServer(tick()) end) end
                    if RequestMinigame and RequestMinigame.InvokeServer then pcall(function() RequestMinigame:InvokeServer(-1, 1) end) end
                    if FishingDone and FishingDone.FireServer then pcall(function() FishingDone:FireServer() end) end
                    task.wait(0.8)
                end
            end)
        else
            stopInstant()
        end
    end,
})

AutoFishTab:Button({
    Title = "Show Auto Fish Status",
    Description = "Prints current auto-fish mode states to console.",
    Callback = function()
        print("[AutoFish] Blatant:", tostring(autoBlatant), "Instant:", tostring(autoInstant))
        pcall(function() WindUI:Notify({ Title = "Auto Fish", Content = "Blatant: "..tostring(autoBlatant).." — Instant: "..tostring(autoInstant), Duration = 3 }) end)
    end,
})

-- ---------- Auto Favorite Tab ----------
local FavTab = Window:Tab({ Title = "Auto Favorite", Icon = "heart", Locked = false })
local selectedRarities = {}
for _, r in ipairs(RARITIES) do selectedRarities[r.name] = false end
local function toggleRarity(name, state) selectedRarities[name] = state end

for _, r in ipairs(RARITIES) do
    local name = r.name
    FavTab:Toggle({
        Title = name,
        Icon = "star",
        Default = false,
        Callback = function(state) toggleRarity(name, state) end,
    })
end

FavTab:Button({ Title = "Select All Rarities", Callback = function() for _, r in ipairs(RARITIES) do selectedRarities[r.name] = true end pcall(function() WindUI:Notify({ Title = "Favorites", Content = "All rarities selected", Duration = 2 }) end) end })
FavTab:Button({ Title = "Clear All Selections", Callback = function() for _, r in ipairs(RARITIES) do selectedRarities[r.name] = false end pcall(function() WindUI:Notify({ Title = "Favorites", Content = "Selections cleared", Duration = 2 }) end) end })

local function favoriteSelectedRarities()
    if not FavoriteEvent then
        WindUI:Notify({ Title = "Favorites", Content = "Favorite remote not found", Duration = 3 })
        return
    end

    local inv = nil
    local ok, err = pcall(function() inv = InventoryExpect or (DataStore and DataStore:GetExpect({ "Inventory" })) end)
    if not ok or not inv then
        -- try reading direct (best-effort)
        pcall(function() inv = DataStore and DataStore:GetExpect({ "Inventory" }) end)
    end
    if not inv then
        WindUI:Notify({ Title = "Favorites", Content = "Could not read inventory", Duration = 4 })
        return
    end

    local favoritedCount = 0
    local function matchesSelection(item)
        if not item then return false end
        local tier = (item.Data and item.Data.Tier) or item.Tier or item.Rarity or nil
        local rname = nil
        if type(tier) == "number" then rname = TierToName[tier] or nil end
        if not rname then return false end
        return selectedRarities[rname] == true
    end

    for _, cat in ipairs(FavoriteCategories) do
        local tab = inv[cat]
        if tab and type(tab) == "table" then
            for _, item in ipairs(tab) do
                local okMatch, matched = pcall(matchesSelection, item)
                if okMatch and matched then
                    local uuid = item.UUID or item.Id or item.id or item.Value or nil
                    if uuid and tostring(uuid) ~= "" then
                        local ok, res = pcall(function()
                            if type(FavoriteEvent.FireServer) == "function" then
                                FavoriteEvent:FireServer(uuid)
                            elseif type(FavoriteEvent) == "function" then
                                FavoriteEvent(uuid) -- fallback if FavoriteEvent is a function
                            end
                        end)
                        if ok then favoritedCount = favoritedCount + 1 end
                    end
                end
            end
        end
    end

    WindUI:Notify({ Title = "Favorites", Content = "Favorited "..tostring(favoritedCount).." items (best-effort)", Duration = 4 })
end

FavTab:Button({
    Title = "Favorite Selected Rarities",
    Description = "Favorites all items in your inventory that match the selected rarities (best-effort)",
    Callback = function()
        local any = false
        for k,v in pairs(selectedRarities) do if v then any = true break end end
        if not any then
            WindUI:Notify({ Title = "Favorites", Content = "No rarities selected", Duration = 3 })
            return
        end
        task.spawn(favoriteSelectedRarities)
    end,
})

FavTab:Button({
    Title = "Favorite Everything",
    Description = "Favorites everything in inventory (like old module).",
    Callback = function()
        for _, r in ipairs(RARITIES) do selectedRarities[r.name] = true end
        task.spawn(favoriteSelectedRarities)
    end,
})

-- Misc Tab: Themes & Configs
local MiscTab = Window:Tab({ Title = "Misc", Icon = "cog", Locked = false })
MiscTab:Section({ Title = "Themes", Desc = "Select Your Themes.", Color = "Blue" })

local ThemeDropdown = MiscTab:Dropdown({
    Title = "Select Theme",
    Values = themeNames,
    Value = "Volcano",
    Callback = function(selectedTheme) pcall(function() WindUI:SetTheme(selectedTheme) end) end
})

MiscTab:Toggle({
    Title = "Transparent Window",
    Desc = "Toggle UI transparency on or off",
    Default = false,
    Callback = function(state) if state then Window:ToggleTransparency(true) else Window:ToggleTransparency(false) end end
})

MiscTab:Section({ Title = "Configuration Settings", Desc = "Save or load your theme and transparency settings.", Color = "Blue" })

local folderPath = "SYNCROPS_Config"
safe_makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
    if ok and json then
        if safe_writefile(filePath, json) then
            return true
        end
    end
    return false
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if safe_isfile(filePath) then
        local jsonData = safe_readfile(filePath)
        if jsonData then
            local ok, data = pcall(function() return HttpService:JSONDecode(jsonData) end)
            if ok then return data end
        end
    end
    return nil
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(safe_listfiles(folderPath)) do
        local fileName = file:match("([^/\\]+)%.json$")
        if fileName then table.insert(files, fileName) end
    end
    return files
end

local savedSettings = { Transparent = false, Theme = WindUI:GetCurrentTheme() }

local configName = ""
MiscTab:Input({ Title = "Config Name", Placeholder = "Enter name (e.g. Default)", Callback = function(text) configName = text end })

local filesDropdown
local files = ListFiles()
filesDropdown = MiscTab:Dropdown({ Title = "Select Config File", Values = files, Value = files[1], Callback = function(selected) configName = selected end })

MiscTab:Button({
    Title = "💾 Save Config",
    Desc = "Save transparency + theme",
    Callback = function()
        if configName == "" then WindUI:Notify({Title="⚠️ Missing name",Content="Please enter a config name before saving."}) return end
        savedSettings.Transparent = WindUI:GetTransparency()
        savedSettings.Theme = WindUI:GetCurrentTheme()
        if SaveFile(configName, savedSettings) then
            WindUI:Notify({Title="✅ Config Saved",Content="Saved config: "..configName})
            filesDropdown:Refresh(ListFiles())
        else
            WindUI:Notify({Title="❌ Failed",Content="Could not save config; writefile unsupported."})
        end
    end
})

MiscTab:Button({
    Title = "📂 Load Config",
    Desc = "Load transparency + theme",
    Callback = function()
        if configName == "" then WindUI:Notify({Title="⚠️ Missing name",Content="Please select or type a config first."}); return end
        local data = LoadFile(configName)
        if data then
            if data.Transparent ~= nil then Window:ToggleTransparency(data.Transparent) end
            if data.Theme then WindUI:SetTheme(data.Theme) end
            WindUI:Notify({Title="✅ Config Loaded",Content="Loaded config: "..configName})
        else
            WindUI:Notify({Title="❌ Failed",Content="Could not find or load config: "..configName})
        end
    end
})

MiscTab:Button({ Title = "🔁 Refresh Config List", Callback = function() filesDropdown:Refresh(ListFiles()) end })

-- Popup after UI ready
task.delay(0.2, function()
    WindUI:Popup({
        Title = "Successfully Loaded",
        Icon = "info",
        Content = "Made by @syncrops! Join our Discord!",
        Buttons = {
            { Title = "OK", Callback = function() end, Variant = "Primary" },
        },
    })
end)

print("✅ Wind UI loaded successfully")
