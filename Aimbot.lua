-- @ttwiz_z, edited by @Basevr on Discord
-- Aimbot (LocalScript) - Humanoid only
-- Hold = V, Toggle = B
print("@ttwiz_z made this, edited by @Basevr on Discord")
local ShowNotifications = true
local HoldKey = Enum.KeyCode.V
local ToggleKey = Enum.KeyCode.B
local ESP = true
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local Aiming = false
local ToggleAiming = false
local HoldAiming = false
local Target = nil

local function Notify(Message)
	if not ShowNotifications then return end
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Aimbot",
			Text = Message,
			Icon = "rbxassetid://16377272133",
			Duration = 0.5
		})
	end)
end

local Callback = Instance.new("BindableFunction")
function Callback.OnInvoke(Button)
end
Notify("Hold = V, Toggle = B")
Callback:Destroy()

local function GenerateString()
	return string.lower(string.reverse(string.sub(HttpService:GenerateGUID(false), 1, 8)))
end

local function CreateESP(Model)
	if not ESP then return end
	if Model:FindFirstChildWhichIsA("SelectionBox") then return end

	local Hitbox = Instance.new("SelectionBox")
	Hitbox.Name = GenerateString()
	Hitbox.LineThickness = 0.05
	Hitbox.Adornee = Model
	Hitbox.Parent = Model

	spawn(function()
		while Hitbox.Parent and Hitbox:IsDescendantOf(game) do
			for i = 1, 230 do
				if not Hitbox.Parent or not Hitbox:IsDescendantOf(game) then
					return
				end
				if Target ~= Model then
					pcall(function() Debris:AddItem(Hitbox, 0) end)
					return
