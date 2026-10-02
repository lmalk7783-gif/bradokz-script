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

-- زر إخفاء/إظهار الواجهة (⚡)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleUI"
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.01, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "⚡"
ToggleBtn.TextSize = 24
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "bradokzMain"
MainFrame.Size = UDim2.new(0, 210, 0, 310)
MainFrame.Position = UDim2.new(0.06, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- إخفاء/إظهار عند الضغط على ⚡
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

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
local BtnAimbot = CreateSquareButton("Aimbot")
local BtnKnife = CreateSquareButton("قتل")
local BtnKillAll = CreateSquareButton("قتل الجميع (للمردر)")

-- 1. الفلاش باك الانسيابي (Rewind)
local PositionHistory = {}
local isRewinding = false

RunService.Heartbeat:Connect(function()
    if not isRewinding and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        table.insert(PositionHistory, LocalPlayer.Character.HumanoidRootPart.CFrame)
        if #PositionHistory > 300 then
            table.remove(PositionHistory, 1)
        end
    end
end)

BtnFlashback.MouseButton1Click:Connect(function()
    if isRewinding then
        isRewinding = false
        BtnFlashback.Text = "فلاش باك"
    else
        if #PositionHistory > 0 then
            isRewinding = true
            BtnFlashback.Text = "إيقاف الفلاش باك"
            
            task.spawn(function()
                while isRewinding and #PositionHistory > 0 do
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local lastCFrame = table.remove(PositionHistory)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = lastCFrame
                    end
                    task.wait(0.01)
                end
                isRewinding = false
                BtnFlashback.Text = "فلاش باك"
            end)
        end
    end
end)

-- 2. كشف الأدوار
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
end)

-- 3. Aimbot
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

-- 4. قتل
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

-- 5. قتل الجميع
BtnKillAll.MouseButton1Click:Connect(function()
    local knife = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife"))
    if knife then
        knife.Parent = LocalPlayer.Character
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                task.wait(0.1)
                knife:Activate()
            end
        end
    end
end)
