-- bradokz Hub - Custom Script for Brainrot Game
-- Made for Delta Executor

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "bradokz Hub",
    SubTitle = "by bradokz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "الرئيسية", Icon = "home" }),
    Player = Window:AddTab({ Title = "اللاعب والشخصية", Icon = "user" }),
    Settings = Window:AddTab({ Title = "الأداء والتخفيف", Icon = "settings" })
}

local Options = Fluent.Options
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------------------
-- 1. Desync
---------------------------------------------------------
local DesyncToggle = Tabs.Main:AddToggle("DesyncToggle", {Title = "Desync", Default = false})

getgenv().DesyncActive = false
DesyncToggle:OnChanged(function()
    getgenv().DesyncActive = Options.DesyncToggle.Value
end)

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
-- 2. Steal Button (زر السرقة الأسود)
---------------------------------------------------------
local StealGui = Instance.new("ScreenGui")
local StealBtn = Instance.new("TextButton")

StealGui.Name = "StealGui_bradokz"
StealGui.Parent = game:GetService("CoreGui")

StealBtn.Name = "StealBtn"
StealBtn.Parent = StealGui
StealBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StealBtn.Size = UDim2.new(0, 130, 0, 50)
StealBtn.Position = UDim2.new(0.8, 0, 0.35, 0)
StealBtn.Text = "Steal"
StealBtn.TextSize = 22
StealBtn.Font = Enum.Font.SourceSansBold
StealBtn.Visible = false
StealBtn.Active = true
StealBtn.Draggable = true

Tabs.Main:AddButton({
    Title = "السرقة تلقائي",
    Callback = function()
        StealBtn.Visible = true
    end
})

StealBtn.MouseButton1Click:Connect(function()
    for _, prompt in pairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            fireproximityprompt(prompt)
        end
    end
end)

---------------------------------------------------------
-- 3. Base Button (زر العودة للبيت الأسود)
---------------------------------------------------------
local BaseGui = Instance.new("ScreenGui")
local BaseBtn = Instance.new("TextButton")

BaseGui.Name = "BaseGui_bradokz"
BaseGui.Parent = game:GetService("CoreGui")

BaseBtn.Name = "BaseBtn"
BaseBtn.Parent = BaseGui
BaseBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BaseBtn.Size = UDim2.new(0, 130, 0, 50)
BaseBtn.Position = UDim2.new(0.8, 0, 0.48, 0)
BaseBtn.Text = "base"
BaseBtn.TextSize = 22
BaseBtn.Font = Enum.Font.SourceSansBold
BaseBtn.Visible = false
BaseBtn.Active = true
BaseBtn.Draggable = true

Tabs.Main:AddButton({
    Title = "العودة",
    Callback = function()
        BaseBtn.Visible = true
    end
})

local SavedBasePos = nil
if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
    SavedBasePos = LocalPlayer.Character.HumanoidRootPart.CFrame
end

BaseBtn.MouseButton1Click:Connect(function()
    if SavedBasePos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBasePos
    end
end)

---------------------------------------------------------
-- 4. Target Player & Bat Attack
---------------------------------------------------------
local playerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        table.insert(playerNames, p.Name)
    end
end

local SelectedPlayerName = nil
local PlayerDropdown = Tabs.Main:AddDropdown("PlayerDropdown", {
    Title = "اختر الشخص في السيرفر",
    Values = playerNames,
    Multi = false,
    Default = 1,
})

PlayerDropdown:OnChanged(function(Value)
    SelectedPlayerName = Value
end)

Tabs.Main:AddButton({
    Title = "ضرب الشخص",
    Callback = function()
        if SelectedPlayerName then
            local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                    local bat = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if bat then
                        bat.Parent = LocalPlayer.Character
                        bat:Activate()
                    end
                end
            end
        end
    end
})

---------------------------------------------------------
-- 5. Size Control
---------------------------------------------------------
Tabs.Player:AddButton({
    Title = "تكبير الحجم",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            if hum:FindFirstChild("HeadScale") then
                hum.HeadScale.Value = hum.HeadScale.Value * 1.4
                hum.BodyDepthScale.Value = hum.BodyDepthScale.Value * 1.4
                hum.BodyWidthScale.Value = hum.BodyWidthScale.Value * 1.4
                hum.BodyHeightScale.Value = hum.BodyHeightScale.Value * 1.4
            end
        end
    end
})

Tabs.Player:AddButton({
    Title = "تصغير الحجم",
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
-- 6. Infinite Jump Toggle
---------------------------------------------------------
local InfJumpToggle = Tabs.Player:AddToggle("InfJumpToggle", {Title = "القفز اللانهائي", Default = false})

getgenv().InfJump = false
InfJumpToggle:OnChanged(function()
    getgenv().InfJump = Options.InfJumpToggle.Value
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

---------------------------------------------------------
-- 7. Lag Reduction
---------------------------------------------------------
Tabs.Settings:AddButton({
    Title = "تخفيف اللاق",
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

Fluent:Notify({
    Title = "bradokz Hub",
    Content = "تم تشغيل السكربت بنجاح!",
    Duration = 5
})
