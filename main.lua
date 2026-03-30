
-- Rivals Aimbot Pro + ESP + FPS Boost + Key System (Delta)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

-- === СИСТЕМА КЛЮЧЕЙ ===
local validKeys = {
    ["ADMIN-KEY-001"] = "admin",
    ["USER-KEY-001"] = "user",
    ["USER-KEY-002"] = "user",
    ["USER-KEY-003"] = "user",
    ["USER-KEY-004"] = "user",
    ["USER-KEY-005"] = "user",
    ["USER-KEY-006"] = "user",
    ["USER-KEY-007"] = "user",
    ["USER-KEY-008"] = "user",
    ["USER-KEY-009"] = "user"
}

local function askForKey()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeyInputGUI"
    gui.Parent = game:GetService("CoreGui")
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,0,30)
    label.Text = "Введите ключ доступа"
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.BackgroundColor3 = Color3.fromRGB(20,20,20)
    label.Parent = frame
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.8,0,0,30)
    textBox.Position = UDim2.new(0.1,0,0.3,0)
    textBox.PlaceholderText = "Ключ"
    textBox.Text = ""
    textBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
    textBox.TextColor3 = Color3.fromRGB(255,255,255)
    textBox.Parent = frame
    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(0.4,0,0,30)
    submit.Position = UDim2.new(0.3,0,0.6,0)
    submit.Text = "Войти"
    submit.BackgroundColor3 = Color3.fromRGB(0,120,0)
    submit.TextColor3 = Color3.fromRGB(255,255,255)
    submit.Parent = frame
    local result = nil
    submit.MouseButton1Click:Connect(function()
        result = textBox.Text
        gui:Destroy()
    end)
    repeat task.wait() until result ~= nil
    return result
end

local userRole = nil
repeat
    local key = askForKey()
    if validKeys[key] then
        userRole = validKeys[key]
        break
    else
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="Ошибка", Text="Неверный ключ", Duration=2})
    end
until false

print(userRole == "admin" and "Администратор" or "Пользователь")

-- === НАСТРОЙКИ ===
local settings = {
    enabled = true,
    aimbot = true,
    esp = true,
    fov = 200,
    smoothness = 0.3,
    teamCheck = false,
    visibleCheck = true,
    aimPart = "Head",
    espColor = Color3.fromRGB(255,0,0),
    espType = "Box",
    fpsBoost = true
}

-- === FPS БУСТ ===
if settings.fpsBoost then
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").FogEnd = 1000
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled = false end
        if v:IsA("Decal") then v.Transparency = 1 end
    end
end

-- === МЕНЮ (появляется через 10 секунд) ===
task.wait(10)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RivalsMenu"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Rivals Aimbot Pro"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Parent = mainFrame

local function makeToggle(name, y, settingKey)

local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,30)
    btn.Position = UDim2.new(0.05,0,0,y)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = mainFrame
    btn.MouseButton1Click:Connect(function()
        settings[settingKey] = not settings[settingKey]
        btn.Text = name .. ": " .. (settings[settingKey] and "ON" or "OFF")
    end)
    return btn
end

makeToggle("Aimbot", 40, "aimbot")
makeToggle("ESP", 80, "esp")
makeToggle("Team Check", 120, "teamCheck")
makeToggle("Visible Check", 160, "visibleCheck")
makeToggle("FPS Boost", 200, "fpsBoost")

-- ESP Type
local espTypeLabel = Instance.new("TextLabel")
espTypeLabel.Size = UDim2.new(0.9,0,0,20)
espTypeLabel.Position = UDim2.new(0.05,0,240)
espTypeLabel.Text = "ESP Type: " .. settings.espType
espTypeLabel.TextColor3 = Color3.fromRGB(255,255,255)
espTypeLabel.BackgroundTransparency = 1
espTypeLabel.Parent = mainFrame

local espTypeBtn = Instance.new("TextButton")
espTypeBtn.Size = UDim2.new(0.4,0,0,25)
espTypeBtn.Position = UDim2.new(0.05,0,265)
espTypeBtn.Text = settings.espType
espTypeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
espTypeBtn.TextColor3 = Color3.fromRGB(255,255,255)
espTypeBtn.Parent = mainFrame
espTypeBtn.MouseButton1Click:Connect(function()
    local types = {"Box", "Circle", "Skeleton"}
    local idx = table.find(types, settings.espType) or 1
    idx = idx % 3 + 1
    settings.espType = types[idx]
    espTypeLabel.Text = "ESP Type: " .. settings.espType
    espTypeBtn.Text = settings.espType
end)

-- Color (только админ)
if userRole == "admin" then
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(0.9,0,0,20)
    colorLabel.Position = UDim2.new(0.05,0,300)
    colorLabel.Text = "ESP Color: Red"
    colorLabel.TextColor3 = Color3.fromRGB(255,255,255)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Parent = mainFrame
    
    local redBtn = Instance.new("TextButton")
    redBtn.Size = UDim2.new(0.2,0,0,25)
    redBtn.Position = UDim2.new(0.05,0,325)
    redBtn.Text = "Red"
    redBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    redBtn.TextColor3 = Color3.fromRGB(255,255,255)
    redBtn.Parent = mainFrame
    redBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(255,0,0)
        colorLabel.Text = "ESP Color: Red"
    end)
    
    local greenBtn = Instance.new("TextButton")
    greenBtn.Size = UDim2.new(0.2,0,0,25)
    greenBtn.Position = UDim2.new(0.3,0,325)
    greenBtn.Text = "Green"
    greenBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    greenBtn.TextColor3 = Color3.fromRGB(0,0,0)
    greenBtn.Parent = mainFrame
    greenBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(0,255,0)
        colorLabel.Text = "ESP Color: Green"
    end)
    
    local blueBtn = Instance.new("TextButton")
    blueBtn.Size = UDim2.new(0.2,0,0,25)
    blueBtn.Position = UDim2.new(0.55,0,325)
    blueBtn.Text = "Blue"
    blueBtn.BackgroundColor3 = Color3.fromRGB(0,0,255)
    blueBtn.TextColor3 = Color3.fromRGB(255,255,255)
    blueBtn.Parent = mainFrame
    blueBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(0,0,255)
        colorLabel.Text = "ESP Color: Blue"
    end)
    
    local yellowBtn = Instance.new("TextButton")
    yellowBtn.Size = UDim2.new(0.2,0,0,25)
    yellowBtn.Position = UDim2.new(0.8,0,325)
    yellowBtn.Text = "Yellow"
    yellowBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)
    yellowBtn.TextColor3 = Color3.fromRGB(0,0,0)
    yellowBtn.Parent = mainFrame
    yellowBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(255,255,0)
        colorLabel.Text = "ESP Color: Yellow"
    end)
end

-- FOV Slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.9,0,0,20)
fovLabel.Position = UDim2.new(0.05,0,360)
fovLabel.Text = "FOV: " .. settings.fov
fovLabel.TextColor3 = Color3.fromRGB(255,255,255)
fovLabel.BackgroundTransparency = 1
fovLabel.Parent = mainFrame

local fovSlider = Instance.new("TextBox")
fovSlider.Size = UDim2.new(0.9,0,0,25)
fovSlider.Position = UDim2.new(0.05,0,385)
fovSlider.PlaceholderText = "50-500"
fovSlider.Text = tostring(settings.fov)
fovSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
fovSlider.TextColor3 = Color3.fromRGB(255,255,255)
fovSlider.Parent = mainFrame
fovSlider.FocusLost:Connect(function()
    local val = tonumber(fovSlider.Text)
    if val then
        settings.fov = math.clamp(val, 50, 500)
        fovLabel.Text = "FOV: " .. settings.fov
        fovSlider.Text = tostring(settings.fov)
    else
        fovSlider.Text = tostring(settings.fov)
    end
end)

-- Smoothness Slider
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(0.9,0,0,20)
smoothLabel.Position = UDim2.new(0.05,0,420)
smoothLabel.Text = "Smoothness: " .. settings.smoothness
smoothLabel.TextColor3 = Color3.fromRGB(255,255,255)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Parent = mainFrame

local smoothSlider = Instance.new("TextBox")
smoothSlider.Size = UDim2.new(0.9,0,0,25)
smoothSlider.Position = UDim2.new(0.05,0,445)
smoothSlider.PlaceholderText = "0.1-1.0"
smoothSlider.Text = tostring(settings.smoothness)
smoothSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)
smoothSlider.TextColor3 = Color3.fromRGB(255,255,255)
smoothSlider.Parent = mainFrame
smoothSlider.FocusLost:Connect(function()
    local val = tonumber(smoothSlider.Text)
    if val then
        settings.smoothness = math.clamp(val, 0.05, 1)
        smoothLabel.Text = "Smoothness: " .. settings.smoothness
        smoothSlider.Text = tostring(settings.smoothness)
    else
        smoothSlider.Text = tostring(settings.smoothness)
    end
end)

-- Open/Close
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- === ESP ===
local espObjects = {}
local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function updateESP()
    clearESP()
    if not settings.esp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (not settings.teamCheck or plr.Team ~= LocalPlayer.Team) then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                if settings.espType == "Box" then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(3, 5, 1)
                    box.Color3 = settings.espColor
                    box.AlwaysOnTop = true
                    box.ZIndex = 0
                    box.Adornee = char
                    box.Parent = char
                    table.insert(espObjects, box)
                elseif settings.espType == "Circle" then
                    local circle = Instance.new("CylinderHandleAdornment")
                    circle.Radius = 2
                    circle.Height = 4
                    circle.Color3 = settings.espColor
                    circle.AlwaysOnTop = true
                    circle.Adornee = char
                    circle.Parent = char
                    table.insert(espObjects, circle)
                elseif settings.espType == "Skeleton" then
                    local parts = {"Head", "HumanoidRootPart", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
                    for i=1,#parts do

for j=i+1,#parts do
                            if char:FindFirstChild(parts[i]) and char:FindFirstChild(parts[j]) then
                                local line = Instance.new("SelectionBox")
                                line.Adornee = char
                                line.Color3 = settings.espColor
                                line.LineThickness = 0.2
                                line.Transparency = 0.3
                                line.Parent = char
                                table.insert(espObjects, line)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)
RunService.RenderStepped:Connect(updateESP)

-- === AIMBOT (исправленный) ===
local function getClosestPlayer()
    local closest = nil
    local shortest = settings.fov
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (not settings.teamCheck or plr.Team ~= LocalPlayer.Team) then
            local char = plr.Character
            if char then
                local part = char:FindFirstChild(settings.aimPart)
                if not part then part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") end
                if part and part.Position then
                    local screenPos, onScreen = camera:WorldToScreenPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortest then
                            if settings.visibleCheck then
                                local raycastParams = RaycastParams.new()
                                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                                raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                                local rayResult = workspace:Raycast(camera.CFrame.Position, (part.Position - camera.CFrame.Position).unit * 500, raycastParams)
                                if rayResult and rayResult.Instance:IsDescendantOf(char) then
                                    shortest = dist
                                    closest = part
                                end
                            else
                                shortest = dist
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not settings.enabled or not settings.aimbot then return end
    local target = getClosestPlayer()
    if target then
        local targetPos = camera:WorldToScreenPoint(target.Position)
        local deltaX = (targetPos.X - Mouse.X) * settings.smoothness
        local deltaY = (targetPos.Y - Mouse.Y) * settings.smoothness
        -- Для Delta используется mousemoverel (если не работает, замените на коробочную функцию)
        pcall(function() mousemoverel(deltaX, deltaY) end)
    end
end)

print("Rivals Aimbot Pro загружен. Нажмите Insert через 10 секунд после ввода ключа.")
