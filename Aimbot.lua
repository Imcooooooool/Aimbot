-- @ttwiz_z, edited by @Basevr on Discord
-- Aimbot (LocalScript) - Humanoid only
-- Hold = V, Toggle = B
print("@ttwiz_z made this, edited by @Basevr on Discord")
local ShowNotifications = true
local HoldKey = Enum.KeyCode.V
local ToggleKey = Enum.KeyCode.B
local ESP = true
local TriggerDistance = 100
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
function Callback.OnInvoke(Button) end
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
		while Hitbox.Parent and Hitbox:IsDescendantOf(game) and Target == Model do
			for i = 1, 230 do
				if not Hitbox.Parent or not Hitbox:IsDescendantOf(game) or Target ~= Model then
					pcall(function() Debris:AddItem(Hitbox, 0) end)
					return
				end
				Hitbox.Name = GenerateString()
				Hitbox.Color3 = Color3.fromHSV(i / 230, 1, 1)
				task.wait()
			end
		end
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == HoldKey then
			HoldAiming = true
			Target = nil
			Notify("[Aiming Mode]: HOLD ON")
		elseif input.KeyCode == ToggleKey then
			ToggleAiming = not ToggleAiming
			Target = nil
			if ToggleAiming then
				Notify("[Aiming Mode]: TOGGLE ON")
			else
				Notify("[Aiming Mode]: TOGGLE OFF")
			end
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == HoldKey then
		HoldAiming = false
		Target = nil
		Notify("[Aiming Mode]: HOLD OFF")
	end
end)

RunService.RenderStepped:Connect(function()
	pcall(function()
		Aiming = ToggleAiming or HoldAiming
		if not Aiming then return end
		if not Target then
			local closestDist = math.huge
			for _, model in ipairs(workspace:GetChildren()) do
				local humanoid = model:FindFirstChildWhichIsA("Humanoid")
				if humanoid and humanoid.Health > 0 and model ~= Player.Character then
					local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
					if root then
						local viewportPoint, onScreen = Camera:WorldToViewportPoint(root.Position)
						if onScreen then
							local mouseVec = Vector2.new(Mouse.X, Mouse.Y)
							local partVec = Vector2.new(viewportPoint.X, viewportPoint.Y)
							local mag = (mouseVec - partVec).Magnitude
							if mag <= TriggerDistance and mag < closestDist then
								closestDist = mag
								Target = model
							end
						end
					end
				end
			end
			if Target then
				CreateESP(Target)
				Notify("[Target]: "..Target.Name)
			end
		end
		if Target then
			local humanoid = Target:FindFirstChildWhichIsA("Humanoid")
			local root = Target:FindFirstChild("HumanoidRootPart") or Target.PrimaryPart
			if humanoid and humanoid.Health > 0 and root then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, root.Position)
			else
				Target = nil
			end
		end
	end)
end)
