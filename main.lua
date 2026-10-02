-- [[ bradokz Hub - V2 Ultimate ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "bradokz Hub ⚡",
   LoadingTitle = "جاري تحميل السكربت المطور...",
   LoadingSubtitle = "by bradokz",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("المميزات الرئيسية 🚀", 4483362458)
local CombatTab = Window:CreateTab("القتال والملاحقة ⚔️", 4483362458)
local PlayerTab = Window:CreateTab("حجم اللاعب 📏", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local SavedPosition = nil
local TargetPlayer = nil
local IsAttacking = false

-- 1. زر السرقة السريعة بدون مربع (Instant Steal)
MainTab:CreateButton({
   Name = "سرقة فورية بدون انتظار (Instant Steal)",
   Callback = function()
       for _, prompt in pairs(workspace:GetDescendants()) do
           if prompt:IsA("ProximityPrompt") then
               prompt.HoldDuration = 0
               fireproximityprompt(prompt)
           end
       end
   end,
})

-- 2. تحسين الـ Desync الخارق (محدش يضربك)
local DesyncEnabled = false
MainTab:CreateToggle({
   Name = "تفعيل Desync متطور (حماية من الضرب)",
   CurrentValue = false,
   Flag = "DesyncToggle",
   Callback = function(Value)
       DesyncEnabled = Value
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("HumanoidRootPart") then
           if DesyncEnabled then
               char.HumanoidRootPart.CanCollide = false
               -- قطع مزامنة الـ Velocity لمنع التتبع
               RunService.Heartbeat:Connect(function()
                   if DesyncEnabled and char:FindFirstChild("HumanoidRootPart") then
                       char.HumanoidRootPart.Velocity = Vector3.new(0, -100, 0)
                   end
               end)
           end
       end
   end,
})

-- 3. نظام ملاحقة وضرب اللاعبين + العودة عند ترك العصا
local PlayerList = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(PlayerList, p.Name) end
end

CombatTab:CreateDropdown({
   Name = "اختر اللاعب للاستهداف",
   Options = PlayerList,
   CurrentOption = "",
   Flag = "TargetDropdown",
   Callback = function(Option)
       TargetPlayer = Players:FindFirstChild(Option[1])
   end,
})

CombatTab:CreateToggle({
   Name = "تفعيل الملاحقة والضرب الآلي",
   CurrentValue = false,
   Flag = "AutoAttack",
   Callback = function(Value)
       IsAttacking = Value
       if Value then
           SavedPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame
           
           task.spawn(function()
               while IsAttacking do
                   task.wait()
                   local char = LocalPlayer.Character
                   local tool = char and char:FindFirstChildOfClass("Tool")
                   
                   -- التحقق من إمساك العصا/السلاح
                   if tool and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       -- الالتصاق باللاعب
                       char.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                       -- الضرب التلقائي
                       tool:Activate()
                   elseif not tool and SavedPosition then
                       -- في حالة ترك العصا: العودة للمكان الأصلي
                       char.HumanoidRootPart.CFrame = SavedPosition
                   end
               end
           end)
       else
           if SavedPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = SavedPosition
           end
       end
   end,
})

-- 4. التحكم في حجم الشخصية (Size Changer)
PlayerTab:CreateButton({
   Name = "تكبير الحجم (Big Size)",
   Callback = function()
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("Humanoid") then
           local hum = char.Humanoid
           if hum:FindFirstChild("BodyWidthScale") then
               hum.BodyWidthScale.Value = 3
               hum.BodyHeightScale.Value = 3
               hum.BodyDepthScale.Value = 3
               hum.HeadScale.Value = 3
           end
       end
   end,
})

PlayerTab:CreateButton({
   Name = "تصغير الحجم (Small Size)",
   Callback = function()
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("Humanoid") then
           local hum = char.Humanoid
           if hum:FindFirstChild("BodyWidthScale") then
               hum.BodyWidthScale.Value = 0.4
               hum.BodyHeightScale.Value = 0.4
               hum.BodyDepthScale.Value = 0.4
               hum.HeadScale.Value = 0.4
           end
       end
   end,
})

PlayerTab:CreateButton({
   Name = "إعادة للحجم الطبيعي",
   Callback = function()
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("Humanoid") then
           local hum = char.Humanoid
           if hum:FindFirstChild("BodyWidthScale") then
               hum.BodyWidthScale.Value = 1
               hum.BodyHeightScale.Value = 1
               hum.BodyDepthScale.Value = 1
               hum.HeadScale.Value = 1
           end
       end
   end,
})

Rayfield:Notify({
   Title = "bradokz Hub",
   Content = "تم تحميل المميزات الجديدة بنجاح!",
   Duration = 5,
})
