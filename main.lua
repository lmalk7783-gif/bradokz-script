-- [[ bradokz Hub - V5 Custom Edition ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "bradokz Hub ⚡",
   LoadingTitle = "جاري تحميل السكربت...",
   LoadingSubtitle = "by bradokz",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("الحركة والحماية 🏃", 4483362458)
local CombatTab = Window:CreateTab("القتال والملاحقة ⚔️", 4483362458)
local VisualTab = Window:CreateTab("الرؤية والأداء 👁️", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local SavedBaseCFrame = nil
local TargetPlayer = nil
local IsAttacking = false

-- 1. حفظ موقع القاعدة تلقائياً
local function SaveBase()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SavedBaseCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end
SaveBase()

-- زرار الانتقال للقاعدة
MainTab:CreateButton({
   Name = "الانتقال إلى القاعدة (Teleport to Base)",
   Callback = function()
       if SavedBaseCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBaseCFrame
           Rayfield:Notify({ Title = "نجاح", Content = "تم الانتقال لقاعدتك بنجاح!", Duration = 2 })
       else
           Rayfield:Notify({ Title = "تنبيه", Content = "لم يتم تحديد موقع القاعدة بعد!", Duration = 2 })
       end
   end,
})

MainTab:CreateButton({
   Name = "تحديد موقع القاعدة الحالي",
   Callback = function()
       SaveBase()
       Rayfield:Notify({ Title = "تم الحفظ", Content = "تم تسجيل مكانك الحالي كقاعدة!", Duration = 2 })
   end,
})

-- 2. Desync معدل بدون وقوع أو تثبيت
local DesyncToggle = false
local DesyncConn = nil

MainTab:CreateToggle({
   Name = "تفعيل Desync (بدون وقوع أو تعليق)",
   CurrentValue = false,
   Flag = "DesyncV5",
   Callback = function(Value)
       DesyncToggle = Value
       if DesyncToggle then
           DesyncConn = RunService.Heartbeat:Connect(function()
               if DesyncToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                   local hrp = LocalPlayer.Character.HumanoidRootPart
                   local oldCFrame = hrp.CFrame
                   hrp.CFrame = hrp.CFrame * CFrame.new(0, math.random(-5, 5), 0)
                   RunService.RenderStepped:Wait()
                   hrp.CFrame = oldCFrame
               end
           end)
       else
           if DesyncConn then DesyncConn:Disconnect() end
       end
   end,
})

-- 3. القفز اللانهائي
local InfJumpEnabled = false
MainTab:CreateToggle({
   Name = "القفز اللانهائي (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
       InfJumpEnabled = Value
   end,
})

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 4. القتال والضرب
local PlayerNames = {}
local function UpdatePlayers()
    PlayerNames = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(PlayerNames, p.Name) end
    end
end
UpdatePlayers()

CombatTab:CreateDropdown({
   Name = "اختر اللاعب للاستهداف",
   Options = PlayerNames,
   CurrentOption = "",
   Flag = "TargetSelect",
   Callback = function(Option)
       TargetPlayer = Players:FindFirstChild(Option[1])
   end,
})

CombatTab:CreateToggle({
   Name = "تفعيل الملاحقة والضرب الآلي",
   CurrentValue = false,
   Flag = "AutoCombat",
   Callback = function(Value)
       IsAttacking = Value
       if IsAttacking then
           task.spawn(function()
               while IsAttacking do
                   task.wait(0.03)
                   if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       local myChar = LocalPlayer.Character
                       if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                           myChar.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.5)
                           local tool = myChar:FindFirstChildOfClass("Tool")
                           if tool then tool:Activate() end
                       end
                   end
               end
           end)
       end
   end,
})

-- 5. كشف أغلى BrainRot في السيرفر بس (Most Expensive BrainRot ESP)
local ExpensiveESPEnabled = false

VisualTab:CreateToggle({
   Name = "كشف أغلى BrainRot في السيرفر (ESP)",
   CurrentValue = false,
   Flag = "MostExpensiveESP",
   Callback = function(Value)
       ExpensiveESPEnabled = Value
       
       -- مسح أي كشف قديم
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Highlight") and v.Name == "MostExpensiveBrainRotESP" then
               v:Destroy()
           end
       end
       
       if ExpensiveESPEnabled then
           task.spawn(function()
               local highestValue = -1
               local rarestItem = nil

               -- البحث عن الأغلى في الماب (بفحص القيمة أو السعر)
               for _, obj in pairs(workspace:GetDescendants()) do
                   local valObj = obj:FindFirstChild("Value") or obj:FindFirstChild("Price") or obj:FindFirstChild("Cost")
                   if valObj and valObj:IsA("IntValue") or valObj:IsA("NumberValue") then
                       if valObj.Value > highestValue then
                           highestValue = valObj.Value
                           rarestItem = obj
                       end
                   end
               end

               -- إذا لم يجد قيمة مباشرة، يحدد العنصر ذو أعلى مستوى/اسم
               if not rarestItem then
                   for _, obj in pairs(workspace:GetDescendants()) do
                       if obj:IsA("Model") and (obj.Name:find("BrainRot") or obj.Name:find("100M") or obj.Name:find("Secret")) then
                           rarestItem = obj
                           break
                       end
                   end
               end

               if rarestItem then
                   local hl = Instance.new("Highlight")
                   hl.Name = "MostExpensiveBrainRotESP"
                   hl.FillColor = Color3.fromRGB(255, 215, 0) -- لون ذهبي
                   hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                   hl.Parent = rarestItem
                   Rayfield:Notify({ Title = "تم الكشف!", Content = "تم تحديد مكان أغلى BrainRot باللون الذهبي!", Duration = 3 })
               else
                   Rayfield:Notify({ Title = "تنبيه", Content = "لم يتم العثور على عنصر ثين بعينه الآن.", Duration = 3 })
               end
           end)
       end
   end,
})

-- 6. تخفيف اللاق (Anti-Lag)
VisualTab:CreateButton({
   Name = "تخفيف اللاق وزيادة الفريمات (Anti-Lag)",
   Callback = function()
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
               v.Material = Enum.Material.SmoothPlastic
           elseif v:IsA("Decal") or v:IsA("Texture") then
               v:Destroy()
           elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
           end
       end
       game:GetService("Lighting").GlobalShadows = false
       Rayfield:Notify({ Title = "تم الإزالة", Content = "تم إزالة اللاق وتحسين الفريمات بنجاح!", Duration = 3 })
   end,
})
