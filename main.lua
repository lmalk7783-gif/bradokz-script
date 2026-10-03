-- [Flashback Feature for bradokz Hub]
local LocalPlayer = game:GetService("Players").LocalPlayer

-- إنشاء زرار الفلاش باك داخل الواجهة الرئيسية
local FlashbackBtn = Instance.new("TextButton")
FlashbackBtn.Size = UDim2.new(0.9, 0, 0, 40)
FlashbackBtn.Position = UDim2.new(0.05, 0, 0, 255) -- تحت زرار الانتقال للمسدس
FlashbackBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
FlashbackBtn.Text = "حفظ نقطة الفلاش باك"
FlashbackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlashbackBtn.TextSize = 13
FlashbackBtn.Font = Enum.Font.GothamBold
FlashbackBtn.Parent = MainFrame -- يتم إضافته تلقائياً للواجهة

local FBC = Instance.new("UICorner")
FBC.CornerRadius = UDim.new(0, 8)
FBC.Parent = FlashbackBtn

local savedPos = nil

FlashbackBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not savedPos then
                -- حفظ النقطة
                savedPos = hrp.CFrame
                FlashbackBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
                FlashbackBtn.Text = "الرجوع السريع (Flashback)"
            else
                -- الرجوع الانسيابي الفوري للنقطة المحفوظة
                hrp.CFrame = savedPos
                savedPos = nil
                FlashbackBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
                FlashbackBtn.Text = "حفظ نقطة الفلاش باك"
            end
        end
    end
end)
