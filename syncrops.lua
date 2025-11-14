-- 🔴 Load WindUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not success or not WindUI then
    warn("❌ Failed to load WindUI")
    return
end

-- 🌈 Add all themes
local themeNames = {
    "Ocean Blue","Forest Green","Minimal Light","Retro Purple","Sunset",
    "Neon Pulse","Steel Phantom","Vaporwave","Deep Sea","Sepia Warmth",
    "Monokai Dark","Solarized Light","Cherry Blossom","Charcoal Gold",
    "Icy Mint","Volcano","Amethyst","Pastel Dream","Coffee Shop","Cyberpunk Red"
}

-- Example: Adding all themes
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

-- Add all themes to WindUI
for name, colors in pairs(themeColors) do
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
end

WindUI:SetTheme("Volcano") -- default

WindUI:SetFont("rbxassetid://12187360881")

local function GradientText(text, color1, color2)
    local result = ""
    for i = 1, #text do
        local t = (i - 1) / (#text - 1)
        local r = color1.R + (color2.R - color1.R) * t
        local g = color1.G + (color2.G - color1.G) * t
        local b = color1.B + (color2.B - color1.B) * t
        local hex = string.format("#%02X%02X%02X", r * 255, g * 255, b * 255)
        result = result .. string.format('<font color="%s">%s</font>', hex, text:sub(i, i))
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = GradientText("SYNCROPS", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0)),
    Icon = "rbxassetid://80426684728669",
    IconThemed = "true",
    Author = "By @syncrops",
    Size = UDim2.fromOffset(580, 460),
    Resizable = true,
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:Tag({
    Title = "Developer",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 10, -- from 0 to 13
})

Window:Tag({
    Title = "test UI V1.0",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 10, -- from 0 to 13
})

Window:SetIconSize(50) -- default is 20

Window:EditOpenButton({
    Title =  GradientText("SYNCROPS", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0)),
    Icon = "rbxassetid://80426684728669",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

Window:DisableTopbarButtons({ "Close" })

local Info = Window:Tab({Title = "Information", Icon = "info" })

local InviteCode = "SYNCROPS" -- change to your discord invite
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response
local ErrorMessage = nil

xpcall(function()
    Response = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
        Url = DiscordAPI,
        Method = "GET",
        Headers = {
            ["Accept"] = "application/json"
        }
    }).Body)
end, function(err)
    warn("err fetching discord info: " .. tostring(err))
    ErrorMessage = tostring(err)
    Response = nil
end)

if Response and Response.guild then
    local ParagraphConfig = {
        Title = Response.guild.name,
        Desc =
            ' Member Count: ' .. tostring(Response.approximate_member_count) ..
            '\n Online Count: ' .. tostring(Response.approximate_presence_count)
        ,
        Image = "https://cdn.discordapp.com/icons/" .. Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=256",
        ImageSize = 42,
        Buttons = {
            {
                Icon = "link",
                Title = "Copy Discord Invite",
                Callback = function()
                    pcall(function()
                        setclipboard("https://discord.gg/" .. InviteCode)
                    end)
                end
            },
            {
                Icon = "refresh-cw",
                Title = "Update Info",
                Callback = function()
                    xpcall(function()
                        local UpdatedResponse = game:GetService("HttpService"):JSONDecode(WindUI.Creator.Request({
                            Url = DiscordAPI,
                            Method = "GET",
                        }).Body)
                        
                        if UpdatedResponse and UpdatedResponse.guild then
                            DiscordInfo:SetDesc(
                                ' Member Count: ' .. tostring(UpdatedResponse.approximate_member_count) ..
                                '\n Online Count: ' .. tostring(UpdatedResponse.approximate_presence_count)
                            )
                        end
                    end, function(err)
                        warn("err updating discord info: " .. tostring(err))
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

-- 📘 Game Information Box (like “Bubble Gum Simulator INFINITY”)
local GameInfo = Info:Paragraph({
    Title = GradientText("SYNCROPS", Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 0)),
    Desc = "Script made by @syncrops",
    Color = "White",
})

-- 🎮 Supported Games Tab
local SupportedGamesTab = Window:Tab({
    Title = "Supported Games!", 
    Icon = "gamepad",
})

-- 🪓 Cut Trees Button
SupportedGamesTab:Button({
    Title = "Cut Trees", 
    Desc = "Teleport to Cut Trees!",
    Callback = function()
        -- Replace with Cut Trees game ID
        local cutTreesID = 16241018808 
        game:GetService("TeleportService"):Teleport(cutTreesID, game.Players.LocalPlayer)
    end
})

-- 🎣 Fish It Button
SupportedGamesTab:Button({
    Title = "Fish It!", 
    Desc = "Teleport to Fish It!",
    Callback = function()
        -- Replace with Fish It game ID
        local fishItID = 17799431029 
        game:GetService("TeleportService"):Teleport(fishItID, game.Players.LocalPlayer)
    end
})

-- ===== Auto Fishing (Blatant / Instant) + Auto-Favorite by Rarity =====
-- Paste this after your Window definition and after the remotes you showed:
-- EquipTool, ChargeRod, RequestMinigame, FishingDone are expected to exist.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage:WaitForChild("Packages")

-- require Net & Replion for favorites
local NetModule = require(Packages.Net)
local Replion = require(Packages.Replion).Client

local FavoriteEvent = NetModule:RemoteEvent and NetModule:RemoteEvent("FavoriteItem") or nil
local DataStore = Replion:WaitReplion("Data")
local InventoryExpect = DataStore and DataStore:GetExpect({ "Inventory" }) -- may be table-like

-- categories to search (same as your earlier module)
local FavoriteCategories = { "Fishes", "Items", "Potions", "Totems", "Fishing Rods", "Baits" }

-- Rarity mapping (from your module)
local RARITIES = {
	{ name = "Common", tier = 1 },
	{ name = "Uncommon", tier = 2 },
	{ name = "Rare", tier = 3 },
	{ name = "Epic", tier = 4 },
	{ name = "Legendary", tier = 5 },
	{ name = "Mythic", tier = 6 },
	{ name = "SECRET", tier = 7 },
}

-- Quick helper: map tier->name
local TierToName = {}
for _, r in ipairs(RARITIES) do TierToName[r.tier] = r.name end

-- ---------- UI: Auto Fish Tab ----------
local AutoFishTab = Window:Tab({
	Title = "Auto Fish",
	Icon = "fish",
	Locked = false,
})

-- state flags
local autoBlatant = false
local autoInstant = false

local blatantLoopHandle = nil
local instantLoopHandle = nil

-- Utility safe call wrappers (simple pcall use where needed)
local function safeInvoke(rf, ...)
	if not rf then return false, "missing remote" end
	local ok, res = pcall(function() return rf:InvokeServer(...) end)
	return ok, res
end
local function safeFire(re, ...)
	if not re then return false, "missing event" end
	local ok, res = pcall(function() return re:FireServer(...) end)
	return ok, res
end

-- Start/stop helpers
local function stopBlatant()
	autoBlatant = false
	if blatantLoopHandle then
		blatantLoopHandle = nil
	end
end
local function stopInstant()
	autoInstant = false
	if instantLoopHandle then
		instantLoopHandle = nil
	end
end

AutoFishTab:Toggle({
	Title = "Blatant Auto Fish",
	Icon = "zap",
	Default = false,
	Callback = function(state)
		-- enabling blatant disables instant and vice versa
		if state then
			autoInstant = false
			-- kill instant loop if running
			instantLoopHandle = nil
		end
		autoBlatant = state

		if state then
			-- spawn blatant loop
			blatantLoopHandle = task.spawn(function()
				while autoBlatant do
					-- equip main rod slot 1 (best-effort)
					if EquipTool and pcall then
						pcall(function() EquipTool:FireServer(1) end)
					end
					task.wait(0.4)

					-- charge cast if available
					if ChargeRod then
						pcall(function() ChargeRod:InvokeServer(tick()) end)
					end

					-- request minigame / start
					if RequestMinigame then
						pcall(function() RequestMinigame:InvokeServer(-1, 1) end)
					end

					-- normal wait for bite + finish
					task.wait(2.5 + math.random() * 1.5)
					if FishingDone then
						pcall(function() FishingDone:FireServer() end)
					end

					-- short delay before next cycle
					task.wait(1.2)
				end
			end)
		else
			-- stop
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
			-- disabling blatant if enabling instant
			autoBlatant = false
			blatantLoopHandle = nil
		end
		autoInstant = state

		if state then
			instantLoopHandle = task.spawn(function()
				while autoInstant do
					-- equip rod slot 1
					if EquipTool then pcall(function() EquipTool:FireServer(1) end) end
					task.wait(0.25)

					-- try to charge or request minigame if present
					if ChargeRod then pcall(function() ChargeRod:InvokeServer(tick()) end) end
					if RequestMinigame then pcall(function() RequestMinigame:InvokeServer(-1, 1) end) end

					-- Immediately attempt to finish fishing (best-effort)
					-- Some servers may validate and this will be rejected — that's expected.
					if FishingDone then
						pcall(function() FishingDone:FireServer() end)
					end

					-- very short cooldown to avoid spamming server (tune as needed)
					task.wait(0.8)
				end
			end)
		else
			stopInstant()
		end
	end,
})

-- Small informative label button
AutoFishTab:Button({
	Title = "Show Auto Fish Status",
	Description = "Prints current auto-fish mode states to console.",
	Callback = function()
		print("[AutoFish] Blatant:", tostring(autoBlatant), "Instant:", tostring(autoInstant))
		WindUI:Notify({ Title = "Auto Fish", Content = "Blatant: "..tostring(autoBlatant).." — Instant: "..tostring(autoInstant), Duration = 3 })
	end,
})

-- ---------- UI: Auto Favorite Tab (multi-select via toggles) ----------
local FavTab = Window:Tab({
	Title = "Auto Favorite",
	Icon = "heart",
	Locked = false,
})

-- track which rarities user selected
local selectedRarities = {}
for _, r in ipairs(RARITIES) do selectedRarities[r.name] = false end

-- helper to toggle selection
local function toggleRarity(name, state)
	selectedRarities[name] = state
end

-- Add a toggle per rarity (functionally multi-select)
for _, r in ipairs(RARITIES) do
	local name = r.name
	FavTab:Toggle({
		Title = name,
		Icon = "star",
		Default = false,
		Callback = function(state)
			toggleRarity(name, state)
		end,
	})
end

-- convenience buttons: Select All / Clear All
FavTab:Button({
	Title = "Select All Rarities",
	Callback = function()
		for _, r in ipairs(RARITIES) do
			selectedRarities[r.name] = true
		end
		WindUI:Notify({ Title = "Favorites", Content = "All rarities selected", Duration = 2 })
	end,
})
FavTab:Button({
	Title = "Clear All Selections",
	Callback = function()
		for _, r in ipairs(RARITIES) do
			selectedRarities[r.name] = false
		end
		WindUI:Notify({ Title = "Favorites", Content = "Selections cleared", Duration = 2 })
	end,
})

-- core favoriting function
local function favoriteSelectedRarities()
	if not FavoriteEvent then
		WindUI:Notify({ Title = "Favorites", Content = "Favorite remote not found", Duration = 3 })
		return
	end
	-- read inventory from Replion Data
	local inv = nil
	local success, err = pcall(function() inv = InventoryExpect and InventoryExpect end)
	if not success or not inv then
		-- try wait read directly from Replion (best-effort)
		pcall(function() inv = DataStore and DataStore:GetExpect({ "Inventory" }) end)
	end
	if not inv then
		WindUI:Notify({ Title = "Favorites", Content = "Could not read inventory", Duration = 4 })
		return
	end

	local favoritedCount = 0
	-- Helper to decide if an item matches selected rarities
	local function matchesSelection(item)
		-- item might be simple: { UUID = "...", Id = 12, Data = { Tier = X, Name = "..." } }
		if not item then return false end
		-- try Data.Tier
		local tier = (item.Data and item.Data.Tier) or item.Tier or item.Rarity or nil
		local rname = nil
		if type(tier) == "number" then
			rname = TierToName[tier] or nil
		end
		-- fallback: maybe item.Data.Name includes rarity? Unlikely.
		-- if no tier found, be conservative and skip
		if not rname then return false end
		return selectedRarities[rname] == true
	end

	-- iterate categories and favorite matching items
	for _, cat in ipairs(FavoriteCategories) do
		local tab = inv[cat]
		if tab and type(tab) == "table" then
			for _, item in ipairs(tab) do
				local okMatch, matched = pcall(matchesSelection, item)
				if okMatch and matched then
					-- attempt to favorite by UUID (common format item.UUID)
					local uuid = item.UUID or item.Id or item.id or item.Value or nil
					if uuid and tostring(uuid) ~= "" then
						local ok, res = pcall(function() FavoriteEvent:FireServer(uuid) end)
						if ok then
							favoritedCount = favoritedCount + 1
						else
							-- ignore single failures
						end
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
		-- quick check that at least one rarity is selected
		local any = false
		for k,v in pairs(selectedRarities) do if v then any = true break end end
		if not any then
			WindUI:Notify({ Title = "Favorites", Content = "No rarities selected", Duration = 3 })
			return
		end
		task.spawn(function()
			favoriteSelectedRarities()
		end)
	end,
})

-- small helper: favorite everything (all rarities)
FavTab:Button({
	Title = "Favorite Everything",
	Description = "Favorites everything in inventory (like old module).",
	Callback = function()
		-- set all toggles temporarily and run
		for _, r in ipairs(RARITIES) do selectedRarities[r.name] = true end
		task.spawn(function() favoriteSelectedRarities() end)
	end,
})

-- ===== end of block =====


local MiscTab = Window:Tab({
    Title = "Misc", 
    Icon = "cog",
    Locked = false,
})

MiscTab:Section({
    Title = "Themes",
    Desc = "Select Your Themes.",
    Color = "Blue"
})

-- 🎨 Theme Dropdown
local ThemeDropdown = MiscTab:Dropdown({
    Title = "Select Theme",
    Values = themeNames,
    Value = "Volcano",
    Callback = function(selectedTheme)
        WindUI:SetTheme(selectedTheme)
    end
})

-- 🪟 Transparent Window Toggle
MiscTab:Toggle({
    Title = "Transparent Window",
    Desc = "Toggle UI transparency on or off",
    Default = false, -- starts off
    Callback = function(state)
        if state then
            Window:ToggleTransparency(true)
        else
            Window:ToggleTransparency(false)
        end
    end
})

-- ⚙️ CONFIG SYSTEM (WindUI-style) --

MiscTab:Section({
    Title = "Configuration Settings",
    Desc = "Save or load your theme and transparency settings.",
    Color = "Blue"
})

local HttpService = game:GetService("HttpService")
local folderPath = "SYNCROPS_Config" -- change if you want
makefolder(folderPath)

local function SaveFile(fileName, data)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    local jsonData = HttpService:JSONEncode(data)
    writefile(filePath, jsonData)
end

local function LoadFile(fileName)
    local filePath = folderPath .. "/" .. fileName .. ".json"
    if isfile(filePath) then
        local jsonData = readfile(filePath)
        return HttpService:JSONDecode(jsonData)
    end
end

local function ListFiles()
    local files = {}
    for _, file in ipairs(listfiles(folderPath)) do
        local fileName = file:match("([^/]+)%.json$")
        if fileName then
            table.insert(files, fileName)
        end
    end
    return files
end

-- 💾 Store settings here
local savedSettings = {
    Transparent = false,
    Theme = WindUI:GetCurrentTheme()
}

-- 🌈 Input for config name
local configName = ""
MiscTab:Input({
    Title = "Config Name",
    Placeholder = "Enter name (e.g. Default)",
    Callback = function(text)
        configName = text
    end
})

-- 📥 Dropdown to list saved configs
local filesDropdown
local files = ListFiles()
filesDropdown = MiscTab:Dropdown({
    Title = "Select Config File",
    Values = files,
    Value = files[1],
    Callback = function(selected)
        configName = selected
    end
})

-- 🧩 Save button
MiscTab:Button({
    Title = "💾 Save Config",
    Desc = "Save transparency + theme",
    Callback = function()
        if configName == "" then
            WindUI:Notify({Title="⚠️ Missing name",Content="Please enter a config name before saving."})
            return
        end
        savedSettings.Transparent = WindUI:GetTransparency()
        savedSettings.Theme = WindUI:GetCurrentTheme()
        SaveFile(configName, savedSettings)
        WindUI:Notify({Title="✅ Config Saved",Content="Saved config: "..configName})
        filesDropdown:Refresh(ListFiles())
    end
})

-- 📂 Load button
MiscTab:Button({
    Title = "📂 Load Config",
    Desc = "Load transparency + theme",
    Callback = function()
        if configName == "" then
            WindUI:Notify({Title="⚠️ Missing name",Content="Please select or type a config first."})
            return
        end
        local data = LoadFile(configName)
        if data then
            if data.Transparent ~= nil then
                Window:ToggleTransparency(data.Transparent)
            end
            if data.Theme then
                WindUI:SetTheme(data.Theme)
            end
            WindUI:Notify({Title="✅ Config Loaded",Content="Loaded config: "..configName})
        else
            WindUI:Notify({Title="❌ Failed",Content="Could not find or load config: "..configName})
        end
    end
})

-- 🔄 Refresh list
MiscTab:Button({
    Title = "🔁 Refresh Config List",
    Callback = function()
        filesDropdown:Refresh(ListFiles())
    end
})

-- ✅ Show popup after UI is ready
task.delay(0.2, function()
	WindUI:Popup({
		Title = "Successfully Loaded",
		Icon = "info",
		Content = "Made by @syncrops! Join our Discord!",
		Buttons = {
			{
				Title = "OK",
				Callback = function() end,
				Variant = "Primary",
			},
		},
	})
end)

print("✅ Wind UI loaded successfully")
