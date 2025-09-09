local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")


if _G.TriggerbotConnection then
    _G TriggerbotConnection:Disconnect()
    _G.TriggerbotConnection = nil
end

local TRIGGER_KEY = Enum.KeyCode.V -- key bind
local Active = false

local function notify(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Triggerbot";
        Text = msg;
        Duration = 2;
    })
end

Mouse.KeyDown:Connect(function(key)
    if key:lower() == TRIGGER_KEY.Name:lower() then
        Active = not Active
        notify("Triggerbot " .. (Active and "ON" or "OFF"))
    end
end)

-- Main function
_G.TriggerbotConnection = RunService.RenderStepped:Connect(function()
    if not Active then return end

    local tool = Character:FindFirstChildOfClass("Tool") 
    if not tool then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local lookVector = (targetHRP.Position - HumanoidRootPart.Position).Unit
            local mouseDirection = (Mouse.Hit.Position - HumanoidRootPart.Position).Unit

            if lookVector:Dot(mouseDirection) > 0.95 then
               -- Start shooting lil nigga
                tool:Activate()
            end
        end
    end
end)
