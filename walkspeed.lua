- Da hood based games walkspeed Only!

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local NORMAL_SPEED = 16
local FAST_SPEED = 250

local debugLog = {}

local function log(msg)
    local text = "[SpeedScript] " .. tostring(msg)
    print(text)
    table.insert(debugLog, text)
end

local function copyDebug()
    local full = table.concat(debugLog, "\n")

    pcall(function()
        if setclipboard then
            setclipboard(full)
        end
    end)
end

local humanoid

local function findHumanoid()
    local char = player.Character or player.CharacterAdded:Wait()
    humanoid = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)

    if humanoid then
        log("Humanoid found")
    else
        log("Humanoid NOT found")
        copyDebug()
    end
end

findHumanoid()

player.CharacterAdded:Connect(function()
    log("Character respawned")
    task.wait(0.5)
    findHumanoid()
end)

local holding = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.C then
        holding = true
        log("C pressed")
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then
        holding = false
        log("C released")

        if humanoid then
            humanoid.WalkSpeed = NORMAL_SPEED
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not humanoid then return end

    if holding then
        if humanoid.WalkSpeed ~= FAST_SPEED then
            humanoid.WalkSpeed = FAST_SPEED
        end
    end
end)

log("Done")
