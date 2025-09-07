-- Green balls aura fr

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humroot = char:WaitForChild("HumanoidRootPart")

local AURA_COLOR = Color3.fromRGB(0, 255, 80) -- green
local ORBIT_COUNT = 12
local RADIUS = 3
local ROT_SPEED = 3
local HEIGHT = 2 -- u can change here

-- DIDDY
if humroot:FindFirstChild("GreenBalls") then
    humroot.GreenAura:Destroy()
end

local auraFolder = Instance.new("Folder")
auraFolder.Name = "GreenBalls"
auraFolder.Parent = humroot

local orbitParts = {}
for i = 1, ORBIT_COUNT do
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.3, 0.3, 0.3)
    part.Shape = Enum.PartType.Ball
    part.Color = AURA_COLOR
    part.Material = Enum.Material.Neon
    part.Anchored = true
    part.CanCollide = false
    part.Parent = auraFolder
    table.insert(orbitParts, part)
end

RunService.RenderStepped:Connect(function()
    local t = tick() * ROT_SPEED
    for i, part in ipairs(orbitParts) do
        local angle = (i / #orbitParts) * math.pi * 2 + t
        local yOffset = HEIGHT * math.sin(t + i)
        local offset = Vector3.new(math.cos(angle) * RADIUS, yOffset, math.sin(angle) * RADIUS)
        part.Position = humroot.Position + offset
    end
end)
