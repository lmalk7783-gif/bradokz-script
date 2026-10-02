-- [[ bradokz Hub - MM2 Direct Delta ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- إنشاء واجهة bradokz
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "bradokz"
ScreenGui.ResetOnSpawn = false

local success = pcall(function()
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 3)
end)
if not success or not ScreenGui.Parent then
    ScreenGui.Parent = game:GetService("CoreGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "bradokzMain"
MainFrame.Size = UDim2.new(0, 210, 0, 310)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "bradokz Hub ⚡"
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.BorderSizePixel = 1
Title.BorderColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

local UIList = Instance.new("UIListLayout")
UIList.Parent = MainFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 4)

local function CreateSquareButton(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize = 15
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(120, 120, 120)
    btn.Parent = MainFrame
    return btn
end

-- الأزرار
local BtnFlashback = CreateSquareButton("فلاش باك")
local BtnAimbot = CreateSquareButton("أيم بوت")
local BtnKnife = CreateSquareButton("رمي")
local BtnKill = CreateSquareButton("قتل")
local BtnTeleportGun = CreateSquareButton("الانتقال إلى القاعدة")

-- 1. الفلاش باك
local PositionHistory = {}
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        table.insert(PositionHistory, LocalPlayer.Character.HumanoidRootPart.CFrame)
        if #PositionHistory > 180 then
            table.remove(PositionHistory, 1)
        end
    end
end)

BtnFlashback.MouseButton1Click:Connect(function()
    if #PositionHistory > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = PositionHistory[1]
    end
end)

-- 2. كشف الأدوار والمسدس
local function GetRole(player)
    if not player or not player.Character then return "Innocent" end
    if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
        return "Murderer"
    elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
        return "Sheriff"
    end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local role = GetRole(p)
            local hl = p.Character:FindFirstChild("bradokz_ESP")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "bradokz_ESP"
                hl.Parent = p.Character
            end
            
            if role == "Murderer" then
                hl.FillColor = Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" then
                hl.FillColor = Color3.fromRGB(0, 100, 255)
            else
                hl.FillColor = Color3.fromRGB(0, 255, 0)
            end
        end
    end
    
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
            local hl = obj:FindFirstChild("bradokz_GunESP")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "bradokz_GunESP"
                hl.Parent = obj
            end
            hl.FillColor = Color3.fromRGB(255, 255, 0)
        end
    end
end)

-- 3. أيم بوت
BtnAimbot.MouseButton1Click:Connect(function()
    local murderer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and GetRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            murderer = p
            break
        end
    end
    
    if murderer and LocalPlayer.Character then
        local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
        if gun then
            gun.Parent = LocalPlayer.Character
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, murderer.Character.HumanoidRootPart.Position)
            gun:Activate()
        end
    end
end)

-- 4. رمي السكينة
BtnKnife.MouseButton1Click:Connect(function()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (GetRole(p) == "Sheriff" or GetRole(p) == "Innocent") and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            target = p
            break
        end
    end
    
    if target and LocalPlayer.Character then
        local knife = LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
        if knife then
            knife.Parent = LocalPlayer.Character
            Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            knife:Activate()
        end
    end
end)

-- 5. القتل
BtnKill.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then
        local knife = LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
        if knife then
            knife.Parent = LocalPlayer.Character
            knife:Activate()
        end
    end
end)

-- 6. الانتقال للمسدس
BtnTeleportGun.MouseButton1Click:Connect(function()
    local droppedGun = nil
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "GunDrop" or (obj:IsA("Tool") and obj.Name == "Gun") then
            droppedGun = obj
            break
        end
    end
    
    if droppedGun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if droppedGun:IsA("BasePart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = droppedGun.CFrame
        elseif droppedGun:FindFirstChild("Handle") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = droppedGun.Handle.CFrame
        end
    end
end)
