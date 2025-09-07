local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer 
local camera = game.Workspace.CurrentCamera
local aimdih = false
local Target = nil

local function ethantherizzler_1() 
    local limit = 10000  -- Diddy
    local closestPlayer = nil
    local closestMagnitude = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPosition, onScreen = camera:WorldToViewportPoint(head.Position) -- Thanks to diddy

            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - mousePos).Magnitude

                if distance < closestMagnitude then
                    local rayOrigin = camera.CFrame.Position
                    local rayDirection = (head.Position - rayOrigin).unit * limit
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterDescendantsInstances = {localPlayer.Character}
                    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

                    if raycastResult and raycastResult.Instance:IsDescendantOf(player.Character) then
                        closestMagnitude = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end
local function lock()
    if Target and Target.Character then
        local targetPart = Target.Character:FindFirstChild("Head") or Target.Character:FindFirstChild("Torso") or Target.Character:FindFirstChild("UpperTorso")
        if targetPart then
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
        end 
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Q then
        if aimdih then
            aimdih = false
            Target = nil
        else
            Target = ethantherizzler_1()
            aimdih = (Target ~= nil)
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if aimdih then
        lock()
    end
end)
print("Hello")
