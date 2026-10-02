-- bradokz Hub - Ultra Light & Fast Version
-- Works 100% on Delta Mobile Executor

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local DesyncBtn = Instance.new("TextButton")
local StealGuiBtn = Instance.new("TextButton")
local BaseGuiBtn = Instance.new("TextButton")
local InfJumpBtn = Instance.new("TextButton")
local LagBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "bradokzHubGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 170, 255)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 320)
MainFrame.Active = true
MainFrame.Draggable = true

TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "bradokz Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 20

CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleLabel
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Position = UDim2.new(0.85, 0, 0.1, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local function createButton(name, text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Position = UDim2.new(0.1, 0, 0, posY)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Desync
local desyncActive = false
local desyncBtnObj
desyncBtnObj = createButton("DesyncBtn", "Desync: إيقاف", 50, function()
    desyncActive = not desyncActive
    if desyncActive then
        desyncBtnObj.Text = "Desync: تفعيل"
        desyncBtnObj.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        desyncBtnObj.Text = "Desync: إيقاف"
        desyncBtnObj.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    local lp = game:GetService("Players").LocalPlayer
    if desyncActive and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        local oldVel = hrp.Velocity
        hrp.Velocity = Vector3.new(9999, 9999, 9999)
        game:GetService("RunService").RenderStepped:Wait()
        hrp.Velocity = oldVel
    end
end)

-- 2. Steal Button
createButton("StealBtn", "تفعيل زر السرقة (Steal)", 100, function()
    local sGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local sBtn = Instance.new("TextButton", sGui)
    sBtn.Size = UDim2.new(0, 110, 0, 50)
    sBtn.Position = UDim2.new(0.8, 0, 0.3, 0)
    sBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    sBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sBtn.Text = "Steal"
    sBtn.TextSize = 20
    sBtn.Draggable = true
    sBtn.Active = true
    sBtn.MouseButton1Click:Connect(function()
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                fireproximityprompt(prompt)
            end
        end
    end)
end)

-- 3. Base Button
createButton("BaseBtn", "تفعيل زر العودة (base)", 150, function()
    local bGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local bBtn = Instance.new("TextButton", bGui)
    bBtn.Size = UDim2.new(0, 110, 0, 50)
    bBtn.Position = UDim2.new(0.8, 0, 0.45, 0)
    bBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bBtn.Text = "base"
    bBtn.TextSize = 20
    bBtn.Draggable = true
    bBtn.Active = true
    
    local lp = game:GetService("Players").LocalPlayer
    local savedPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.CFrame
    
    bBtn.MouseButton1Click:Connect(function()
        if savedPos and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = savedPos
        end
    end)
end)

-- 4. Infinite Jump
local infJumpActive = false
local infJumpBtnObj
infJumpBtnObj = createButton("InfJumpBtn", "القفز اللانهائي: إيقاف", 200, function()
    infJumpActive = not infJumpActive
    if infJumpActive then
        infJumpBtnObj.Text = "القفز اللانهائي: تفعيل"
        infJumpBtnObj.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        infJumpBtnObj.Text = "القفز اللانهائي: إيقاف"
        infJumpBtnObj.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    local lp = game:GetService("Players").LocalPlayer
    if infJumpActive and lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 5. Lag Reduction
createButton("LagBtn", "تخفيف اللاق", 250, function()
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
end)
