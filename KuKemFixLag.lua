local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LP = Players.LocalPlayer

-- ═══════════ GUI FPS ═══════════
local gui = Instance.new("ScreenGui")
gui.Name = "KukemPremium"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 140, 0, 30)
fpsLabel.Position = UDim2.new(0, 20, 0, 60)
fpsLabel.BackgroundColor3 = Color3.fromRGB(10, 8, 16)
fpsLabel.BackgroundTransparency = 0.3
fpsLabel.Text = "FPS: --"
fpsLabel.TextColor3 = Color3.fromRGB(120, 255, 180)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 15
fpsLabel.BorderSizePixel = 0
fpsLabel.Parent = gui

local c1 = Instance.new("UICorner"); c1.CornerRadius = UDim.new(0, 6); c1.Parent = fpsLabel
local s1 = Instance.new("UIStroke")
s1.Color = Color3.fromRGB(120, 255, 180); s1.Thickness = 1; s1.Transparency = 0.3
s1.Parent = fpsLabel

-- ═══════════ FIX NGAY KHI CHẠY ═══════════
local function fixAll()
    local count = 0

    -- 1. Tắt hiệu ứng
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local t = obj.ClassName
        if t == "ParticleEmitter" or t == "Trail" or t == "Beam"
            or t == "Fire" or t == "Smoke" or t == "Sparkles"
            or t == "PointLight" or t == "SpotLight" then
            if obj.Parent and not obj:IsDescendantOf(LP.Character) then
                pcall(function() obj.Enabled = false end)
                count = count + 1
            end
        elseif t == "Texture" or t == "Decal" then
            if obj.Parent and not obj:IsDescendantOf(LP.Character) then
                pcall(function() obj.Transparency = 1 end)
                count = count + 1
            end
        end
    end

    -- 2. Xóa cỏ/cây
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local n = obj.Name:lower()
        if n:find("grass") or n:find("foliage") or n:find("bush") or n:find("leaf") then
            pcall(function() obj:Destroy() end)
            count = count + 1
        end
    end

    -- 3. Xóa nước
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("water") and obj:IsA("BasePart") then
            pcall(function()
                obj.Transparency = 1
                obj.CanCollide = false
            end)
            count = count + 1
        end
    end

    -- 4. Xóa rác
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
            local n = obj.Name:lower()
            if n:find("debris") or n:find("garbage") or n:find("trash")
                or n:find("rubble") or n:find("corpse") then
                pcall(function() obj:Destroy() end)
                count = count + 1
            end
        end
    end

    -- 5. Tắt bóng đổ
    Lighting.GlobalShadows = false

    -- 6. Tăng tầm nhìn (xóa sương mù)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 100000

    -- 7. Giảm quality rendering
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    -- 8. Tắt anti-alias
    pcall(function()
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    end)

    print("[KuKem Lag Fix] Da fix " .. count .. " vat the")
    return count
end

fixAll()

-- Auto dọn rác mỗi 15 giây
spawn(function()
    while true do
        task.wait(15)
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
                local n = obj.Name:lower()
                if n:find("debris") or n:find("garbage") or n:find("corpse") then
                    pcall(function() obj:Destroy() end)
                end
            end
        end
    end
end)

-- ═══════════ FPS COUNTER ═══════════
local frames = 0
local lastTime = tick()
local fps = 0

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local now = tick()
    if now - lastTime >= 0.5 then
        fps = math.floor(frames / (now - lastTime))
        frames = 0
        lastTime = now
    end
end)

spawn(function()
    while true do
        local color = Color3.fromRGB(120, 255, 180)   -- xanh
        if fps < 30 then
            color = Color3.fromRGB(255, 80, 80)        -- đỏ
        elseif fps < 50 then
            color = Color3.fromRGB(255, 200, 40)       -- vàng
        end
        fpsLabel.Text = "FPS: " .. fps
        fpsLabel.TextColor3 = color
        s1.Color = color
        task.wait(0.5)
    end
end)

print("[KuKemPremium] Auto Fix Lag chay xong")