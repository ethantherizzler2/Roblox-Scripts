-- made by @ethantherizzler_1
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomPinkNotify"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

function Notify(titleText, descText, duration)
    duration = duration or 3

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 80)
    Frame.Position = UDim2.new(1, 350, 0.8, 0) 
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    Frame.AnchorPoint = Vector2.new(1, 0)

    local Corner = Instance.new("UICorner", Frame)
    Corner.CornerRadius = UDim.new(0, 16)

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 6, 1, 0)
    Accent.Position = UDim2.new(0, 0, 0, 0)
    Accent.BackgroundColor3 = Color3.fromRGB(255, 192, 203)
    Accent.BorderSizePixel = 0
    Accent.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0.5, 0)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = titleText
    Title.TextColor3 = Color3.fromRGB(255, 192, 203)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Frame

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -20, 0.5, -5)
    Desc.Position = UDim2.new(0, 15, 0.5, 0)
    Desc.BackgroundTransparency = 1
    Desc.Text = descText
    Desc.TextColor3 = Color3.fromRGB(220, 220, 220)
    Desc.TextSize = 16
    Desc.Font = Enum.Font.Gotham
    Desc.TextWrapped = true
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Frame

local tweenIn = TweenService:Create(
    Frame,
    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    {Position = UDim2.new(1, -20, 0.92, 0)}
)
tweenIn:Play()

task.wait(duration)

local tweenOut = TweenService:Create(
    Frame,
    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
    {Position = UDim2.new(1, 350, 0.92, 0)}
)
tweenOut:Play()

    tweenOut.Completed:Wait()
    Frame:Destroy()
end

Notify("Phantom", "Loaded successfully 💗", 4)