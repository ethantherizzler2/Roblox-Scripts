local ext = getgenv().Ethh

getgenv().walkSpeedSettings = {
    WalkSpeed = {
        Enabled = ext and ext.WalkSpeed and ext.WalkSpeed.Enabled or true,
        Speed = ext and ext.WalkSpeed and ext.WalkSpeed.Speed or 300,
    },
    Activation = {
        WalkSpeedToggleKey = ext and ext.WalkSpeed and ext.WalkSpeed.Keybind or "T",
    }
}


local uis = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local isSpeedEnabled = false
local defaultSpeed = 16


local function updateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if isSpeedEnabled and getgenv().walkSpeedSettings.WalkSpeed.Enabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().walkSpeedSettings.WalkSpeed.Speed
        end
    end
end


local speedConnection = RunService.RenderStepped:Connect(updateSpeed)


LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    updateSpeed()
end)


uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode[getgenv().walkSpeedSettings.Activation.WalkSpeedToggleKey] then
        isSpeedEnabled = not isSpeedEnabled
        if isSpeedEnabled then
            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().walkSpeedSettings.WalkSpeed.Speed
        else
            LocalPlayer.Character.Humanoid.WalkSpeed = defaultSpeed
        end
    end
end)
