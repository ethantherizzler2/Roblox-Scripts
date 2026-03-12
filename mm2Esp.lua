local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
local GetPlayerData = ReplicatedStorage:FindFirstChild("GetPlayerData", true)

local Roles = {}

local Colors = {
	Murderer = Color3.fromRGB(225,0,0),
	Sheriff = Color3.fromRGB(0,0,225),
	Hero = Color3.fromRGB(255,250,0),
	Innocent = Color3.fromRGB(0,225,0)
}

local function CreateHighlight(char)
	if not char then return end
	if not char:FindFirstChild("Highlight") then
		local h = Instance.new("Highlight")
		h.Name = "Highlight"
		h.FillTransparency = 0.5
		h.OutlineTransparency = 0
		h.Parent = char
	end
end

local function IsAlive(player)
	local data = Roles[player.Name]
	if data then
		return not data.Killed and not data.Dead
	end
	return false
end

local function UpdateRoles()
	local success, result = pcall(function()
		return GetPlayerData:InvokeServer()
	end)

	if success and result then
		Roles = result
	end
end

local function UpdateHighlights()
	for _,player in ipairs(Players:GetPlayers()) do
		if player ~= LP and player.Character then

			CreateHighlight(player.Character)

			local highlight = player.Character:FindFirstChild("Highlight")
			local data = Roles[player.Name]

			if highlight and data and IsAlive(player) then
				local role = data.Role or "Innocent"
				highlight.FillColor = Colors[role] or Colors.Innocent
			end
		end
	end
end

task.spawn(function()
	while true do
		UpdateRoles()
		task.wait(1)
	end
end)

-- Update visuals every frame
RunService.RenderStepped:Connect(function()
	UpdateHighlights()
end)
