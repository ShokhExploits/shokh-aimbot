--[[
╔═══════════════════════════════════════════════════╗
║        S H O K H   v2.2  –  by Shokh             ║
║  RightShift → open / close                        ║
║  ESP · Rainbow · Silent Aim · Big Head            ║
║  Gun Mods · Anti-Aim · Full Bright · Configs     ║
╚═══════════════════════════════════════════════════╝

  KEYSYSTEM: Secure authentication on startup
  
  SILENT AIM: hooks Mouse.__index so every weapon's
  raycast/tool hit lands on the target's chosen part.
  No camera rotation at all — completely silent.

  BIG HEAD: enlarges Head BasePart for easier hits.

  GUN MODS: No spread, infinite ammo, no reload,
  hit chance & head hit chance adjustments.

  CONFIG: 3 named slots. Save & load independently.
]]

-- ────────────────────────────────────────────────────
--  SERVICES
-- ────────────────────────────────────────────────────
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting         = game:GetService("Lighting")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")

local LP     = Players.LocalPlayer
local PGui   = LP:WaitForChild("PlayerGui")
local Mouse  = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- ════════════════════════════════════════════════════════════════════════════
--  KEYSYSTEM
-- ════════════════════════════════════════════════════════════════════════════
local keySystemPassed = false

local function createKeySystem()
    -- Root ScreenGui
    local ksg = Instance.new("ScreenGui")
    ksg.Name = "ShokhKeySystem"
    ksg.ResetOnSpawn = false
    ksg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ksg.IgnoreGuiInset = true
    ksg.Parent = PGui
    
    -- Background (dark blur effect)
    local bgFill = Instance.new("Frame")
    bgFill.Size = UDim2.new(1, 0, 1, 0)
    bgFill.BackgroundColor3 = Color3.new(0, 0, 0)
    bgFill.BackgroundTransparency = 0.5
    bgFill.BorderSizePixel = 0
    bgFill.ZIndex = 1
    bgFill.Parent = ksg
    
    -- Main card
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 380, 0, 320)
    card.Position = UDim2.new(0.5, -190, 0.5, -160)
    card.BackgroundColor3 = Color3.fromRGB(14, 17, 27)
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = ksg
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(80, 160, 255)
    stroke.Thickness = 2
    stroke.Parent = card
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "SHOKH KEY SYSTEM"
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(80, 160, 255)
    title.Parent = card
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -20, 0, 24)
    subtitle.Position = UDim2.new(0, 10, 0, 54)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Enter your key to continue"
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextColor3 = Color3.fromRGB(108, 118, 146)
    subtitle.Parent = card
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -40, 0, 42)
    inputBox.Position = UDim2.new(0, 20, 0, 95)
    inputBox.BackgroundColor3 = Color3.fromRGB(26, 31, 48)
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = "Key..."
    inputBox.PlaceholderColor3 = Color3.fromRGB(62, 72, 100)
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextColor3 = Color3.fromRGB(232, 236, 248)
    inputBox.TextXAlignment = Enum.TextXAlignment.Center
    inputBox.Parent = card
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = Color3.fromRGB(44, 92, 188)
    inputStroke.Thickness = 1.5
    inputStroke.Parent = inputBox
    
    -- Error label
    local errorLbl = Instance.new("TextLabel")
    errorLbl.Size = UDim2.new(1, -40, 0, 20)
    errorLbl.Position = UDim2.new(0, 20, 0, 147)
    errorLbl.BackgroundTransparency = 1
    errorLbl.Text = ""
    errorLbl.TextSize = 11
    errorLbl.Font = Enum.Font.Gotham
    errorLbl.TextColor3 = Color3.fromRGB(218, 52, 52)
    errorLbl.Parent = card
    
    -- Submit button
    local submitBtn = Instance.new("TextButton")
    submitBtn.Size = UDim2.new(1, -40, 0, 40)
    submitBtn.Position = UDim2.new(0, 20, 0, 175)
    submitBtn.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    submitBtn.BorderSizePixel = 0
    submitBtn.Text = "VERIFY"
    submitBtn.TextSize = 13
    submitBtn.Font = Enum.Font.GothamBold
    submitBtn.TextColor3 = Color3.new(1, 1, 1)
    submitBtn.Parent = card
    
    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitBtn
    
    -- Discord button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -40, 0, 35)
    discordBtn.Position = UDim2.new(0, 20, 0, 227)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = "🔗 Discord Key System"
    discordBtn.TextSize = 12
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextColor3 = Color3.new(1, 1, 1)
    discordBtn.Parent = card
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn
    
    -- Loading indicator
    local loadingDots = Instance.new("TextLabel")
    loadingDots.Size = UDim2.new(1, -40, 0, 20)
    loadingDots.Position = UDim2.new(0, 20, 0, 272)
    loadingDots.BackgroundTransparency = 1
    loadingDots.Text = ""
    loadingDots.TextSize = 10
    loadingDots.Font = Enum.Font.Gotham
    loadingDots.TextColor3 = Color3.fromRGB(108, 118, 146)
    loadingDots.Parent = card
    
    -- Entrance animation
    card.Position = UDim2.new(0.5, -190, -0.5, -160)
    -- smoother bounce entrance
    TweenService:Create(card, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -190, 0.5, -160)
    }):Play()
    
    TweenService:Create(bgFill, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.35
    }):Play()
    
    -- Events
    local verifyAttempts = 0
    local function verify()
        verifyAttempts = verifyAttempts + 1
        local input = inputBox.Text:lower()
        
        if input == "shokh" then
            errorLbl.Text = "✓ Access Granted!"
            errorLbl.TextColor3 = Color3.fromRGB(48, 196, 86)
            submitBtn.BackgroundColor3 = Color3.fromRGB(48, 196, 86)
            
            task.wait(0.8)
            
            -- Fade out animation
            TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, -190, 1.5, -160)
            }):Play()
            
            TweenService:Create(bgFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(0.5)
            keySystemPassed = true
            ksg:Destroy()
        else
            errorLbl.Text = "✗ Invalid key! Attempts: " .. verifyAttempts
            inputBox.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
            
            task.wait(1.5)
            inputBox.BackgroundColor3 = Color3.fromRGB(26, 31, 48)
            errorLbl.Text = ""
            inputBox.Text = ""
        end
    end
    
    submitBtn.MouseButton1Click:Connect(verify)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then verify() end
    end)
    
    -- Discord button opens link in Chrome
    discordBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local url = "https://discord.gg/vXJ6PJCTjY"
            if jit.os == "Windows" then
                os.execute('start chrome "' .. url .. '"')
            else
                os.execute('open "' .. url .. '"')
            end
        end)
    end)

    -- Close button (visual only - does not bypass key)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,28,0,28)
    closeBtn.Position = UDim2.new(1,-36,0,8)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.TextColor3 = Color3.fromRGB(200,200,200)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = card
    closeBtn.MouseButton1Click:Connect(function()
        -- small shake animation to indicate can't close
        local orig = card.Position
        for i=1,3 do
            TweenService:Create(card, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = orig + UDim2.new(0,6,0,0)}):Play()
            task.wait(0.05)
            TweenService:Create(card, TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = orig + UDim2.new(0,-6,0,0)}):Play()
            task.wait(0.05)
        end
        TweenService:Create(card, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = orig}):Play()
    end)

    -- Prevent escape from bypassing: play a subtle flash when ESC pressed
    local escConn; escConn = UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.Escape then
            -- flash border
            local origCol = stroke.Color
            stroke.Color = Color3.fromRGB(218,52,52)
            task.delay(0.18, function() stroke.Color = origCol end)
        end
    end)
    
    -- Loading animation
    local dotCount = 0
    local dotConn
    dotConn = RunService.Heartbeat:Connect(function()
        if not loadingDots.Parent then
            dotConn:Disconnect()
            return
        end
        dotCount = (dotCount + 1) % 3
        loadingDots.Text = "Waiting for key..." .. string.rep(".", dotCount + 1)
    end)
    
    -- Wait for key system to pass
    repeat task.wait(0.1) until keySystemPassed
end

createKeySystem()
repeat task.wait(0.1) until keySystemPassed

-- ════════════════════════════════════════════════════════════════════════════
local DEFAULT = {
    esp=false, rainbow=false,
    espR=255, espG=60, espB=60,
    silentAim=false, fov=80, showFov=true, hitPart="Head",
    bigHead=false, bigHeadSize=20,
    aimbot=false, aimbotSpeed=8,
    noShadow=false, fullBright=false,
    uiKey="RightShift",
    -- Aim keybind (default MouseButton2)
    aimKey="MouseButton2",
    -- Gun mods
    gunNoSpread=false, gunInfAmmo=false, gunNoReload=false,
    gunHitChance=100, gunHeadHitChance=100,
    -- ESP Tools
    espBoxFull=false, espBoxCorner=false, espTracer=false,
    espNameLabels=false, espDistanceDisplay=false,
}

local cfg = {}
for k,v in pairs(DEFAULT) do cfg[k]=v end

local slotNames = {"Config 1","Config 2","Config 3"}

local function slotPath(n) return "shokh_slot"..n..".json" end
local function namesPath()  return "shokh_names.json" end

-- ── Save: write cfg + names ───────────────────────────
local function saveSlot(n)
    local ok1, err1 = pcall(function()
        local data = HttpService:JSONEncode(cfg)
        if data then
            writefile(slotPath(n), data)
        end
    end)
    
    local ok2, err2 = pcall(function()
        local data = HttpService:JSONEncode(slotNames)
        if data then
            writefile(namesPath(), data)
        end
    end)
    
    return ok1 and ok2
end

-- ── Load: read cfg, return true on success ────────────
local function loadSlot(n)
    local ok, data = pcall(function()
        if not isfile(slotPath(n)) then return nil end
        local content = readfile(slotPath(n))
        return HttpService:JSONDecode(content)
    end)
    
    if ok and data and type(data) == "table" then
        for k, v in pairs(data) do
            if cfg[k] ~= nil then 
                cfg[k] = v 
            end
        end
        return true
    end
    
    return false
end

-- Load saved names on startup
pcall(function()
    if isfile(namesPath()) then
        local content = readfile(namesPath())
        local d = HttpService:JSONDecode(content)
        for i = 1, 3 do 
            if type(d[i]) == "string" then 
                slotNames[i] = d[i] 
            end 
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════════════
--  GUN MODS
-- ════════════════════════════════════════════════════════════════════════════

local gunConnections = {} -- map tool -> {conns}
local lastAmmo = {}

local function setupGunMods()
    for tool, conns in pairs(gunConnections) do
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    end
    gunConnections = {}
    
    if not (cfg.gunNoSpread or cfg.gunInfAmmo or cfg.gunNoReload or 
            cfg.gunHitChance < 100 or cfg.gunHeadHitChance < 100) then
        return
    end
    
    -- Hook tool activation
    local function hookTool(tool)
        if not tool or not tool:IsA or not tool:IsA("Tool") then return end
        -- avoid double-hook
        if gunConnections[tool] then return end
        local conns = {}

        -- Infinite ammo heartbeat
        if cfg.gunInfAmmo then
            local ammoConn = RunService.Heartbeat:Connect(function()
                if not cfg.gunInfAmmo or not tool or not tool.Parent then return end
                pcall(function()
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") then if ammo.Value <= 0 then ammo.Value = 999 end end
                    local mag = tool:FindFirstChild("Magazine") or tool:FindFirstChild("Mag")
                    if mag and mag:IsA("IntValue") then if mag.Value <= 0 then mag.Value = 999 end end
                    if tool:FindFirstChild("Handle") then
                        local handleAmmo = tool.Handle:FindFirstChild("Ammo")
                        if handleAmmo and handleAmmo:IsA("IntValue") then if handleAmmo.Value <= 0 then handleAmmo.Value = 999 end end
                    end
                end)
            end)
            table.insert(conns, ammoConn)
        end

        -- No reload: try to intercept reload-related events conservatively
        if cfg.gunNoReload then
            -- also watch for child changes that look like magazine depletion
            local reloadConn = tool.DescendantAdded:Connect(function(desc)
                pcall(function()
                    local mag = tool:FindFirstChild("Magazine") or tool:FindFirstChild("Mag")
                    if mag and mag:IsA("IntValue") then mag.Value = math.max(mag.Value, 1) end
                    local ammo = tool:FindFirstChild("Ammo")
                    if ammo and ammo:IsA("IntValue") then ammo.Value = math.max(ammo.Value, 1) end
                end)
            end)
            table.insert(conns, reloadConn)
        end

        -- No spread
        if cfg.gunNoSpread then
            local spreadConn = RunService.Heartbeat:Connect(function()
                if not cfg.gunNoSpread or not tool or not tool.Parent then return end
                pcall(function()
                    local spread = tool:FindFirstChild("Spread")
                    if spread then
                        if spread:IsA("Vector3Value") then spread.Value = Vector3.new(0,0,0)
                        elseif spread:IsA("NumberValue") then spread.Value = 0 end
                    end
                end)
            end)
            table.insert(conns, spreadConn)
        end

        gunConnections[tool] = conns

        -- cleanup when tool removed
        local anc; anc = tool.AncestryChanged:Connect(function()
            if not tool.Parent then
                if gunConnections[tool] then
                    for _, c in ipairs(gunConnections[tool]) do pcall(function() c:Disconnect() end) end
                    gunConnections[tool] = nil
                end
                anc:Disconnect()
            end
        end)
    end
    
    -- Hook all tools in backpack
    for _, tool in ipairs(LP.Backpack:GetChildren()) do
        hookTool(tool)
    end
    -- Hook tools present in character
    if LP.Character then
        for _, tool in ipairs(LP.Character:GetChildren()) do
            hookTool(tool)
        end
    end

    -- Hook tools when character spawns and when tools are added to character/backpack
    local charConn = LP.CharacterAdded:Connect(function(char)
        task.wait(0.1)
        for _, tool in ipairs(char:GetChildren()) do
            hookTool(tool)
        end
        char.ChildAdded:Connect(function(c)
            task.wait(0.05)
            hookTool(c)
        end)
    end)
    table.insert(gunConnections, charConn)

    -- Hook new tools added to backpack
    local backpackConn = LP.Backpack.ChildAdded:Connect(function(child)
        task.wait(0.05)
        hookTool(child)
    end)
    table.insert(gunConnections, backpackConn)
end

-- ════════════════════════════════════════════════════════════════════════════
--  ESP TOOLS: Box, Tracer, Names, Distance
-- ════════════════════════════════════════════════════════════════════════════

local espConnections = {}
local espPool = {}

local function getESPColor()
    if cfg.rainbow then
        return Color3.fromHSV(math.random() / 1, 0.8, 1)
    else
        return Color3.fromRGB(cfg.espR, cfg.espG, cfg.espB)
    end
end

local function createDrawing(typeName)
    local ok, obj = pcall(function() return Drawing.new(typeName) end)
    if ok and obj then return obj end
    return nil
end

local function drawBoxESPFor(player, screenPos, size, color, isFull)
    -- persistent drawings per-player stored in espPool
    if not espPool[player] then espPool[player] = {} end
    local pool = espPool[player]
    local boxSize = math.max(6, size * 20)
    local halfBox = boxSize / 2

    -- Full box
    if isFull then
        if not pool.box then pool.box = createDrawing("Square") or createDrawing("Rectangle") end
        local box = pool.box
        if box then
            pcall(function()
                box.Position = Vector2.new(screenPos.X - halfBox, screenPos.Y - halfBox)
                box.Size = Vector2.new(boxSize, boxSize)
                box.Color = color
                box.Visible = true
                box.Filled = false
                box.Thickness = 1.5
            end)
        end
    else
        -- corner box: use up to 8 lines
        pool.corners = pool.corners or {}
        local corners = {
            {pos = Vector2.new(screenPos.X - halfBox, screenPos.Y - halfBox), pos2 = Vector2.new(screenPos.X - halfBox + boxSize/4, screenPos.Y - halfBox)},
            {pos = Vector2.new(screenPos.X - halfBox, screenPos.Y - halfBox), pos2 = Vector2.new(screenPos.X - halfBox, screenPos.Y - halfBox + boxSize/4)},
            {pos = Vector2.new(screenPos.X + halfBox, screenPos.Y + halfBox), pos2 = Vector2.new(screenPos.X + halfBox - boxSize/4, screenPos.Y + halfBox)},
            {pos = Vector2.new(screenPos.X + halfBox, screenPos.Y + halfBox), pos2 = Vector2.new(screenPos.X + halfBox, screenPos.Y + halfBox - boxSize/4)},
            {pos = Vector2.new(screenPos.X - halfBox, screenPos.Y + halfBox), pos2 = Vector2.new(screenPos.X - halfBox + boxSize/4, screenPos.Y + halfBox)},
            {pos = Vector2.new(screenPos.X - halfBox, screenPos.Y + halfBox), pos2 = Vector2.new(screenPos.X - halfBox, screenPos.Y + halfBox - boxSize/4)},
            {pos = Vector2.new(screenPos.X + halfBox, screenPos.Y - halfBox), pos2 = Vector2.new(screenPos.X + halfBox - boxSize/4, screenPos.Y - halfBox)},
            {pos = Vector2.new(screenPos.X + halfBox, screenPos.Y - halfBox), pos2 = Vector2.new(screenPos.X + halfBox, screenPos.Y - halfBox + boxSize/4)},
        }
        for i, corner in ipairs(corners) do
            if not pool.corners[i] then pool.corners[i] = createDrawing("Line") end
            local line = pool.corners[i]
            if line then
                pcall(function()
                    line.From = corner.pos
                    line.To = corner.pos2
                    line.Color = color
                    line.Thickness = 1.5
                    line.Transparency = 1
                    line.Visible = true
                end)
            end
        end
    end
end

local function clearESPPoolFor(player)
    local pool = espPool[player]
    if not pool then return end
    pcall(function()
        if pool.box then pcall(function() pool.box:Remove() end) end
        if pool.tracer then pcall(function() pool.tracer:Remove() end) end
        if pool.name then pcall(function() pool.name:Remove() end) end
        if pool.dist then pcall(function() pool.dist:Remove() end) end
        if pool.corners then for _, l in ipairs(pool.corners) do pcall(function() if l then l:Remove() end end) end end
    end)
    espPool[player] = nil
end

local espRenderConn
local function setupESPTools()
    if espRenderConn then pcall(function() espRenderConn:Disconnect() end) end
    -- clear old drawings
    for p,_ in pairs(espPool) do clearESPPoolFor(p) end

    if not (cfg.espBoxFull or cfg.espBoxCorner or cfg.espTracer or cfg.espNameLabels or cfg.espDistanceDisplay) then return end

    espRenderConn = RunService.RenderStepped:Connect(function()
        local lpHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            local char = p.Character
            if not char then clearESPPoolFor(p); continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then clearESPPoolFor(p); continue end

            local part = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
            if not part then clearESPPoolFor(p); continue end

            local espColor = getESPColor()
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local size = (Camera:WorldToViewportPoint(part.Position + part.CFrame.LookVector * 5) - Vector3.new(screenPos.X, screenPos.Y, 0)).Magnitude / 10
                if cfg.espBoxFull then drawBoxESPFor(p, Vector2.new(screenPos.X, screenPos.Y), size, espColor, true) else if espPool[p] and espPool[p].box then pcall(function() espPool[p].box.Visible = false end) end end
                if cfg.espBoxCorner then drawBoxESPFor(p, Vector2.new(screenPos.X, screenPos.Y), size, espColor, false) else if espPool[p] and espPool[p].corners then for _,l in ipairs(espPool[p].corners) do pcall(function() l.Visible = false end) end end
                if cfg.espTracer and lpHrp then
                    if not espPool[p] then espPool[p] = {} end
                    if not espPool[p].tracer then espPool[p].tracer = createDrawing("Line") end
                    local line = espPool[p].tracer
                    if line then pcall(function()
                        local s1 = Camera:WorldToViewportPoint(lpHrp.Position)
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Color = espColor
                        line.Thickness = 1.5
                        line.Transparency = 0.7
                        line.Visible = true
                    end) end
                else
                    if espPool[p] and espPool[p].tracer then pcall(function() espPool[p].tracer.Visible = false end) end
                end

                if cfg.espNameLabels then
                    if not espPool[p] then espPool[p] = {} end
                    if not espPool[p].name then espPool[p].name = createDrawing("Text") end
                    local text = espPool[p].name
                    if text then pcall(function()
                        text.Position = Vector2.new(screenPos.X, screenPos.Y - 30)
                        text.Text = p.Name
                        text.Color = espColor
                        text.Size = 16
                        text.Center = true
                        text.Outline = true
                        text.OutlineColor = Color3.new(0,0,0)
                        text.Visible = true
                    end) end
                else if espPool[p] and espPool[p].name then pcall(function() espPool[p].name.Visible = false end) end end

                if cfg.espDistanceDisplay and lpHrp then
                    if not espPool[p] then espPool[p] = {} end
                    if not espPool[p].dist then espPool[p].dist = createDrawing("Text") end
                    local t = espPool[p].dist
                    if t then pcall(function()
                        local dist = math.floor((lpHrp.Position - part.Position).Magnitude)
                        t.Position = Vector2.new(screenPos.X, screenPos.Y + 10)
                        t.Text = "["..dist.."m]"
                        t.Color = espColor
                        t.Size = 14
                        t.Center = true
                        t.Outline = true
                        t.OutlineColor = Color3.new(0,0,0)
                        t.Visible = true
                    end) end
                else if espPool[p] and espPool[p].dist then pcall(function() espPool[p].dist.Visible = false end) end end
            else
                -- off-screen: hide any drawings
                if espPool[p] then
                    pcall(function()
                        if espPool[p].box then espPool[p].box.Visible = false end
                        if espPool[p].tracer then espPool[p].tracer.Visible = false end
                        if espPool[p].name then espPool[p].name.Visible = false end
                        if espPool[p].dist then espPool[p].dist.Visible = false end
                        if espPool[p].corners then for _,l in ipairs(espPool[p].corners) do l.Visible = false end end
                    end)
                end
            end
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════════════
local HL_NAME = "ShokhHL"

local function espCol()
    return Color3.fromRGB(cfg.espR, cfg.espG, cfg.espB)
end

local function getHL(char)
    return char:FindFirstChild(HL_NAME)
end

local function addHL(player, char)
    if player == LP or getHL(char) then return end
    local h = Instance.new("Highlight")
    h.Name             = HL_NAME
    h.Adornee          = char
    h.DepthMode        = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor        = espCol()
    h.OutlineColor     = Color3.new(1,1,1)
    h.FillTransparency = 0.45
    h.Parent           = char
end

local function removeHL(char)
    local h = getHL(char); if h then h:Destroy() end
end

local function refreshESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        local c = p.Character; if not c then continue end
        if cfg.esp then addHL(p,c) else removeHL(c) end
    end
end

-- ────────────────────────────────────────────────────
--  BIG HEAD
-- ────────────────────────────────────────────────────
local bhConns = {}
local hitboxes = {}

local function ensureHitboxForChar(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    -- remove existing
    local existing = char:FindFirstChild("ShokhHitbox")
    if existing then existing:Destroy() end

    local hb = Instance.new("Part")
    hb.Name = "ShokhHitbox"
    hb.Size = Vector3.new(cfg.bigHeadSize, cfg.bigHeadSize, cfg.bigHeadSize)
    hb.Transparency = 1
    hb.CanCollide = false
    hb.Anchored = false
    hb.Massless = true
    hb.Parent = char

    -- Position to head
    hb.CFrame = head.CFrame

    -- Weld to head so it follows movement
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hb; weld.Part1 = head; weld.Parent = hb

    hitboxes[char] = hb
    return hb
end

local function removeHitboxForChar(char)
    if not char then return end
    local hb = char:FindFirstChild("ShokhHitbox")
    if hb then hb:Destroy() end
    hitboxes[char] = nil
end

local function applyBigHead(player)
    if player == LP then return end
    local function doChar(char)
        if not char then return end
        removeHitboxForChar(char)
        if cfg.bigHead then
            ensureHitboxForChar(char)
        end
        char.AncestryChanged:Connect(function()
            removeHitboxForChar(char)
        end)
    end
    player.CharacterAdded:Connect(doChar)
    if player.Character then doChar(player.Character) end
end

local function restoreHeads()
    -- remove all hitboxes
    for char, hb in pairs(hitboxes) do
        pcall(function() if hb and hb.Parent then hb:Destroy() end end)
    end
    hitboxes = {}
end
end

-- ────────────────────────────────────────────────────
--  SILENT AIM
--  Strategy: hook Mouse.__index ONCE. When silentAim
--  is ON and a target is within FOV, return the fake
--  Hit/Target values. Works for all tool types because
--  every Roblox weapon reads Mouse.Hit to raycast.
-- ────────────────────────────────────────────────────

local currentTarget = nil  -- updated every RenderStepped
local hookedMt, origIndex = nil, nil

-- Aim bind state
local aimBindName = cfg and cfg.aimKey or "MouseButton2"
local aimBindInput = Enum.UserInputType.MouseButton2
local aimPressed = false

-- Find closest player part inside FOV circle
local function getTarget()
    local best, bestD = nil, math.huge
    local cx = Camera.ViewportSize.X / 2
    local cy = Camera.ViewportSize.Y / 2
    local hitPart = cfg.hitPart or "Head"
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP or not p.Character then continue end
        local char = p.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        
        -- prefer our hitbox if present
        local part = char:FindFirstChild("ShokhHitbox") or char:FindFirstChild(hitPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        
        local sp, vis = Camera:WorldToViewportPoint(part.Position)
        if vis then
            local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
            if d <= cfg.fov and d < bestD then
                -- apply hit chance filtering
                local pass = true
                local chance = math.random(1,100)
                if cfg.gunHitChance and cfg.gunHitChance < 100 then
                    -- for non-head parts use body chance
                    if tostring(hitPart):lower() ~= "head" then
                        if chance > cfg.gunHitChance then pass = false end
                    end
                end
                if tostring(hitPart):lower() == "head" and cfg.gunHeadHitChance and cfg.gunHeadHitChance < 100 then
                    local hc = math.random(1,100)
                    if hc > cfg.gunHeadHitChance then pass = false end
                end

                if pass then
                    bestD = d
                    best = part
                end
            end
        end
    end
    return best
end

-- Install hook
local function installHook()
    if hookedMt then return end
    local ok, mt = pcall(getrawmetatable, Mouse)
    if not ok or not mt then return end
    pcall(setreadonly, mt, false)
    origIndex = mt.__index
    
    mt.__index = function(self, key)
            local aimActive = (cfg.silentAim or aimPressed)
            if aimActive and currentTarget and currentTarget.Parent then
                if key == "Hit" then 
                    -- return exact CFrame of the target part
                    return (currentTarget.CFrame or CFrame.new(currentTarget.Position))
                elseif key == "Target" then 
                    return currentTarget 
                elseif key == "X" then 
                    return Camera.ViewportSize.X / 2
                elseif key == "Y" then 
                    return Camera.ViewportSize.Y / 2
                end
            end
        
        if type(origIndex) == "function" then 
            return origIndex(self, key) 
        end
        return rawget(origIndex, key) or origIndex[key]
    end
    
    pcall(setreadonly, mt, true)
    hookedMt = mt
end

local function removeHook()
    if not hookedMt or not origIndex then return end
    pcall(setreadonly, hookedMt, false)
    hookedMt.__index = origIndex
    pcall(setreadonly, hookedMt, true)
    hookedMt = nil; origIndex = nil
end

-- Install at startup and never remove (toggled by cfg.silentAim flag instead)
installHook()

-- Update target every render frame
RunService.RenderStepped:Connect(function()
    local aimActive = (cfg.silentAim or aimPressed)
    if aimActive then
        currentTarget = getTarget()
        if currentTarget and (not currentTarget.Parent or currentTarget:IsDescendantOf(LP.Character)) then
            currentTarget = nil
        end
    else
        currentTarget = nil
    end
end)

-- Aimbot: smooth camera aim when enabled and aiming
RunService.RenderStepped:Connect(function(dt)
    if cfg.aimbot and aimPressed and currentTarget and currentTarget.Parent then
        local cam = Camera
        local tgtPos = currentTarget.Position
        local desired = CFrame.new(cam.CFrame.Position, tgtPos)
        cam.CFrame = cam.CFrame:Lerp(desired, math.clamp(dt * cfg.aimbotSpeed, 0, 1))
    end
end)

-- ────────────────────────────────────────────────────
--  NO SHADOW / FULL BRIGHT
-- ────────────────────────────────────────────────────
local origShadow, origSoft
local function applyNoShadow(on)
    if on then
        origShadow = Lighting.GlobalShadows
        origSoft   = Lighting.ShadowSoftness
        Lighting.GlobalShadows  = false
        Lighting.ShadowSoftness = 1
    else
        if origShadow~=nil then Lighting.GlobalShadows  = origShadow end
        if origSoft        then Lighting.ShadowSoftness = origSoft   end
    end
end

local origBright, origAmb, origOut, origFog
local function applyFullBright(on)
    if on then
        origBright = Lighting.Brightness
        origAmb    = Lighting.Ambient
        origOut    = Lighting.OutdoorAmbient
        origFog    = Lighting.FogEnd
        Lighting.Brightness     = 2
        Lighting.Ambient        = Color3.new(1,1,1)
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.FogEnd         = 1e5
    else
        if origBright then Lighting.Brightness     = origBright end
        if origAmb    then Lighting.Ambient        = origAmb    end
        if origOut    then Lighting.OutdoorAmbient = origOut    end
        if origFog    then Lighting.FogEnd         = origFog    end
    end
end

-- ────────────────────────────────────────────────────
--  PLAYER LIFECYCLE
-- ────────────────────────────────────────────────────
local function onPlayerAdded(p)
    p.CharacterAdded:Connect(function(char)
        task.wait()
        if cfg.esp     then addHL(p, char) end
        if cfg.bigHead then applyBigHead(p) end
    end)
    if cfg.bigHead then applyBigHead(p) end
end

for _, p in ipairs(Players:GetPlayers()) do onPlayerAdded(p) end
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(p)
    if p.Character then removeHL(p.Character) end
    pcall(function() clearESPPoolFor(p) end)
end)
RunService.Heartbeat:Connect(refreshESP)

local function applyAll()
    refreshESP()
    applyNoShadow(cfg.noShadow)
    applyFullBright(cfg.fullBright)
    setupGunMods()
    setupESPTools()
    if cfg.bigHead then
        for _, p in ipairs(Players:GetPlayers()) do applyBigHead(p) end
    else
        restoreHeads()
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
--  GUI
-- ═══════════════════════════════════════════════════════════════════════════

-- ── Colour palette ──────────────────────────────────
local C = {
    win      = Color3.fromRGB(14, 17, 27),
    sidebar  = Color3.fromRGB(10, 12, 20),
    panel    = Color3.fromRGB(20, 25, 40),
    panelHov = Color3.fromRGB(26, 32, 50),
    accent   = Color3.fromRGB(80, 160, 255),
    accentDk = Color3.fromRGB(44,  92, 188),
    green    = Color3.fromRGB(48, 196,  86),
    red      = Color3.fromRGB(218,  52,  52),
    orange   = Color3.fromRGB(255, 158,  36),
    textPri  = Color3.fromRGB(232, 236, 248),
    textSec  = Color3.fromRGB(108, 118, 146),
    textDim  = Color3.fromRGB(62,  72,  100),
    border   = Color3.fromRGB(30,  36,  56),
    track    = Color3.fromRGB(26,  31,  48),
    tOn      = Color3.fromRGB(80, 160, 255),
    tOff     = Color3.fromRGB(42,  48,  68),
}

-- ── Helpers ─────────────────────────────────────────
local function mkCorner(r,p)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=p; return c
end
local function mkPad(t,b,l,r,p)
    local u=Instance.new("UIPadding")
    u.PaddingTop=UDim.new(0,t); u.PaddingBottom=UDim.new(0,b)
    u.PaddingLeft=UDim.new(0,l); u.PaddingRight=UDim.new(0,r)
    u.Parent=p
end
local function mkStroke(w,col,p)
    local s=Instance.new("UIStroke"); s.Thickness=w; s.Color=col; s.Parent=p; return s
end
local function mkFrame(bg,sz,pos,par)
    local f=Instance.new("Frame"); f.BackgroundColor3=bg; f.BorderSizePixel=0
    f.Size=sz or UDim2.new(1,0,1,0); f.Position=pos or UDim2.new(0,0,0,0)
    f.Parent=par; return f
end
local function mkLbl(txt,sz,col,xa,par)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1
    l.Text=txt; l.TextSize=sz; l.Font=Enum.Font.GothamBold
    l.TextColor3=col; l.TextXAlignment=xa or Enum.TextXAlignment.Left
    l.Size=UDim2.new(1,0,0,sz+6); l.Parent=par; return l
end
local function tw(obj,t,g)
    TweenService:Create(obj,TweenInfo.new(t,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),g):Play()
end

-- ── Root ScreenGui ──────────────────────────────────
if PGui:FindFirstChild("ShokhGui") then
    PGui:FindFirstChild("ShokhGui"):Destroy()
end
local sg=Instance.new("ScreenGui"); sg.Name="ShokhGui"
sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset=true; sg.Parent=PGui
sg.Enabled=false  -- Hidden until keysystem passes

-- ── FOV circle ──────────────────────────────────────
local fovF=Instance.new("Frame"); fovF.Name="FovCircle"
fovF.BackgroundTransparency=1; fovF.BorderSizePixel=0
fovF.ZIndex=50; fovF.Parent=sg
local fovRing=mkFrame(Color3.new(),UDim2.new(1,0,1,0),nil,fovF)
fovRing.BackgroundTransparency=1; mkCorner(999,fovRing)
mkStroke(1.5,Color3.fromRGB(255,255,255),fovRing)

local function syncFovCircle()
    local r=cfg.fov
    local cx,cy=Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2
    fovF.Size=UDim2.new(0,r*2,0,r*2)
    fovF.Position=UDim2.new(0,cx-r,0,cy-r)
    fovF.Visible=cfg.showFov and cfg.silentAim
end
RunService.Heartbeat:Connect(syncFovCircle)

-- ── Window ──────────────────────────────────────────
local WIN_W, WIN_H = 620, 430
local win = mkFrame(C.win,
    UDim2.new(0,WIN_W,0,WIN_H),
    UDim2.new(0.5,-WIN_W/2, 0.5,-WIN_H/2+22), sg)
mkCorner(12,win); mkStroke(1,C.border,win)
win.BackgroundTransparency=1

local shadowF=mkFrame(Color3.new(),UDim2.new(1,26,1,26),UDim2.new(0,-13,0,-13),sg)
shadowF.BackgroundTransparency=0.62; shadowF.ZIndex=win.ZIndex-1
mkCorner(16,shadowF); shadowF.Visible=false

-- Animate open
task.defer(function()
    -- Show loading screen first
    sg.Enabled = true
    
    win.Visible=true
    shadowF.Visible=true
    
    -- Start from off-screen
    win.Position = UDim2.new(0.5,-WIN_W/2, -0.5,-WIN_H/2)
    win.BackgroundTransparency = 1
    
    task.wait(0.2)
    
    -- Slide in with smooth animation
    tw(win, 0.6, {
        Position=UDim2.new(0.5,-WIN_W/2, 0.5,-WIN_H/2),
        BackgroundTransparency=0
    })
    tw(shadowF, 0.6, {BackgroundTransparency=0.62})
end)

-- ── Title bar ───────────────────────────────────────
local TH=44
local titleBar=mkFrame(C.sidebar,UDim2.new(1,0,0,TH),UDim2.new(0,0,0,0),win)
mkCorner(12,titleBar); mkPad(0,0,16,16,titleBar)
mkFrame(C.sidebar,UDim2.new(1,0,0,12),UDim2.new(0,0,1,-12),titleBar)

local titleLbl=mkLbl("Shokh",17,C.textPri,Enum.TextXAlignment.Left,titleBar)
titleLbl.Position=UDim2.new(0,0,0.5,-10); titleLbl.Size=UDim2.new(0,76,0,22)

local verLbl=mkLbl("v2.2",11,C.textDim,Enum.TextXAlignment.Left,titleBar)
verLbl.Position=UDim2.new(0,76,0.5,-6); verLbl.Size=UDim2.new(0,34,0,14)

local keyHint=mkLbl("RShift to toggle",11,C.textSec,Enum.TextXAlignment.Right,titleBar)
keyHint.Position=UDim2.new(1,-220,0.5,-8); keyHint.Size=UDim2.new(0,220,0,18)

-- ── Body ────────────────────────────────────────────
local body=mkFrame(C.win,UDim2.new(1,0,1,-TH),UDim2.new(0,0,0,TH),win)

local SW=150
local sideBox=mkFrame(C.sidebar,UDim2.new(0,SW,1,-16),UDim2.new(0,8,0,8),body)
mkCorner(10,sideBox); mkStroke(1,C.border,sideBox); mkPad(8,8,7,7,sideBox)
local sideLL=Instance.new("UIListLayout")
sideLL.SortOrder=Enum.SortOrder.LayoutOrder
sideLL.Padding=UDim.new(0,3); sideLL.Parent=sideBox

local pageArea=mkFrame(Color3.new(),
    UDim2.new(1,-SW-24,1,-16),
    UDim2.new(0,SW+16,0,8),body)
pageArea.BackgroundTransparency=1

-- ═══════════════════════════════════════════════════════════════════════════
--  WIDGET FACTORY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

local tabs, tabFrames = {}, {}
local activeTab = nil

-- ── mkTab ───────────────────────────────────────────
local function mkTab(name,icon,order)
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.new(1,0,0,38); btn.BackgroundColor3=C.sidebar
    btn.BorderSizePixel=0; btn.Text=icon.."  "..name
    btn.TextSize=13; btn.Font=Enum.Font.GothamBold
    btn.TextColor3=C.textSec; btn.TextXAlignment=Enum.TextXAlignment.Left
    btn.LayoutOrder=order; btn.Parent=sideBox
    mkCorner(8,btn); mkPad(0,0,10,0,btn)

    local pg=mkFrame(Color3.new(),UDim2.new(1,0,1,0),UDim2.new(0,0,0,0),pageArea)
    pg.BackgroundTransparency=1; pg.Visible=false

    local sc=Instance.new("ScrollingFrame")
    sc.Size=UDim2.new(1,0,1,0); sc.BackgroundTransparency=1
    sc.BorderSizePixel=0; sc.ScrollBarThickness=3
    sc.ScrollBarImageColor3=C.border; sc.CanvasSize=UDim2.new(0,0,0,0)
    sc.AutomaticCanvasSize=Enum.AutomaticSize.Y; sc.Parent=pg
    mkPad(2,8,0,4,sc)

    local ll=Instance.new("UIListLayout")
    ll.SortOrder=Enum.SortOrder.LayoutOrder; ll.Padding=UDim.new(0,5); ll.Parent=sc

    tabs[name]=btn; tabFrames[name]={frame=pg,scroll=sc}

    btn.MouseButton1Click:Connect(function()
        if activeTab==name then return end
        for n,b in pairs(tabs) do
            tw(b,0.15,{
                BackgroundColor3=n==name and C.panel or C.sidebar,
                TextColor3=n==name and C.textPri or C.textSec
            })
        end
        for _,tf in pairs(tabFrames) do 
            if tf.frame.Visible then
                tw(tf.frame, 0.1, {BackgroundTransparency=1})
                task.delay(0.05, function() tf.frame.Visible=false; tf.frame.BackgroundTransparency=0 end)
            end
        end
        pg.Visible=true
        tw(pg, 0.1, {BackgroundTransparency=0})
        activeTab=name
    end)
    return sc
end

-- ── mkRow ───────────────────────────────────────────
local function mkRow(par,h,order)
    local r=mkFrame(C.panel,UDim2.new(1,0,0,h or 50),nil,par)
    r.LayoutOrder=order or 0; mkCorner(8,r); mkPad(0,0,14,14,r)
    r.MouseEnter:Connect(function() 
        tw(r, 0.12, {BackgroundColor3=C.panelHov}) 
    end)
    r.MouseLeave:Connect(function() 
        tw(r, 0.12, {BackgroundColor3=C.panel}) 
    end)
    return r
end

-- ── mkSec ───────────────────────────────────────────
local function mkSec(par,txt,order)
    local l=Instance.new("TextLabel"); l.BackgroundTransparency=1
    l.Text=txt; l.TextSize=9; l.Font=Enum.Font.GothamBold
    l.TextColor3=C.textDim; l.TextXAlignment=Enum.TextXAlignment.Left
    l.Size=UDim2.new(1,0,0,16); l.LayoutOrder=order or 0; l.Parent=par
    mkPad(0,0,4,0,l)
end

-- ── mkToggle ────────────────────────────────────────
local function mkToggle(par,name,sub,init,order,onChange)
    local row=mkRow(par,50,order)
    local nl=mkLbl(name,13,C.textPri,nil,row)
    nl.Position=UDim2.new(0,0,0,8); nl.Size=UDim2.new(0.78,0,0,17)
    if sub then
        local sl=mkLbl(sub,10,C.textSec,nil,row)
        sl.Font=Enum.Font.Gotham; sl.Position=UDim2.new(0,0,0,27)
        sl.Size=UDim2.new(0.78,0,0,14)
    end
    local pill=Instance.new("TextButton")
    pill.Size=UDim2.new(0,46,0,26); pill.Position=UDim2.new(1,-46,0.5,-13)
    pill.BorderSizePixel=0; pill.Text=""; pill.Parent=row; mkCorner(13,pill)
    local knob=mkFrame(Color3.new(1,1,1),UDim2.new(0,20,0,20),UDim2.new(0,3,0.5,-10),pill)
    mkCorner(10,knob)
    local v=init
    local function refresh(val)
        tw(pill,0.18,{BackgroundColor3=val and C.tOn or C.tOff})
        tw(knob,0.18,{Position=val and UDim2.new(1,-23,0.5,-10) or UDim2.new(0,3,0.5,-10)})
    end
    refresh(v)
    pill.MouseButton1Click:Connect(function() 
        v=not v
        refresh(v)
        onChange(v) 
    end)
    return function(nv) v=nv; refresh(v) end  -- sync function
end

-- ── mkSlider ────────────────────────────────────────
local function mkSlider(par,name,sub,mn,mx,init,order,onChange)
    local row=mkRow(par,64,order)
    local nl=mkLbl(name,13,C.textPri,nil,row)
    nl.Position=UDim2.new(0,0,0,7); nl.Size=UDim2.new(0.62,0,0,17)
    local vLbl=Instance.new("TextLabel"); vLbl.BackgroundTransparency=1
    vLbl.TextSize=12; vLbl.Font=Enum.Font.GothamBold
    vLbl.TextColor3=C.accent; vLbl.TextXAlignment=Enum.TextXAlignment.Right
    vLbl.Size=UDim2.new(0.38,0,0,17); vLbl.Position=UDim2.new(0.62,0,0,7)
    vLbl.Parent=row
    if sub then
        local sl=mkLbl(sub,10,C.textSec,nil,row)
        sl.Font=Enum.Font.Gotham; sl.Position=UDim2.new(0,0,0,25)
        sl.Size=UDim2.new(0.7,0,0,13)
    end
    local track=mkFrame(C.track,UDim2.new(1,0,0,6),UDim2.new(0,0,1,-14),row)
    mkCorner(3,track)
    local fill=mkFrame(C.accent,UDim2.new(0,0,1,0),UDim2.new(0,0,0,0),track)
    mkCorner(3,fill)
    local knob=mkFrame(Color3.new(1,1,1),UDim2.new(0,14,0,14),UDim2.new(0,-7,0.5,-7),fill)
    mkCorner(7,knob); mkStroke(2,C.accent,knob)
    local dragging=false
    local function setV(nv)
        nv=math.clamp(math.floor(nv+0.5),mn,mx)
        local pct=(nv-mn)/(mx-mn)
        fill.Size=UDim2.new(pct,0,1,0)
        vLbl.Text=tostring(nv); onChange(nv)
    end
    setV(init)
    track.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=true
            local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            setV(mn+rel*(mx-mn))
        end
    end)
    track.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rel=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            setV(mn+rel*(mx-mn))
        end
    end)
    return setV
end

-- ── mkDropdown ──────────────────────────────────────
local function mkDropdown(par,name,opts,init,order,onChange)
    local row=mkRow(par,50,order)
    local nl=mkLbl(name,13,C.textPri,nil,row)
    nl.Position=UDim2.new(0,0,0.5,-9); nl.Size=UDim2.new(0.5,0,0,18)
    local db=Instance.new("TextButton")
    db.Size=UDim2.new(0,132,0,28); db.Position=UDim2.new(1,-132,0.5,-14)
    db.BackgroundColor3=C.sidebar; db.BorderSizePixel=0
    db.Text=init.."  ▾"; db.TextSize=11; db.Font=Enum.Font.GothamBold
    db.TextColor3=C.textPri; db.Parent=row; mkCorner(6,db); mkStroke(1,C.border,db)
    
    db.MouseEnter:Connect(function()
        tw(db, 0.1, {BackgroundColor3=Color3.fromRGB(35, 42, 65)})
    end)
    db.MouseLeave:Connect(function()
        if not dl.Visible then
            tw(db, 0.1, {BackgroundColor3=C.sidebar})
        end
    end)
    
    local dl=mkFrame(C.sidebar,UDim2.new(0,132,0,#opts*30+6),UDim2.new(1,-132,1,4),row)
    dl.ZIndex=30; dl.Visible=false; mkCorner(6,dl); mkStroke(1,C.border,dl); mkPad(3,3,4,4,dl)
    local dll=Instance.new("UIListLayout")
    dll.SortOrder=Enum.SortOrder.LayoutOrder; dll.Padding=UDim.new(0,2); dll.Parent=dl
    for i,opt in ipairs(opts) do
        local ob=Instance.new("TextButton")
        ob.Size=UDim2.new(1,0,0,26); ob.BackgroundColor3=C.sidebar; ob.BorderSizePixel=0
        ob.Text=opt; ob.TextSize=11; ob.Font=Enum.Font.GothamBold
        ob.TextColor3=C.textPri; ob.LayoutOrder=i; ob.Parent=dl; mkCorner(5,ob)
        ob.MouseEnter:Connect(function() tw(ob,0.08,{BackgroundColor3=C.panelHov}) end)
        ob.MouseLeave:Connect(function() tw(ob,0.08,{BackgroundColor3=C.sidebar}) end)
        ob.MouseButton1Click:Connect(function()
            db.Text=opt.."  ▾"; dl.Visible=false; onChange(opt)
        end)
    end
    db.MouseButton1Click:Connect(function()
        dl.Visible=not dl.Visible
        tw(db, 0.12, {
            BackgroundColor3=dl.Visible and C.panelHov or C.sidebar,
            TextColor3=dl.Visible and C.accent or C.textPri
        })
    end)
    return function(v) db.Text=v.."  ▾" end
end

-- ── mkColorPicker ───────────────────────────────────
local function mkColorPicker(par,name,iR,iG,iB,order,onChange)
    local row=mkRow(par,114,order)
    local nl=mkLbl(name,13,C.textPri,nil,row)
    nl.Position=UDim2.new(0,0,0,5); nl.Size=UDim2.new(0.65,0,0,17)
    local swatch=mkFrame(Color3.fromRGB(iR,iG,iB),UDim2.new(0,40,0,28),UDim2.new(1,-40,0,4),row)
    mkCorner(7,swatch); mkStroke(1,C.border,swatch)
    local r,g,b=iR,iG,iB
    local function refSwatch() swatch.BackgroundColor3=Color3.fromRGB(r,g,b); onChange(r,g,b) end
    local sR,sG,sB
    local function miniBar(lTxt,col,yOff,iv,onCh)
        local bg=mkFrame(C.track,UDim2.new(1,0,0,6),UDim2.new(0,0,0,yOff),row); mkCorner(3,bg)
        local lt=Instance.new("TextLabel"); lt.BackgroundTransparency=1; lt.Text=lTxt
        lt.TextSize=9; lt.Font=Enum.Font.GothamBold; lt.TextColor3=col
        lt.TextXAlignment=Enum.TextXAlignment.Left
        lt.Size=UDim2.new(0,8,0,9); lt.Position=UDim2.new(0,-11,0,yOff-2); lt.Parent=row
        local ff=mkFrame(col,UDim2.new(iv/255,0,1,0),UDim2.new(0,0,0,0),bg)
        ff.BackgroundTransparency=0.3; mkCorner(3,ff)
        local kn=mkFrame(Color3.fromRGB(232,236,248),UDim2.new(0,11,0,11),UDim2.new(0,-5,0.5,-5),ff)
        mkCorner(6,kn)
        local dr=false
        local function sv(nv)
            nv=math.clamp(math.floor(nv+0.5),0,255)
            ff.Size=UDim2.new(nv/255,0,1,0); onCh(nv); refSwatch()
        end
        bg.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                dr=true
                sv((math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1))*255)
            end
        end)
        bg.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end
        end)
        kn.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
                sv((math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1))*255)
            end
        end)
        return function(v) ff.Size=UDim2.new(v/255,0,1,0) end
    end
    sR=miniBar("R",Color3.fromRGB(255,80,80), 30,iR,function(v) r=v end)
    sG=miniBar("G",Color3.fromRGB(60,210,90), 54,iG,function(v) g=v end)
    sB=miniBar("B",Color3.fromRGB(80,142,255),78,iB,function(v) b=v end)
    return function(rv,gv,bv) r=rv;g=gv;b=bv; sR(rv);sG(gv);sB(bv); refSwatch() end
end

-- ── mkKeybind ───────────────────────────────────────
local function mkKeybind(par,name,init,order,onChanged)
    local row=mkRow(par,50,order)
    local nl=mkLbl(name,13,C.textPri,nil,row)
    nl.Position=UDim2.new(0,0,0.5,-9); nl.Size=UDim2.new(0.5,0,0,18)
    local kb=Instance.new("TextButton")
    kb.Size=UDim2.new(0,128,0,28); kb.Position=UDim2.new(1,-128,0.5,-14)
    kb.BackgroundColor3=C.sidebar; kb.BorderSizePixel=0; kb.Text=init
    kb.TextSize=12; kb.Font=Enum.Font.GothamBold; kb.TextColor3=C.textPri
    kb.Parent=row; mkCorner(7,kb); mkStroke(1,C.border,kb)
    local listening=false
    kb.MouseButton1Click:Connect(function()
        if listening then return end
        listening=true
        kb.Text="[ press key ]"
        tw(kb, 0.12, {
            BackgroundColor3=C.accentDk,
            TextColor3=C.green
        })
        local c
        c = UserInputService.InputBegan:Connect(function(i, gp)
            if gp then return end
            -- Keyboard
            if i.UserInputType == Enum.UserInputType.Keyboard then
                kb.Text = i.KeyCode.Name
                tw(kb, 0.15, { BackgroundColor3=C.sidebar, TextColor3=C.textPri })
                listening=false; c:Disconnect(); onChanged(i.KeyCode.Name, i.KeyCode)
            else
                -- Mouse buttons and gamepad/input types
                local tname = tostring(i.UserInputType)
                local mname = tname:match("Enum.UserInputType%.(.+)") or tname
                kb.Text = mname
                tw(kb, 0.15, { BackgroundColor3=C.sidebar, TextColor3=C.textPri })
                listening=false; c:Disconnect(); onChanged(mname, i.UserInputType)
            end
        end)
    end)
    return function(v) kb.Text=v end
end

-- ═══════════════════════════════════════════════════════════════════════════
--  BUILD PAGES
-- ═══════════════════════════════════════════════════════════════════════════

local rainbowHue = 0
local rbBtn  -- assigned below

-- ────────────────────────────────────────────────────
--  MAIN TAB
-- ────────────────────────────────────────────────────
local mainSc = mkTab("Main","⊞",1)

mkSec(mainSc,"VISUALS",1)

-- Rainbow row (special animated button)
do
    local rbRow=mkRow(mainSc,50,2)
    local rl=mkLbl("Rainbow ESP",13,C.textPri,nil,rbRow)
    rl.Position=UDim2.new(0,0,0.5,-8); rl.Size=UDim2.new(0.6,0,0,18)
    local rs=mkLbl("Cycles all highlight hues",10,C.textSec,nil,rbRow)
    rs.Font=Enum.Font.Gotham; rs.Position=UDim2.new(0,0,0.5,6); rs.Size=UDim2.new(0.6,0,0,14)
    rbBtn=Instance.new("TextButton")
    rbBtn.Size=UDim2.new(0,108,0,28); rbBtn.Position=UDim2.new(1,-108,0.5,-14)
    rbBtn.BackgroundColor3=Color3.fromRGB(255,60,60); rbBtn.BorderSizePixel=0
    rbBtn.Text=cfg.rainbow and "● ON" or "Rainbow"
    rbBtn.TextSize=12; rbBtn.Font=Enum.Font.GothamBold
    rbBtn.TextColor3=Color3.new(1,1,1); rbBtn.Parent=rbRow; mkCorner(7,rbBtn)
    rbBtn.MouseButton1Click:Connect(function()
        cfg.rainbow=not cfg.rainbow
        rbBtn.Text=cfg.rainbow and "● ON" or "Rainbow"
    end)
end

local syncEsp=mkToggle(mainSc,"ESP","Show player highlights through walls",cfg.esp,3,function(v)
    cfg.esp=v; refreshESP()
end)

local syncEspCol=mkColorPicker(mainSc,"ESP Color",cfg.espR,cfg.espG,cfg.espB,4,function(r,g,b)
    cfg.espR=r; cfg.espG=g; cfg.espB=b
    local col=espCol()
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        local c=p.Character; if not c then continue end
        local h=getHL(c); if h then h.FillColor=col end
    end
end)

local syncTargetTracer=mkToggle(mainSc,"Tracer","Draw lines to enemies",cfg.espTracer,5,function(v)
    cfg.espTracer=v; setupESPTools()
end)

local syncBoxFull=mkToggle(mainSc,"Box ESP (Full)","Draw full box around enemies",cfg.espBoxFull,6,function(v)
    cfg.espBoxFull=v; setupESPTools()
end)

local syncBoxCorner=mkToggle(mainSc,"Box ESP (Corner)","Draw corner box around enemies",cfg.espBoxCorner,7,function(v)
    cfg.espBoxCorner=v; setupESPTools()
end)

local syncNameLabels=mkToggle(mainSc,"Name Labels","Show player names",cfg.espNameLabels,8,function(v)
    cfg.espNameLabels=v; setupESPTools()
end)

local syncDistanceDisplay=mkToggle(mainSc,"Distance Display","Show distance to enemies",cfg.espDistanceDisplay,9,function(v)
    cfg.espDistanceDisplay=v; setupESPTools()
end)

mkSec(mainSc,"COMBAT",10)

local syncSilent=mkToggle(mainSc,"Silent Aim","Hooks Mouse.Hit — no camera movement",cfg.silentAim,11,function(v)
    cfg.silentAim=v; syncFovCircle()
end)

local syncAimbot=mkToggle(mainSc,"Aimbot","Smooth camera aim while holding aim key",cfg.aimbot,11.5,function(v)
    cfg.aimbot=v
end)

local syncFov=mkSlider(mainSc,"FOV Radius","Pixel radius of the aim cone (shows as circle)",15,150,cfg.fov,12,function(v)
    cfg.fov=v; syncFovCircle()
end)

local syncAimbotSpeed=mkSlider(mainSc,"Aimbot Speed","Higher is faster",1,20,cfg.aimbotSpeed,12.2,function(v)
    cfg.aimbotSpeed=v
end)

local syncShowFov=mkToggle(mainSc,"Show FOV Circle",nil,cfg.showFov,13,function(v)
    cfg.showFov=v; syncFovCircle()
end)

local syncHitPart=mkDropdown(mainSc,"Hit Part",{"Head","HumanoidRootPart"},cfg.hitPart,14,function(v)
    cfg.hitPart=v
end)

local syncBigHead=mkToggle(mainSc,"Big Head","Expands enemy head hitbox",cfg.bigHead,15,function(v)
    cfg.bigHead=v
    if v then for _,p in ipairs(Players:GetPlayers()) do applyBigHead(p) end
    else restoreHeads() end
end)

local syncBigSz=mkSlider(mainSc,"Head Size","Stud size while Big Head is ON",10,50,cfg.bigHeadSize,16,function(v)
    cfg.bigHeadSize=v
end)

mkSec(mainSc,"WORLD",20)

local syncNoShadow=mkToggle(mainSc,"No Shadow","Disables shadow rendering",cfg.noShadow,21,function(v)
    cfg.noShadow=v; applyNoShadow(v)
end)

local syncFullBright=mkToggle(mainSc,"Full Bright","Maximum ambient light",cfg.fullBright,22,function(v)
    cfg.fullBright=v; applyFullBright(v)
end)

-- ────────────────────────────────────────────────────
--  GUN TAB
-- ────────────────────────────────────────────────────
local gunSc = mkTab("Gun","🔫",2)

mkSec(gunSc,"MODS",1)

local syncGunNoSpread=mkToggle(gunSc,"No Spread","Remove weapon bullet spread",cfg.gunNoSpread,2,function(v)
    cfg.gunNoSpread=v; setupGunMods()
end)

local syncGunInfAmmo=mkToggle(gunSc,"Infinite Ammo","Never run out of ammo",cfg.gunInfAmmo,3,function(v)
    cfg.gunInfAmmo=v; setupGunMods()
end)

local syncGunNoReload=mkToggle(gunSc,"No Reload","Infinite magazine",cfg.gunNoReload,4,function(v)
    cfg.gunNoReload=v; setupGunMods()
end)

mkSec(gunSc,"ACCURACY",10)

local syncHitChance=mkSlider(gunSc,"Body Hit Chance",nil,0,100,cfg.gunHitChance,11,function(v)
    cfg.gunHitChance=v
end)

local syncHeadHitChance=mkSlider(gunSc,"Head Hit Chance",nil,0,100,cfg.gunHeadHitChance,12,function(v)
    cfg.gunHeadHitChance=v
end)

-- ────────────────────────────────────────────────────
--  SETTINGS TAB
-- ────────────────────────────────────────────────────
local settSc = mkTab("Settings","⚙",3)

mkSec(settSc,"UI KEYBIND",1)

local currentKey = Enum.KeyCode.RightShift
local syncKey=mkKeybind(settSc,"Toggle UI Key",cfg.uiKey,2,function(kn,kc)
    cfg.uiKey=kn; currentKey=kc; keyHint.Text=kn.." to toggle"
end)

-- Aim keybind (supports mouse buttons)
local currentAim = Enum.UserInputType.MouseButton2
local syncAimKey = mkKeybind(settSc, "Aim Key", cfg.aimKey, 3, function(kn, ki)
    cfg.aimKey = kn
    -- store input type if mouse, or KeyCode if keyboard
    if typeof(ki) == "EnumItem" then
        currentAim = ki
    else
        currentAim = ki
    end
end)

mkSec(settSc,"CONFIG SLOTS",10)

-- syncAllUI defined here (all sync functions now exist above)
local slotNameSyncs = {}

local function syncAllUI()
    syncEsp(cfg.esp)
    syncEspCol(cfg.espR,cfg.espG,cfg.espB)
    if cfg.rainbow then rbBtn.Text="● ON" else rbBtn.Text="Rainbow" end
    syncTargetTracer(cfg.espTracer)
    syncBoxFull(cfg.espBoxFull)
    syncBoxCorner(cfg.espBoxCorner)
    syncNameLabels(cfg.espNameLabels)
    syncDistanceDisplay(cfg.espDistanceDisplay)
    syncSilent(cfg.silentAim)
    syncFov(cfg.fov)
    syncShowFov(cfg.showFov)
    syncHitPart(cfg.hitPart)
    syncBigHead(cfg.bigHead)
    syncBigSz(cfg.bigHeadSize)
    syncAimbot(cfg.aimbot)
    syncAimbotSpeed(cfg.aimbotSpeed)
    syncNoShadow(cfg.noShadow)
    syncFullBright(cfg.fullBright)
    syncGunNoSpread(cfg.gunNoSpread)
    syncGunInfAmmo(cfg.gunInfAmmo)
    syncGunNoReload(cfg.gunNoReload)
    syncHitChance(cfg.gunHitChance)
    syncHeadHitChance(cfg.gunHeadHitChance)
    syncKey(cfg.uiKey)
    if syncAimKey then syncAimKey(cfg.aimKey) end
    applyAll(); syncFovCircle(); setupESPTools()
end

for slot=1,3 do
    -- Outer card
    local card=mkFrame(C.panel,UDim2.new(1,0,0,96),nil,settSc)
    card.LayoutOrder=10+slot; mkCorner(10,card); mkStroke(1,C.border,card); mkPad(10,10,12,12,card)
    card.MouseEnter:Connect(function() tw(card,0.1,{BackgroundColor3=C.panelHov}) end)
    card.MouseLeave:Connect(function() tw(card,0.1,{BackgroundColor3=C.panel}) end)

    -- Slot number badge
    local badge=mkFrame(C.accentDk,UDim2.new(0,24,0,24),UDim2.new(0,0,0,0),card)
    mkCorner(6,badge)
    local badgeLbl=mkLbl(tostring(slot),13,Color3.new(1,1,1),Enum.TextXAlignment.Center,badge)
    badgeLbl.Size=UDim2.new(1,0,1,0); badgeLbl.Position=UDim2.new(0,0,0,0)

    -- Editable name TextBox
    local nameBox=Instance.new("TextBox")
    nameBox.BackgroundColor3=C.track; nameBox.BorderSizePixel=0
    nameBox.Text=slotNames[slot]; nameBox.PlaceholderText="Config name..."
    nameBox.TextSize=13; nameBox.Font=Enum.Font.GothamBold
    nameBox.TextColor3=C.textPri; nameBox.PlaceholderColor3=C.textDim
    nameBox.TextXAlignment=Enum.TextXAlignment.Left
    nameBox.ClearTextOnFocus=false
    nameBox.Size=UDim2.new(1,-32,0,28); nameBox.Position=UDim2.new(0,32,0,0)
    nameBox.Parent=card; mkCorner(7,nameBox); mkPad(0,0,10,10,nameBox)
    mkStroke(1,C.border,nameBox)

    local s=slot -- capture
    nameBox.FocusLost:Connect(function()
        local t=nameBox.Text
        if t=="" then t="Config "..s; nameBox.Text=t end
        slotNames[s]=t
        pcall(writefile, namesPath(), HttpService:JSONEncode(slotNames))
    end)
    slotNameSyncs[slot]=function(v) nameBox.Text=v end

    -- Save / Load buttons
    local saveBtn=Instance.new("TextButton")
    saveBtn.Size=UDim2.new(0.48,0,0,32); saveBtn.Position=UDim2.new(0,0,1,-32)
    saveBtn.BackgroundColor3=C.accent; saveBtn.BorderSizePixel=0
    saveBtn.Text="💾  Save"; saveBtn.TextSize=12; saveBtn.Font=Enum.Font.GothamBold
    saveBtn.TextColor3=Color3.new(1,1,1); saveBtn.Parent=card; mkCorner(7,saveBtn)

    local loadBtn=Instance.new("TextButton")
    loadBtn.Size=UDim2.new(0.48,0,0,32); loadBtn.Position=UDim2.new(0.52,0,1,-32)
    loadBtn.BackgroundColor3=C.accentDk; loadBtn.BorderSizePixel=0
    loadBtn.Text="📂  Load"; loadBtn.TextSize=12; loadBtn.Font=Enum.Font.GothamBold
    loadBtn.TextColor3=Color3.new(1,1,1); loadBtn.Parent=card; mkCorner(7,loadBtn)

    saveBtn.MouseButton1Click:Connect(function()
        local ok = saveSlot(s)
        tw(saveBtn, 0.15, {BackgroundColor3=ok and C.green or C.red})
        task.delay(1.5, function() 
            tw(saveBtn, 0.3, {BackgroundColor3=C.accent}) 
        end)
    end)

    loadBtn.MouseButton1Click:Connect(function()
        local ok = loadSlot(s)
        if ok then
            syncAllUI()
            pcall(function()
                if isfile(namesPath()) then
                    local content = readfile(namesPath())
                    local d = HttpService:JSONDecode(content)
                    for i = 1, 3 do
                        if type(d[i]) == "string" then
                            slotNames[i] = d[i]
                            if slotNameSyncs[i] then slotNameSyncs[i](d[i]) end
                        end
                    end
                end
            end)
            tw(loadBtn, 0.15, {BackgroundColor3=C.green})
        else
            tw(loadBtn, 0.15, {BackgroundColor3=C.red})
        end
        task.delay(1.5, function() 
            tw(loadBtn, 0.3, {BackgroundColor3=C.accentDk}) 
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  ACTIVATE MAIN TAB
-- ═══════════════════════════════════════════════════════════════════════════
for n,b in pairs(tabs) do
    b.BackgroundColor3 = n=="Main" and C.panel or C.sidebar
    b.TextColor3       = n=="Main" and C.textPri or C.textSec
end
for n,tf in pairs(tabFrames) do tf.frame.Visible = n=="Main" end
activeTab="Main"

-- ═══════════════════════════════════════════════════════════════════════════
--  DRAG
-- ═══════════════════════════════════════════════════════════════════════════
do
    local dr,ds,sp=false,nil,nil
    titleBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dr=true; ds=i.Position; sp=win.Position
        end
    end)
    titleBar.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            win.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
--  OPEN / CLOSE KEYBIND (animated slide)
-- ═══════════════════════════════════════════════════════════════════════════
local guiOpen=true
UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==currentKey then
        guiOpen=not guiOpen
        if guiOpen then
            win.Visible=true
            shadowF.Visible=true
            tw(win, 0.32, {
                Position=UDim2.new(0.5,-WIN_W/2, 0.5,-WIN_H/2),
                BackgroundTransparency=0
            })
            tw(shadowF, 0.32, {BackgroundTransparency=0.62})
        else
            tw(win, 0.25, {
                Position=UDim2.new(0.5,-WIN_W/2, 0.5,-WIN_H/2+30),
                BackgroundTransparency=0.1
            })
            tw(shadowF, 0.25, {BackgroundTransparency=0})
            task.delay(0.26, function()
                win.Visible=false
                shadowF.Visible=false
            end)
        end
    end
end)

-- Aim input handling: set aimPressed when aim key/button is held
UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    -- keyboard key
    if i.UserInputType == Enum.UserInputType.Keyboard and typeof(currentAim) == "EnumItem" and i.KeyCode == currentAim then
        aimPressed = true
    end
    -- mouse / other input types
    if typeof(currentAim) == "EnumItem" and i.UserInputType == currentAim then
        aimPressed = true
    end
    -- fallback: compare display name
    local tname = tostring(i.UserInputType)
    local iname = tname:match("Enum.UserInputType%.(.+)") or tname
    if cfg.aimKey and cfg.aimKey == iname then aimPressed = true end
end)

UserInputService.InputEnded:Connect(function(i, gp)
    if gp then return end
    if i.UserInputType == Enum.UserInputType.Keyboard and typeof(currentAim) == "EnumItem" and i.KeyCode == currentAim then
        aimPressed = false
    end
    if typeof(currentAim) == "EnumItem" and i.UserInputType == currentAim then
        aimPressed = false
    end
    local tname = tostring(i.UserInputType)
    local iname = tname:match("Enum.UserInputType%.(.+)") or tname
    if cfg.aimKey and cfg.aimKey == iname then aimPressed = false end
end)

-- ═══════════════════════════════════════════════════════════════════════════
--  HEARTBEAT: rainbow cycle + ESP colour sync
-- ═══════════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function(dt)
    rainbowHue = (rainbowHue + dt * 0.3) % 1
    
    if cfg.rainbow then
        local col = Color3.fromHSV(rainbowHue, 0.85, 1)
        rbBtn.BackgroundColor3 = col
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LP then continue end
            local c = p.Character
            if not c then continue end
            local h = getHL(c)
            if h then 
                h.FillColor = col
            end
        end
    else
        rbBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        
        if cfg.esp then
            local col = espCol()
            for _, p in ipairs(Players:GetPlayers()) do
                if p == LP then continue end
                local c = p.Character
                if not c then continue end
                local h = getHL(c)
                if h then 
                    h.FillColor = col
                end
            end
        end
    end
end)
-- End of script
