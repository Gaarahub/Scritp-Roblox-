--========================================================
-- VIOLET CORE B11
-- Created by José FX
-- UI / Movement / ESP / Animation Framework
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CLEAN PREVIOUS VERSION
--========================================================

local OldGui = PlayerGui:FindFirstChild("VioletCore")
if OldGui then
	OldGui:Destroy()
end

--========================================================
-- COLORS
--========================================================

local C = {
	Background = Color3.fromRGB(8, 8, 10),
	Panel = Color3.fromRGB(15, 15, 18),
	Panel2 = Color3.fromRGB(22, 22, 26),
	Panel3 = Color3.fromRGB(29, 29, 34),

	Border = Color3.fromRGB(48, 48, 55),

	Text = Color3.fromRGB(240, 240, 245),
	SubText = Color3.fromRGB(145, 145, 155),

	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(85, 48, 150),

	On = Color3.fromRGB(65, 195, 110),
	Off = Color3.fromRGB(58, 58, 65),

	White = Color3.fromRGB(255, 255, 255)
}

--========================================================
-- STATE
--========================================================

local State = {
	Aimbot = false,
	SilentAim = false,
	AutoShoot = false,

	ESP = false,
	ESPLines = false,
	ESPRainbow = false,
	ESPTrack = false,

	Speed = false,
	CustomSpeed = false,
	InfiniteJump = false,
	CustomJump = false,

	AnimZombie = false,
	AnimGhost = false,
	AnimGoat = false,

	AutoFarm = false,
	AutoCollect = false,

	GPS120 = false,
	GPS80 = false,

	SaveConfig = false,
	LoadConfig = false,
	ResetConfig = false,

	TargetPart = "Head"
}

--========================================================
-- CHARACTER HELPERS
--========================================================

local function GetCharacter()
	return LocalPlayer.Character
end

local function GetHumanoid()
	local Character = GetCharacter()

	if not Character then
		return nil
	end

	return Character:FindFirstChildOfClass("Humanoid")
end

--========================================================
-- MOVEMENT
--========================================================

local DEFAULT_SPEED = 16
local CUSTOM_SPEED = 32

local DEFAULT_JUMP = 50
local CUSTOM_JUMP = 75

local function ApplySpeed()
	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if State.Speed or State.CustomSpeed then
		Humanoid.WalkSpeed = CUSTOM_SPEED
	else
		Humanoid.WalkSpeed = DEFAULT_SPEED
	end
end

local function ApplyJump()
	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if State.CustomJump then
		Humanoid.JumpPower = CUSTOM_JUMP
	else
		Humanoid.JumpPower = DEFAULT_JUMP
	end
end

UserInputService.JumpRequest:Connect(function()
	if not State.InfiniteJump then
		return
	end

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--========================================================
-- ANIMATIONS
--========================================================

local AnimationIds = {
	Zombie = "",
	Ghost = "",
	Goat = ""
}

local CurrentTrack

local function StopAnimation()
	if CurrentTrack then
		CurrentTrack:Stop()
		CurrentTrack:Destroy()
		CurrentTrack = nil
	end
end

local function PlayAnimation(Name)
	local Id = AnimationIds[Name]

	if not Id or Id == "" then
		warn("[Violet Core] Missing animation ID:", Name)
		return
	end

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	local Animator = Humanoid:FindFirstChildOfClass("Animator")

	if not Animator then
		Animator = Instance.new("Animator")
		Animator.Parent = Humanoid
	end

	StopAnimation()

	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://" .. Id

	local Track = Animator:LoadAnimation(Animation)
	Track.Priority = Enum.AnimationPriority.Action
	Track:Play()

	CurrentTrack = Track
end

--========================================================
-- ESP
--========================================================

local ESPData = {}

local function RemoveESP(Player)
	local Data = ESPData[Player]

	if not Data then
		return
	end

	if Data.Highlight then
		Data.Highlight:Destroy()
	end

	if Data.Line then
		Data.Line:Destroy()
	end

	ESPData[Player] = nil
end

local function CreateESP(Player)
	if Player == LocalPlayer then
		return
	end

	RemoveESP(Player)

	if not State.ESP then
		return
	end

	local Character = Player.Character

	if not Character then
		return
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	local Highlight = Instance.new("Highlight")
	Highlight.Name = "VioletESP"
	Highlight.Adornee = Character
	Highlight.FillTransparency = 0.75
	Highlight.OutlineTransparency = 0
	Highlight.Parent = Character

	ESPData[Player] = {
		Highlight = Highlight
	}

	if State.ESPLines then
		local Line = Instance.new("Beam")

		local LocalRoot =
			LocalPlayer.Character
			and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if LocalRoot then
			local Attachment0 = Instance.new("Attachment")
			Attachment0.Parent = LocalRoot

			local Attachment1 = Instance.new("Attachment")
			Attachment1.Parent = Root

			Line.Attachment0 = Attachment0
			Line.Attachment1 = Attachment1

			Line.Width0 = 0.04
			Line.Width1 = 0.04

			Line.FaceCamera = true
			Line.Parent = Root

			ESPData[Player].Line = Line
			ESPData[Player].Attachment0 = Attachment0
			ESPData[Player].Attachment1 = Attachment1
		end
	end
end

local function RefreshESP()
	for _, Player in ipairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer then
			CreateESP(Player)
		end
	end
end

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function()
		task.wait(0.25)
		CreateESP(Player)
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	RemoveESP(Player)
end)

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "VioletCore"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"

OpenButton.Size = UDim2.fromOffset(38, 38)
OpenButton.Position = UDim2.new(1, -52, 0.5, -19)

OpenButton.BackgroundColor3 = C.Panel
OpenButton.BackgroundTransparency = 0.08
OpenButton.BorderSizePixel = 0

OpenButton.Text = "V"
OpenButton.TextColor3 = C.Text
OpenButton.TextSize = 13
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 9)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = C.Accent
OpenStroke.Thickness = 1
OpenStroke.Transparency = 0.25
OpenStroke.Parent = OpenButton

--========================================================
-- WINDOW
--========================================================

local Window = Instance.new("Frame")
Window.Name = "MainWindow"

Window.Size = UDim2.fromOffset(475, 315)
Window.Position = UDim2.new(0.5, -237, 0.5, -157)

Window.BackgroundColor3 = C.Background
Window.BackgroundTransparency = 0.08
Window.BorderSizePixel = 0

Window.Visible = false
Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 10)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = C.Border
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.2
WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)

Header.BackgroundColor3 = C.Panel
Header.BorderSizePixel = 0
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -105, 0, 20)
Title.Position = UDim2.fromOffset(13, 6)

Title.BackgroundTransparency = 1
Title.Text = "Violet Core"

Title.TextColor3 = C.Text
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -105, 0, 13)
Creator.Position = UDim2.fromOffset(14, 28)

Creator.BackgroundTransparency = 1
Creator.Text = "José FX"

Creator.TextColor3 = C.Accent
Creator.TextSize = 8
Creator.Font = Enum.Font.GothamMedium
Creator.TextXAlignment = Enum.TextXAlignment.Left

Creator.Parent = Header

--========================================================
-- HEADER CONTROLS
--========================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(25, 25)
MinButton.Position = UDim2.new(1, -59, 0, 12)

MinButton.BackgroundColor3 = C.Panel2
MinButton.BorderSizePixel = 0

MinButton.Text = "—"
MinButton.TextColor3 = C.SubText
MinButton.TextSize = 13
MinButton.Font = Enum.Font.GothamBold

MinButton.AutoButtonColor = false
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(25, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 12)

CloseButton.BackgroundColor3 = C.Panel2
CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"
CloseButton.TextColor3 = C.SubText
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold

CloseButton.AutoButtonColor = false
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--========================================================
-- DRAGGING
--========================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Window.Position
	end
end)

Header.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if not Dragging then
		return
	end

	if Input.UserInputType ~= Enum.UserInputType.MouseMovement
		and Input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local Delta = Input.Position - DragStart

	Window.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,

		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)
end)

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -12, 1, -58)
Content.Position = UDim2.fromOffset(6, 55)

Content.BackgroundTransparency = 1
Content.Parent = Window

--========================================================
-- CATEGORY PANEL
--========================================================

local Categories = Instance.new("ScrollingFrame")
Categories.Size = UDim2.fromOffset(135, 1)

Categories.BackgroundColor3 = C.Panel
Categories.BackgroundTransparency = 0.08
Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 2
Categories.ScrollBarImageColor3 = C.Accent

Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y
Categories.CanvasSize = UDim2.new()

Categories.Parent = Content

local CatPadding = Instance.new("UIPadding")
CatPadding.PaddingTop = UDim.new(0, 6)
CatPadding.PaddingBottom = UDim.new(0, 6)
CatPadding.PaddingLeft = UDim.new(0, 5)
CatPadding.PaddingRight = UDim.new(0, 5)
CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")
CatLayout.Padding = UDim.new(0, 3)
CatLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatLayout.Parent = Categories

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 8)
CatCorner.Parent = Categories

--========================================================
-- OPTIONS PANEL
--========================================================

local Options = Instance.new("ScrollingFrame")

Options.Size = UDim2.new(1, -141, 1, 0)
Options.Position = UDim2.fromOffset(141, 0)

Options.BackgroundColor3 = C.Panel
Options.BackgroundTransparency = 0.05
Options.BorderSizePixel = 0

Options.ScrollBarThickness = 2
Options.ScrollBarImageColor3 = C.Accent

Options.AutomaticCanvasSize = Enum.AutomaticSize.Y
Options.CanvasSize = UDim2.new()

Options.Parent = Content

local OptionsPadding = Instance.new("UIPadding")
OptionsPadding.PaddingTop = UDim.new(0, 7)
OptionsPadding.PaddingBottom = UDim.new(0, 7)
OptionsPadding.PaddingLeft = UDim.new(0, 7)
OptionsPadding.PaddingRight = UDim.new(0, 7)
OptionsPadding.Parent = Options

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.Padding = UDim.new(0, 4)
OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionsLayout.Parent = Options

local OptionsCorner = Instance.new("UICorner")
OptionsCorner.CornerRadius = UDim.new(0, 8)
OptionsCorner.Parent = Options

--========================================================
-- SECTIONS
--========================================================

local Sections = {
	{
		Name = "Combat",
		Icon = "⚔",
		Items = {
			{"toggle", "Aimbot", "Aimbot"},
			{"toggle", "Silent Aim", "SilentAim"},
			{"selector", "Target Part"},
			{"toggle", "Auto Shoot", "AutoShoot"}
		}
	},

	{
		Name = "ESP",
		Icon = "◉",
		Items = {
			{"toggle", "Player ESP", "ESP"},
			{"toggle", "ESP Lines", "ESPLines"},
			{"toggle", "Rainbow ESP", "ESPRainbow"},
			{"toggle", "Track Target", "ESPTrack"}
		}
	},

	{
		Name = "Movement",
		Icon = "➤",
		Items = {
			{"toggle", "Speed", "Speed"},
			{"toggle", "Custom Speed", "CustomSpeed"},
			{"toggle", "Infinite Jump", "InfiniteJump"},
			{"toggle", "Custom Jump", "CustomJump"}
		}
	},

	{
		Name = "Animations",
		Icon = "♟",
		Items = {
			{"toggle", "Zombie", "AnimZombie"},
			{"toggle", "Ghost", "AnimGhost"},
			{"toggle", "Goat", "AnimGoat"}
		}
	},

	{
		Name = "Autofarm",
		Icon = "$",
		Items = {
			{"toggle", "Auto Farm", "AutoFarm"},
			{"toggle", "Auto Collect", "AutoCollect"}
		}
	},

	{
		Name = "GPS",
		Icon = "⚡",
		Items = {
			{"toggle", "120 GPS", "GPS120"},
			{"toggle", "80 GPS", "GPS80"}
		}
	},

	{
		Name = "Settings",
		Icon = "⚙",
		Items = {
			{"toggle", "Save Configuration", "SaveConfig"},
			{"toggle", "Load Configuration", "LoadConfig"},
			{"toggle", "Reset Configuration", "ResetConfig"}
		}
	},

	{
		Name = "Information",
		Icon = "ⓘ",
		Items = {
			{"info", "Created by", "José FX"},
			{"info", "Discord", "Community / Social"},
			{"info", "Credits", "José FX"}
		}
	}
}

--========================================================
-- CLEAR OPTIONS
--========================================================

local function ClearOptions()
	for _, Object in ipairs(Options:GetChildren()) do
		if not Object:IsA("UIListLayout")
			and not Object:IsA("UIPadding") then

			Object:Destroy()
		end
	end
end

--========================================================
-- TOGGLE VISUAL
--========================================================

local function CreateToggle(Name, Key)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 31)

	Row.BackgroundColor3 = C.Panel2
	Row.BorderSizePixel = 0

	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -55, 1, 0)
	Label.Position = UDim2.fromOffset(8, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = C.Text
	Label.TextSize = 8
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Switch = Instance.new("TextButton")

	Switch.Size = UDim2.fromOffset(27, 14)
	Switch.Position = UDim2.new(1, -35, 0.5, -7)

	Switch.BackgroundColor3 = C.Off
	Switch.BorderSizePixel = 0

	Switch.Text = ""
	Switch.AutoButtonColor = false

	Switch.Parent = Row

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = Switch

	local Knob = Instance.new("Frame")

	Knob.Size = UDim2.fromOffset(10, 10)
	Knob.Position = UDim2.fromOffset(2, 2)

	Knob.BackgroundColor3 = C.White
	Knob.BorderSizePixel = 0

	Knob.Parent = Switch

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local function UpdateVisual()
		if State[Key] then
			Switch.BackgroundColor3 = C.On
			Knob.Position = UDim2.new(1, -12, 0, 2)
		else
			Switch.BackgroundColor3 = C.Off
			Knob.Position = UDim2.fromOffset(2, 2)
		end
	end

	Switch.MouseButton1Click:Connect(function()

		State[Key] = not State[Key]

		UpdateVisual()

		-- Movement
		if Key == "Speed"
			or Key == "CustomSpeed" then

			ApplySpeed()
		end

		if Key == "CustomJump" then
			ApplyJump()
		end

		-- Infinite jump
		if Key == "InfiniteJump" then
			ApplyJump()
		end

		-- ESP
		if Key == "ESP"
			or Key == "ESPLines"
			or Key == "ESPRainbow"
			or Key == "ESPTrack" then

			RefreshESP()
		end

		-- Animations
		if Key == "AnimZombie" and State[Key] then
			PlayAnimation("Zombie")
		end

		if Key == "AnimGhost" and State[Key] then
			PlayAnimation("Ghost")
		end

		if Key == "AnimGoat" and State[Key] then
			PlayAnimation("Goat")
		end

		print(
			"[Violet Core]",
			Name,
			State[Key] and "ON" or "OFF"
		)
	end)

	UpdateVisual()
end

--========================================================
-- SELECTOR
--========================================================

local function CreateSelector(Name)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 31)

	Row.BackgroundColor3 = C.Panel2
	Row.BorderSizePixel = 0

	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.fromOffset(8, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = C.Text
	Label.TextSize = 8
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.Parent = Row

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(72, 21)
	Button.Position = UDim2.new(1, -80, 0.5, -10)

	Button.BackgroundColor3 = C.Panel
	Button.BorderSizePixel = 0

	Button.Text = State.TargetPart
	Button.TextColor3 = C.Accent

	Button.TextSize = 8
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false
	Button.Parent = Row

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 5)
	ButtonCorner.Parent = Button

	local Values = {
		"Head",
		"Torso",
		"Feet"
	}

	local Index = 1

	Button.MouseButton1Click:Connect(function()

		Index += 1

		if Index > #Values then
			Index = 1
		end

		State.TargetPart = Values[Index]
		Button.Text = State.TargetPart

		print("[Violet Core] Target:", State.TargetPart)
	end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name, Value)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 40)

	Row.BackgroundColor3 = C.Panel2
	Row.BorderSizePixel = 0

	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Row

	local NameLabel = Instance.new("TextLabel")

	NameLabel.Size = UDim2.new(1, -16, 0, 13)
	NameLabel.Position = UDim2.fromOffset(8, 4)

	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name

	NameLabel.TextColor3 = C.SubText
	NameLabel.TextSize = 7
	NameLabel.Font = Enum.Font.GothamMedium

	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = Row

	local ValueLabel = Instance.new("TextLabel")

	ValueLabel.Size = UDim2.new(1, -16, 0, 16)
	ValueLabel.Position = UDim2.fromOffset(8, 19)

	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = Value

	ValueLabel.TextColor3 = C.Text
	ValueLabel.TextSize = 8
	ValueLabel.Font = Enum.Font.GothamBold

	ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
	ValueLabel.Parent = Row
end

--========================================================
-- SHOW SECTION
--========================================================

local function ShowSection(Section)

	ClearOptions()

	local SectionTitle = Instance.new("TextLabel")

	SectionTitle.Size = UDim2.new(1, 0, 0, 25)

	SectionTitle.BackgroundTransparency = 1

	SectionTitle.Text =
		Section.Icon .. "   " .. Section.Name

	SectionTitle.TextColor3 = C.Text
	SectionTitle.TextSize = 11
	SectionTitle.Font = Enum.Font.GothamBold

	SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

	SectionTitle.Parent = Options

	for _, Item in ipairs(Section.Items) do

		if Item[1] == "toggle" then
			CreateToggle(Item[2], Item[3])

		elseif Item[1] == "selector" then
			CreateSelector(Item[2])

		elseif Item[1] == "info" then
			CreateInfo(Item[2], Item[3])
		end
	end

	Options.CanvasPosition = Vector2.new(0, 0)
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 30)

	Button.BackgroundColor3 = C.Panel
	Button.BorderSizePixel = 0

	Button.Text =
		Section.Icon .. "   " .. Section.Name

	Button.TextColor3 = C.SubText
	Button.TextSize = 8
	Button.Font = Enum.Font.GothamMedium

	Button.TextXAlignment = Enum.TextXAlignment.Left

	Button.AutoButtonColor = false
	Button.LayoutOrder = Index

	Button.Parent = Categories

	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 8)
	Padding.Parent = Button

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button

	CategoryButtons[Section.Name] = Button

	Button.MouseButton1Click:Connect(function()

		for _, Other in pairs(CategoryButtons) do
			Other.BackgroundColor3 = C.Panel
			Other.TextColor3 = C.SubText
		end

		Button.BackgroundColor3 = C.AccentDark
		Button.TextColor3 = C.White

		ShowSection(Section)
	end)
end

--========================================================
-- OPEN / CLOSE
--========================================================

OpenButton.MouseButton1Click:Connect(function()
	Window.Visible = not Window.Visible
	OpenButton.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
	Window.Visible = false
	OpenButton.Visible = true
end)

--========================================================
-- MINIMIZE
--========================================================

local Minimized = false

MinButton.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	Content.Visible = not Minimized

	if Minimized then
		Window.Size = UDim2.fromOffset(475, 50)
	else
		Window.Size = UDim2.fromOffset(475, 315)
	end
end)

--========================================================
-- RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(0.4)

	ApplySpeed()
	ApplyJump()

	if State.ESP then
		task.wait(0.2)
		RefreshESP()
	end
end)

--========================================================
-- INITIALIZATION
--========================================================

Window.Visible = false
OpenButton.Visible = true

local FirstButton = CategoryButtons["Combat"]

if FirstButton then
	FirstButton.BackgroundColor3 = C.AccentDark
	FirstButton.TextColor3 = C.White
end

ShowSection(Sections[1])

print("====================================")
print("Violet Core B11")
print("Created by José FX")
print("UI initialized successfully")
print("Menu starts CLOSED")
print("Open button remains visible")
print("====================================")
