-- Tema Renkleri Tablosu
local themes = {
    White = {
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        OutlineColor = Color3.fromRGB(128, 128, 128),
        TextColor = Color3.fromRGB(0, 0, 0)
    },
    Black = {
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        OutlineColor = Color3.fromRGB(128, 128, 128),
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    ["Night Blue"] = {
        BackgroundColor = Color3.fromRGB(10, 25, 70),
        OutlineColor = Color3.fromRGB(128, 128, 128),
        TextColor = Color3.fromRGB(255, 255, 255)
    }
}

-- Tema seçici çerçevesi
local themeSelector = Instance.new("Frame")
themeSelector.Size = UDim2.new(0, 200, 0, 50)
themeSelector.Position = UDim2.new(0, 10, 0, 40)
themeSelector.BackgroundTransparency = 1 -- Şeffaf (aracı sadece butonlar gösterilecek)
themeSelector.Parent = mainFrame

-- Tema butonlarını oluştur
for i, themeName in ipairs({"White", "Black", "Night Blue"}) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 40)
    btn.Position = UDim2.new(0, (i-1) * 65, 0, 0)
    btn.Text = themeName
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Parent = themeSelector

    -- Butona tıklanınca temayı uygula
    btn.MouseButton1Click:Connect(function()
        local theme = themes[themeName]
        mainFrame.BackgroundColor3 = theme.BackgroundColor
        mainFrame.BorderColor3 = theme.OutlineColor

        -- Tüm içindeki metinlerin rengini değiştir
        for _, obj in pairs(mainFrame:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                obj.TextColor3 = theme.TextColor
            end
            if obj:IsA("Frame") then
                obj.BorderColor3 = theme.OutlineColor
            end
        end

        -- Özel durumlar (örneğin FG3 butonu)
        fg3Button.BackgroundColor3 = theme.BackgroundColor
        fg3Button.TextColor3 = theme.TextColor
        fg3Button.BorderColor3 = theme.OutlineColor

        -- Kapat, küçült buton renkleri
        closeButton.BackgroundColor3 = theme.BackgroundColor
        closeButton.TextColor3 = theme.TextColor
        closeButton.BorderColor3 = theme.OutlineColor

        minimizeButton.BackgroundColor3 = theme.BackgroundColor
        minimizeButton.TextColor3 = theme.TextColor
        minimizeButton.BorderColor3 = theme.OutlineColor
    end)
end

-- Animasyon için TweenService
local TweenService = game:GetService("TweenService")

-- Animasyonlu aç/kapat fonksiyonu
local function animateGui(open)
    if open then
        mainFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 0, 0, 0)
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 400)})
        tween:Play()
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Wait()
        mainFrame.Visible = false
    end
end

-- Kapat butonuna animasyonlu kapatma ekle
closeButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)

-- Onaydaki Yes butonuna animasyonlu kapatma
yesButton.MouseButton1Click:Connect(function()
    -- Önce animasyonla küçültüp sonra sil
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
    tween:Play()
    tween.Completed:Wait()
    screenGui:Destroy()
end)

-- No butonu onay penceresini kapatır (animasyon yok)
noButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
end)

-- Küçült butonu animasyonlu gizle/açma
minimizeButton.MouseButton1Click:Connect(function()
    animateGui(false)
    fg3Button.Visible = true
end)

-- FG3 butonu animasyonlu geri açma
fg3Button.MouseButton1Click:Connect(function()
    animateGui(true)
    fg3Button.Visible = false
end)

-- İlk tema olarak siyah seçili olsun (başlangıçta)
themeSelector:GetChildren()[1].TextColor3 = Color3.fromRGB(255, 255, 255)
themeSelector:GetChildren()[1].BackgroundColor3 = Color3.fromRGB(70, 70, 70)
themeSelector:GetChildren()[1]:MouseButton1Click() -- Otomatik uygulansın
