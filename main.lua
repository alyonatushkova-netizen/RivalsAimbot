-- Rivals Mobile SIMPLE (Delta)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local set = {
    aim = true,
    esp = true,
    smooth = 0.3
}

-- МЕНЮ (кнопка появляется сразу)
local gui = Instance.new("ScreenGui")
gui.Parent = game:CoreGui

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 80, 0, 80)
btn.Position = UDim2.new(0.8, 0, 0.8, 0)
btn.Text = "MENU"
btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = gui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Visible = false
frame.Parent = gui

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleBtn.Text = "Aimbot: ON"
toggleBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggleBtn.Parent = frame
toggleBtn.MouseButton1Click:Connect(function()
    set.aim = not set.aim
    toggleBtn.Text = "Aimbot: " .. (set.aim and "ON" or "OFF")
end)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.8, 0, 0, 40)
espBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
espBtn.Text = "ESP: ON"
espBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
espBtn.Parent = frame
espBtn.MouseButton1Click:Connect(function()
    set.esp = not set.esp
    espBtn.Text = "ESP: " .. (set.esp and "ON" or "OFF")
end)

btn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ESP
local espObjs = {}
local function clearESP()
    for _, obj in pairs(espObjs) do pcall(obj.Destroy, obj) end
    espObjs = {}
end

local function updateESP()
    clearESP()
    if not set.esp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local box = Instance.new("BoxHandleAdornment")
                box.Size = Vector3.new(3, 5, 1)
                box.Color3 = Color3.fromRGB(255,0,0)
                box.AlwaysOnTop = true
                box.Adornee = char
                box.Parent = char
                table.insert(espObjs, box)
            end
        end
    end
end

Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)
RunService.RenderStepped:Connect(updateESP)

-- Aimbot (мобильный)
local function getClosest()
    local closest = nil
    local shortest = 200
    local camCF = camera.CFrame
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            if char then
                local part = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                if part then
                    local dir = (part.Position - camCF.Position).unit
                    local angle = math.deg(math.acos(camCF.LookVector:Dot(dir)))
                    if angle < shortest then
                        shortest = angle
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not set.aim then return end
    local target = getClosest()
    if target then
        local newCF = CFrame.new(camera.CFrame.Position, target.Position)
        camera.CFrame = camera.CFrame:Lerp(newCF, set.smooth)
    end
end)

print("Скрипт загружен. Нажмите MENU")
