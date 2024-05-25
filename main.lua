local Items = workspace:WaitForChild("Items")
local Living = workspace:WaitForChild("Living")
local Traps = workspace:WaitForChild("Traps")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Camera = workspace.CurrentCamera

local NotificationGui = Instance.new("ScreenGui")
local notificationlists = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

NotificationGui.Name = [[NotificationGui]]
NotificationGui.Parent = game.CoreGui
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

notificationlists.BackgroundColor3 = Color3.new(0, 0, 0)
notificationlists.BackgroundTransparency = 0.5
notificationlists.BorderColor3 = Color3.new(0, 0, 0)
notificationlists.BorderSizePixel = 0
notificationlists.Name = [[notification]]
notificationlists.Parent = NotificationGui
notificationlists.Position = UDim2.new(0.782774389, 0, 0.836363614, 0)
notificationlists.Size = UDim2.new(0.153, 0,0.078, 0)

UIListLayout.Parent = notificationlists
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

Parts = {}

function IsPartInMouseRadius(part:BasePart,radius)
	local vector, onScreen  = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
	if onScreen then
		local viewportPoint = Vector2.new(vector.X, vector.Y)
		local distance = (viewportPoint-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
		if distance <= radius then
			return true
		end
	end
	return false
end

function setup(model:Instance,atype)
	local part:BasePart
	if atype == "Item" then
		part = model.Handle
	elseif atype == "Monster" then
		part = model.HumanoidRootPart
	elseif atype == "Trap" then
		if model:IsA("BasePart") then
			part = model
		elseif model:IsA("Model") then
			part = model.PrimaryPart or model:FindFirstChild("Handle") or model:FindFirstChildOfClass("BasePart")
			if not part then
				local size = model:GetExtentsSize()
				part = Instance.new("Part",model)
				part.Name = "Box"
				part.Transparency = 1
				part.CanCollide = false
				part.Anchored = true
				part.Size = size
			end
		end
	elseif atype == "Start" then
		part = workspace.map.Pieces.RealStart.SpawnLocation
	end
	if not part then
		loadednotification("Error",model and model.Name.." cant find basepart! ("..atype..")" or "model is null!",3)
		return
	end
	
	if part:FindFirstChild("ItemEsp") then
		part.ItemEsp:Destroy()
	end
	if part:FindFirstChild("Highlight") then
		part.Highlight:Destroy()
	end
	
	local ItemEsp = Instance.new("BillboardGui")
	local Frame = Instance.new("Frame")
	local arrow = Instance.new("ImageLabel")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local info = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local ItemName = Instance.new("TextLabel")
	local TextLabel = Instance.new("TextLabel")

	ItemEsp.Active = true
	ItemEsp.ClipsDescendants = true
	ItemEsp.LightInfluence = 1
	ItemEsp.Name = [[ItemEsp]]
	ItemEsp.Parent = part
	ItemEsp.Size = UDim2.new(0, 75, 0, 38)
	ItemEsp.SizeOffset = Vector2.new(0, 0.6)
	ItemEsp.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ItemEsp.AlwaysOnTop = true

	Frame.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame.BackgroundTransparency = 1
	Frame.BorderColor3 = Color3.new(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Parent = ItemEsp
	Frame.Size = UDim2.new(1, 0, 1, 0)

	arrow.AnchorPoint = Vector2.new(0.5, 1)
	arrow.BackgroundColor3 = Color3.new(1, 1, 1)
	arrow.BackgroundTransparency = 1
	arrow.BorderColor3 = Color3.new(0, 0, 0)
	arrow.BorderSizePixel = 0
	arrow.Image = [[http://www.roblox.com/asset/?id=16513307678]]
	arrow.ImageColor3 = Color3.new(0, 0, 0)
	arrow.Name = [[arrow]]
	arrow.Parent = Frame
	arrow.Position = UDim2.new(0.5, 0, 1, 0)
	arrow.Rotation = -90
	arrow.Size = UDim2.new(0.300000012, 0, 0.300000012, 0)

	UIAspectRatioConstraint.Parent = arrow

	info.BackgroundColor3 = Color3.new(0, 0, 0)
	info.BackgroundTransparency = 0.5
	info.BorderColor3 = Color3.new(0, 0, 0)
	info.BorderSizePixel = 0
	info.Name = [[info]]
	info.Parent = Frame
	info.Size = UDim2.new(1, 0, 0.699999988, 0)
	
	if atype == "Item" then
		info.BackgroundColor3 = Color3.new(0, 0, 0)
	elseif atype == "Monster" then
		info.BackgroundColor3 = Color3.new(0.666667, 0, 0)
	elseif atype == "Trap" then
		info.BackgroundColor3 = Color3.new(0, 0, 0.380392)
	elseif atype == "Start" then
		info.BackgroundColor3 = Color3.new(0, 0.333333, 0)
	end

	UICorner.Parent = info

	ItemName.BackgroundColor3 = Color3.new(1, 1, 1)
	ItemName.BackgroundTransparency = 1
	ItemName.BorderColor3 = Color3.new(0, 0, 0)
	ItemName.BorderSizePixel = 0
	ItemName.Font = Enum.Font.GothamBold
	ItemName.Name = model.Name
	ItemName.Parent = info
	ItemName.Position = UDim2.new(0, 0, 0.150000006, 0)
	ItemName.Size = UDim2.new(1, 0, 0.400000006, 0)
	ItemName.TextColor3 = Color3.new(1, 1, 1)
	ItemName.TextScaled = true
	ItemName.TextSize = 14
	ItemName.TextWrapped = true
	ItemName.Text = model.Name
	
	TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderColor3 = Color3.new(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Parent = info
	TextLabel.Position = UDim2.new(0, 0, 0.600000024, 0)
	TextLabel.Size = UDim2.new(1, 0, 0.200000003, 0)
	TextLabel.TextColor3 = Color3.new(0.333333, 1, 1)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14
	TextLabel.TextWrapped = true
	
	local highlight = Instance.new("Highlight",part)
	highlight.FillColor = Color3.new(0,1,0)
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	
	if part.Transparency == 1 then
		part.Transparency = .5
	end
	
	if atype == "Monster" then
		TextLabel.Text = [[Health: ]].. model.Humanoid.Health .. [[/]].. model.Humanoid.MaxHealth
		ItemEsp.Size = UDim2.new(0, 100, 0, 50)
		highlight.FillColor = Color3.new(1, 0, 0)
	elseif atype == "Item" then
		TextLabel.Text = [[Value: ]].. model.Value.Value
		highlight.FillColor = Color3.new(0.317647, 0.639216, 0.47451)
		if model.Value.Value >= 80 then
			ItemEsp.Size = UDim2.new(0, 125, 0, 63)
			highlight.FillColor = Color3.new(0, 1, 0)
		end
	elseif atype == "Trap" then
		TextLabel.Text = "A trap."
		ItemEsp.Size = UDim2.new(0, 50, 0, 25)
		highlight.FillColor = Color3.new(1, 0, 0)
	else
		ItemName.Text = "Your Ship"
		TextLabel.Text = "Spawner."
		highlight.FillColor = Color3.new(1, 1, 1)
	end
	
	table.insert(Parts,part)
end

function loadednotification(text1,text2,duration)
	local notification = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local ItemName = Instance.new("TextLabel")
	local TextLabel = Instance.new("TextLabel")
	local Notification = Instance.new("Sound")
	
	notification.BackgroundColor3 = Color3.new(1, 1, 1)
	notification.BackgroundTransparency = 0
	notification.BorderColor3 = Color3.new(0, 0, 0)
	notification.BorderSizePixel = 0
	notification.Name = [[notification]]
	notification.Parent = notificationlists
	notification.Size = UDim2.new(0,0,1,0)
	
	game:GetService("TweenService"):Create(notification,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
		Size = UDim2.new(1,0,1,0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.5
	}):Play()
	
	task.wait(.1)

	UICorner.Parent = notification

	ItemName.BackgroundColor3 = Color3.new(1, 1, 1)
	ItemName.BackgroundTransparency = 0
	ItemName.BorderColor3 = Color3.new(0, 0, 0)
	ItemName.BorderSizePixel = 0
	ItemName.Font = Enum.Font.GothamBold
	ItemName.Name = [[ItemName]]
	ItemName.Parent = notification
	ItemName.Position = UDim2.new(0.9518978096, 0, 0.111038804, 0)
	ItemName.Size = UDim2.new(0, 0, 0.400000036, 0)
	ItemName.Text = text1
	ItemName.TextColor3 = Color3.new(1, 1, 1)
	ItemName.TextScaled = true
	ItemName.TextSize = 14
	ItemName.TextWrapped = true
	
	game:GetService("TweenService"):Create(ItemName,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(0.955445528, 0, 0.400000036, 0),
		Position = UDim2.new(0.0218978096, 0, 0.111038804, 0)
	}):Play()
	
	task.wait(.1)

	TextLabel.BackgroundColor3 = Color3.new(1, 1, 1)
	TextLabel.BackgroundTransparency = 0
	TextLabel.BorderColor3 = Color3.new(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Parent = notification
	TextLabel.Position = UDim2.new(1, 0, 0.600000024, 0)
	TextLabel.Size = UDim2.new(0, 0, 0.200000003, 0)
	TextLabel.Text = text2
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14
	TextLabel.TextWrapped = true
	
	game:GetService("TweenService"):Create(TextLabel,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
		BackgroundColor3 = Color3.new(1, 1, 1),
		TextColor3 = Color3.new(0.333333, 1, 1),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0.200000003, 0),
		Position = UDim2.new(0, 0, 0.600000024, 0)
	}):Play()

	Notification.Name = [[Notification]]
	Notification.Parent = notification
	Notification.SoundId = [[rbxassetid://5153734608]]
	Notification.Volume = 1
	
	Notification:Play()
	
	delay(duration-.7,function()
		game:GetService("TweenService"):Create(ItemName,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
			Size = UDim2.new(0,0,0.400000036,0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			TextColor3 = Color3.new(1, 1, 1),
			Position = UDim2.new(0.9518978096, 0, 0.111038804, 0)
		}):Play()
		task.wait(.1)
		game:GetService("TweenService"):Create(TextLabel,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
			Size = UDim2.new(0,0,0.200000003,0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			TextColor3 = Color3.new(1, 1, 1),
			Position = UDim2.new(1, 0, 0.600000024, 0)
		}):Play()
		task.wait(.1)
		game:GetService("TweenService"):Create(notification,TweenInfo.new(0.5,Enum.EasingStyle.Cubic,Enum.EasingDirection.InOut),{
			Size = UDim2.new(0,0,1,0),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
		}):Play()
	end)
	
	game.Debris:AddItem(notification,duration)
end

for i,v in pairs(Items:GetChildren()) do
	if v:IsA("Tool") and v:FindFirstChild("Value") and v:FindFirstChild("Handle") then
		setup(v,"Item")
		if v.Value.Value >= 50 then
			loadednotification(v.Name,"Value: ".. v.Value.Value,3)
		end
	end
end

for i,v in pairs(Living:GetChildren()) do
	if not game.Players:GetPlayerFromCharacter(v) then
		setup(v,"Monster")
		loadednotification(v.Name,"Health: " ..v.Humanoid.Health,3)
	end
end

for i,v in pairs(Traps:GetChildren()) do
	setup(v,"Trap")
end

Items.ChildAdded:Connect(function(v)
	task.wait(5)
	if v:IsA("Tool") and v:FindFirstChild("Value") and v:FindFirstChild("Handle") then
		setup(v,"Item")
		if v.Value.Value >= 50 then
			loadednotification(v.Name,"Value: ".. v.Value.Value,3)
		end
	end
end)

Living.ChildAdded:Connect(function(v)
	task.wait(5)
	if not game.Players:GetPlayerFromCharacter(v) then
		setup(v,"Monster")
		loadednotification(v.Name,"Health: " ..v.Humanoid.Health,3)
	end
end)

Traps.ChildAdded:Connect(function(v)
	task.wait(5)
	setup(v,"Trap")
end)

setup(workspace,"Start")

--[[
local t = tick()
local lines = {}
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	if tick()-t > 0.05 then
for i,v:BasePart in pairs(Parts) do
	local Line
	for i,e in pairs(lines) do
		if e[1] == nil then
			e[2]:Remove()
			continue
		end
		if e[1] == v then
			Line = e[2]
		end
	end
	if not Line then
		Line = Drawing.new("Line")
		table.insert(lines,{v,Line})
	end
	local ssHeadPoint, onscreen = Camera:WorldToScreenPoint(v.Position)
	ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
	if onscreen then
		Line.From = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
		Line.To = ssHeadPoint
		Line.Visible = true
	else
		Line.Visible = false
	end
end
end
end)

]]

loadednotification("Item Esp Loaded!","Credits: HairBaconGamming",5)
