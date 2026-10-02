-- [[ bradokz Hub - V6 Final Fixed ]] --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "bradokz Hub ⚡",
   LoadingTitle = "جاري التحميل...",
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

-- 1. حفظ القاعدة والانتقال إليها
local function SaveBase()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        SavedBaseCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end
SaveBase()

MainTab:CreateButton({
   Name = "الانتقال إلى القاعدة (Teleport to Base)",
   Callback = function()
       if SavedBaseCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBaseCFrame
           Rayfield:Notify({ Title = "نجاح", Content = "تم الانتقال لقاعدتك!", Duration = 2 })
       end
   end,
})

MainTab:CreateButton({
   Name = "تحديد موقع القاعدة الحالي",
   Callback = function()
       SaveBase()
       Rayfield:Notify({ Title = "تم الحفظ", Content = "تم تحديد مكان قاعدتك!", Duration = 2 })
   end,
})

-- 2. Desync ثابت (بدون وقوع أو تثبيت)
local DesyncToggle = false
MainTab:CreateToggle({
   Name = "تفعيل Desync (حماية خفيفة)",
   CurrentValue = false,
   Flag = "DesyncFixed",
   Callback = function(Value)
       DesyncToggle = Value
       task.spawn(function()
           while DesyncToggle do
               task.wait()
               if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                   local hrp = LocalPlayer.Character.HumanoidRootPart
                   hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                   hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
               end
           end
       end)
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

-- 4. القتال والضرب (بدون الوقوع في الأرض)
local PlayerNames = {}
for _, p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then table.insert(PlayerNames, p.Name) end
end

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
                   task.wait(0.05)
                   if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                       local myChar = LocalPlayer.Character
                       if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                           -- الانتقال خلف الهدف بدون التسبب في الوقوع
                           myChar.HumanoidRootPart.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                           
                           -- تفعيل الضربة
                           local tool = myChar:FindFirstChildOfClass("Tool")
                           if tool then tool:Activate() end
                       end
                   end
               end
           end)
       end
   end,
})

-- 5. كشف أغلى BrainRot (ESP نصي واضح فوق المجسم)
local ESPEnabled = false
VisualTab:CreateToggle({
   Name = "كشف أغلى BrainRot في السيرفر (ESP)",
   CurrentValue = false,
   Flag = "MostExpensiveESP",
   Callback = function(Value)
       ESPEnabled = Value
       
       -- تنظيف السكربت من الكشوفات القديمة
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("BillboardGui") and v.Name == "BrainRotESP_Gui" then
               v:Destroy()
           end
       end

       if ESPEnabled then
           task.spawn(function()
               local targetObj = nil
               
               -- البحث عن أعلى كائن يحتوي على كلمة BrainRot أو قيم عالية
               for _, v in pairs(workspace:GetDescendants()) do
                   if v:IsA("Model") or v:IsA("BasePart") then
                       if v.Name:lower():find("brain") or v.Name:lower():find("rot") or v.Name:find("100M") or v.Name:find("Secret") then
                           targetObj = v
                           break
                       end
                   end
               end

               if targetObj then
                   local bg = Instance.new("BillboardGui")
                   bg.Name = "BrainRotESP_Gui"
                   bg.AlwaysOnTop = true
                   bg.Size = UDim2.new(0, 200, 0, 50)
                   bg.ExtentsOffset = Vector3.new(0, 3, 0)
                   bg.Parent = targetObj

                   local txt = Instance.new("TextLabel")
                   txt.Size = UDim2.new(1, 0, 1, 0)
                   txt.BackgroundTransparency = 1
                   txt.Text = "🔥 أغلى BrainRot هنا 🔥"
                   txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                   txt.TextScaled = true
                   txt.Font = Enum.Font.SourceSansBold
                   txt.Parent = bg
                   
                   Rayfield:Notify({ Title = "تم الكشف!", Content = "تم تحديد مكان الكائن النصي باللون الذهبي!", Duration = 3 })
               else
                   Rayfield:Notify({ Title = "تنبيه", Content = "لم يتم العثور على BrainRot في الخريطة حالياً", Duration = 3 })
               end
           end)
       end
   end,
})

-- 6. تخفيف اللاق الفوري (Anti-Lag)
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
       Rayfield:Notify({ Title = "تم الإزالة", Content = "تم إزالة اللاق وتحسين الأداء!", Duration = 3 })
   end,
})
