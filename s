-- JOMHUB V2 : MOBILE OPTIMIZED VERSION (BASE UI TEMPLATE)
local Il111lllll1I = game:GetService("Players")
local IlIIIl1lIl1l = game:GetService("TweenService")
local IIIIl11lI111 = game:GetService("UserInputService")
local II1ll1IlI1lI = game:GetService("CoreGui")
local IIlIllIlIl1l = game:GetService("RunService")
local ll1llIl1IIll = game:GetService("HttpService")
local lII11lI1111l = game:GetService("ReplicatedStorage")
local llI11IIl11II = game:GetService("Workspace")
local I1llII1IIllI = game:GetService("VirtualUser")

local lIll1l11lI1l = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or lIll1l11lI1l

local Il1111lIl1I1 = Il111lllll1I.LocalPlayer
while not Il1111lIl1I1 do task.wait(); Il1111lIl1I1 = Il111lllll1I.LocalPlayer end

Il1111lIl1I1.Idled:Connect(function()
    I1llII1IIllI:CaptureController()
    I1llII1IIllI:ClickButton2(Vector2.new())
end)

local function ServerHop()
    task.spawn(function()
        math.randomseed(tick())
        
        local ll1I1lIllIll
        local l11l1lIIllI1 = 0
        
        -- More robust server fetching with retries and proxy fallback
        while not ll1I1lIllIll and l11l1lIIllI1 < 2 do
            local IlII1111lIlI = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
            if l11l1lIIllI1 == 1 then
                IlII1111lIlI = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100" -- Fallback proxy
            end
            
            local llllIIlIlIIl, IIlllI1IlIl1
            if lIll1l11lI1l then
                llllIIlIlIIl, IIlllI1IlIl1 = pcall(lIll1l11lI1l, {Url = IlII1111lIlI, Method = "GET"})
            elseif game.HttpGet then
                llllIIlIlIIl, IIlllI1IlIl1 = pcall(game.HttpGet, game, IlII1111lIlI, true)
            else
                break -- No HTTP method available
            end
            
            if llllIIlIlIIl and IIlllI1IlIl1 then
                local IlIIIII1lI1I = (type(IIlllI1IlIl1) == "table") and IIlllI1IlIl1.Body or IIlllI1IlIl1
                if IlIIIII1lI1I and type(IlIIIII1lI1I) == "string" then
                    local II11l1llIll1, Illll1l1ll1I = pcall(ll1llIl1IIll.JSONDecode, ll1llIl1IIll, IlIIIII1lI1I)
                    if II11l1llIll1 and Illll1l1ll1I and Illll1l1ll1I.data then
                        ll1I1lIllIll = Illll1l1ll1I.data
                    end
                end
            end
            l11l1lIIllI1 = l11l1lIIllI1 + 1
            if not ll1I1lIllIll then task.wait(0.5) end
        end
        
        if ll1I1lIllIll and #ll1I1lIllIll > 0 then
            local IIIIIIl111ll = {}
            for _, server in ipairs(ll1I1lIllIll) do
                if type(server) == "table" and server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(IIIIIIl111ll, server)
                end
            end
            
            if #IIIIIIl111ll > 0 then
                -- Shuffle the list to ensure randomness
                for i = #IIIIIIl111ll, 2, -1 do
                    local l1II1IlI1lI1 = math.random(1, i)
                    IIIIIIl111ll[i], IIIIIIl111ll[l1II1IlI1lI1] = IIIIIIl111ll[l1II1IlI1lI1], IIIIIIl111ll[i]
                end
                
                -- Try to teleport to the first valid server from the shuffled list
                pcall(function()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, IIIIIIl111ll[1].id, Il1111lIl1I1)
                end)
                task.wait(3) -- Give teleport time to process
                return -- Exit function after initiating teleport
            end
        end
        
        print("[JOMHUB] Server Hop failed: Could not retrieve a valid server list.")
    end)
end

_G.JomHub_BossPity = _G.JomHub_BossPity or 0

if readfile and isfile and isfile("JomHUB_Configs/JomHubMobile_Pity.txt") then
    local II11I1I1111I = tonumber(readfile("JomHUB_Configs/JomHubMobile_Pity.txt"))
    if II11I1I1111I then _G.JomHub_BossPity = II11I1I1111I end
end

local I111IIIll1l1 = nil

local function updatePity(val)
    _G.JomHub_BossPity = val
    if I111IIIll1l1 then I111IIIll1l1.Text = "Current Pity: " .. _G.JomHub_BossPity .. "/25" end
    if writefile then if not isfolder("JomHUB_Configs") then pcall(makefolder, "JomHUB_Configs") end; pcall(function() writefile("JomHUB_Configs/JomHubMobile_Pity.txt", tostring(val)) end) end
end

-- STATE & SETTINGS
local l11ll11II1l1 = {
    AutoLevelActive = false,
    AutoFarmActive = false,
    selectedMob = "None",
    lastPortal = "",
    AutoBossActive = false,
    AutoAllBossActive = false,
    autoHopAllBosses = false,
    selectedBoss = "None",
    farmPos = "Behind",
    farmDistance = 10,
    autoMelee = true,
    autoSword = false,
    autoFruit = false,
    autoSkills = {},
    autoMeleeSkills = {},
    autoSwordSkills = {},
    autoFruitSkills = {},
    lastAutoQuest = "",
    autoDungeon = false,
    dungeonType = "CidDungeon",
    dungeonDiff = "Easy",
    dungeonPos = "Behind",
    autoInfiniteTower = false,
    infiniteTowerPos = "Behind",
    autoFarmTitle = false,
    selectedTitle = "None",
    hopForTitle = false,
    autoSummon = false,
    summonTargets = {},
    summonDiff = "Normal",
    autoFarmItems = false,
    itemFarmDuration = 60,
    farmCommon = {},
    farmRare = {},
    farmEpic = {},
    farmLegendary = {},
    farmMythical = {},
    farmSecret = {},
    pityBuilderBosses = {},
    pitySummonBoss = "None",
    pitySummonDiff = "Normal",
    autoSummonPity = false,
    autoHopPity = false,
    afkModeActive = false,
    afkIslands = {}
}

local llI1IIlIIIII = {
    ["Starter"] = "StarterIsland", ["Jungle"] = "JungleIsland", ["Desert"] = "DesertIsland",
    ["Snow"] = "SnowIsland", ["Shibuya"] = "ShibuyaStation", ["HollowIsland"] = "HollowIsland",
    ["Shinjuku"] = "ShinjukuIsland", ["Slime"] = "SlimeIsland", ["Academy"] = "AcademyIsland",
    ["Judgement"] = "JudgementIsland", ["SoulDominion"] = "SoulDominionIsland", ["Ninja"] = "NinjaIsland",
    ["Lawless"] = "LawlessIsland", ["Boss"] = "BossIsland", ["Sailor"] = "SailorIsland", ["Valentine"] = "ValentineIsland"
}
    
local function mergeConfig(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" and type(dst[k]) == "table" then mergeConfig(dst[k], v) else dst[k] = v end
    end
end

if readfile and isfile and isfolder then
    if isfile("JomHUB_Configs/JomHubMobile_autoload.txt") then
        local IlIl11I1lIll = readfile("JomHUB_Configs/JomHubMobile_autoload.txt")
        if isfile("JomHUB_Configs/"..IlIl11I1lIll..".json") then
            local llllIIlIlIIl, Illll1l1ll1I = pcall(function() return ll1llIl1IIll:JSONDecode(readfile("JomHUB_Configs/"..IlIl11I1lIll..".json")) end)
            if llllIIlIlIIl and type(Illll1l1ll1I) == "table" then mergeConfig(l11ll11II1l1, Illll1l1ll1I) end
        end
    end
end

local llIIIl1l1Ill = {}
local I1ll11l1l1I1 = lII11lI1111l:WaitForChild("Remotes", 5)
local lI1Il1lIlI1I = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("UpdateInventory")
local IllllIlIIlII = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("RequestInventory")

if lI1Il1lIlI1I then
    lI1Il1lIlI1I.OnClientEvent:Connect(function(action, Illll1l1ll1I)
        if action == "Items" and type(Illll1l1ll1I) == "table" then
            local llll1lIl1lI1 = {}
            for _, item in ipairs(Illll1l1ll1I) do
                if type(item) == "table" and item.name then
                    llll1lIl1lI1[item.name] = item.quantity or 1
                end
            end
            llIIIl1l1Ill = llll1lIl1lI1
        end
    end)
end

task.spawn(function()
    while task.wait(10) do
        if IllllIlIIlII then pcall(function() IllllIlIIlII:FireServer() end) end
    end
end)

local function getUiParent()
    local llllIIlIlIIl, l1Il1I1lllI1 = pcall(function() return gethui() end)
    if not llllIIlIlIIl or not l1Il1I1lllI1 then llllIIlIlIIl, l1Il1I1lllI1 = pcall(function() return II1ll1IlI1lI end) end
    if not llllIIlIlIIl or not l1Il1I1lllI1 then l1Il1I1lllI1 = Il111lllll1I.LocalPlayer:WaitForChild("PlayerGui") end
    return l1Il1I1lllI1
end

local ll111I1l1lIl = getUiParent()
if ll111I1l1lIl:FindFirstChild("JomHubMobile") then
    ll111I1l1lIl.JomHubMobile:Destroy()
end

local ll1IIIlI11I1 = Instance.new("ScreenGui")
ll1IIIlI11I1.Name = "JomHubMobile"
ll1IIIlI11I1.ResetOnSpawn = false
ll1IIIlI11I1.ZIndexBehavior = Enum.ZIndexBehavior.Global
ll1IIIlI11I1.Parent = ll111I1l1lIl

-- Mobile Responsive Colors
local IlI1lIlllIll = {
    BG = Color3.fromRGB(5, 8, 14),
    TopBar = Color3.fromRGB(10, 15, 24),
    TabBG = Color3.fromRGB(8, 12, 18),
    ElementBG = Color3.fromRGB(15, 20, 30),
    ElementHover = Color3.fromRGB(25, 35, 50),
    Accent = Color3.fromRGB(45, 120, 255),
    Text = Color3.fromRGB(220, 230, 255),
    Muted = Color3.fromRGB(100, 120, 150)
}

local function round(l1Il1I1lllI1, radius)
    local lI1I1111ll11 = Instance.new("UICorner")
    lI1I1111ll11.CornerRadius = UDim.new(0, radius)
    lI1I1111ll11.Parent = l1Il1I1lllI1
end

local function createLabel(l1Il1I1lllI1, text, align, font, size, color)
    local lI111I1I1I1I = Instance.new("TextLabel")
    lI111I1I1I1I.BackgroundTransparency = 1
    lI111I1I1I1I.Text = text
    lI111I1I1I1I.Font = font
    lI111I1I1I1I.TextSize = size
    lI111I1I1I1I.TextColor3 = color
    lI111I1I1I1I.TextXAlignment = align
    lI111I1I1I1I.Parent = l1Il1I1lllI1
    return lI111I1I1I1I
end

-- Floating Open/Close Button (Touch Friendly)
local ll1l1l1IIl1l = Instance.new("TextButton")
ll1l1l1IIl1l.Size = UDim2.new(0, 50, 0, 50)
ll1l1l1IIl1l.Position = UDim2.new(1, -65, 0.15, 0)
ll1l1l1IIl1l.BackgroundColor3 = IlI1lIlllIll.TopBar
ll1l1l1IIl1l.Text = "JOM"
ll1l1l1IIl1l.TextColor3 = IlI1lIlllIll.Accent
ll1l1l1IIl1l.Font = Enum.Font.GothamBold
ll1l1l1IIl1l.TextSize = 14
ll1l1l1IIl1l.BorderSizePixel = 0
ll1l1l1IIl1l.Visible = false
ll1l1l1IIl1l.Parent = ll1IIIlI11I1
local Il1lI1lll1II = Instance.new("UIStroke")
Il1lI1lll1II.Color = IlI1lIlllIll.Accent
Il1lI1lll1II.Thickness = 2
Il1lI1lll1II.Parent = ll1l1l1IIl1l

-- Make Open Button Draggable
local IlIll11II11l, Il1I1l11lIl1, lIlIII1llll1
ll1l1l1IIl1l.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IlIll11II11l = true; Il1I1l11lIl1 = input.Position; lIlIII1llll1 = ll1l1l1IIl1l.Position
    end
end)
IIIIl11lI111.InputChanged:Connect(function(input)
    if IlIll11II11l and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local II1Il11lIll1 = input.Position - Il1I1l11lIl1
        ll1l1l1IIl1l.Position = UDim2.new(lIlIII1llll1.X.Scale, lIlIII1llll1.X.Offset + II1Il11lIll1.X, lIlIII1llll1.Y.Scale, lIlIII1llll1.Y.Offset + II1Il11lIll1.Y)
    end
end)
IIIIl11lI111.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then IlIll11II11l = false end
end)

local lIllIlI11II1 = Instance.new("Frame")
local l1I1I1lI1l1l = workspace.CurrentCamera
local lI111II1IIl1 = l1I1I1lI1l1l and l1I1I1lI1l1l.ViewportSize or Vector2.new(800, 600)
local III1l11I1lll = math.min(math.max(lI111II1IIl1.X * 0.75, 300), 560)
local lII1Illl1lII = math.min(math.max(lI111II1IIl1.Y * 0.65, 280), 420)
lIllIlI11II1.Size = UDim2.new(0, III1l11I1lll, 0, lII1Illl1lII)
lIllIlI11II1.Position = UDim2.new(0.5, 0, 0.5, 0)
lIllIlI11II1.AnchorPoint = Vector2.new(0.5, 0.5)
lIllIlI11II1.BackgroundColor3 = IlI1lIlllIll.BG
lIllIlI11II1.BackgroundTransparency = 0.15
lIllIlI11II1.Visible = false
lIllIlI11II1.ClipsDescendants = true
lIllIlI11II1.Parent = ll1IIIlI11I1

local lIlI11lI11l1 = Instance.new("UIStroke")
lIlI11lI11l1.Thickness = 2
lIlI11lI11l1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
lIlI11lI11l1.Parent = lIllIlI11II1

-- Constraints to ensure it doesn't stretch or shrink improperly
local ll1Il1Il11Il = Instance.new("UISizeConstraint")
ll1Il1Il11Il.MinSize = Vector2.new(280, 260)
ll1Il1Il11Il.MaxSize = Vector2.new(560, 420)
ll1Il1Il11Il.Parent = lIllIlI11II1

local llIIllIl1Il1 = Instance.new("Frame")
llIIllIl1Il1.Size = UDim2.new(1, 0, 0, 45)
llIIllIl1Il1.BackgroundColor3 = IlI1lIlllIll.TopBar
llIIllIl1Il1.BackgroundTransparency = 0.15
llIIllIl1Il1.Parent = lIllIlI11II1
local l11I1l1I1III = createLabel(llIIllIl1Il1, " [ SYSTEM ] JOMHUB", Enum.TextXAlignment.Left, Enum.Font.GothamBold, 14, IlI1lIlllIll.Accent)
l11I1l1I1III.Size = UDim2.new(1, -15, 1, 0)
l11I1l1I1III.Position = UDim2.new(0, 15, 0, 0)

_G.ActiveRGBToggles = {}

-- Moves RGB loop under the Title definition so the Title string cycles RGB
task.spawn(function()
    local llIIlI1I11ll = 0
    while ll1IIIlI11I1.Parent do
        llIIlI1I11ll = llIIlI1I11ll + 0.005
        if llIIlI1I11ll > 1 then llIIlI1I11ll = 0 end
        local l1IIII1lIllI = Color3.fromHSV(llIIlI1I11ll, 1, 1)
        if lIlI11lI11l1.Parent then lIlI11lI11l1.Color = l1IIII1lIllI end
        if Il1lI1lll1II.Parent then Il1lI1lll1II.Color = l1IIII1lIllI end
        if l11I1l1I1III.Parent then l11I1l1I1III.TextColor3 = l1IIII1lIllI end
        for switchFrame, _ in pairs(_G.ActiveRGBToggles) do
            if switchFrame.Parent then switchFrame.BackgroundColor3 = l1IIII1lIllI
            else _G.ActiveRGBToggles[switchFrame] = nil end
        end
        task.wait(0.03)
    end
end)

local l1Il1I1l1lII = Instance.new("ScrollingFrame")
l1Il1I1l1lII.Size = UDim2.new(1, 0, 0, 40)
l1Il1I1l1lII.Position = UDim2.new(0, 0, 0, 45)
l1Il1I1l1lII.BackgroundColor3 = IlI1lIlllIll.TabBG
l1Il1I1l1lII.ScrollBarThickness = 0
l1Il1I1l1lII.CanvasSize = UDim2.new(0, 0, 0, 0)
l1Il1I1l1lII.AutomaticCanvasSize = Enum.AutomaticSize.X
l1Il1I1l1lII.Parent = lIllIlI11II1

local lIII1IIIlIll = Instance.new("UIListLayout")
lIII1IIIlIll.FillDirection = Enum.FillDirection.Horizontal
lIII1IIIlIll.SortOrder = Enum.SortOrder.LayoutOrder
lIII1IIIlIll.Padding = UDim.new(0, 5)
lIII1IIIlIll.Parent = l1Il1I1l1lII

local IllIII11IlI1 = Instance.new("UIPadding")
IllIII11IlI1.PaddingLeft = UDim.new(0, 10)
IllIII11IlI1.PaddingRight = UDim.new(0, 10)
IllIII11IlI1.PaddingTop = UDim.new(0, 5)
IllIII11IlI1.PaddingBottom = UDim.new(0, 5)
IllIII11IlI1.Parent = l1Il1I1l1lII

local lllI11lIIIIl = Instance.new("Frame")
lllI11lIIIIl.Size = UDim2.new(1, 0, 1, -85)
lllI11lIIIIl.Position = UDim2.new(0, 0, 0, 85)
lllI11lIIIIl.BackgroundTransparency = 1
lllI11lIIIIl.Parent = lIllIlI11II1

ll1l1l1IIl1l.Activated:Connect(function()
    lIllIlI11II1.Visible = not lIllIlI11II1.Visible
    ll1l1l1IIl1l.BackgroundTransparency = lIllIlI11II1.Visible and 0.5 or 0
end)

-- Make Topbar Draggable
local l1l1IIIlII11, lI1lll1IlIl1, lIIlI1Ill11I
llIIllIl1Il1.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        l1l1IIIlII11 = true; lI1lll1IlIl1 = input.Position; lIIlI1Ill11I = lIllIlI11II1.Position
    end
end)
IIIIl11lI111.InputChanged:Connect(function(input)
    if l1l1IIIlII11 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local II1Il11lIll1 = input.Position - lI1lll1IlIl1
        lIllIlI11II1.Position = UDim2.new(lIIlI1Ill11I.X.Scale, lIIlI1Ill11I.X.Offset + II1Il11lIll1.X, lIIlI1Ill11I.Y.Scale, lIIlI1Ill11I.Y.Offset + II1Il11lIll1.Y)
    end
end)
IIIIl11lI111.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then l1l1IIIlII11 = false end
end)

lIllIlI11II1:GetPropertyChangedSignal("Position"):Connect(function()
    if _G.ActiveDropdownContainer and _G.ActiveDropdownContainer.Visible and _G.ActiveDropdownButton then
        local l1IIII1lllIl = _G.ActiveDropdownButton
        local Ill1III1I1l1 = _G.ActiveDropdownContainer
        local l11l1Ill1IIl = Ill1III1I1l1.Size.Y.Offset
        local IIlll111II1l = l1IIII1lllIl.AbsolutePosition.X
        local Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y
        if (l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y + l11l1Ill1IIl) > ll1IIIlI11I1.AbsoluteSize.Y then
            Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y - l11l1Ill1IIl
        end
        Ill1III1I1l1.Position = UDim2.new(0, IIlll111II1l, 0, Il11llll111l)
    end
end)

-- UI Library Setup
local IlIlIII1IIll = {}
local l1I1II11llIl = {}
local IlI111Il1IIl = nil
local IIIlll1II11l = nil

function IlIlIII1IIll:CreateTab(name)
    local II1IIIllIlI1 = Instance.new("TextButton")
    II1IIIllIlI1.Size = UDim2.new(0, 100, 1, 0)
    II1IIIllIlI1.BackgroundColor3 = IlI1lIlllIll.ElementBG
    II1IIIllIlI1.Text = name
    II1IIIllIlI1.TextColor3 = IlI1lIlllIll.Muted
    II1IIIllIlI1.Font = Enum.Font.GothamSemibold
    II1IIIllIlI1.TextSize = 13
    II1IIIllIlI1.AutoButtonColor = false
    II1IIIllIlI1.Parent = l1Il1I1l1lII
    round(II1IIIllIlI1, 6)
    
    -- Auto size tab button to fit text
    II1IIIllIlI1.Size = UDim2.new(0, II1IIIllIlI1.TextBounds.X + 24, 1, 0)
    
    local IlIl1111IIll = Instance.new("ScrollingFrame")
    IlIl1111IIll.Size = UDim2.new(1, 0, 1, 0)
    IlIl1111IIll.BackgroundTransparency = 1
    IlIl1111IIll.ScrollBarThickness = 2
    IlIl1111IIll.ScrollBarImageColor3 = IlI1lIlllIll.Accent
    IlIl1111IIll.CanvasSize = UDim2.new(0, 0, 0, 0)
    IlIl1111IIll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    IlIl1111IIll.Visible = false
    IlIl1111IIll.Parent = lllI11lIIIIl
    
    local I1lIl1l11IIl = Instance.new("UIListLayout")
    I1lIl1l11IIl.SortOrder = Enum.SortOrder.LayoutOrder
    I1lIl1l11IIl.Padding = UDim.new(0, 8)
    I1lIl1l11IIl.Parent = IlIl1111IIll
    
    local llll11111Ill = Instance.new("UIPadding")
    llll11111Ill.PaddingLeft = UDim.new(0, 12)
    llll11111Ill.PaddingRight = UDim.new(0, 12)
    llll11111Ill.PaddingTop = UDim.new(0, 12)
    llll11111Ill.PaddingBottom = UDim.new(0, 12)
    llll11111Ill.Parent = IlIl1111IIll
    
    local I1lI111lI11I = {Btn = II1IIIllIlI1, Page = IlIl1111IIll}
    table.insert(l1I1II11llIl, I1lI111lI11I)
    
    II1IIIllIlI1.Activated:Connect(function()
        if IIIlll1II11l then IIIlll1II11l.Visible = false; IIIlll1II11l = nil end
        for _, v in ipairs(l1I1II11llIl) do
            v.Btn.TextColor3 = IlI1lIlllIll.Muted
            v.Btn.BackgroundColor3 = IlI1lIlllIll.ElementBG
            v.Page.Visible = false
        end
        II1IIIllIlI1.TextColor3 = IlI1lIlllIll.Text
        II1IIIllIlI1.BackgroundColor3 = IlI1lIlllIll.Accent
        IlIl1111IIll.Visible = true
    end)
    
    if #l1I1II11llIl == 1 then
        II1IIIllIlI1.TextColor3 = IlI1lIlllIll.Text
        II1IIIllIlI1.BackgroundColor3 = IlI1lIlllIll.Accent
        IlIl1111IIll.Visible = true
    end
    
    local lI11lllIIlI1 = {}
    
    -- Creates a uniformly aligned Section Header
    function lI11lllIIlI1:CreateSection(title)
        local Il1I1ll11l1l = Instance.new("Frame")
        Il1I1ll11l1l.Size = UDim2.new(1, 0, 0, 25)
        Il1I1ll11l1l.BackgroundTransparency = 1
        Il1I1ll11l1l.Parent = IlIl1111IIll
        local lI111I1I1I1I = createLabel(Il1I1ll11l1l, title, Enum.TextXAlignment.Left, Enum.Font.GothamBold, 12, IlI1lIlllIll.Accent)
        lI111I1I1I1I.Size = UDim2.new(1, 0, 1, 0)
    end

    -- 100% Width Mobile Friendly Toggle
    function lI11lllIIlI1:CreateToggle(title, default, callback)
        local lIIIIII11IlI = default or false
        local I11lIIIl1III = Instance.new("TextButton")
        I11lIIIl1III.Size = UDim2.new(1, 0, 0, 45) -- Standard touch height
        I11lIIIl1III.BackgroundColor3 = IlI1lIlllIll.ElementBG
        I11lIIIl1III.Text = ""
        I11lIIIl1III.AutoButtonColor = false
        I11lIIIl1III.Parent = IlIl1111IIll
        
        local lI111I1I1I1I = createLabel(I11lIIIl1III, title, Enum.TextXAlignment.Left, Enum.Font.Gotham, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(1, -60, 1, 0); lI111I1I1I1I.Position = UDim2.new(0, 15, 0, 0)
        
        local l1I111lIII1l = Instance.new("Frame")
        l1I111lIII1l.Size = UDim2.new(0, 40, 0, 22)
        l1I111lIII1l.AnchorPoint = Vector2.new(1, 0.5)
        l1I111lIII1l.Position = UDim2.new(1, -15, 0.5, 0)
        l1I111lIII1l.BackgroundColor3 = lIIIIII11IlI and IlI1lIlllIll.Accent or IlI1lIlllIll.TopBar
        l1I111lIII1l.Parent = I11lIIIl1III
        
        local IlIl1llllll1 = Instance.new("Frame")
        IlIl1llllll1.Size = UDim2.new(0, 16, 0, 16)
        IlIl1llllll1.AnchorPoint = Vector2.new(0, 0.5)
        IlIl1llllll1.Position = UDim2.new(0, lIIIIII11IlI and 21 or 3, 0.5, 0)
        IlIl1llllll1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        IlIl1llllll1.BorderSizePixel = 0
        IlIl1llllll1.Parent = l1I111lIII1l
        
        if lIIIIII11IlI then _G.ActiveRGBToggles[l1I111lIII1l] = true end

        I11lIIIl1III.Activated:Connect(function()
            lIIIIII11IlI = not lIIIIII11IlI
            if lIIIIII11IlI then _G.ActiveRGBToggles[l1I111lIII1l] = true else _G.ActiveRGBToggles[l1I111lIII1l] = nil; IlIIIl1lIl1l:Create(l1I111lIII1l, TweenInfo.new(0.2), {BackgroundColor3 = IlI1lIlllIll.TopBar}):Play() end
            IlIIIl1lIl1l:Create(IlIl1llllll1, TweenInfo.new(0.2), {Position = UDim2.new(0, lIIIIII11IlI and 21 or 3, 0.5, 0)}):Play()
            if callback then callback(lIIIIII11IlI) end
        end)
    end
    
    -- 100% Width Mobile Friendly Dropdown
    function lI11lllIIlI1:CreateDropdown(title, list, default, callback)
        list = list or {}
        local IIIllIII1l1l = default
        
        local l1IIII1lllIl = Instance.new("TextButton")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 0, 45)
        l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG
        l1IIII1lllIl.Text = ""
        l1IIII1lllIl.AutoButtonColor = false
        l1IIII1lllIl.Parent = IlIl1111IIll
        
        local lI111I1I1I1I = createLabel(l1IIII1lllIl, title .. ": " .. (default or "None"), Enum.TextXAlignment.Left, Enum.Font.Gotham, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(1, -40, 1, 0); lI111I1I1I1I.Position = UDim2.new(0, 15, 0, 0)
        
        local IllIllI1111I = createLabel(l1IIII1lllIl, "+", Enum.TextXAlignment.Right, Enum.Font.GothamBold, 16, IlI1lIlllIll.Accent)
        IllIllI1111I.Size = UDim2.new(0, 20, 1, 0); IllIllI1111I.Position = UDim2.new(1, -25, 0, 0)

        local IIl1I1IIlIII = Instance.new("Frame")
        IIl1I1IIlIII.BackgroundColor3 = IlI1lIlllIll.ElementBG
        IIl1I1IIlIII.BorderColor3 = IlI1lIlllIll.Accent
        IIl1I1IIlIII.BorderSizePixel = 1
        IIl1I1IIlIII.Visible = false
        IIl1I1IIlIII.ClipsDescendants = true
        IIl1I1IIlIII.ZIndex = 100
        IIl1I1IIlIII.Parent = ll1IIIlI11I1

        local Il11llII111l = Instance.new("ScrollingFrame")
        Il11llII111l.Size = UDim2.new(1, 0, 1, 0)
        Il11llII111l.BackgroundTransparency = 1
        Il11llII111l.ScrollBarThickness = 3
        Il11llII111l.ScrollBarImageColor3 = IlI1lIlllIll.Accent
        Il11llII111l.ZIndex = 101
        Il11llII111l.CanvasSize = UDim2.new(0, 0, 0, 0)
        Il11llII111l.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Il11llII111l.Parent = IIl1I1IIlIII
        
        local l1IllIlIl111 = Instance.new("UIListLayout")
        l1IllIlIl111.SortOrder = Enum.SortOrder.LayoutOrder
        l1IllIlIl111.Padding = UDim.new(0, 2)
        l1IllIlIl111.Parent = Il11llII111l

        local Il1IllllIIll = Instance.new("UIPadding"); Il1IllllIIll.PaddingLeft = UDim.new(0, 2); Il1IllllIIll.PaddingRight = UDim.new(0, 2); Il1IllllIIll.PaddingTop = UDim.new(0, 2); Il1IllllIIll.PaddingBottom = UDim.new(0, 2); Il1IllllIIll.Parent = Il11llII111l

        l1IIII1lllIl.Activated:Connect(function()
            local I11I1I1III1I = not IIl1I1IIlIII.Visible
            if IIIlll1II11l and IIIlll1II11l ~= IIl1I1IIlIII then IIIlll1II11l.Visible = false end
            
            IllIllI1111I.Text = I11I1I1III1I and "-" or "+"
            IIl1I1IIlIII.Visible = I11I1I1III1I
            IIIlll1II11l = I11I1I1III1I and IIl1I1IIlIII or nil

            if I11I1I1III1I then
                _G.ActiveDropdownButton = l1IIII1lllIl
                _G.ActiveDropdownContainer = IIl1I1IIlIII
                local IlIIIl1ll11l = 35; local lI1Il1lIIl11 = 4; local IIIIIlll1l1I = 150
                local Illl1lIIIIll = (#list * IlIIIl1ll11l) + ((#list - 1) * l1IllIlIl111.Padding.Offset) + lI1Il1lIIl11
                local l11l1Ill1IIl = math.min(Illl1lIIIIll, IIIIIlll1l1I)

                IIl1I1IIlIII.Size = UDim2.new(0, l1IIII1lllIl.AbsoluteSize.X, 0, l11l1Ill1IIl)
                local IIlll111II1l = l1IIII1lllIl.AbsolutePosition.X
                local Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y
                if (l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y + l11l1Ill1IIl) > ll1IIIlI11I1.AbsoluteSize.Y then
                    Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y - l11l1Ill1IIl
                end
                IIl1I1IIlIII.Position = UDim2.new(0, IIlll111II1l, 0, Il11llll111l)
            else
                if _G.ActiveDropdownContainer == IIl1I1IIlIII then
                    _G.ActiveDropdownContainer = nil; _G.ActiveDropdownButton = nil
                end
            end
        end)
        
        IlIl1111IIll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if IIl1I1IIlIII.Visible then 
                IIl1I1IIlIII.Visible = false; IIIlll1II11l = nil; IllIllI1111I.Text = "+" 
                if _G.ActiveDropdownContainer == IIl1I1IIlIII then _G.ActiveDropdownContainer = nil; _G.ActiveDropdownButton = nil end
            end
        end)
        
        for _, item in ipairs(list) do
            local l11lI1I1IlII = Instance.new("TextButton")
            l11lI1I1IlII.Size = UDim2.new(1, 0, 0, 35)
            l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementBG
            l11lI1I1IlII.Text = "  " .. item
            l11lI1I1IlII.TextColor3 = IlI1lIlllIll.Muted
            l11lI1I1IlII.Font = Enum.Font.Gotham
            l11lI1I1IlII.TextSize = 13
            l11lI1I1IlII.TextXAlignment = Enum.TextXAlignment.Left
            l11lI1I1IlII.ZIndex = 102
            l11lI1I1IlII.BorderSizePixel = 0
            l11lI1I1IlII.AutoButtonColor = false
            l11lI1I1IlII.Parent = Il11llII111l

            l11lI1I1IlII.MouseEnter:Connect(function() l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementHover end)
            l11lI1I1IlII.MouseLeave:Connect(function() l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementBG end)
            
            l11lI1I1IlII.Activated:Connect(function()
                if IIIllIII1l1l == item then IIIllIII1l1l = nil; lI111I1I1I1I.Text = title .. ": None"; if callback then callback(nil) end
                else IIIllIII1l1l = item; lI111I1I1I1I.Text = title .. ": " .. item; if callback then callback(item) end end
                IllIllI1111I.Text = "+"
                IIl1I1IIlIII.Visible = false
                IIIlll1II11l = nil
                if _G.ActiveDropdownContainer == IIl1I1IIlIII then _G.ActiveDropdownContainer = nil; _G.ActiveDropdownButton = nil end
            end)
        end
    end
    
    function lI11lllIIlI1:CreateSlider(title, min, max, default, callback)
        local IIIlI11l1IIl = min or 0
        local lI1IIlIIlIlI = max or 100
        local I1I11ll11II1 = default or IIIlI11l1IIl
        
        local I1lII1Il1l1I = Instance.new("Frame")
        I1lII1Il1l1I.Size = UDim2.new(1, 0, 0, 60)
        I1lII1Il1l1I.BackgroundColor3 = IlI1lIlllIll.ElementBG
        I1lII1Il1l1I.Parent = IlIl1111IIll
        
        local lI111I1I1I1I = createLabel(I1lII1Il1l1I, title .. ": " .. I1I11ll11II1, Enum.TextXAlignment.Left, Enum.Font.Gotham, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(1, -30, 0, 30); lI111I1I1I1I.Position = UDim2.new(0, 15, 0, 0)
        
        local lII11l1l1lII = Instance.new("Frame")
        lII11l1l1lII.Size = UDim2.new(1, -30, 0, 6)
        lII11l1l1lII.Position = UDim2.new(0, 15, 0, 38)
        lII11l1l1lII.BackgroundColor3 = IlI1lIlllIll.TopBar
        lII11l1l1lII.Parent = I1lII1Il1l1I
        round(lII11l1l1lII, 3)
        
        local III1IllI1I1l = Instance.new("Frame")
        local III1I1II11ll = 0
        if lI1IIlIIlIlI > IIIlI11l1IIl then
            III1I1II11ll = math.clamp((I1I11ll11II1 - IIIlI11l1IIl) / (lI1IIlIIlIlI - IIIlI11l1IIl), 0, 1)
        end
        III1IllI1I1l.Size = UDim2.new(III1I1II11ll, 0, 1, 0)
        III1IllI1I1l.BackgroundColor3 = IlI1lIlllIll.Accent
        III1IllI1I1l.Parent = lII11l1l1lII
        round(III1IllI1I1l, 3)
        
        local l1IIII1lllIl = Instance.new("TextButton")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 1, 20)
        l1IIII1lllIl.Position = UDim2.new(0, 0, 0, -10)
        l1IIII1lllIl.BackgroundTransparency = 1
        l1IIII1lllIl.Text = ""
        l1IIII1lllIl.Parent = lII11l1l1lII
        
        local IllII1Illlll = false
        l1IIII1lllIl.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then IllII1Illlll = true end end)
        IIIIl11lI111.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then IllII1Illlll = false end end)
        IIIIl11lI111.InputChanged:Connect(function(i)
            if IllII1Illlll and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local I111llIl1Ill = math.clamp((i.Position.X - lII11l1l1lII.AbsolutePosition.X) / lII11l1l1lII.AbsoluteSize.X, 0, 1)
                local IIIlI1I1IIl1 = math.floor(IIIlI11l1IIl + (lI1IIlIIlIlI - IIIlI11l1IIl) * I111llIl1Ill)
                III1IllI1I1l.Size = UDim2.new(I111llIl1Ill, 0, 1, 0)
                lI111I1I1I1I.Text = title .. ": " .. IIIlI1I1IIl1
                if callback then callback(IIIlI1I1IIl1) end
            end
        end)
    end
    
    -- 100% Width Mobile Friendly Multi-Dropdown
    function lI11lllIIlI1:CreateMultiDropdown(title, list, defaultDict, callback)
        list = list or {}
        local lI1lII1IIl1I = defaultDict or {}
        
        local l1IIII1lllIl = Instance.new("TextButton")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 0, 45)
        l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG
        l1IIII1lllIl.Text = ""
        l1IIII1lllIl.AutoButtonColor = false
        l1IIII1lllIl.Parent = IlIl1111IIll
        
        local lI111I1I1I1I = createLabel(l1IIII1lllIl, title, Enum.TextXAlignment.Left, Enum.Font.Gotham, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(1, -40, 1, 0); lI111I1I1I1I.Position = UDim2.new(0, 15, 0, 0)
        
        local IllIllI1111I = createLabel(l1IIII1lllIl, "+", Enum.TextXAlignment.Right, Enum.Font.GothamBold, 16, IlI1lIlllIll.Accent)
        IllIllI1111I.Size = UDim2.new(0, 20, 1, 0); IllIllI1111I.Position = UDim2.new(1, -25, 0, 0)

        local IIl1I1IIlIII = Instance.new("Frame")
        IIl1I1IIlIII.BackgroundColor3 = IlI1lIlllIll.ElementBG
        IIl1I1IIlIII.BorderColor3 = IlI1lIlllIll.Accent
        IIl1I1IIlIII.BorderSizePixel = 1
        IIl1I1IIlIII.Visible = false
        IIl1I1IIlIII.ClipsDescendants = true
        IIl1I1IIlIII.ZIndex = 100
        IIl1I1IIlIII.Parent = ll1IIIlI11I1

        local Il11llII111l = Instance.new("ScrollingFrame")
        Il11llII111l.Size = UDim2.new(1, 0, 1, 0)
        Il11llII111l.BackgroundTransparency = 1
        Il11llII111l.ScrollBarThickness = 3
        Il11llII111l.ScrollBarImageColor3 = IlI1lIlllIll.Accent
        Il11llII111l.ZIndex = 101
        Il11llII111l.CanvasSize = UDim2.new(0, 0, 0, 0)
        Il11llII111l.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Il11llII111l.Parent = IIl1I1IIlIII
        
        local l1IllIlIl111 = Instance.new("UIListLayout")
        l1IllIlIl111.SortOrder = Enum.SortOrder.LayoutOrder
        l1IllIlIl111.Padding = UDim.new(0, 2)
        l1IllIlIl111.Parent = Il11llII111l

        local Il1IllllIIll = Instance.new("UIPadding"); Il1IllllIIll.PaddingLeft = UDim.new(0, 2); Il1IllllIIll.PaddingRight = UDim.new(0, 2); Il1IllllIIll.PaddingTop = UDim.new(0, 2); Il1IllllIIll.PaddingBottom = UDim.new(0, 2); Il1IllllIIll.Parent = Il11llII111l

        l1IIII1lllIl.Activated:Connect(function()
            local I11I1I1III1I = not IIl1I1IIlIII.Visible
            if IIIlll1II11l and IIIlll1II11l ~= IIl1I1IIlIII then IIIlll1II11l.Visible = false end
            
            IllIllI1111I.Text = I11I1I1III1I and "-" or "+"
            IIl1I1IIlIII.Visible = I11I1I1III1I
            IIIlll1II11l = I11I1I1III1I and IIl1I1IIlIII or nil

            if I11I1I1III1I then
                _G.ActiveDropdownButton = l1IIII1lllIl
                _G.ActiveDropdownContainer = IIl1I1IIlIII
                local IlIIIl1ll11l = 35; local lI1Il1lIIl11 = 4; local IIIIIlll1l1I = 150
                local Illl1lIIIIll = (#list * IlIIIl1ll11l) + ((#list - 1) * l1IllIlIl111.Padding.Offset) + lI1Il1lIIl11
                local l11l1Ill1IIl = math.min(Illl1lIIIIll, IIIIIlll1l1I)

                IIl1I1IIlIII.Size = UDim2.new(0, l1IIII1lllIl.AbsoluteSize.X, 0, l11l1Ill1IIl)
                local IIlll111II1l = l1IIII1lllIl.AbsolutePosition.X
                local Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y
                if (l1IIII1lllIl.AbsolutePosition.Y + l1IIII1lllIl.AbsoluteSize.Y + l11l1Ill1IIl) > ll1IIIlI11I1.AbsoluteSize.Y then
                    Il11llll111l = l1IIII1lllIl.AbsolutePosition.Y - l11l1Ill1IIl
                end
                IIl1I1IIlIII.Position = UDim2.new(0, IIlll111II1l, 0, Il11llll111l)
            else
                if _G.ActiveDropdownContainer == IIl1I1IIlIII then
                    _G.ActiveDropdownContainer = nil; _G.ActiveDropdownButton = nil
                end
            end
        end)
        
        IlIl1111IIll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            if IIl1I1IIlIII.Visible then 
                IIl1I1IIlIII.Visible = false; IIIlll1II11l = nil; IllIllI1111I.Text = "+" 
                if _G.ActiveDropdownContainer == IIl1I1IIlIII then _G.ActiveDropdownContainer = nil; _G.ActiveDropdownButton = nil end
            end
        end)
        
        local function updateLabel()
            local II1lIlIlIll1 = 0; for k, v in pairs(lI1lII1IIl1I) do if v then II1lIlIlIll1 = II1lIlIlIll1 + 1 end end; lI111I1I1I1I.Text = title .. " (" .. II1lIlIlIll1 .. ")"
        end
        
        for _, item in ipairs(list) do
            local l11lI1I1IlII = Instance.new("TextButton")
            l11lI1I1IlII.Size = UDim2.new(1, 0, 0, 35)
            l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementBG
            l11lI1I1IlII.Text = "  " .. item .. (lI1lII1IIl1I[item] and " [ON]" or ""); l11lI1I1IlII.TextColor3 = lI1lII1IIl1I[item] and IlI1lIlllIll.Accent or IlI1lIlllIll.Muted; l11lI1I1IlII.Font = Enum.Font.Gotham; l11lI1I1IlII.TextSize = 13; l11lI1I1IlII.TextXAlignment = Enum.TextXAlignment.Left; l11lI1I1IlII.ZIndex = 102; l11lI1I1IlII.BorderSizePixel = 0; l11lI1I1IlII.AutoButtonColor = false; l11lI1I1IlII.Parent = Il11llII111l
            l11lI1I1IlII.MouseEnter:Connect(function() l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementHover end)
            l11lI1I1IlII.MouseLeave:Connect(function() l11lI1I1IlII.BackgroundColor3 = IlI1lIlllIll.ElementBG end)
            
            l11lI1I1IlII.Activated:Connect(function()
                lI1lII1IIl1I[item] = not lI1lII1IIl1I[item]; l11lI1I1IlII.Text = "  " .. item .. (lI1lII1IIl1I[item] and " [ON]" or ""); l11lI1I1IlII.TextColor3 = lI1lII1IIl1I[item] and IlI1lIlllIll.Accent or IlI1lIlllIll.Muted; updateLabel(); if callback then callback(lI1lII1IIl1I) end
            end)
        end
        updateLabel()
    end

    function lI11lllIIlI1:CreateTextBox(title, placeholder, callback)
        local l1IIII1lllIl = Instance.new("Frame")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 0, 45)
        l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG
        l1IIII1lllIl.Parent = IlIl1111IIll
        local lI111I1I1I1I = createLabel(l1IIII1lllIl, title, Enum.TextXAlignment.Left, Enum.Font.Gotham, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(0.5, -15, 1, 0); lI111I1I1I1I.Position = UDim2.new(0, 15, 0, 0)
        local IlIl1llllll1 = Instance.new("TextBox")
        IlIl1llllll1.Size = UDim2.new(0.5, -15, 0.7, 0); IlIl1llllll1.Position = UDim2.new(0.5, 0, 0.15, 0)
        IlIl1llllll1.BackgroundColor3 = IlI1lIlllIll.TopBar; IlIl1llllll1.TextColor3 = IlI1lIlllIll.Text; IlIl1llllll1.PlaceholderText = placeholder
        IlIl1llllll1.Font = Enum.Font.Gotham; IlIl1llllll1.TextSize = 13; IlIl1llllll1.Parent = l1IIII1lllIl
        round(IlIl1llllll1, 4)
        IlIl1llllll1.FocusLost:Connect(function() if callback then callback(IlIl1llllll1.Text) end end)
        return IlIl1llllll1
    end

    function lI11lllIIlI1:CreateLabel(title, color)
        local l1IIII1lllIl = Instance.new("Frame")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 0, 30)
        l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG
        l1IIII1lllIl.BackgroundTransparency = 1
        l1IIII1lllIl.Parent = IlIl1111IIll
        local lI111I1I1I1I = createLabel(l1IIII1lllIl, title, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 13, color or IlI1lIlllIll.Accent)
        lI111I1I1I1I.Size = UDim2.new(1, 0, 1, 0)
        return lI111I1I1I1I
    end

    function lI11lllIIlI1:CreateButton(title, callback)
        local l1IIII1lllIl = Instance.new("TextButton")
        l1IIII1lllIl.Size = UDim2.new(1, 0, 0, 45)
        l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG
        l1IIII1lllIl.Text = ""
        l1IIII1lllIl.AutoButtonColor = false
        l1IIII1lllIl.Parent = IlIl1111IIll
        
        local lI111I1I1I1I = createLabel(l1IIII1lllIl, title, Enum.TextXAlignment.Center, Enum.Font.GothamBold, 13, IlI1lIlllIll.Text)
        lI111I1I1I1I.Size = UDim2.new(1, 0, 1, 0)
        
        l1IIII1lllIl.MouseEnter:Connect(function() l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementHover end)
        l1IIII1lllIl.MouseLeave:Connect(function() l1IIII1lllIl.BackgroundColor3 = IlI1lIlllIll.ElementBG end)
        
        l1IIII1lllIl.Activated:Connect(function()
            IlIIIl1lIl1l:Create(l1IIII1lllIl, TweenInfo.new(0.1), {BackgroundColor3 = IlI1lIlllIll.Accent}):Play()
            task.delay(0.1, function() IlIIIl1lIl1l:Create(l1IIII1lllIl, TweenInfo.new(0.1), {BackgroundColor3 = IlI1lIlllIll.ElementHover}):Play() end)
            if callback then callback() end
        end)
        return l1IIII1lllIl
    end

    return lI11lllIIlI1
end

-- =========================================================
-- START BUILDING YOUR UI HERE
-- =========================================================

local II111I1l1lII = {"AizenBoss", "AlucardBoss", "AnosBoss", "AtomicBoss", "BlessedMaidenBoss", "EscanorBoss", "GilgameshBoss", "GojoBoss", "IchigoBoss", "JinwooBoss", "MadokaBoss", "QinShiBoss", "RagnaBoss", "RimuruBoss", "SaberAlterBoss", "SaberBoss", "ShadowBoss", "ShadowMonarchBoss", "StrongestinHistoryBoss", "StrongestofTodayBoss", "StrongestShinobiBoss", "SukunaBoss", "TrueAizenBoss", "YamatoBoss", "YujiBoss"}

local I1II11lIllll = {
    ["Wood"] = "AutoLevel", ["Common Chest"] = "AutoLevel",
    ["Energy Core"] = "YujiBoss", ["Haki Color Reroll"] = "AllBosses", ["Iron"] = "AutoLevel", ["Rare Chest"] = "AutoLevel",
    ["Abyss Edge"] = "JinwooBoss", ["Awakened Cursed Finger"] = "StrongestinHistoryBoss", ["Black Frost"] = "RagnaBoss",
    ["Boss Ticket"] = "AllBosses", ["Broken Sword"] = "AutoLevel", ["Chrysalis Sigil"] = "AllBosses", ["Cursed Finger"] = "SukunaBoss", 
    ["Dark Grail"] = "AllBosses", ["Divine Grail"] = "AllBosses", ["Divine Fragment"] = "MadokaBoss", ["Dungeon Key"] = "AllBosses", ["Epic Chest"] = "AutoLevel", 
    ["Flash Impact"] = "YujiBoss", ["Fusion Ring"] = "TrueAizenBoss", ["Heart"] = "MadokaBoss", ["Illusion Prism"] = "AizenBoss",
    ["Limitless Key"] = "GojoBoss", ["Limitless Ring"] = "GojoBoss", ["Malevolent Key"] = "SukunaBoss", 
    ["Mirage Pen"] = "AizenBoss", ["Monarch Core"] = "ShadowMonarchBoss", ["Morgan Remnant"] = "SaberAlterBoss", ["Obsidian"] = "AutoLevel", 
    ["Race Reroll"] = "AllBosses", ["Reversal Pulse"] = "StrongestofTodayBoss", ["Sage Pulse"] = "RimuruBoss", 
    ["Slime Shard"] = "Slime", ["Soul Fragment"] = "IchigoBoss", ["Tempest Relic"] = "AllBosses", ["Throne Remnant"] = "GilgameshBoss", ["Tide Remnant"] = "BlessedMaidenBoss",
    ["Trait Reroll"] = "AllBosses", ["Umbral Capsule"] = "ShadowBoss", ["Vessel Ring"] = "StrongestinHistoryBoss",
    ["Void Fragment"] = "GojoBoss", ["Worthiness Fragment"] = "Hollow", ["Wyrm Brand"] = "RagnaBoss",
    ["Alter Essence"] = "SaberAlterBoss", ["Ancient Shard"] = "GilgameshBoss", ["Blue Singularity"] = "StrongestofTodayBoss", ["Calamity Seal"] = "AutoLevel", 
    ["Clan Reroll"] = "AutoLevel", ["Cursed Talisman"] = "Curse", ["Dark Ring"] = "JinwooBoss", 
    ["Dismantle Fang"] = "SukunaBoss", ["Divergent Pulse"] = "YujiBoss", ["Divinity Essence"] = "TrueAizenBoss", ["Energy Shard"] = "StrongSorcerer", ["Gale Essence"] = "BlessedMaidenBoss", 
    ["Golden Essence"] = "GilgameshBoss", ["Infinity Core"] = "GojoBoss", ["Jade Tablet"] = "QinShiBoss", 
    ["Legendary Chest"] = "AutoLevel", ["Malevolent Soul"] = "StrongestinHistoryBoss", ["Monarch Essence"] = "ShadowMonarchBoss", 
    ["Mythril"] = "AutoLevel", ["Radiant Core"] = "MadokaBoss", ["Reiatsu Core"] = "AizenBoss", 
    ["Sacred Bow"] = "MadokaBoss", ["Shadow Essence"] = "ShadowMonarchBoss", ["Silver Requiem"] = "RagnaBoss", 
    ["Six Eye"] = "StrongestofTodayBoss", ["Slime Remnant"] = "RimuruBoss", ["Soul Amulet"] = "AlucardBoss", 
    ["Spiritual Core"] = "IchigoBoss", ["Tempest Seal"] = "RimuruBoss", ["Void Seed"] = "ShadowBoss",
    ["Adamantite"] = "Hollow", ["Aero Core"] = "BlessedMaidenBoss", ["Alter Armor"] = "SaberAlterBoss", ["Atomic Core"] = "ShadowBoss", ["Blood Ring"] = "AlucardBoss", 
    ["Casull"] = "AlucardBoss", ["Celestial Mark"] = "BlessedMaidenBoss", ["Conqueror Fragment"] = "AutoLevel", ["Corrupt Crown"] = "SaberAlterBoss", ["Corruption Core"] = "SaberAlterBoss", ["Crimson Heart"] = "SukunaBoss", 
    ["Cursed Flesh"] = "StrongestinHistoryBoss", ["Evolution Fragment"] = "TrueAizenBoss", ["Gilgamesh Armor"] = "GilgameshBoss", ["Hogyoku Fragment"] = "AizenBoss", ["Imperial Seal"] = "QinShiBoss", 
    ["Infinity Essence"] = "StrongestofTodayBoss", ["Kamish Dagger"] = "ShadowMonarchBoss", ["Maiden Outfit"] = "BlessedMaidenBoss", ["Manipulator Outfit"] = "TrueAizenBoss", ["Mythical Chest"] = "AutoLevel", 
    ["Phantasm Core"] = "GilgameshBoss", ["Pink Gem"] = "MadokaBoss", ["Shadow Crystal"] = "ShadowMonarchBoss", 
    ["Shadow Heart"] = "JinwooBoss", ["Slime Core"] = "RimuruBoss", ["Soul Flame"] = "IchigoBoss", ["Transcendent Core"] = "TrueAizenBoss",
    ["Aura Crate"] = {"StrongestShinobiBoss", "YamatoBoss", "MadokaBoss", "AizenBoss", "AlucardBoss", "ArenaFighter", "Ninja", "Quincy"},
    ["Cosmetic Crate"] = {"StrongestShinobiBoss", "YamatoBoss", "MadokaBoss", "AizenBoss", "AlucardBoss", "ArenaFighter", "Ninja", "Quincy"},
    ["Secret Chest"] = "AutoLevel"
}

local llllIIlIIlI1 = {
    ["Collector"] = { type = "ItemDrops", amount = 200 }, ["Hoarder"] = { type = "ItemDrops", amount = 1000 }, ["Treasure Hunter"] = { type = "ItemDrops", amount = 3000 }, ["Golden Tyrant"] = { type = "ItemDrops", amount = 10000 },
    ["Lucky Novice"] = { type = "BossKills", amount = 10 }, ["Fortune Seeker"] = { type = "BossKills", amount = 25 }, ["Lucky Star"] = { type = "BossKills", amount = 75 }, ["Blessed One"] = { type = "BossKills", amount = 250 }, ["The Chosen One"] = { type = "BossKills", amount = 500 }, ["Blessed Sovereign"] = { type = "BossKills", amount = 1250 }, ["Destiny Marked"] = { type = "BossKills", amount = 2500 }, ["Celestial Favor"] = { type = "BossKills", amount = 5000 },
    ["Blade Master"] = { type = "Boss", name = "SaberBoss" }, ["Honored One"] = { type = "Boss", name = "GojoBoss" }, ["Curse King"] = { type = "Boss", name = "SukunaBoss" }, ["Shadow Monarch"] = { type = "Boss", name = "JinwooBoss" }, ["Manipulator"] = { type = "Boss", name = "AizenBoss" }, ["King of Beginning"] = { type = "Boss", name = "QinShiBoss" }, ["Living Weapon"] = { type = "Boss", name = "YujiBoss" }, ["Eminence in Shadow"] = { type = "Boss", name = "ShadowBoss" }, ["Vampire King"] = { type = "Boss", name = "AlucardBoss" }, ["Soul Reaper"] = { type = "Boss", name = "IchigoBoss" }, ["Strongest Sorcerer"] = { type = "Boss", name = "StrongestofTodayBoss" }, ["Disgraced One"] = { type = "Boss", name = "StrongestinHistoryBoss" }, ["Demon Lord"] = { type = "Boss", name = "RimuruBoss" }, ["Golden King"] = { type = "Boss", name = "GilgameshBoss" }, ["Demon King"] = { type = "Boss", name = "ShadowMonarchBoss" }, ["King of Shadows"] = { type = "Boss", name = "ShadowMonarchBoss" },
    ["The One"] = { type = "Boss", name = "EscanorBoss" }, ["Blade Sovereign"] = { type = "Boss", name = "YamatoBoss" }, ["Astral Empress"] = { type = "Boss", name = "BlessedMaidenBoss" }, ["Transcendent Being"] = { type = "Boss", name = "TrueAizenBoss" }, ["Corrupt Tyrant"] = { type = "Boss", name = "SaberAlterBoss" }, ["Battlefield Warlord"] = { type = "Boss", name = "StrongestShinobiBoss" }, ["Eminence Incarnate"] = { type = "Boss", name = "AtomicBoss" },
    ["Void Empress"] = { type = "Dungeon", name = "InfiniteTower" }
}

local lIlIl111lI1l = {
    ["SaberBoss"] = { ["Boss Key"] = 1 }, ["QinShiBoss"] = { ["Boss Key"] = 3 }, ["IchigoBoss"] = { ["Boss Key"] = 5 }, ["GilgameshBoss"] = { ["Divine Grail"] = 1 }, ["RimuruBoss"] = { ["Slime Key"] = 1 }, ["AnosBoss"] = { ["Calamity Seal"] = 1 }, ["StrongestofTodayBoss"] = { ["Limitless Key"] = 1 }, ["StrongestinHistoryBoss"] = { ["Malevolent Key"] = 1 }, ["BlessedMaidenBoss"] = { ["Tempest Relic"] = 1 }, ["TrueAizenBoss"] = { ["Chrysalis Sigil"] = 1 }, ["SaberAlterBoss"] = { ["Dark Grail"] = 1 }, ["AtomicBoss"] = { ["Atomic Omen"] = 1}
}


local function saveConfig(name, lIIIIII11IlI)
    if writefile then
        if not isfolder("JomHUB_Configs") then pcall(makefolder, "JomHUB_Configs") end
        if lIIIIII11IlI then
            local l1IllI1IIllI, IlII11Ill1ll = pcall(function() return ll1llIl1IIll:JSONEncode(l11ll11II1l1) end)
            if l1IllI1IIllI then pcall(writefile, "JomHUB_Configs/"..name..".json", IlII11Ill1ll) end
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", name)
        else
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", "")
        end
    end
end

local I11IIl11l111 = IlIlIII1IIll:CreateTab("Main")
I11IIl11l111:CreateSection("General Settings")
I11IIl11l111:CreateDropdown("Farm Position", {"Above", "Behind"}, l11ll11II1l1.farmPos, function(IIIlI1I1IIl1) l11ll11II1l1.farmPos = IIIlI1I1IIl1 end)
I11IIl11l111:CreateSlider("Distance", 0, 10, l11ll11II1l1.farmDistance, function(IIIlI1I1IIl1) l11ll11II1l1.farmDistance = IIIlI1I1IIl1 end)
local l1l1ll1I11Il = {"Thief", "ThiefBoss", "Monkey", "MonkeyBoss", "DesertBandit", "DesertBoss", "FrostRogue", "SnowBoss", "Sorcerer", "PandaMiniBoss", "Hollow", "StrongSorcerer", "Curse", "Slime", "AcademyTeacher", "Swordsman", "Quincy", "Ninja", "ArenaFighter"}
I11IIl11l111:CreateDropdown("Select Mob", l1l1ll1I11Il, l11ll11II1l1.selectedMob, function(IIIlI1I1IIl1) l11ll11II1l1.selectedMob = IIIlI1I1IIl1 end)
I11IIl11l111:CreateToggle("Enable Auto Farm Mob", l11ll11II1l1.AutoFarmActive, function(IIIlI1I1IIl1) l11ll11II1l1.AutoFarmActive = IIIlI1I1IIl1; saveConfig("AutoFarmMob", IIIlI1I1IIl1) end)

I11IIl11l111:CreateSection("Weapons Setup")
I11IIl11l111:CreateToggle("Auto Equip Melee", l11ll11II1l1.autoMelee, function(IIIlI1I1IIl1) l11ll11II1l1.autoMelee = IIIlI1I1IIl1 end)
I11IIl11l111:CreateToggle("Auto Equip Sword", l11ll11II1l1.autoSword, function(IIIlI1I1IIl1) l11ll11II1l1.autoSword = IIIlI1I1IIl1 end)
I11IIl11l111:CreateToggle("Auto Equip Fruit", l11ll11II1l1.autoFruit, function(IIIlI1I1IIl1) l11ll11II1l1.autoFruit = IIIlI1I1IIl1 end)

local I1lI1II1Illl = IlIlIII1IIll:CreateTab("COMBO")
I1lI1II1Illl:CreateSection("Melee Skills")
I1lI1II1Illl:CreateMultiDropdown("Auto Melee Skills", {"Skill Z", "Skill X", "Skill C", "Skill V", "Skill F"}, l11ll11II1l1.autoMeleeSkills, function(IIIlI1I1IIl1) l11ll11II1l1.autoMeleeSkills = IIIlI1I1IIl1 end)
I1lI1II1Illl:CreateSection("Sword Skills")
I1lI1II1Illl:CreateMultiDropdown("Auto Sword Skills", {"Skill Z", "Skill X", "Skill C", "Skill V", "Skill F"}, l11ll11II1l1.autoSwordSkills, function(IIIlI1I1IIl1) l11ll11II1l1.autoSwordSkills = IIIlI1I1IIl1 end)
I1lI1II1Illl:CreateSection("Fruit Skills")
I1lI1II1Illl:CreateMultiDropdown("Auto Fruit Skills", {"Skill Z", "Skill X", "Skill C", "Skill V", "Skill F"}, l11ll11II1l1.autoFruitSkills, function(IIIlI1I1IIl1) l11ll11II1l1.autoFruitSkills = IIIlI1I1IIl1 end)

local Il111Ill11I1 = IlIlIII1IIll:CreateTab("FARM")
Il111Ill11I1:CreateSection("Auto Level")
Il111Ill11I1:CreateToggle("Enable Auto Level", l11ll11II1l1.AutoLevelActive, function(IIIlI1I1IIl1) l11ll11II1l1.AutoLevelActive = IIIlI1I1IIl1; saveConfig("AutoLevel", IIIlI1I1IIl1) end)
Il111Ill11I1:CreateSection("Auto Farm Title")
local l1IIlllIlIll = {"Collector", "Hoarder", "Treasure Hunter", "Golden Tyrant", "Lucky Novice", "Fortune Seeker", "Lucky Star", "Blessed One", "The Chosen One", "Blessed Sovereign", "Destiny Marked", "Celestial Favor", "Blade Master", "Honored One", "Curse King", "Shadow Monarch", "Manipulator", "King of Beginning", "Living Weapon", "Eminence in Shadow", "Vampire King", "Soul Reaper", "Strongest Sorcerer", "Disgraced One", "Demon Lord", "Golden King", "Demon King", "King of Shadows", "The One", "Blade Sovereign", "Astral Empress", "Transcendent Being", "Corrupt Tyrant", "Battlefield Warlord", "Eminence Incarnate", "Void Empress"}
Il111Ill11I1:CreateDropdown("Select Title", l1IIlllIlIll, l11ll11II1l1.selectedTitle, function(IIIlI1I1IIl1) l11ll11II1l1.selectedTitle = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateToggle("Auto Farm Title", l11ll11II1l1.autoFarmTitle, function(IIIlI1I1IIl1) l11ll11II1l1.autoFarmTitle = IIIlI1I1IIl1; saveConfig("AutoFarmTitle", IIIlI1I1IIl1) end)
Il111Ill11I1:CreateToggle("Hop If No Boss", l11ll11II1l1.hopForTitle, function(IIIlI1I1IIl1) l11ll11II1l1.hopForTitle = IIIlI1I1IIl1; saveConfig("AutoFarmTitle", l11ll11II1l1.autoFarmTitle) end)

Il111Ill11I1:CreateSection("Auto Farm Items")
Il111Ill11I1:CreateMultiDropdown("Common", {"Wood", "Common Chest"}, l11ll11II1l1.farmCommon, function(IIIlI1I1IIl1) l11ll11II1l1.farmCommon = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateMultiDropdown("Rare", {"Energy Core", "Iron", "Rare Chest", "Haki Color Reroll"}, l11ll11II1l1.farmRare, function(IIIlI1I1IIl1) l11ll11II1l1.farmRare = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateMultiDropdown("Epic", {"Abyss Edge", "Awakened Cursed Finger", "Black Frost", "Boss Key", "Boss Ticket", "Broken Sword", "Cursed Finger", "Divine Fragment", "Dungeon Key", "Dungeon Token", "Epic Chest", "Flash Impact", "Heart", "Illusion Prism", "Limitless Key", "Limitless Ring", "Malevolent Key", "Mirage Pen", "Monarch Core", "Obsidian", "Race Reroll", "Reversal Pulse", "Sage Pulse", "Slime Shard", "Soul Fragment", "Throne Remnant", "Trait Reroll", "Umbral Capsule", "Vessel Ring", "Void Fragment", "Worthiness Fragment", "Wyrm Brand"}, l11ll11II1l1.farmEpic, function(IIIlI1I1IIl1) l11ll11II1l1.farmEpic = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateMultiDropdown("Legendary", {"Ancient Shard", "Blue Singularity", "Calamity Seal", "Clan Reroll", "Cursed Talisman", "Dark Ring", "Dismantle Fang", "Divergent Pulse", "Energy Shard", "Golden Essence", "Infinity Core", "Jade Tablet", "Legendary Chest", "Malevolent Soul", "Monarch Essence", "Mythril", "Radiant Core", "Reiatsu Core", "Sacred Bow", "Shadow Essence", "Silver Requiem", "Six Eye", "Slime Remnant", "Soul Amulet", "Spiritual Core", "Tempest Seal", "Void Seed"}, l11ll11II1l1.farmLegendary, function(IIIlI1I1IIl1) l11ll11II1l1.farmLegendary = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateMultiDropdown("Mythical", {"Adamantite", "Atomic Core", "Blood Ring", "Casull", "Conqueror Fragment", "Crimson Heart", "Cursed Flesh", "Imperial Seal", "Infinity Essence", "Kamish Dagger", "Mythical Chest", "Phantasm Core", "Pink Gem", "Shadow Crystal", "Shadow Heart", "Slime Core", "Soul Flame"}, l11ll11II1l1.farmMythical, function(IIIlI1I1IIl1) l11ll11II1l1.farmMythical = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateMultiDropdown("Secret", {"Aura Crate", "Cosmetic Crate", "Secret Chest"}, l11ll11II1l1.farmSecret, function(IIIlI1I1IIl1) l11ll11II1l1.farmSecret = IIIlI1I1IIl1 end)
Il111Ill11I1:CreateToggle("Auto Farm Items", l11ll11II1l1.autoFarmItems, function(IIIlI1I1IIl1) l11ll11II1l1.autoFarmItems = IIIlI1I1IIl1; saveConfig("AutoFarmItems", IIIlI1I1IIl1) end)
Il111Ill11I1:CreateSlider("Switch Time (Sec)", 10, 600, l11ll11II1l1.itemFarmDuration, function(IIIlI1I1IIl1) l11ll11II1l1.itemFarmDuration = IIIlI1I1IIl1 end)

local I111l1lIlIlI = IlIlIII1IIll:CreateTab("BOSS")
I111l1lIlIlI:CreateSection("Boss Hunt")

I111l1lIlIlI:CreateDropdown("Select Boss", II111I1l1lII, "None", function(IIIlI1I1IIl1)
    l11ll11II1l1.selectedBoss = IIIlI1I1IIl1
    print("Selected Boss:", IIIlI1I1IIl1)
end)

I111l1lIlIlI:CreateToggle("Auto Kill Boss", l11ll11II1l1.AutoBossActive, function(IIIlI1I1IIl1)
    l11ll11II1l1.AutoBossActive = IIIlI1I1IIl1
    print("Auto Boss set to:", IIIlI1I1IIl1)
    saveConfig("AutoBoss", IIIlI1I1IIl1)
end)
I111l1lIlIlI:CreateToggle("Auto Kill All Bosses", l11ll11II1l1.AutoAllBossActive, function(IIIlI1I1IIl1)
    l11ll11II1l1.AutoAllBossActive = IIIlI1I1IIl1
    print("Auto All Bosses set to:", IIIlI1I1IIl1)
    saveConfig("AutoAllBosses", IIIlI1I1IIl1)
end)
I111l1lIlIlI:CreateToggle("Auto Hop (All Bosses)", l11ll11II1l1.autoHopAllBosses, function(IIIlI1I1IIl1)
    l11ll11II1l1.autoHopAllBosses = IIIlI1I1IIl1
    saveConfig("AutoHopAllBosses", IIIlI1I1IIl1)
end)

I111l1lIlIlI:CreateSection("Auto Pity System")
local l11l1l11I1Il = {"AtomicBoss", "TrueAizenBoss", "AnosBoss", "RimuruBoss", "StrongestofTodayBoss", "StrongestinHistoryBoss", "SaberBoss", "QinShiBoss", "IchigoBoss", "GilgameshBoss", "BlessedMaidenBoss", "SaberAlterBoss"}
I111l1lIlIlI:CreateMultiDropdown("1. Target Boss:", l11l1l11I1Il, l11ll11II1l1.pityBuilderBosses, function(IIIlI1I1IIl1) l11ll11II1l1.pityBuilderBosses = IIIlI1I1IIl1 end)
I111l1lIlIlI:CreateDropdown("2. Pity Target", II111I1l1lII, l11ll11II1l1.pitySummonBoss, function(IIIlI1I1IIl1) l11ll11II1l1.pitySummonBoss = IIIlI1I1IIl1 end)
I111l1lIlIlI:CreateDropdown("3. Difficulty", {"Normal", "Medium", "Hard", "Extreme"}, l11ll11II1l1.pitySummonDiff, function(IIIlI1I1IIl1) l11ll11II1l1.pitySummonDiff = IIIlI1I1IIl1 end)
I111IIIll1l1 = I111l1lIlIlI:CreateLabel("Current Pity: " .. (_G.JomHub_BossPity or 0) .. "/25", IlI1lIlllIll.Accent)
I111l1lIlIlI:CreateToggle("Start Auto Pity", l11ll11II1l1.autoSummonPity, function(IIIlI1I1IIl1) 
    l11ll11II1l1.autoSummonPity = IIIlI1I1IIl1 
    saveConfig("AutoPity", IIIlI1I1IIl1)
    if not IIIlI1I1IIl1 and not l11ll11II1l1.autoHopPity then updatePity(0) end
end)
I111l1lIlIlI:CreateToggle("START FULLY AUTOMATED PITY (HOP)", l11ll11II1l1.autoHopPity, function(IIIlI1I1IIl1) 
    l11ll11II1l1.autoHopPity = IIIlI1I1IIl1 
    saveConfig("AutoHopPity", IIIlI1I1IIl1)
    if not IIIlI1I1IIl1 and not l11ll11II1l1.autoSummonPity then updatePity(0) end
end)

local l1I11ll1111l = IlIlIII1IIll:CreateTab("DUNGEON")
l1I11ll1111l:CreateSection("Dungeon Settings")
l1I11ll1111l:CreateDropdown("Dungeon Type", {"CidDungeon", "RuneDungeon", "DoubleDungeon", "BossRush"}, l11ll11II1l1.dungeonType, function(IIIlI1I1IIl1) l11ll11II1l1.dungeonType = IIIlI1I1IIl1 end)
l1I11ll1111l:CreateDropdown("Difficulty", {"Easy", "Medium", "Hard", "Extreme"}, l11ll11II1l1.dungeonDiff, function(IIIlI1I1IIl1) l11ll11II1l1.dungeonDiff = IIIlI1I1IIl1 end)
l1I11ll1111l:CreateDropdown("Dungeon Pos", {"Above", "Behind"}, l11ll11II1l1.dungeonPos, function(IIIlI1I1IIl1) l11ll11II1l1.dungeonPos = IIIlI1I1IIl1 end)
l1I11ll1111l:CreateToggle("Auto Dungeon", l11ll11II1l1.autoDungeon, function(IIIlI1I1IIl1) 
    l11ll11II1l1.autoDungeon = IIIlI1I1IIl1 
    if writefile then
        if not isfolder("JomHUB_Configs") then pcall(makefolder, "JomHUB_Configs") end
        if IIIlI1I1IIl1 then
            local I111llI1l1ll = {
                autoDungeon = true,
                dungeonType = l11ll11II1l1.dungeonType,
                dungeonDiff = l11ll11II1l1.dungeonDiff,
                dungeonPos = l11ll11II1l1.dungeonPos,
                autoMelee = l11ll11II1l1.autoMelee,
                autoSword = l11ll11II1l1.autoSword,
                autoFruit = l11ll11II1l1.autoFruit,
                autoSkills = l11ll11II1l1.autoSkills,
                autoMeleeSkills = l11ll11II1l1.autoMeleeSkills,
                autoSwordSkills = l11ll11II1l1.autoSwordSkills,
                autoFruitSkills = l11ll11II1l1.autoFruitSkills,
                farmDistance = l11ll11II1l1.farmDistance
            }
            local l1IllI1IIllI, Illll1l1ll1I = pcall(function() return ll1llIl1IIll:JSONEncode(I111llI1l1ll) end)
            if l1IllI1IIllI then pcall(writefile, "JomHUB_Configs/SailorPieceMobile_Dungeon.json", Illll1l1ll1I) end
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", "SailorPieceMobile_Dungeon")
        else
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", "")
        end
    end
end)

l1I11ll1111l:CreateSection("Infinite Tower")
l1I11ll1111l:CreateDropdown("Tower Pos", {"Above", "Behind"}, l11ll11II1l1.infiniteTowerPos, function(IIIlI1I1IIl1) l11ll11II1l1.infiniteTowerPos = IIIlI1I1IIl1 end)
l1I11ll1111l:CreateToggle("Auto Infinite Tower", l11ll11II1l1.autoInfiniteTower, function(IIIlI1I1IIl1) 
    l11ll11II1l1.autoInfiniteTower = IIIlI1I1IIl1 
    if writefile then
        if not isfolder("JomHUB_Configs") then pcall(makefolder, "JomHUB_Configs") end
        if IIIlI1I1IIl1 then
            local IIll1lI1ll1I = {
                autoInfiniteTower = true,
                infiniteTowerPos = l11ll11II1l1.infiniteTowerPos,
                autoMelee = l11ll11II1l1.autoMelee,
                autoSword = l11ll11II1l1.autoSword,
                autoFruit = l11ll11II1l1.autoFruit,
                autoSkills = l11ll11II1l1.autoSkills,
                autoMeleeSkills = l11ll11II1l1.autoMeleeSkills,
                autoSwordSkills = l11ll11II1l1.autoSwordSkills,
                autoFruitSkills = l11ll11II1l1.autoFruitSkills,
                farmDistance = l11ll11II1l1.farmDistance
            }
            local l1IllI1IIllI, Illll1l1ll1I = pcall(function() return ll1llIl1IIll:JSONEncode(IIll1lI1ll1I) end)
            if l1IllI1IIllI then pcall(writefile, "JomHUB_Configs/SailorPieceMobile_InfiniteTower.json", Illll1l1ll1I) end
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", "SailorPieceMobile_InfiniteTower")
        else
            pcall(writefile, "JomHUB_Configs/JomHubMobile_autoload.txt", "")
        end
    end
end)

local II1lI1IllI1l = IlIlIII1IIll:CreateTab("AFK")
II1lI1IllI1l:CreateSection("Multi-Island AFK Farm")

local IlII1llIlI1I = {}
for name, _ in pairs(llI1IIlIIIII) do
    table.insert(IlII1llIlI1I, name)
end
table.sort(IlII1llIlI1I)

II1lI1IllI1l:CreateMultiDropdown("Select Islands", IlII1llIlI1I, l11ll11II1l1.afkIslands, function(IIIlI1I1IIl1) l11ll11II1l1.afkIslands = IIIlI1I1IIl1 end)
II1lI1IllI1l:CreateToggle("Start AFK Farm", l11ll11II1l1.afkModeActive, function(IIIlI1I1IIl1) 
    l11ll11II1l1.afkModeActive = IIIlI1I1IIl1
    saveConfig("AFKMode", IIIlI1I1IIl1) 
end)

local IIIIl11I1lll = IlIlIII1IIll:CreateTab("MISC")
IIIIl11I1lll:CreateSection("Auto Summon")
local IllIlIIIlII1 = {
    "SaberBoss", "QinShiBoss", "IchigoBoss", "GilgameshBoss", "GojoBoss",
    "BlessedMaidenBoss", "SaberAlterBoss", "AtomicBoss", "TrueAizenBoss",
    "AnosBoss", "RimuruBoss", "StrongestofTodayBoss", "StrongestinHistoryBoss"
}
IIIIl11I1lll:CreateMultiDropdown("Summon Targets", IllIlIIIlII1, l11ll11II1l1.summonTargets, function(IIIlI1I1IIl1) l11ll11II1l1.summonTargets = IIIlI1I1IIl1 end)
IIIIl11I1lll:CreateDropdown("Difficulty", {"Normal", "Medium", "Hard", "Extreme"}, l11ll11II1l1.summonDiff, function(IIIlI1I1IIl1) l11ll11II1l1.summonDiff = IIIlI1I1IIl1 end)
IIIIl11I1lll:CreateToggle("Auto Summon Boss", l11ll11II1l1.autoSummon, function(IIIlI1I1IIl1) 
    l11ll11II1l1.autoSummon = IIIlI1I1IIl1 
    saveConfig("AutoSummon", IIIlI1I1IIl1)
end)

IIIIl11I1lll:CreateSection("Config Management")
IIIIl11I1lll:CreateButton("Clear / Delete Config", function()
    local lllll1ll1l1I = false
    if delfolder then
        local l1IllI1IIllI = pcall(function() delfolder("JomHUB_Configs") end)
        if l1IllI1IIllI then lllll1ll1l1I = true end
    end
    if not lllll1ll1l1I and delfile and listfiles then
        pcall(function()
            for _, file in ipairs(listfiles("JomHUB_Configs")) do
                pcall(delfile, file)
            end
        end)
    end
    
    -- Failsafe to instantly stop auto-loading if delete fails
    if writefile then
        pcall(function()
            if not isfolder("JomHUB_Configs") then makefolder("JomHUB_Configs") end
            writefile("JomHUB_Configs/JomHubMobile_autoload.txt", "")
            writefile("JomHUB_Configs/SailorPieceMobile_autoload.txt", "")
            writefile("JomHUB_Configs/SailorPiece_autoload.txt", "")
        end)
    end
end)

local ll1lIIl111I1 = IlIlIII1IIll:CreateTab("SETTING")
ll1lIIl111I1:CreateSection("Performance Optimization")
ll1lIIl111I1:CreateButton("Extreme FPS Boost (Map)", function()
    local IIIII1ll1l1I = game:GetService("Lighting")
    IIIII1ll1l1I.GlobalShadows = false
    IIIII1ll1l1I.FogEnd = 9e9
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
end)
ll1lIIl111I1:CreateButton("Disable Shadows", function()
    game:GetService("Lighting").GlobalShadows = false
end)
ll1lIIl111I1:CreateButton("Full Bright Mode", function()
    game:GetService("Lighting").Brightness = 2
    game:GetService("Lighting").ClockTime = 14
    game:GetService("Lighting").FogEnd = 100000
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

-- =========================================================
-- LOADING SCREEN SEQUENCE
-- =========================================================
local lllI1I11lI1l = Instance.new("Frame")
lllI1I11lI1l.Size = UDim2.new(0, 250, 0, 100)
lllI1I11lI1l.Position = UDim2.new(0.5, 0, 0.5, 0)
lllI1I11lI1l.AnchorPoint = Vector2.new(0.5, 0.5)
lllI1I11lI1l.BackgroundColor3 = IlI1lIlllIll.BG
lllI1I11lI1l.BorderSizePixel = 0
lllI1I11lI1l.ZIndex = 200
lllI1I11lI1l.Parent = ll1IIIlI11I1
round(lllI1I11lI1l, 8)

local II11llllI1ll = createLabel(lllI1I11lI1l, "JOMHUB", Enum.TextXAlignment.Center, Enum.Font.GothamBold, 24, IlI1lIlllIll.Accent)
II11llllI1ll.Size = UDim2.new(1, 0, 0, 30); II11llllI1ll.Position = UDim2.new(0, 0, 0, 15); II11llllI1ll.ZIndex = 201

local I11l1l1IIl1I = createLabel(lllI1I11lI1l, "Initializing...", Enum.TextXAlignment.Center, Enum.Font.Gotham, 12, IlI1lIlllIll.Text)
I11l1l1IIl1I.Size = UDim2.new(1, 0, 0, 20); I11l1l1IIl1I.Position = UDim2.new(0, 0, 0, 45); I11l1l1IIl1I.ZIndex = 201

local IIlIlI11I1l1 = Instance.new("Frame")
IIlIlI11I1l1.Size = UDim2.new(0.8, 0, 0, 6); IIlIlI11I1l1.Position = UDim2.new(0.1, 0, 0, 75); IIlIlI11I1l1.BackgroundColor3 = IlI1lIlllIll.TopBar; IIlIlI11I1l1.BorderSizePixel = 0; IIlIlI11I1l1.ZIndex = 201; IIlIlI11I1l1.Parent = lllI1I11lI1l; round(IIlIlI11I1l1, 3)

local II111lIllIlI = Instance.new("Frame")
II111lIllIlI.Size = UDim2.new(0, 0, 1, 0); II111lIllIlI.BackgroundColor3 = IlI1lIlllIll.Accent; II111lIllIlI.BorderSizePixel = 0; II111lIllIlI.ZIndex = 202; II111lIllIlI.Parent = IIlIlI11I1l1; round(II111lIllIlI, 3)

task.spawn(function()
    local I11lIlIlll1l = {
        {t = "Hooking Game Engine...", p = 0.3, d = 0.6},
        {t = "LOADING ASSETS...", p = 0.6, d = 0.7},
        {t = "Bypassing Anti-Cheat...", p = 0.85, d = 0.6},
        {t = "Initializing UI...", p = 1, d = 0.5}
    }
    for _, l1IllI1IIllI in ipairs(I11lIlIlll1l) do
        if I11l1l1IIl1I then I11l1l1IIl1I.Text = l1IllI1IIllI.t end
        if II111lIllIlI then IlIIIl1lIl1l:Create(II111lIllIlI, TweenInfo.new(l1IllI1IIllI.d), {Size = UDim2.new(l1IllI1IIllI.p, 0, 1, 0)}):Play() end
        task.wait(l1IllI1IIllI.d)
    end
    if I11l1l1IIl1I then I11l1l1IIl1I.Text = "Completed!" end
    task.wait(0.3)
    if lllI1I11lI1l then
        IlIIIl1lIl1l:Create(lllI1I11lI1l, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        IlIIIl1lIl1l:Create(II11llllI1ll, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        IlIIIl1lIl1l:Create(I11l1l1IIl1I, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        IlIIIl1lIl1l:Create(IIlIlI11I1l1, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        IlIIIl1lIl1l:Create(II111lIllIlI, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        lllI1I11lI1l:Destroy()
    end
    if ll1l1l1IIl1l then ll1l1l1IIl1l.Visible = true end
end)

-- =========================================================
-- GAME LOGIC & LOOPS (MOBILE ADAPTED)
-- =========================================================
local IllI11IIlII1 = {
    { Level = 1, Quest = "QuestNPC1", Mob = "Thief", Portal = "Starter" },
    { Level = 100, Quest = "QuestNPC2", Mob = "ThiefBoss", Portal = "Starter" },
    { Level = 250, Quest = "QuestNPC3", Mob = "Monkey", Portal = "Jungle" },
    { Level = 500, Quest = "QuestNPC4", Mob = "MonkeyBoss", Portal = "Jungle" },
    { Level = 750, Quest = "QuestNPC5", Mob = "DesertBandit", Portal = "Desert" },
    { Level = 1000, Quest = "QuestNPC6", Mob = "DesertBoss", Portal = "Desert" },
    { Level = 1500, Quest = "QuestNPC7", Mob = "FrostRogue", Portal = "Snow" },
    { Level = 2000, Quest = "QuestNPC8", Mob = "SnowBoss", Portal = "Snow" },
    { Level = 3000, Quest = "QuestNPC9", Mob = "Sorcerer", Portal = "Shibuya" },
    { Level = 4000, Quest = "QuestNPC10", Mob = "PandaMiniBoss", Portal = "Shibuya" },
    { Level = 5000, Quest = "QuestNPC11", Mob = "Hollow", Portal = "HollowIsland" },
    { Level = 6250, Quest = "QuestNPC12", Mob = "StrongSorcerer", Portal = "Shinjuku" },
    { Level = 7000, Quest = "QuestNPC13", Mob = "Curse", Portal = "Shinjuku" },
    { Level = 8000, Quest = "QuestNPC14", Mob = "Slime", Portal = "Slime" },
    { Level = 9000, Quest = "QuestNPC15", Mob = "AcademyTeacher", Portal = "Academy" },
    { Level = 10000, Quest = "QuestNPC16", Mob = "Swordsman", Portal = "Judgement" },
    { Level = 10750, Quest = "QuestNPC17", Mob = "Quincy", Portal = "SoulDominion" },
    { Level = 11500, Quest = "QuestNPC18", Mob = "Ninja", Portal = "Ninja" },
    { Level = 12000, Quest = "QuestNPC19", Mob = "ArenaFighter", Portal = "Lawless" }
}

local function parseLevel(IIIlI1I1IIl1)
    if type(IIIlI1I1IIl1) == "number" then return IIIlI1I1IIl1 end
    if type(IIIlI1I1IIl1) == "string" then
        local I11lIlI11II1 = string.match(IIIlI1I1IIl1, "%d+")
        if I11lIlI11II1 then return tonumber(I11lIlI11II1) end
    end
    return 1
end

local function getCurrentLevel()
    local Illll1l1ll1I = Il1111lIl1I1:FindFirstChild("Data")
    if Illll1l1ll1I and Illll1l1ll1I:FindFirstChild("Level") then return parseLevel(Illll1l1ll1I.Level.Value) end
    local I1lIll1l1IlI = Il1111lIl1I1:FindFirstChild("leaderstats")
    if I1lIll1l1IlI and I1lIll1l1IlI:FindFirstChild("Level") then return parseLevel(I1lIll1l1IlI.Level.Value) end
    if Il1111lIl1I1:GetAttribute("Level") then return parseLevel(Il1111lIl1I1:GetAttribute("Level")) end
    return 1
end

local IIIll1IIIIlI = {
    thief = "Starter", thiefboss = "Starter",
    monkey = "Jungle", monkeyboss = "Jungle",
    desertbandit = "Desert", desertboss = "Desert",
    frostrogue = "Snow", snowboss = "Snow", ragna = "Snow", ragnaboss = "Snow",
    jinwooboss = "Sailor", jinwoo = "Sailor", shadowboss = "Sailor", shadowmonarchboss = "Sailor",
    yujiboss = "Shibuya", sukunaboss = "Shibuya", gojoboss = "Shibuya", sorcererstudent = "Shibuya", pandasorcerer = "Shibuya", sorcerer = "Shibuya", pandaminiboss = "Shibuya", strongestoftodayboss = "Shibuya",        
    hollow = "HollowIsland", aizenboss = "HollowIsland", aizen = "HollowIsland",
    trueaizenboss = "SoulDominion",
    curse = "Shinjuku", strongsorcerer = "Shinjuku", strongestinhistoryboss = "Shinjuku", strongestoftodayboss = "Shinjuku",
    slimewarrior = "Slime", slime = "Slime", madokaboss = "Valentine", madoka = "Valentine", rimuruboss = "Slime",
    academyteacher = "Academy", anosboss = "Academy",
    swordsman = "Judgement", yamatoboss = "Judgement", yamato = "Judgement", alucardboss = "Sailor", alucard = "Sailor", qinshiboss = "Boss",
    quincy = "SoulDominion", ichigoboss = "Boss",
    saberboss = "Boss", saber = "Boss", gilgameshboss = "Boss", escanorboss = "Sailor",
    blessedmaidenboss = "Boss", saberalterboss = "Boss", atomicboss = "Lawless", atomic = "Lawless", strongestshinobiboss = "Ninja",
    ninja = "Ninja",
    arenafighter = "Lawless"
}

local I1ll11l1l1I1 = lII11lI1111l:WaitForChild("Remotes", 5)
local llIII111II1l = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("TeleportToPortal")
local ll11Ill1lllI = lII11lI1111l:WaitForChild("CombatSystem", 5)
local IlIl1lIIl11l = ll11Ill1lllI and ll11Ill1lllI:FindFirstChild("Remotes") and ll11Ill1lllI.Remotes:FindFirstChild("RequestHit")
local llllIlII11lI = lII11lI1111l:FindFirstChild("AbilitySystem")
local l1lll1l1lII1 = llllIlII11lI and llllIlII11lI:FindFirstChild("Remotes") and llllIlII11lI.Remotes:FindFirstChild("RequestAbility")

local llIl1II11I11 = lII11lI1111l:WaitForChild("RemoteEvents", 5)
local lIllII1llI11 = llIl1II11I11 and llIl1II11I11:FindFirstChild("QuestAccept")
local lI1lIllll1I1 = llIl1II11I11 and llIl1II11I11:FindFirstChild("QuestComplete")
local l11I1II11lII = llIl1II11I11 and llIl1II11I11:FindFirstChild("QuestAbandon")

local IIIllIlIl1I1 = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("RequestDungeonPortal")
local IIl1ll1IlI1l = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("DungeonWaveVote")

local lIlIll11ll1l = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("BossUIShow")
local lIl1lI1lIIlI = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("ShowNotification")
local l1lIl1lIII1I = I1ll11l1l1I1 and I1ll11l1l1I1:FindFirstChild("OpenInfiniteTowerUI")

if lIlIll11ll1l then
    lIlIll11ll1l.OnClientEvent:Connect(function(Illll1l1ll1I)
        if type(Illll1l1ll1I) == "table" and Illll1l1ll1I.pity ~= nil then
            local Il1II1llI1lI = tonumber(Illll1l1ll1I.pity) or 0
            if Il1II1llI1lI > _G.JomHub_BossPity or Il1II1llI1lI == 0 then updatePity(Il1II1llI1lI) end 
        end
    end)
end
if lIl1lI1lIIlI then
    lIl1lI1lIIlI.OnClientEvent:Connect(function(title, Illll1l1ll1I)
        if type(Illll1l1ll1I) == "table" and Illll1l1ll1I.message and l11ll11II1l1.autoDungeon and (string.find(Illll1l1ll1I.message, "difficulty") or string.find(Illll1l1ll1I.message, "vote") or string.find(Illll1l1ll1I.message, "normal")) then
            if IIl1ll1IlI1l then pcall(function() IIl1ll1IlI1l:FireServer(l11ll11II1l1.dungeonDiff) end) end
        end
    end)
end
if l1lIl1lIII1I then
    l1lIl1lIII1I.OnClientEvent:Connect(function()
        if l11ll11II1l1.autoDungeon or l11ll11II1l1.autoInfiniteTower then
            if IIl1ll1IlI1l then pcall(function() IIl1ll1IlI1l:FireServer("start") end) end
            pcall(function()
                local I1ll11lI1lI1 = Il1111lIl1I1:FindFirstChild("PlayerGui")
                if I1ll11lI1lI1 then
                    local II1l11111lII = I1ll11lI1lI1:FindFirstChild("InfiniteTowerUI") or I1ll11lI1lI1:FindFirstChild("TowerUI")
                    if II1l11111lII and II1l11111lII.Enabled then II1l11111lII.Enabled = false end
                end
            end)
        end
    end)
end

local l1ll111lIIl1 = {"Combat", "Gojo", "Sukuna", "Qin Shi", "Yuji", "Alucard", "Strongest Of Today", "Strongest In History", "Gilgamesh", "Madoka", "Anos", "Blessed Maiden", "Saber Alter", "Strongest Shinobi", "King of heroes", "Curse king", "Limitless sorcerer", "Corrupted Excalibur", "Fists", "Brass Knuckles", "Fighting Style", "Gauntlets", "Dragon Gauntlets"}
local I1ll11I1lIll = {"Saber", "Katana", "Jinwoo", "Dark Blade", "Ragna", "Aizen", "Shadow", "Ichigo", "Rimuru", "Shadow Monarch", "Escanor", "True Aizen", "Yamato", "Abyssal Empress", "Atomic", "Gryphon", "Excalibur", "Sin of pride", "Solo hunter", "Manipulator", "True Manipulator", "Sword", "KatanaSword", "Cutlass", "Longsword", "Dual Katana"}
local lIlIl1I1Ill1 = {"Quake", "Invisible", "Flame", "Bomb", "Light"}

local function getWeaponsToUse()
    local l11II1lIIlI1 = {}
    local II1IIlII1Il1 = Il1111lIl1I1:FindFirstChild("Backpack")
    local IIIlIII1Illl = Il1111lIl1I1.Character
    local function checkList(list)
        if IIIlIII1Illl then
            for _, tool in ipairs(IIIlIII1Illl:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, name in ipairs(list) do
                        if string.lower(tool.Name) == string.lower(name) then return tool end
                    end
                end
            end
        end
        if II1IIlII1Il1 then
            for _, tool in ipairs(II1IIlII1Il1:GetChildren()) do
                if tool:IsA("Tool") then
                    for _, name in ipairs(list) do
                        if string.lower(tool.Name) == string.lower(name) then return tool end
                    end
                end
            end
        end
        return nil
    end
    if l11ll11II1l1.autoMelee then local llIIlllllI1l = checkList(l1ll111lIIl1); if llIIlllllI1l then table.insert(l11II1lIIlI1, llIIlllllI1l) end end
    if l11ll11II1l1.autoSword then local llIIlllllI1l = checkList(I1ll11I1lIll); if llIIlllllI1l then table.insert(l11II1lIIlI1, llIIlllllI1l) end end
    if l11ll11II1l1.autoFruit then local llIIlllllI1l = checkList(lIlIl1I1Ill1); if llIIlllllI1l then table.insert(l11II1lIIlI1, llIIlllllI1l) end end
    
    if #l11II1lIIlI1 == 0 and II1IIlII1Il1 then
        local Il11II1l1IIl = IIIlIII1Illl and IIIlIII1Illl:FindFirstChildOfClass("Tool") or II1IIlII1Il1:FindFirstChildOfClass("Tool")
        if Il11II1l1IIl then table.insert(l11II1lIIlI1, Il11II1l1IIl) end
    end
    return l11II1lIIlI1
end

local function executeAttacks(targetObj, wep)
    if not targetObj then return end
    if IlIl1lIIl11l then pcall(function() IlIl1lIIl11l:FireServer(targetObj) end) end

    if l1lll1l1lII1 then
        local lI1I1Ill1lll = l11ll11II1l1.autoSkills or {}
        if wep and typeof(wep) == "Instance" then
            local l1lIl1l1lI11 = string.lower(wep.Name)
            local lllI1IllI1II, l1111lII1II1, Il1I1lII1111 = false, false, false
            for _, v in ipairs(l1ll111lIIl1) do if string.lower(v) == l1lIl1l1lI11 then lllI1IllI1II = true break end end
            if not lllI1IllI1II then for _, v in ipairs(I1ll11I1lIll) do if string.lower(v) == l1lIl1l1lI11 then l1111lII1II1 = true break end end end
            if not lllI1IllI1II and not l1111lII1II1 then for _, v in ipairs(lIlIl1I1Ill1) do if string.lower(v) == l1lIl1l1lI11 then Il1I1lII1111 = true break end end end
            
            if lllI1IllI1II then lI1I1Ill1lll = l11ll11II1l1.autoMeleeSkills or {}
            elseif l1111lII1II1 then lI1I1Ill1lll = l11ll11II1l1.autoSwordSkills or {}
            elseif Il1I1lII1111 then lI1I1Ill1lll = l11ll11II1l1.autoFruitSkills or {}
            end
        end
        if lI1I1Ill1lll["Skill Z"] then pcall(function() l1lll1l1lII1:FireServer(1) end) end
        if lI1I1Ill1lll["Skill X"] then pcall(function() l1lll1l1lII1:FireServer(2) end) end
        if lI1I1Ill1lll["Skill C"] then pcall(function() l1lll1l1lII1:FireServer(3) end) end
        if lI1I1Ill1lll["Skill V"] then pcall(function() l1lll1l1lII1:FireServer(4) end) end
        if lI1I1Ill1lll["Skill F"] then pcall(function() l1lll1l1lII1:FireServer(5) end) end
    end
end

local function getPortalForMob(mobName)
    if not mobName or mobName == "" then return nil end
    local ll111II11l1I = string.lower(string.gsub(mobName:gsub("%d+$", ""), "%s+", ""))
    return IIIll1IIIIlI[ll111II11l1I] or "Starter"
end

local function checkBossAlive(bName)
    local lIlIl11lllll = llI11IIl11II:FindFirstChild("NPCs")
    if lIlIl11lllll then
        local l1IllI1I1l11 = string.lower(string.gsub(bName, "%s+", ""))
        local I1lI11l11lII = string.gsub(l1IllI1I1l11, "boss", "")
        for _, npc in ipairs(lIlIl11lllll:GetChildren()) do
            local I11I11111IIl = npc.Name:gsub("%d+$", "")
            I11I11111IIl = I11I11111IIl:gsub("_.*", "")
            local Il1IlI1111II = string.lower(string.gsub(I11I11111IIl, "%s+", ""))
            if Il1IlI1111II == l1IllI1I1l11 then
                local lllI111l1lIl = npc:FindFirstChild("Humanoid")
                if lllI111l1lIl and lllI111l1lIl.Health > 0 then return true end
            elseif Il1IlI1111II == I1lI11l11lII then
                local lllI111l1lIl = npc:FindFirstChild("Humanoid")
                if lllI111l1lIl and lllI111l1lIl.Health > 0 and lllI111l1lIl.MaxHealth > 5000 then return true end
            end
        end
    end
    return false
end

local function teleportToIsland(portalName)
    if not portalName or portalName == "" then return false end
    if l11ll11II1l1.lastPortal == portalName then return true end

    local Il11lII1Ill1 = llI1IIlIIIII[portalName] or (portalName .. "Island")
    
    if llIII111II1l then
        pcall(function() llIII111II1l:FireServer(portalName) end)
    end

    local llll111I1Il1 = tick()
    local I1I1Il111IIl = false
    while tick() - llll111I1Il1 < 10 do -- 10 seconds timeout for island rendering
        local l11l1llll11I = llI11IIl11II:FindFirstChild(Il11lII1Ill1)
        if l11l1llll11I then
            local Il1Ill1IIIll = l11l1llll11I:FindFirstChild("Portal_" .. portalName)
            if Il1Ill1IIIll then
                I1I1Il111IIl = true
                break
            end
        end
        task.wait(0.2)
    end

    if I1I1Il111IIl then
        l11ll11II1l1.lastPortal = portalName
        task.wait(1) -- small buffer after portal renders
        return true
    else
        l11ll11II1l1.lastPortal = "" -- Reset if failed so it can try again
        return false
    end
end

local function teleportToIsland_AFK(portalName)
    if not portalName or portalName == "" then return false end

    local Il11lII1Ill1 = llI1IIlIIIII[portalName] or (portalName .. "Island")
    
    if llIII111II1l then
        pcall(function() llIII111II1l:FireServer(portalName) end)
    end

    local llll111I1Il1 = tick()
    local I1I1Il111IIl = false
    while tick() - llll111I1Il1 < 7 do -- Reduced timeout for AFK mode
        local l11l1llll11I = llI11IIl11II:FindFirstChild(Il11lII1Ill1)
        if l11l1llll11I then
            -- Wait for the specific portal part to confirm arrival, this is more reliable
            local Il1Ill1IIIll = l11l1llll11I:FindFirstChild("Portal_" .. portalName)
            if Il1Ill1IIIll then
                I1I1Il111IIl = true
                break
            end
        end
        task.wait(0.1) -- Faster check
    end

    if I1I1Il111IIl then
        l11ll11II1l1.lastPortal = portalName
        task.wait(0.5) -- A short buffer for assets to load after confirming portal
        return true
    else
        l11ll11II1l1.lastPortal = "" -- Reset if failed
        return false
    end
end

local function getFarmPosition(targetRoot, baseDistance, posType)
    local llI1IlIl1IIl = targetRoot.Position
    if posType == "Above" then 
        local IlIII1lIIl1l = llI1IlIl1IIl + Vector3.new(0, baseDistance, 0)
        return CFrame.new(IlIII1lIIl1l) * CFrame.Angles(math.rad(-90), 0, 0)
    else
        local lI1l1lI1l1lI = (targetRoot.CFrame * CFrame.new(0, 0, baseDistance)).Position
        return CFrame.lookAt(lI1l1lI1l1lI, llI1IlIl1IIl)
    end
end

local function SmartTeleport(targetCFrame)
    local IIIlIII1Illl = Il1111lIl1I1.Character
    local l11l1l11lIII = IIIlIII1Illl and IIIlIII1Illl:FindFirstChild("HumanoidRootPart")
    if not l11l1l11lIII then return end

    local lll1lIl111II = { [75159314259063] = true, [99684056491472] = true, [123955125827131] = true, [96767841099256] = true }
    local I1l1l111llII = lll1lIl111II[game.PlaceId]
    local lllI11IlIlIl = (game.PlaceId == 138368689293913)
    
    local Il1I111l1IlI = 150
    if (l11ll11II1l1.autoDungeon and I1l1l111llII) or (l11ll11II1l1.autoInfiniteTower and lllI11IlIlIl) then
        Il1I111l1IlI = 400 -- Faster tween speed for dungeons
    end

    local lI1IIlI1l1lI = (l11l1l11lIII.Position - targetCFrame.Position).Magnitude
    if lI1IIlI1l1lI < 50 then 
        l11l1l11lIII.CFrame = targetCFrame
        pcall(function() l11l1l11lIII.AssemblyLinearVelocity = Vector3.zero end)
        return 
    end

    local I1IlllI1l1I1 = math.max(0.1, lI1IIlI1l1lI / Il1I111l1IlI)
    
    local lIl1l11lllIl = l11l1l11lIII:FindFirstChild("JomTeleportBV")
    if not lIl1l11lllIl then
        lIl1l11lllIl = Instance.new("BodyVelocity")
        lIl1l11lllIl.Name = "JomTeleportBV"
        lIl1l11lllIl.Velocity = Vector3.zero
        lIl1l11lllIl.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        lIl1l11lllIl.Parent = l11l1l11lIII
    end

    local ll1l11l1lIll = TweenInfo.new(I1IlllI1l1I1, Enum.EasingStyle.Linear)
    local IlII1l1lIlI1 = IlIIIl1lIl1l:Create(l11l1l11lIII, ll1l11l1lIll, {CFrame = targetCFrame})
    
    IlII1l1lIlI1:Play()
    
    local llll111I1Il1 = tick()
    while IlII1l1lIlI1.PlaybackState == Enum.PlaybackState.Playing do
        if not (l11ll11II1l1.AutoFarmActive or l11ll11II1l1.AutoLevelActive or l11ll11II1l1.AutoBossActive or l11ll11II1l1.AutoAllBossActive or l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity or l11ll11II1l1.autoDungeon or l11ll11II1l1.autoInfiniteTower or l11ll11II1l1.autoFarmTitle or l11ll11II1l1.autoFarmItems or l11ll11II1l1.autoSummon) or (tick() - llll111I1Il1 > I1IlllI1l1I1 + 1) then
            IlII1l1lIlI1:Cancel()
            break
        end
        task.wait()
    end
    
    if lIl1l11lllIl then lIl1l11lllIl:Destroy() end
end

task.spawn(function()
    while task.wait() do
        if l11ll11II1l1.afkModeActive then
            local IIIlIII1Illl = Il1111lIl1I1.Character
            if not IIIlIII1Illl then task.wait(1); continue end
            local l11l1l11lIII = IIIlIII1Illl:FindFirstChild("HumanoidRootPart")
            local lllI111l1lIl = IIIlIII1Illl:FindFirstChild("Humanoid")
            if not l11l1l11lIII or not lllI111l1lIl or lllI111l1lIl.Health <= 0 then continue end

            for _, v in pairs(IIIlIII1Illl:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            local I1llI11lll11 = {}
            for name, lI1lII1IIl1I in pairs(l11ll11II1l1.afkIslands or {}) do
                if lI1lII1IIl1I then table.insert(I1llI11lll11, name) end
            end
            table.sort(I1llI11lll11)

            if #I1llI11lll11 == 0 then task.wait(1); continue end

            local ll11IIIll11l = IIIlIII1Illl:GetAttribute("AfkIslandIndex") or 1
            if ll11IIIll11l > #I1llI11lll11 then ll11IIIll11l = 1 end
            local llllI11I1l1I = I1llI11lll11[ll11IIIll11l]

            if l11ll11II1l1.lastPortal ~= llllI11I1l1I then
                print("[JOMHUB AFK] Switching to island: " .. llllI11I1l1I)
                local llllIIlIlIIl = teleportToIsland_AFK(llllI11I1l1I)
                if llllIIlIlIIl then task.wait(0.5) else task.wait(2) end
                continue
            end

            local lIlIl11lllll = llI11IIl11II:FindFirstChild("NPCs")
            local I1IIl1I11II1 = {}
            if lIlIl11lllll then
                for _, npc in ipairs(lIlIl11lllll:GetChildren()) do
                    local lII1lIl11I1I = npc:FindFirstChild("Humanoid")
                    if lII1lIl11I1I and lII1lIl11I1I.Health > 0 then
                        local I11I11111IIl = npc.Name:gsub("%d+$", "")
                        I11I11111IIl = I11I11111IIl:gsub("_.*", "")
                        local Il1IlI1111II = string.lower(string.gsub(I11I11111IIl, "%s+", ""))
                        local I11llI11I11l = string.gsub(Il1IlI1111II, "boss", "")
                        
                        local I1I11III1l11 = IIIll1IIIIlI[Il1IlI1111II] or IIIll1IIIIlI[I11llI11I11l]
                        if I1I11III1l11 == llllI11I1l1I then
                            table.insert(I1IIl1I11II1, npc)
                        end
                    end
                end
            end
            
            table.sort(I1IIl1I11II1, function(a, b)
                local IIl11III1ll1 = string.find(string.lower(a.Name), "boss") ~= nil
                local I1IIl1lIII1l = string.find(string.lower(b.Name), "boss") ~= nil
                if IIl11III1ll1 and not I1IIl1lIII1l then return true end
                if I1IIl1lIII1l and not IIl11III1ll1 then return false end
                return false
            end)

            if #I1IIl1I11II1 == 0 then
                print("[JOMHUB AFK] Island " .. llllI11I1l1I .. " cleared. Switching to next.")
                local lIl1lIlll1I1 = ll11IIIll11l + 1
                if lIl1lIlll1I1 > #I1llI11lll11 then lIl1lIlll1I1 = 1 end
                IIIlIII1Illl:SetAttribute("AfkIslandIndex", lIl1lIlll1I1)
                l11ll11II1l1.lastPortal = ""
                task.wait(1)
                continue
            end

            local l11II1lIIlI1 = getWeaponsToUse()
            local Illl1111Il1I = #l11II1lIIlI1 > 0 and l11II1lIIlI1 or {false}

            for _, target in ipairs(I1IIl1I11II1) do
                if target and target.Parent and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    local I1lI11lI1III = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
                    if I1lI11lI1III then
                        local I111111ll11l = getFarmPosition(I1lI11lI1III, l11ll11II1l1.farmDistance, l11ll11II1l1.farmPos)
                        l11l1l11lIII.CFrame = I111111ll11l

                        for _, wep in ipairs(Illl1111Il1I) do
                            if wep and typeof(wep) == "Instance" and wep.Parent ~= IIIlIII1Illl then
                                pcall(function() lllI111l1lIl:EquipTool(wep) end)
                                task.wait(0.05)
                            end
                            executeAttacks(target, wep)
                        end
                        task.wait(0.1)
                    end
                end
            end
            task.wait(0.1)
            continue
        end

        local lIIlIl1llll1 = l11ll11II1l1.AutoFarmActive or l11ll11II1l1.AutoLevelActive or l11ll11II1l1.AutoBossActive or l11ll11II1l1.AutoAllBossActive or l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity or l11ll11II1l1.autoDungeon or l11ll11II1l1.autoInfiniteTower or l11ll11II1l1.autoFarmTitle or l11ll11II1l1.autoFarmItems or l11ll11II1l1.autoSummon
        if not lIIlIl1llll1 then
            l11ll11II1l1.lastPortal = "" -- Reset state if toggled off
            local IIIlIII1Illl = Il1111lIl1I1.Character
            if IIIlIII1Illl and IIIlIII1Illl:FindFirstChild("HumanoidRootPart") then
                local IlI11Il11I1I = IIIlIII1Illl.HumanoidRootPart:FindFirstChild("JomFarmBV")
                if IlI11Il11I1I then IlI11Il11I1I:Destroy() end
            end
            task.wait(1)
            continue
        end
        
        local IIIlIII1Illl = Il1111lIl1I1.Character
        if not IIIlIII1Illl then task.wait(1); continue end

        local lll1lIl111II = { [75159314259063] = true, [99684056491472] = true, [123955125827131] = true, [96767841099256] = true }
        local I1l1l111llII = lll1lIl111II[game.PlaceId]

        local lllI11IlIlIl = (game.PlaceId == 138368689293913)

        if (l11ll11II1l1.autoDungeon and not I1l1l111llII) or (l11ll11II1l1.autoInfiniteTower and not lllI11IlIlIl) then
            task.wait(1) -- Wait for the portal logic to teleport us
            continue
        end

        local l1I1lll11l11 = nil
        local l111l1I1IIII = ""
        if l11ll11II1l1.AutoLevelActive then
            local IllII1I1IIlI = getCurrentLevel()
            local l1llI1I1llll = IllI11IIlII1[1]
            for _, tier in ipairs(IllI11IIlII1) do
                if IllII1I1IIlI >= tier.Level then l1llI1I1llll = tier else break end
            end
            l1I1lll11l11 = l1llI1I1llll.Mob
            l111l1I1IIII = l1llI1I1llll.Quest

            local IllI11lll1lI = Il1111lIl1I1:FindFirstChild("PlayerGui") and Il1111lIl1I1.PlayerGui:FindFirstChild("QuestUI")
            local lI1l11I11Il1 = IllI11lll1lI and IllI11lll1lI:FindFirstChild("Quest") and IllI11lll1lI.Quest.Visible

            if l11ll11II1l1.lastAutoQuest ~= l111l1I1IIII then
                if l11I1II11lII and l11ll11II1l1.lastAutoQuest ~= "" then
                    pcall(function() l11I1II11lII:FireServer("repeatable"); l11I1II11lII:FireServer("Abandon"); l11I1II11lII:FireServer(l11ll11II1l1.lastAutoQuest); l11I1II11lII:FireServer() end)
                end
                l11ll11II1l1.lastAutoQuest = l111l1I1IIII
                lI1l11I11Il1 = false -- Force accept new quest
            end
            
            if not lI1l11I11Il1 then
                local lIll1ll11IIl = IIIlIII1Illl:GetAttribute("LastQuestAccept") or 0
                if tick() - lIll1ll11IIl > 1 then
                    IIIlIII1Illl:SetAttribute("LastQuestAccept", tick())
                    if lIllII1llI11 then pcall(function() lIllII1llI11:FireServer(l111l1I1IIII) end) end
                end
            end
            
            local I1ll111111II = IIIlIII1Illl:GetAttribute("LastQuestComplete") or 0
            if tick() - I1ll111111II > 2 then
                IIIlIII1Illl:SetAttribute("LastQuestComplete", tick())
                if lI1lIllll1I1 then pcall(function() lI1lIllll1I1:FireServer(l111l1I1IIII) end) end
            end

        elseif l11ll11II1l1.AutoFarmActive then
            l1I1lll11l11 = l11ll11II1l1.selectedMob
        elseif l11ll11II1l1.AutoBossActive then
            l1I1lll11l11 = l11ll11II1l1.selectedBoss
        elseif l11ll11II1l1.AutoAllBossActive then
            local lIlIl11lllll = llI11IIl11II:FindFirstChild("NPCs")
            local IIIIIIl1ll11 = false
            
            -- 1. Prioritize ANY physical boss already loaded in workspace.NPCs
            if lIlIl11lllll then
                for _, npc in ipairs(lIlIl11lllll:GetChildren()) do
                    local lllI111l1lIl = npc:FindFirstChild("Humanoid")
                    if lllI111l1lIl and lllI111l1lIl.Health > 0 then
                        local I11I11111IIl = npc.Name:gsub("%d+$", "")
                        I11I11111IIl = I11I11111IIl:gsub("_.*", "")
                        local Il1IlI1111II = string.lower(string.gsub(I11I11111IIl, "%s+", ""))
                        
                        for _, bName in ipairs(II111I1l1lII) do
                            local l1IllI1I1l11 = string.lower(string.gsub(bName, "%s+", ""))
                            local I1lI11l11lII = string.gsub(l1IllI1I1l11, "boss", "")
                            
                            if Il1IlI1111II == l1IllI1I1l11 or Il1IlI1111II == I1lI11l11lII then
                                l1I1lll11l11 = bName
                                IIIIIIl1ll11 = true
                                break
                            end
                        end
                    end
                    if IIIIIIl1ll11 then break end
                end
            end
            
            if not l1I1lll11l11 then
                if l11ll11II1l1.autoHopAllBosses then
                    if not IIIlIII1Illl:GetAttribute("HopDelayStarted") then
                        IIIlIII1Illl:SetAttribute("HopDelayStarted", tick())
                    end
                    if tick() - IIIlIII1Illl:GetAttribute("HopDelayStarted") > 5 then
                        print("[JOMHUB] All bosses dead. Hopping server...")
                        ServerHop()
                        task.wait(10)
                    end
                end
            else
                IIIlIII1Illl:SetAttribute("HopDelayStarted", nil)
            end
        elseif l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity then
            local llll1IllIIlI = _G.JomHub_BossPity or 0
            local l1IlIII1I1l1 = ""
            local l1Il1Il1Il1l = false
            
            if llll1IllIIlI >= 24 then
                if not l11ll11II1l1.pitySummonBoss or l11ll11II1l1.pitySummonBoss == "None" then
                    l1IlIII1I1l1 = "None"
                else
                    l1IlIII1I1l1 = l11ll11II1l1.pitySummonBoss
                end
            else
                if l11ll11II1l1.autoHopPity then
                    local llllIlI11l11 = {}
                    local l1Illl1II1Il = {"GojoBoss", "YujiBoss", "YamatoBoss", "AlucardBoss", "StrongestShinobiBoss", "JinwooBoss", "SukunaBoss", "AizenBoss"}
                    for _, b in ipairs(l1Illl1II1Il) do
                        if checkBossAlive(b) then table.insert(llllIlI11l11, b) end
                    end

                    if #llllIlI11l11 > 0 then
                        local lI1lII1IIl1I = llllIlI11l11[1]
                        for _, b in ipairs(llllIlI11l11) do
                            if b ~= l11ll11II1l1.pitySummonBoss then lI1lII1IIl1I = b; break end
                        end
                        l1IlIII1I1l1 = lI1lII1IIl1I
                    else
                        l1Il1Il1Il1l = true
                    end
                else
                    local llI11l1llIlI = {}
                    for k, v in pairs(l11ll11II1l1.pityBuilderBosses or {}) do if v then table.insert(llI11l1llIlI, k) end end
                    table.sort(llI11l1llIlI)
                    if #llI11l1llIlI == 0 then llI11l1llIlI = {"SaberBoss"} end
                    
                    local IIIII1l1lIII = false
                    for _, b in ipairs(llI11l1llIlI) do
                        if checkBossAlive(b) then 
                            l1IlIII1I1l1 = b
                            IIIII1l1lIII = true
                            if IIIlIII1Illl:GetAttribute("SummonWait") then IIIlIII1Illl:SetAttribute("SummonWait", nil) end
                            break 
                        end
                    end
                    if not IIIII1l1lIII then
                        local I111IIIIlIII = IIIlIII1Illl:GetAttribute("PityBuilderIdx") or 1
                        if I111IIIIlIII > #llI11l1llIlI then I111IIIIlIII = 1; IIIlIII1Illl:SetAttribute("PityBuilderIdx", 1) end
                        
                        local Il1lIIlIl111 = IIIlIII1Illl:GetAttribute("SummonWait")
                        if Il1lIIlIl111 then
                            if tick() - Il1lIIlIl111 < 4 then
                                l1IlIII1I1l1 = llI11l1llIlI[I111IIIIlIII]
                            else
                                IIIlIII1Illl:SetAttribute("PityBuilderIdx", I111IIIIlIII + 1)
                                IIIlIII1Illl:SetAttribute("SummonWait", nil)
                            end
                        else
                            l1IlIII1I1l1 = llI11l1llIlI[I111IIIIlIII]
                        end
                    end
                end
            end
            
            l1I1lll11l11 = l1IlIII1I1l1
            
            if l1Il1Il1Il1l then
                if not IIIlIII1Illl:GetAttribute("PityHopDelay") then IIIlIII1Illl:SetAttribute("PityHopDelay", tick()) end
                if tick() - IIIlIII1Illl:GetAttribute("PityHopDelay") > 5 then
                    print("[JOMHUB] AUTO HOP PITY: No world bosses alive. Hopping...")
                    ServerHop()
                    task.wait(10)
                end
                continue
            else
                IIIlIII1Illl:SetAttribute("PityHopDelay", nil)
            end
        elseif l11ll11II1l1.autoFarmItems then
            local I1I111lIIl1l = {}
            for k, v in pairs(l11ll11II1l1.farmSecret or {}) do if v then table.insert(I1I111lIIl1l, k) end end
            for k, v in pairs(l11ll11II1l1.farmMythical or {}) do if v then table.insert(I1I111lIIl1l, k) end end
            for k, v in pairs(l11ll11II1l1.farmLegendary or {}) do if v then table.insert(I1I111lIIl1l, k) end end
            for k, v in pairs(l11ll11II1l1.farmEpic or {}) do if v then table.insert(I1I111lIIl1l, k) end end
            for k, v in pairs(l11ll11II1l1.farmRare or {}) do if v then table.insert(I1I111lIIl1l, k) end end
            for k, v in pairs(l11ll11II1l1.farmCommon or {}) do if v then table.insert(I1I111lIIl1l, k) end end

            table.sort(I1I111lIIl1l)
            if #I1I111lIIl1l > 0 then
                local I111IIIIlIII = IIIlIII1Illl:GetAttribute("ItemFarmIdx") or 1
                if I111IIIIlIII > #I1I111lIIl1l then I111IIIIlIII = 1; IIIlIII1Illl:SetAttribute("ItemFarmIdx", I111IIIIlIII) end
                
                local III1IIl1lIlI = I1I111lIIl1l[I111IIIIlIII]
                local l111111II111 = I1II11lIllll[III1IIl1lIlI]
                
                local lII1IIllIll1 = IIIlIII1Illl:GetAttribute("ItemFarmTime")
                if not lII1IIllIll1 then 
                    lII1IIllIll1 = tick()
                    IIIlIII1Illl:SetAttribute("ItemFarmTime", lII1IIllIll1)
                end
                
                if tick() - lII1IIllIll1 >= l11ll11II1l1.itemFarmDuration then
                    IIIlIII1Illl:SetAttribute("ItemFarmIdx", I111IIIIlIII + 1)
                    IIIlIII1Illl:SetAttribute("ItemFarmTime", tick())
                    task.wait(1)
                    continue
                end
                
                if type(l111111II111) == "table" then
                    local ll1lIIIlI1l1 = false
                    -- First, iterate through the list to find an alive boss
                    for _, tName in ipairs(l111111II111) do
                        if string.find(string.lower(tName), "boss") and checkBossAlive(tName) then
                            l1I1lll11l11 = tName
                            ll1lIIIlI1l1 = true
                            break
                        end
                    end

                    -- If no boss was found, cycle through the non-boss fallback mobs
                    if not ll1lIIIlI1l1 then
                        local IIlIlI11l111 = {}
                        for _, tName in ipairs(l111111II111) do
                            if not string.find(string.lower(tName), "boss") then
                                table.insert(IIlIlI11l111, tName)
                            end
                        end

                        if #IIlIlI11l111 > 0 then
                            -- Use the main item farm timer to decide which fallback mob to farm
                            local I1IIl1111Il1 = l11ll11II1l1.itemFarmDuration / #IIlIlI11l111
                            local IlIII1lIllIl = tick() - lII1IIllIll1
                            local lII1lI1l1Il1 = math.floor(IlIII1lIllIl / I1IIl1111Il1) + 1
                            if lII1lI1l1Il1 > #IIlIlI11l111 then lII1lI1l1Il1 = #IIlIlI11l111 end
                            
                            l1I1lll11l11 = IIlIlI11l111[lII1lI1l1Il1]
                        else
                            -- No bosses and no fallbacks, so switch to the next item immediately
                            IIIlIII1Illl:SetAttribute("ItemFarmIdx", I111IIIIlIII + 1)
                            IIIlIII1Illl:SetAttribute("ItemFarmTime", tick())
                        end
                    end
                elseif l111111II111 == "AutoLevel" then
                    local IllII1I1IIlI = getCurrentLevel()
                    local l1llI1I1llll = IllI11IIlII1[1]
                    for _, tier in ipairs(IllI11IIlII1) do
                        if IllII1I1IIlI >= tier.Level then l1llI1I1llll = tier else break end
                    end
                    l1I1lll11l11 = l1llI1I1llll.Mob
                elseif l111111II111 == "AllBosses" then
                    for _, bName in ipairs(II111I1l1lII) do
                        if checkBossAlive(bName) then l1I1lll11l11 = bName; break end
                    end
                    if not l1I1lll11l11 then IIIlIII1Illl:SetAttribute("ItemFarmIdx", I111IIIIlIII + 1); IIIlIII1Illl:SetAttribute("ItemFarmTime", tick()) end
                else
                    local lI11IlII1l1l = string.find(string.lower(l111111II111 or ""), "boss")
                    if lI11IlII1l1l and not checkBossAlive(l111111II111) then IIIlIII1Illl:SetAttribute("ItemFarmIdx", I111IIIIlIII + 1); IIIlIII1Illl:SetAttribute("ItemFarmTime", tick())
                    else l1I1lll11l11 = l111111II111 end
                end
            end
        elseif l11ll11II1l1.autoFarmTitle and l11ll11II1l1.selectedTitle ~= "None" then
            local I1lII1ll1Il1 = llllIIlIIlI1[l11ll11II1l1.selectedTitle]
            if I1lII1ll1Il1 then
                if I1lII1ll1Il1.type == "BossKills" or I1lII1ll1Il1.type == "ItemDrops" then
                    for _, bName in ipairs(II111I1l1lII) do
                        if checkBossAlive(bName) then l1I1lll11l11 = bName; break end
                    end
                elseif I1lII1ll1Il1.type == "Boss" then
                    l1I1lll11l11 = I1lII1ll1Il1.name
                end

                if not l1I1lll11l11 and l11ll11II1l1.hopForTitle then
                    if not IIIlIII1Illl:GetAttribute("TitleHopDelay") then IIIlIII1Illl:SetAttribute("TitleHopDelay", tick()) end
                    if tick() - IIIlIII1Illl:GetAttribute("TitleHopDelay") > 5 then
                        print("[JOMHUB] No title bosses found. Hopping server...")
                        ServerHop()
                        task.wait(10)
                    end
                end
            end
        elseif l11ll11II1l1.autoDungeon and I1l1l111llII then
            l1I1lll11l11 = "Dungeon Mob" -- Placeholder name for logic
        elseif l11ll11II1l1.autoInfiniteTower and lllI11IlIlIl then
            l1I1lll11l11 = "Tower Mob" -- Placeholder name for logic
        elseif l11ll11II1l1.autoSummon then
            local I1l11l1I11I1 = {}
            for k, v in pairs(l11ll11II1l1.summonTargets or {}) do if v then table.insert(I1l11l1I11I1, k) end end
            table.sort(I1l11l1I11I1)

            if #I1l11l1I11I1 > 0 then
                local I111IIIIlIII = IIIlIII1Illl:GetAttribute("SummonIdx") or 1
                if I111IIIIlIII > #I1l11l1I11I1 then I111IIIIlIII = 1; IIIlIII1Illl:SetAttribute("SummonIdx", 1) end
                
                local I11lIIlI11I1 = I1l11l1I11I1[I111IIIIlIII]

                -- If the boss is already alive, we don't want to attack it.
                -- We just want to move on to the next boss in our summon list.
                if checkBossAlive(I11lIIlI11I1) then
                    IIIlIII1Illl:SetAttribute("SummonIdx", I111IIIIlIII + 1)
                else
                    -- It's not alive, so let's check if we have the items to summon it.
                    local Ill1l1I11lI1 = lIlIl111lI1l[I11lIIlI11I1]
                    local lI1IIll1Il1l = true
                    if Ill1l1I11lI1 then
                        for item, amount in pairs(Ill1l1I11lI1) do
                            if not llIIIl1l1Ill[item] or llIIIl1l1Ill[item] < amount then lI1IIll1Il1l = false; break end
                        end
                    end

                    if lI1IIll1Il1l then
                        -- We have the items and the boss isn't alive. Set it as a target
                        -- so the script will navigate to its spawner and trigger the summon remote.
                        l1I1lll11l11 = I11lIIlI11I1
                    else
                        -- We don't have the items, so we skip to the next boss.
                        IIIlIII1Illl:SetAttribute("SummonIdx", I111IIIIlIII + 1)
                    end
                end
            end
        end

        if not l1I1lll11l11 or l1I1lll11l11 == "None" then 
            if IIIlIII1Illl and IIIlIII1Illl:FindFirstChild("HumanoidRootPart") then
                local IlI11Il11I1I = IIIlIII1Illl.HumanoidRootPart:FindFirstChild("JomFarmBV")
                if IlI11Il11I1I then IlI11Il11I1I:Destroy() end
            end
            task.wait(1)
            continue 
        end

        if not ((l11ll11II1l1.autoDungeon and I1l1l111llII) or (l11ll11II1l1.autoInfiniteTower and lllI11IlIlIl)) then
            local I1lllIlII1l1 = getPortalForMob(l1I1lll11l11)
            
            if I1lllIlII1l1 and l11ll11II1l1.lastPortal ~= I1lllIlII1l1 then
                print("[JOMHUB] Attempting to teleport to:", I1lllIlII1l1)
                local llllIIlIlIIl = teleportToIsland(I1lllIlII1l1)
                if llllIIlIlIIl then
                    print("[JOMHUB] Successfully arrived and confirmed portal:", I1lllIlII1l1)
                    task.wait(1)
                else
                    print("[JOMHUB] Failed to confirm portal loading for:", I1lllIlII1l1)
                    task.wait(2)
                end
                continue
            end
        end
        
        -- Confirmed on the correct island, scan for enemies and tween!
        local l11l1l11lIII = IIIlIII1Illl and IIIlIII1Illl:FindFirstChild("HumanoidRootPart")
        local lllI111l1lIl = IIIlIII1Illl and IIIlIII1Illl:FindFirstChild("Humanoid")
        if not l11l1l11lIII or not lllI111l1lIl then task.wait(1); continue end
        
        for _, v in pairs(IIIlIII1Illl:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end

        local lIlIl11lllll = llI11IIl11II:FindFirstChild("NPCs")
        local lI1l1lI1II1I = math.huge
        local l1lIl1I11lI1 = nil
        
        if (l11ll11II1l1.autoDungeon and I1l1l111llII) or (l11ll11II1l1.autoInfiniteTower and lllI11IlIlIl) then
            if lIlIl11lllll then
                for _, npc in ipairs(lIlIl11lllll:GetChildren()) do
                    local lII1lIl11I1I = npc:FindFirstChild("Humanoid")
                    local IlIII1III1ll = npc:FindFirstChild("HumanoidRootPart")
                    if lII1lIl11I1I and lII1lIl11I1I.Health > 0 and IlIII1III1ll then
                        local IlII11Ill1ll = (l11l1l11lIII.Position - IlIII1III1ll.Position).Magnitude
                        if IlII11Ill1ll < lI1l1lI1II1I then lI1l1lI1II1I = IlII11Ill1ll; l1lIl1I11lI1 = npc end
                    end
                end
            end
        else
            if lIlIl11lllll then
                local l1IllI1I1l11 = string.lower(string.gsub(l1I1lll11l11, "%s+", ""))
                local I1lI11l11lII = string.gsub(l1IllI1I1l11, "boss", "")
                for _, npc in ipairs(lIlIl11lllll:GetChildren()) do
                    local I11I11111IIl = npc.Name:gsub("%d+$", "")
                    I11I11111IIl = I11I11111IIl:gsub("_.*", "")
                    local Il1IlI1111II = string.lower(string.gsub(I11I11111IIl, "%s+", ""))
                    if Il1IlI1111II == l1IllI1I1l11 or (Il1IlI1111II == I1lI11l11lII and npc:FindFirstChild("Humanoid") and npc.Humanoid.MaxHealth > 5000) then
                        local lII1lIl11I1I = npc:FindFirstChild("Humanoid")
                        local IlIII1III1ll = npc:FindFirstChild("HumanoidRootPart")
                        if lII1lIl11I1I and lII1lIl11I1I.Health > 0 then
                            if IlIII1III1ll then
                                local IlII11Ill1ll = (l11l1l11lIII.Position - IlIII1III1ll.Position).Magnitude
                                if IlII11Ill1ll < lI1l1lI1II1I then lI1l1lI1II1I = IlII11Ill1ll; l1lIl1I11lI1 = npc end
                            elseif l1I1lll11l11 == "StrongestofTodayBoss" or l1I1lll11l11 == "StrongestinHistoryBoss" then
                                -- Shinjuku Boss Streaming Bypass
                                local ll1II1l1Il1I = npc:GetPivot().Position
                                local IlII11Ill1ll = (l11l1l11lIII.Position - ll1II1l1Il1I).Magnitude
                                if IlII11Ill1ll < lI1l1lI1II1I then lI1l1lI1II1I = IlII11Ill1ll; l1lIl1I11lI1 = npc end
                            end
                        end
                    end
                end
            end
        end
        
        if l1lIl1I11lI1 then
            if IIIlIII1Illl then IIIlIII1Illl:SetAttribute("BossLoadAttempts", 0) end
            if (l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity) and not IIIlIII1Illl:GetAttribute("TrackingPityFor") then
                IIIlIII1Illl:SetAttribute("TrackingPityFor", l1lIl1I11lI1.Name)
                local III1l1llII1I = l1lIl1I11lI1
                
                local II1l1I11Il1l = III1l1llII1I:FindFirstChild("Humanoid")
                if II1l1I11Il1l then
                    local IIIIlll1l1I1; IIIIlll1l1I1 = II1l1I11Il1l.Died:Connect(function()
                        if l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity then
                            if _G.JomHub_BossPity >= 24 then updatePity(0)
                            else updatePity(_G.JomHub_BossPity + 1) end
                        end
                        if IIIlIII1Illl then IIIlIII1Illl:SetAttribute("TrackingPityFor", nil) end
                        if IIIIlll1l1I1 then IIIIlll1l1I1:Disconnect() end
                    end)
                end
            end
            local I1lI11lI1III = l1lIl1I11lI1:FindFirstChild("HumanoidRootPart") or l1lIl1I11lI1:FindFirstChildWhichIsA("BasePart")
            local II1l1I11Il1l = l1lIl1I11lI1:FindFirstChild("Humanoid")
            
            if I1lI11lI1III and II1l1I11Il1l then
                pcall(function() II1l1I11Il1l.WalkSpeed = 0; II1l1I11Il1l.JumpPower = 0; I1lI11lI1III.CanCollide = false; I1lI11lI1III.Velocity = Vector3.zero end)
                
                local I1lIIl1l1I11 = (l11ll11II1l1.autoDungeon and I1l1l111llII) and l11ll11II1l1.dungeonPos or l11ll11II1l1.farmPos
                local I111111ll11l = getFarmPosition(I1lI11lI1III, l11ll11II1l1.farmDistance, I1lIIl1l1I11)
                if (l11l1l11lIII.Position - I111111ll11l.Position).Magnitude > 50 then
                    local IlI11Il11I1I = l11l1l11lIII:FindFirstChild("JomFarmBV")
                    if IlI11Il11I1I then IlI11Il11I1I:Destroy() end
                    SmartTeleport(I111111ll11l)
                else
                    local IlI11Il11I1I = l11l1l11lIII:FindFirstChild("JomFarmBV")
                    if not IlI11Il11I1I then
                        IlI11Il11I1I = Instance.new("BodyVelocity")
                        IlI11Il11I1I.Name = "JomFarmBV"
                        IlI11Il11I1I.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        IlI11Il11I1I.Velocity = Vector3.zero
                        IlI11Il11I1I.Parent = l11l1l11lIII
                    end
                    for _, v in ipairs(l11l1l11lIII:GetChildren()) do
                        if (v:IsA("BodyVelocity") and v.Name ~= "JomFarmBV" and v.Name ~= "JomTeleportBV") or v:IsA("BodyPosition") or v:IsA("LinearVelocity") or v:IsA("AlignPosition") then
                            v:Destroy()
                        end
                    end
                    if (l11l1l11lIII.Position - I111111ll11l.Position).Magnitude > 5 then
                        l11l1l11lIII.CFrame = I111111ll11l
                    end
                    l11l1l11lIII.Velocity = Vector3.zero
                    pcall(function() l11l1l11lIII.AssemblyLinearVelocity = Vector3.zero end)
                    
                    local l11II1lIIlI1 = getWeaponsToUse()
                    local Illl1111Il1I = #l11II1lIIlI1 > 0 and l11II1lIIlI1 or {false}
                    for _, wep in ipairs(Illl1111Il1I) do
                        if wep and typeof(wep) == "Instance" and wep.Parent ~= IIIlIII1Illl then
                            pcall(function() lllI111l1lIl:EquipTool(wep) end)
                            task.wait(0.05) -- brief delay needed for game to render tool handle locally
                        end
                        executeAttacks(l1lIl1I11lI1, wep)
                    end
                end
            elseif (l1I1lll11l11 == "StrongestofTodayBoss" or l1I1lll11l11 == "StrongestinHistoryBoss") and II1l1I11Il1l then
                -- Shinjuku bosses might be streamed out, so we tween to their Pivot to force them to load
                local ll1II1l1Il1I = l1lIl1I11lI1:GetPivot().Position
                pcall(function() Il1111lIl1I1:RequestStreamAroundAsync(ll1II1l1Il1I) end)
                if (l11l1l11lIII.Position - ll1II1l1Il1I).Magnitude > 50 then
                    local IlI11Il11I1I = l11l1l11lIII:FindFirstChild("JomFarmBV")
                    if IlI11Il11I1I then IlI11Il11I1I:Destroy() end
                    SmartTeleport(CFrame.new(ll1II1l1Il1I + Vector3.new(0, 15, 0)))
                end
            end
        else
            local IlI11Il11I1I = l11l1l11lIII:FindFirstChild("JomFarmBV")
            if IlI11Il11I1I then IlI11Il11I1I:Destroy() end
            if IIIlIII1Illl:GetAttribute("TrackingPityFor") then IIIlIII1Illl:SetAttribute("TrackingPityFor", nil) end
            
            local lI11IlII1l1l = l1I1lll11l11 and string.find(string.lower(l1I1lll11l11), "boss")
            if lI11IlII1l1l then
                local l1Il1ll1Ill1 = string.gsub(l1I1lll11l11, "Boss", "")
                local lIl1l111lI11 = "TimedBossSpawn_" .. l1I1lll11l11 .. "_Container"
                local l1lIIIlI1lII = "TimedBossSpawn_" .. l1Il1ll1Ill1 .. "_Container"
                local IlllIIlIIlIl = llI11IIl11II:FindFirstChild(lIl1l111lI11) or llI11IIl11II:FindFirstChild(l1lIIIlI1lII)
                if not IlllIIlIIlIl and l1I1lll11l11 == "YamatoBoss" then IlllIIlIIlIl = llI11IIl11II:FindFirstChild("TimedBossSpawn_Yamato_Container") end
                
                if IlllIIlIIlIl then
                    local Ill1lI1lllI1 = IlllIIlIIlIl:FindFirstChild("TimedBossSpawn_" .. l1I1lll11l11) or IlllIIlIIlIl
                    local llI1lIIII1lI = nil
                    if Ill1lI1lllI1:IsA("Model") and Ill1lI1lllI1.PrimaryPart then llI1lIIII1lI = Ill1lI1lllI1:GetPivot().Position
                    elseif Ill1lI1lllI1:IsA("Model") then local ll11l1III1Il = Ill1lI1lllI1:FindFirstChildWhichIsA("BasePart", true); if ll11l1III1Il then llI1lIIII1lI = ll11l1III1Il.Position end
                    elseif Ill1lI1lllI1:IsA("BasePart") then llI1lIIII1lI = Ill1lI1lllI1.Position end
                    
                    if llI1lIIII1lI then
                        pcall(function() Il1111lIl1I1:RequestStreamAroundAsync(llI1lIIII1lI) end)
                        if (l11l1l11lIII.Position - llI1lIIII1lI).Magnitude > 50 then 
                            SmartTeleport(CFrame.new(llI1lIIII1lI + Vector3.new(0, 15, 0))) 
                        else
                            l11l1l11lIII.Velocity = Vector3.zero
                        end
                    end
                end

                local IlIlI1l1lIl1 = {
                    ["AtomicBoss"]=true, ["TrueAizenBoss"]=true, ["AnosBoss"]=true, 
                    ["RimuruBoss"]=true, ["StrongestofTodayBoss"]=true, ["StrongestinHistoryBoss"]=true, 
                    ["SaberBoss"]=true, ["QinShiBoss"]=true, ["IchigoBoss"]=true, 
                    ["GilgameshBoss"]=true, ["BlessedMaidenBoss"]=true, ["SaberAlterBoss"]=true
                }
                
                if (l11ll11II1l1.autoSummonPity or l11ll11II1l1.autoHopPity or l11ll11II1l1.autoSummon) and IlIlI1l1lIl1[l1I1lll11l11] then
                        if not IIIlIII1Illl:GetAttribute("LastPitySummon") or tick() - IIIlIII1Illl:GetAttribute("LastPitySummon") > 8 then
                            IIIlIII1Illl:SetAttribute("LastPitySummon", tick())
                            IIIlIII1Illl:SetAttribute("SummonWait", tick())
                            print("[JOMHUB] Summoning " .. l1I1lll11l11 .. "...")
                            
                            local IlI1llI1111l = lII11lI1111l:FindFirstChild("RemoteEvents")
                            local II111llI1Ill = lII11lI1111l:FindFirstChild("Remotes")
                            local l1IlllIll1lI = l11ll11II1l1.autoSummon and l11ll11II1l1.summonDiff or l11ll11II1l1.pitySummonDiff or "Normal"
                            
                            pcall(function()
                                if l1I1lll11l11 == "AtomicBoss" and IlI1llI1111l and IlI1llI1111l:FindFirstChild("RequestSpawnAtomic") then IlI1llI1111l.RequestSpawnAtomic:FireServer(l1IlllIll1lI)
                                elseif l1I1lll11l11 == "TrueAizenBoss" and IlI1llI1111l and IlI1llI1111l:FindFirstChild("RequestSpawnTrueAizen") then IlI1llI1111l.RequestSpawnTrueAizen:FireServer(l1IlllIll1lI)
                                elseif l1I1lll11l11 == "AnosBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSpawnAnosBoss") then II111llI1Ill.RequestSpawnAnosBoss:FireServer("Anos", l1IlllIll1lI)
                                elseif l1I1lll11l11 == "RimuruBoss" and IlI1llI1111l and IlI1llI1111l:FindFirstChild("RequestSpawnRimuru") then IlI1llI1111l.RequestSpawnRimuru:FireServer(l1IlllIll1lI)
                                elseif l1I1lll11l11 == "StrongestofTodayBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSpawnStrongestBoss") then II111llI1Ill.RequestSpawnStrongestBoss:FireServer("StrongestToday", l1IlllIll1lI)
                                elseif l1I1lll11l11 == "StrongestinHistoryBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSpawnStrongestBoss") then II111llI1Ill.RequestSpawnStrongestBoss:FireServer("StrongestHistory", l1IlllIll1lI)
                                elseif l1I1lll11l11 == "SaberBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("SaberBoss")
                                elseif l1I1lll11l11 == "QinShiBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("QinShiBoss")
                                elseif l1I1lll11l11 == "IchigoBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("IchigoBoss")
                                elseif l1I1lll11l11 == "GilgameshBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("GilgameshBoss", l1IlllIll1lI)
                                elseif l1I1lll11l11 == "BlessedMaidenBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("BlessedMaidenBoss", l1IlllIll1lI)
                                elseif l1I1lll11l11 == "SaberAlterBoss" and II111llI1Ill and II111llI1Ill:FindFirstChild("RequestSummonBoss") then II111llI1Ill.RequestSummonBoss:FireServer("SaberAlterBoss", l1IlllIll1lI)
                                end
                            end)
                        end
                    end
            else
                if not l111l1I1IIII or l111l1I1IIII == "" then
                    for _, tier in ipairs(IllI11IIlII1) do
                        if tier.Mob == l1I1lll11l11 then
                            l111l1I1IIII = tier.Quest
                            break
                        end
                    end
                end

                if l111l1I1IIII and l111l1I1IIII ~= "" then
                    local llllIl1lIlI1 = llI11IIl11II:FindFirstChild(l111l1I1IIII) or (llI11IIl11II:FindFirstChild("ServiceNPCs") and llI11IIl11II.ServiceNPCs:FindFirstChild(l111l1I1IIII))
                    if llllIl1lIlI1 and llllIl1lIlI1:IsA("Model") then
                        local lIIIl1ll1l11 = llllIl1lIlI1:GetPivot().Position
                        pcall(function() Il1111lIl1I1:RequestStreamAroundAsync(lIIIl1ll1l11) end)
                        if (l11l1l11lIII.Position - lIIIl1ll1l11).Magnitude > 50 then
                            SmartTeleport(CFrame.new(lIIIl1ll1l11 + Vector3.new(0, 15, -20)))
                        else
                            l11l1l11lIII.Velocity = Vector3.zero
                        end
                    end
                end
            end
            task.wait(0.5) -- Wait briefly for respawns if no targets found
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if l11ll11II1l1.autoDungeon then
            local l1lIll1I1I11 = 77747658251236
            local lll1lIl111II = {
                [75159314259063] = true, -- Cid
                [99684056491472] = true, -- Rune
                [123955125827131] = true, -- Double
                [96767841099256] = true -- Boss Rush
            }
            if game.PlaceId == l1lIll1I1I11 then
                local IIII11lI1I1l = Il1111lIl1I1.Character and Il1111lIl1I1.Character:GetAttribute("LastDungeonReq") or 0
                if tick() - IIII11lI1I1l > 5 then
                    if Il1111lIl1I1.Character then Il1111lIl1I1.Character:SetAttribute("LastDungeonReq", tick()) end
                    if IIIllIlIl1I1 then pcall(function() IIIllIlIl1I1:FireServer(l11ll11II1l1.dungeonType) end) end
                end
            elseif lll1lIl111II[game.PlaceId] then
                if IIl1ll1IlI1l then pcall(function() IIl1ll1IlI1l:FireServer(l11ll11II1l1.dungeonDiff) end) end
            end
        end
        if l11ll11II1l1.autoInfiniteTower then
            local l1lIll1I1I11 = 77747658251236
            if game.PlaceId == l1lIll1I1I11 then
                if IIIllIlIl1I1 then pcall(function() IIIllIlIl1I1:FireServer("InfiniteTower") end) end
            elseif game.PlaceId == 138368689293913 then
                if IIl1ll1IlI1l then pcall(function() IIl1ll1IlI1l:FireServer("start") end) end
                pcall(function()
                    local I1ll11lI1lI1 = Il1111lIl1I1:FindFirstChild("PlayerGui")
                    if I1ll11lI1lI1 then
                        local II1l11111lII = I1ll11lI1lI1:FindFirstChild("InfiniteTowerUI") or I1ll11lI1lI1:FindFirstChild("TowerUI")
                        if II1l11111lII and II1l11111lII.Enabled then II1l11111lII.Enabled = false end
                    end
                end)
            end
        end
    end
end)
