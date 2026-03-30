
-- Rivals Aimbot Mobile + ESP + FPS Boost + Key System (Delta Mobile)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
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

-- === АНИМАЦИЯ ЗАГРУЗКИ 10 СЕКУНД ===
local loadGui = Instance.new("ScreenGui")
loadGui.Name = "LoadingScreen"
loadGui.Parent = game:GetService("CoreGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BackgroundTransparency = 0.5
bg.Parent = loadGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 250, 0, 80)
loadingFrame.Position = UDim2.new(0.5, -125, 0.5, -40)
loadingFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = loadGui

local titleLoad = Instance.new("TextLabel")
titleLoad.Size = UDim2.new(1,0,0,30)
titleLoad.Text = "Загрузка Rivals Aimbot"
titleLoad.TextColor3 = Color3.fromRGB(255,255,255)
titleLoad.BackgroundTransparency = 1
titleLoad.Parent = loadingFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 0, 10)
progressBar.Position = UDim2.new(0, 0, 0.5, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0,200,0)
progressBar.BorderSizePixel = 0
progressBar.Parent = loadingFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.9, 0, 0, 10)
progressBg.Position = UDim2.new(0.05, 0, 0.7, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(80,80,80)
progressBg.BorderSizePixel = 0
progressBg.Parent = loadingFrame

progressBar.Parent = progressBg

local percentText = Instance.new("TextLabel")
percentText.Size = UDim2.new(0.3,0,0,20)
percentText.Position = UDim2.new(0.35,0,0.3,0)
percentText.Text = "0%"
percentText.TextColor3 = Color3.fromRGB(255,255,255)
percentText.BackgroundTransparency = 1
percentText.Parent = loadingFrame

-- Анимация прогресса
for i = 0, 10 do
    local percent = i * 10
    percentText.Text = percent .. "%"
    local tween = TweenService:Create(progressBar, TweenInfo.new(1, Enum.EasingStyle.Linear), {Size = UDim2.new(percent/100, 0, 0, 10)})
    tween:Play()
    task.wait(1)
end

loadGui:Destroy()

-- === МЕНЮ (появляется после загрузки) ===
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
title.Text = "Rivals Aimbot Mobile"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Parent = mainFrame

local function makeToggle(name, y, settingKey)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9,0,0,40)
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

makeToggle("Aimbot", 50, "aimbot")
makeToggle("ESP", 100, "esp")
makeToggle("Team Check", 150, "teamCheck")
makeToggle("Visible Check", 200, "visibleCheck")
makeToggle("FPS Boost", 250, "fpsBoost")

-- ESP Type
local espTypeLabel = Instance.new("TextLabel")
espTypeLabel.Size = UDim2.new(0.9,0,0,30)
espTypeLabel.Position = UDim2.new(0.05,0,300)
espTypeLabel.Text = "ESP Type: " .. settings.espType
espTypeLabel.TextColor3 = Color3.fromRGB(255,255,255)
espTypeLabel.BackgroundTransparency = 1
espTypeLabel.Parent = mainFrame

local espTypeBtn = Instance.new("TextButton")
espTypeBtn.Size = UDim2.new(0.4,0,0,40)
espTypeBtn.Position = UDim2.new(0.05,0,335)
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
    colorLabel.Size = UDim2.new(0.9,0,0,30)
    colorLabel.Position = UDim2.new(0.05,0,385)
    colorLabel.Text = "ESP Color: Red"
    colorLabel.TextColor3 = Color3.fromRGB(255,255,255)
    colorLabel.BackgroundTransparency = 1

colorLabel.Parent = mainFrame
    
    local redBtn = Instance.new("TextButton")
    redBtn.Size = UDim2.new(0.2,0,0,40)
    redBtn.Position = UDim2.new(0.05,0,420)
    redBtn.Text = "Red"
    redBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    redBtn.TextColor3 = Color3.fromRGB(255,255,255)
    redBtn.Parent = mainFrame
    redBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(255,0,0)
        colorLabel.Text = "ESP Color: Red"
    end)
    
    local greenBtn = Instance.new("TextButton")
    greenBtn.Size = UDim2.new(0.2,0,0,40)
    greenBtn.Position = UDim2.new(0.3,0,420)
    greenBtn.Text = "Green"
    greenBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
    greenBtn.TextColor3 = Color3.fromRGB(0,0,0)
    greenBtn.Parent = mainFrame
    greenBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(0,255,0)
        colorLabel.Text = "ESP Color: Green"
    end)
    
    local blueBtn = Instance.new("TextButton")
    blueBtn.Size = UDim2.new(0.2,0,0,40)
    blueBtn.Position = UDim2.new(0.55,0,420)
    blueBtn.Text = "Blue"
    blueBtn.BackgroundColor3 = Color3.fromRGB(0,0,255)
    blueBtn.TextColor3 = Color3.fromRGB(255,255,255)
    blueBtn.Parent = mainFrame
    blueBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(0,0,255)
        colorLabel.Text = "ESP Color: Blue"
    end)
    
    local yellowBtn = Instance.new("TextButton")
    yellowBtn.Size = UDim2.new(0.2,0,0,40)
    yellowBtn.Position = UDim2.new(0.8,0,420)
    yellowBtn.Text = "Yellow"
    yellowBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)
    yellowBtn.TextColor3 = Color3.fromRGB(0,0,0)
    yellowBtn.Parent = mainFrame
    yellowBtn.MouseButton1Click:Connect(function()
        settings.espColor = Color3.fromRGB(255,255,0)
        colorLabel.Text = "ESP Color: Yellow"
    end)
end

-- Открытие/закрытие меню (кнопка на экране для мобилки)
local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0, 60, 0, 60)
menuButton.Position = UDim2.new(0.85, 0, 0.85, 0)
menuButton.Text = "MENU"
menuButton.TextColor3 = Color3.fromRGB(255,255,255)
menuButton.BackgroundColor3 = Color3.fromRGB(0,150,0)
menuButton.BorderSizePixel = 0
menuButton.Parent = screenGui
menuButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
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

-- === AIMBOT ДЛЯ ТЕЛЕФОНА (поворот камеры) ===
local function getClosestPlayer()
    local closest = nil
    local shortest = settings.fov
    local cameraCF = camera.CFrame
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (not settings.teamCheck or plr.Team ~= LocalPlayer.Team) then
            local char = plr.Character
            if char then
                local part = char:FindFirstChild(settings.aimPart) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if part then
                    local vectorToTarget = (part.Position - cameraCF.Position).unit
                    local angle = cameraCF.LookVector:Dot(vectorToTarget)
                    local angleDeg = math.deg(math.acos(angle))
                    if angleDeg < shortest then
                        if settings.visibleCheck then
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            local rayResult = workspace:Raycast(cameraCF.Position, (part.Position - cameraCF.Position).unit * 500, raycastParams)
                            if rayResult and rayResult.Instance:IsDescendantOf(char) then
                                shortest = angleDeg
                                closest = part
                            end
                        else
                            shortest = angleDeg
                            closest = part
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
        local targetPos = target.Position
        local currentCF = camera.CFrame
        local newCF = CFrame.new(currentCF.Position, targetPos)
        camera.CFrame = camera.CFrame:Lerp(newCF, settings.smoothness)
    end
end)

print("Rivals Aimbot Mobile загружен. Ключ принят. Нажмите MENU для настроек.")
