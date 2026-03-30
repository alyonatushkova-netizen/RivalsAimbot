
-- Rivals Aimbot + Menu для Delta
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Настройки
local settings = {
    enabled = true,
    aimbot = true,
    esp = true,
    fov = 200,
    smoothness = 0.3,
    teamCheck = false,
    visibleCheck = true,
    aimPart = "Head"
}

-- Меню
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RivalsMenu"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Text = "Rivals Aimbot Menu"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Parent = mainFrame

-- Функция создания переключателя
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

-- Слайдер FOV
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.9,0,0,20)
fovLabel.Position = UDim2.new(0.05,0,200)
fovLabel.Text = "FOV: " .. settings.fov
fovLabel.TextColor3 = Color3.fromRGB(255,255,255)
fovLabel.BackgroundTransparency = 1
fovLabel.Parent = mainFrame

local fovSlider = Instance.new("TextBox")
fovSlider.Size = UDim2.new(0.9,0,0,25)
fovSlider.Position = UDim2.new(0.05,0,225)
fovSlider.PlaceholderText = "Значение 50-500"
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

-- Слайдер Smoothness
local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(0.9,0,0,20)
smoothLabel.Position = UDim2.new(0.05,0,260)
smoothLabel.Text = "Smoothness: " .. settings.smoothness
smoothLabel.TextColor3 = Color3.fromRGB(255,255,255)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Parent = mainFrame

local smoothSlider = Instance.new("TextBox")
smoothSlider.Size = UDim2.new(0.9,0,0,25)
smoothSlider.Position = UDim2.new(0.05,0,285)
smoothSlider.PlaceholderText = "0.1 - 1.0"
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

-- Открытие/закрытие меню по Insert
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ESP
local espLines = {}
local function updateESP()
    for _, v in pairs(espLines) do v:Destroy() end
    espLines = {}
    if not settings.esp then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and (not settings.teamCheck or plr.Team ~= LocalPlayer.Team) then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(3, 5, 1)
                box.Color3 = Color3.fromRGB(255,0,0)
                box.AlwaysOnTop = true
                box.ZIndex = 0
                box.Adornee = char
                box.Parent = char
                table.insert(espLines, box)
                
                local line = Instance.new("SelectionBox")
                line.Adornee = char
                line.Color3 = Color3.fromRGB(255,0,0)
                line.LineThickness = 0.1
                line.Transparency = 0.5
                line.Parent = char
                table.insert(espLines, line)
            end
        end
    end
end

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)
RunService.RenderStepped:Connect(updateESP)

-- Aimbot
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
                if part then
                    local screenPos, onScreen = camera:WorldToScreenPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < shortest then
                            if settings.visibleCheck then
                                local ray = Ray.new(camera.CFrame.Position, (part.Position - camera.CFrame.Position).unit * 500)
                                local hit = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                                if hit and hit:IsDescendantOf(char) then
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

local camera = workspace.CurrentCamera
RunService.RenderStepped:Connect(function()
    if not settings.enabled or not settings.aimbot then return end
    local target = getClosestPlayer()
    if target and Mouse.Target ~= target then
        local targetPos = camera:WorldToScreenPoint(target.Position)
        local delta = Vector2.new(targetPos.X - Mouse.X, targetPos.Y - Mouse.Y)
        mousemoverel(delta.X * settings.smoothness, delta.Y * settings.smoothness)
    end
end)

print("Rivals Aimbot + Menu загружен. Нажмите Insert для меню.")
