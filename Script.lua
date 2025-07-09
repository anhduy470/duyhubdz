-- Made by: duy + ChatGPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DuyHubUI"

-- Menu nút tròn
local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0, 50, 0, 50)
menuBtn.Position = UDim2.new(0, 10, 0, 10)
menuBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
menuBtn.Text = "Menu"
menuBtn.Font = Enum.Font.SourceSansBold
menuBtn.TextSize = 14
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(1, 0)

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

menuBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- Tab hệ thống
local tabLabel = Instance.new("TextLabel", frame)
tabLabel.Size = UDim2.new(1, -20, 0, 30)
tabLabel.Position = UDim2.new(0, 10, 0, 5)
tabLabel.BackgroundTransparency = 1
tabLabel.TextColor3 = Color3.new(1,1,1)
tabLabel.Font = Enum.Font.SourceSansBold
tabLabel.TextSize = 20
tabLabel.Text = "Tab: Combat"

local tabs = {"Combat", "Movement", "Troll", "ESP"}
local currentTab = 1
local function switchTab()
	currentTab = currentTab % #tabs + 1
	tabLabel.Text = "Tab: "..tabs[currentTab]
end

local switchTabBtn = Instance.new("TextButton", frame)
switchTabBtn.Size = UDim2.new(0.5, -15, 0, 30)
switchTabBtn.Position = UDim2.new(0, 10, 0, 40)
switchTabBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
switchTabBtn.TextColor3 = Color3.new(0,0,0)
switchTabBtn.Text = "Next Tab"
switchTabBtn.Font = Enum.Font.SourceSansBold
switchTabBtn.TextSize = 14
switchTabBtn.MouseButton1Click:Connect(switchTab)

local prevTabBtn = Instance.new("TextButton", frame)
prevTabBtn.Size = UDim2.new(0.5, -15, 0, 30)
prevTabBtn.Position = UDim2.new(0.5, 5, 0, 40)
prevTabBtn.BackgroundColor3 = Color3.fromRGB(150,150,150)
prevTabBtn.TextColor3 = Color3.new(0,0,0)
prevTabBtn.Text = "Prev Tab"
prevTabBtn.Font = Enum.Font.SourceSansBold
prevTabBtn.TextSize = 14
prevTabBtn.MouseButton1Click:Connect(function()
	currentTab = (currentTab-2) % #tabs +1
	tabLabel.Text = "Tab: "..tabs[currentTab]
end)

-- Tính năng mẫu
local function toggleButton(textOn, textOff, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(200,200,200)
	btn.TextColor3 = Color3.new(0,0,0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = textOff
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and textOn or textOff
		callback(state, btn)
	end)
	return btn
end

-- Combat tab
toggleButton("Troll ALL: ON", "Troll ALL: OFF", 90, function(on)
	if on then
		for _,p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				p.Character:BreakJoints()
			end
		end
	end
end)

toggleButton("Auto Heal: ON", "Auto Heal: OFF", 140, function(on)
	if on then
		humanoid.HealthChanged:Connect(function()
			if humanoid.Health < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
		end)
	end
end)

-- Movement tab
toggleButton("Fly: ON", "Fly: OFF", 190, function(on)
	if on then
		local flying = true
		local gyro = Instance.new("BodyGyro", hrp)
		gyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
		local bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e9,1e9,1e9)
		RunService:BindToRenderStep("Fly", 0, function()
			if flying then
				gyro.CFrame = workspace.CurrentCamera.CFrame
				bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
			end
		end)
	else
		RunService:UnbindFromRenderStep("Fly")
		for _,v in pairs(hrp:GetChildren()) do if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then v:Destroy() end end
	end
end)

-- ESP tab
toggleButton("Highlight: ON", "Highlight: OFF", 240, function(on)
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			if on then
				local hl = Instance.new("Highlight", p.Character)
				hl.FillColor = Color3.fromHSV(math.random(),1,1)
				hl.OutlineColor = Color3.new(1,1,1)
				hl.Name = "ESP_HL"
			else
				local hl = p.Character:FindFirstChild("ESP_HL")
				if hl then hl:Destroy() end
			end
		end
	end
end)

-- Made by
local madeby = Instance.new("TextLabel", frame)
madeby.Size = UDim2.new(1, -20, 0, 20)
madeby.Position = UDim2.new(0, 10, 1, -25)
madeby.Text = "Made by: duy + ChatGPT"
madeby.TextColor3 = Color3.new(1,1,1)
madeby.BackgroundTransparency = 1
madeby.Font = Enum.Font.SourceSans
madeby.TextSize = 14
madeby.TextXAlignment = Enum.TextXAlignment.Right
