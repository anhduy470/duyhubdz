-- Made by: duy + ChatGPT
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "UtilityUI"

local menuBtn = Instance.new("TextButton", gui)
menuBtn.Size = UDim2.new(0, 50, 0, 50)
menuBtn.Position = UDim2.new(0, 10, 0, 10)
menuBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
menuBtn.Text = "Menu"
menuBtn.Font = Enum.Font.SourceSansBold
menuBtn.TextSize = 14
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(1, 0)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

menuBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

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

local highlights = {}
local highlightEnabled, fillBrightness, fillColor = false, 0.5, Color3.fromRGB(255,255,0)

local function updateHighlights()
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			if highlights[p] then highlights[p]:Destroy() highlights[p]=nil end
			if highlightEnabled then
				local hl = Instance.new("Highlight", p.Character)
				hl.FillColor = fillColor
				hl.FillTransparency = 1-fillBrightness
				hl.OutlineColor = Color3.new(1,1,1)
				highlights[p]=hl
			end
		end
	end
end

toggleButton("Highlight: ON", "Highlight: OFF", 10, function(on) highlightEnabled=on updateHighlights() end)

local colorBtn = Instance.new("TextButton", frame)
colorBtn.Size = UDim2.new(1, -20, 0, 40)
colorBtn.Position = UDim2.new(0, 10, 0, 60)
colorBtn.Text = "🎨 Đổi màu Highlight"
colorBtn.BackgroundColor3 = Color3.fromRGB(200,200,200)
colorBtn.TextColor3 = Color3.new(0,0,0)
colorBtn.Font = Enum.Font.SourceSansBold
colorBtn.TextSize = 18
colorBtn.MouseButton1Click:Connect(function()
	fillColor = Color3.fromHSV(math.random(),1,1)
	updateHighlights()
end)

toggleButton("Fly: ON", "Fly: OFF", 110, function(on)
	if on then
		RunService:BindToRenderStep("Fly", 0, function()
			hrp.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
		end)
	else
		RunService:UnbindFromRenderStep("Fly")
	end
end)

toggleButton("Troll: ON", "Troll: OFF", 160, function(on)
	if on then
		for _,p in ipairs(Players:GetPlayers()) do
			if p~=LocalPlayer and p.Character then p.Character:BreakJoints() end
		end
	end
end)

local madeby = Instance.new("TextLabel", frame)
madeby.Size = UDim2.new(1, -20, 0, 20)
madeby.Position = UDim2.new(0, 10, 1, -25)
madeby.Text = "Made by: duy + ChatGPT"
madeby.TextColor3 = Color3.new(1,1,1)
madeby.BackgroundTransparency = 1
madeby.Font = Enum.Font.SourceSans
madeby.TextSize = 14
madeby.TextXAlignment = Enum.TextXAlignment.Right
