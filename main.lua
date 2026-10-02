-- Script Name: bradokz Hub
-- Created for Delta Executor

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "bradokz Hub", HidePremium = false, SaveConfig = false, IntroText = "bradokz"})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Tabs
local MainTab = Window:MakeTab({Name = "الرئيسية", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "اللاعب والشخصية", Icon = "rbxassetid://4483345998"})
local PerformanceTab = Window:MakeTab({Name = "الأداء", Icon = "rbxassetid://4483345998"})

---------------------------------------------------------
-- 1. Desync Feature
---------------------------------------------------------
getgenv().DesyncActive = false
MainTab:AddToggle({
    Name = "Desync",
    Default = false,
    Callback = function(Value)
        getgenv().DesyncActive = Value
    end
})

RunService.Heartbeat:Connect(function()
    if getgenv().DesyncActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local oldVel = hrp.Velocity
        hrp.Velocity = Vector3.new(9999, 9999, 9999)
        RunService.RenderStepped:Wait()
        hrp.Velocity = oldVel
    end
end)

---------------------------------------------------------
-- 2. Steal Button (سرقة تلقائي)
---------------------------------------------------------
local StealScreenGui = Instance.new("ScreenGui")
local StealButton = Instance.new("TextButton")

StealScreenGui.Name = "StealGui"
StealScreenGui.Parent = game:GetService("CoreGui")
StealButton.Name = "StealBtn"
StealButton.Parent = StealScreenGui
StealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StealButton.Size = UDim2.new(0, 120, 0, 50)
StealButton.Position = UDim2.new(0.8, 0, 0.4, 0)
StealButton.Text = "Steal"
StealButton.TextSize = 20
StealButton.Visible = false
StealButton.Active = true
StealButton.Draggable = true

MainTab:AddButton({
    Name = "السرقة تلقائي",
    Callback = function()
        StealButton.Visible = true
    end
})

StealButton.MouseButton1Click:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt)
        end
    end
end)

---------------------------------------------------------
-- 3. Base Return (العودة إلى البيت)
---------------------------------------------------------
local BaseScreenGui = Instance.new("ScreenGui")
local BaseButton = Instance.new("TextButton")

BaseScreenGui.Name = "BaseGui"
BaseScreenGui.Parent = game:GetService("CoreGui")
BaseButton.Name = "BaseBtn"
BaseButton.Parent = BaseScreenGui
BaseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BaseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BaseButton.Size = UDim2.new(0, 120, 0, 50)
BaseButton.Position = UDim2.new(0.8, 0, 0.5, 0)
BaseButton.Text = "base"
BaseButton.TextSize = 20
BaseButton.Visible = false
BaseButton.Active = true
BaseButton.Draggable = true

MainTab:AddButton({
    Name = "العودة",
    Callback = function()
        BaseButton.Visible = true
    end
})

local SavedBasePosition = nil
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    SavedBasePosition = LocalPlayer.Character.HumanoidRootPart.CFrame
end

BaseButton.MouseButton1Click:Connect(function()
    if SavedBasePosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBasePosition
    end
end)

---------------------------------------------------------
-- 4. Target Player & Bat Attack (استهداف وضرب بالعصاية)
---------------------------------------------------------
local SelectedPlayer = nil

MainTab:AddDropdown({
    Name = "اختر الشخص في السيرفر",
    Options = {},
    Callback = function(Option)
        SelectedPlayer = Players:FindFirstChild(Option)
    end
})

MainTab:AddButton({
    Name = "ضرب الشخص",
    Callback = function()
        if SelectedPlayer and SelectedPlayer.Character and SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end
    end
})

---------------------------------------------------------
-- 5. Character Size (تكبير وتصغير الحجم)
---------------------------------------------------------
PlayerTab:AddButton({
    Name = "تكبير الحجم",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum:FindFirstChild("HeadScale") then
                hum.HeadScale.Value = hum.HeadScale.Value * 1.5
                hum.BodyDepthScale.Value = hum.BodyDepthScale.Value * 1.5
                hum.BodyWidthScale.Value = hum.BodyWidthScale.Value * 1.5
                hum.BodyHeightScale.Value = hum.BodyHeightScale.Value * 1.5
            end
        end
    end
})

PlayerTab:AddButton({
    Name = "تصغير الحجم",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum:FindFirstChild("HeadScale") then
                hum.HeadScale.Value = hum.HeadScale.Value * 0.7
                hum.BodyDepthScale.Value = hum.BodyDepthScale.Value * 0.7
                hum.BodyWidthScale.Value = hum.BodyWidthScale.Value * 0.7
                hum.BodyHeightScale.Value = hum.BodyHeightScale.Value * 0.7
            end
        end
    end
})

---------------------------------------------------------
-- 6. Infinite Jump (القفز اللانهائي)
---------------------------------------------------------
getgenv().InfiniteJumpEnabled = false

PlayerTab:AddToggle({
    Name = "القفز اللانهائي",
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJumpEnabled = Value
    end
})

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

---------------------------------------------------------
-- 7. Lag Reduction (تخفيف اللاق)
---------------------------------------------------------
PerformanceTab:AddButton({
    Name = "تخفيف اللاق",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        game:GetService("Lighting").GlobalShadows = false
    end
})

OrionLib:Init()
