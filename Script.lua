--========================================================
-- VIOLET CORE B10
-- Created by José FX
-- Optimized / Reworked
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CLEAN OLD VERSION
--========================================================

local Old = PlayerGui:FindFirstChild("VioletCore_B10")

if Old then
	Old:Destroy()
end

--========================================================
-- COLORS
--========================================================

local Colors = {
	Background = Color3.fromRGB(10, 10, 12),
	Panel = Color3.fromRGB(17, 17, 20),
	Panel2 = Color3.fromRGB(25, 25, 29),
	Panel3 = Color3.fromRGB(31, 31, 36),

	Border = Color3.fromRGB(48, 48, 55),

	Text = Color3.fromRGB(240, 240, 245),
	SubText = Color3.fromRGB(150, 150, 160),

	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(88, 45, 160),

	On = Color3.fromRGB(60, 205, 115),
	Off = Color3.fromRGB(65, 65, 73),

	White = Color3.fromRGB(255, 255, 255)
}

--========================================================
-- STATE
--========================================================

local State = {
	Aimbot = false,
	SilentAim = false,
	AutoShoot = false,
	AutoShootAggressive = false,
	AutoEquip = false,
	LongRange = false,

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

	TargetPart = "Head",

	SpeedValue = 32,
	JumpValue = 75,
	FOVValue = 70
}

--========================================================
-- CONNECTION MANAGEMENT
--========================================================

local Connections = {}

local function Disconnect(Name)
	if Connections[Name] then
		Connections[Name]:Disconnect()
		Connections[Name] = nil
	end
end

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

local function GetRoot()
	local Character = GetCharacter()

	if not Character then
		return nil
	end

	return Character:FindFirstChild("HumanoidRootPart")
end

--========================================================
-- MOVEMENT
--========================================================

local DEFAULT_SPEED = 16
local DEFAULT_JUMP = 50

local function UpdateSpeed()

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if State.Speed or State.CustomSpeed then
		Humanoid.WalkSpeed = State.SpeedValue
	else
		Humanoid.WalkSpeed = DEFAULT_SPEED
	end
end

local function UpdateJump()

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if State.CustomJump then
		Humanoid.JumpPower = State.JumpValue
	else
		Humanoid.JumpPower = DEFAULT_JUMP
	end
end

Disconnect("InfiniteJump")

Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()

	if not State.InfiniteJump then
		return
	end

	local Humanoid = GetHumanoid()

	if Humanoid then
		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

--========================================================
-- TARGET SYSTEM
--========================================================

local function GetTargetPart(Character)

	if not Character then
		return nil
	end

	if State.TargetPart == "Head" then
		return Character:FindFirstChild("Head")
	end

	if State.TargetPart == "Torso" then
		return Character:FindFirstChild("UpperTorso")
			or Character:FindFirstChild("Torso")
			or Character:FindFirstChild("HumanoidRootPart")
	end

	if State.TargetPart == "Feet" then
		return Character:FindFirstChild("LeftFoot")
			or Character:FindFirstChild("RightFoot")
			or Character:FindFirstChild("Left Leg")
			or Character:FindFirstChild("Right Leg")
	end

	return Character:FindFirstChild("HumanoidRootPart")
end

local function GetClosestTarget()

	local Camera = workspace.CurrentCamera

	if not Camera then
		return nil
	end

	local MousePosition = UserInputService:GetMouseLocation()

	local ClosestCharacter = nil
	local ClosestDistance = math.huge

	for _, Player in ipairs(Players:GetPlayers()) do

		if Player ~= LocalPlayer then

			local Character = Player.Character
			local Humanoid = Character
				and Character:FindFirstChildOfClass("Humanoid")

			local Root = Character
				and Character:FindFirstChild("HumanoidRootPart")

			if Character
				and Humanoid
				and Root
				and Humanoid.Health > 0 then

				local ScreenPosition, Visible =
					Camera:WorldToViewportPoint(Root.Position)

				if Visible then

					local Distance =
						(
							Vector2.new(
								ScreenPosition.X,
								ScreenPosition.Y
							)
							- MousePosition
						).Magnitude

					if Distance < ClosestDistance then
						ClosestDistance = Distance
						ClosestCharacter = Character
					end
				end
			end
		end
	end

	return ClosestCharacter
end

--========================================================
-- AIMBOT
--========================================================

Disconnect("Aimbot")

Connections.Aimbot = RunService.RenderStepped:Connect(function()

	if not State.Aimbot then
		return
	end

	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	local Target = GetClosestTarget()

	if not Target then
		return
	end

	local Part = GetTargetPart(Target)

	if not Part then
		return
	end

	Camera.CFrame = CFrame.lookAt(
		Camera.CFrame.Position,
		Part.Position
	)
end)

--========================================================
-- ESP SYSTEM
--========================================================

local ESPObjects = {}

local function RemoveESP(Player)

	local Data = ESPObjects[Player]

	if not Data then
		return
	end

	if Data.Highlight then
		Data.Highlight:Destroy()
	end

	if Data.Line then
		Data.Line:Destroy()
	end

	ESPObjects[Player] = nil
end

local function CreateESP(Player)

	if Player == LocalPlayer then
		return
	end

	RemoveESP(Player)

	local Character = Player.Character

	if not Character then
		return
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	local Data = {}

	--====================================================
	-- HIGHLIGHT
	--====================================================

	if State.ESP then

		local Highlight = Instance.new("Highlight")

		Highlight.Name = "VioletESP"
		Highlight.Adornee = Character

		Highlight.FillTransparency = 0.65
		Highlight.OutlineTransparency = 0

		Highlight.FillColor = Colors.Accent
		Highlight.OutlineColor = Colors.Accent

		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

		Highlight.Parent = Character

		Data.Highlight = Highlight
	end

	--====================================================
	-- LINE
	--====================================================

	if State.ESPLines then

		local Line = Instance.new("Beam")

		Line.Name = "VioletESPLine"

		local Attachment0 = Instance.new("Attachment")
		Attachment0.Name = "VioletESPStart"
		Attachment0.Parent = Root

		local Camera = workspace.CurrentCamera

		if Camera then

			local CameraPart = Camera:FindFirstChild(
				"VioletCameraAttachment"
			)

			if not CameraPart then

				CameraPart = Instance.new("Part")

				CameraPart.Name = "VioletCameraAttachment"
				CameraPart.Anchored = true
				CameraPart.CanCollide = false
				CameraPart.CanTouch = false
				CameraPart.CanQuery = false

				CameraPart.Transparency = 1

				CameraPart.Size = Vector3.new(1, 1, 1)

				CameraPart.Parent = workspace
			end

			local Attachment1 =
				CameraPart:FindFirstChild(
					"VioletESPOrigin"
				)

			if not Attachment1 then

				Attachment1 = Instance.new("Attachment")
				Attachment1.Name = "VioletESPOrigin"
				Attachment1.Parent = CameraPart
			end

			Line.Attachment0 = Attachment1
			Line.Attachment1 = Attachment0

			Line.Width0 = 0.08
			Line.Width1 = 0.08

			Line.FaceCamera = true

			Line.Color = ColorSequence.new(
				Colors.Accent
			)

			Line.Transparency = NumberSequence.new(0.15)

			Line.Parent = CameraPart

			Data.Line = Line
		end
	end

	ESPObjects[Player] = Data
end

local function UpdateAllESP()

	for _, Player in ipairs(Players:GetPlayers()) do

		if Player ~= LocalPlayer then
			CreateESP(Player)
		end
	end
end

local function ClearAllESP()

	for Player in pairs(ESPObjects) do
		RemoveESP(Player)
	end
end

Disconnect("RainbowESP")

Connections.RainbowESP = RunService.RenderStepped:Connect(function()

	if not State.ESPRainbow then
		return
	end

	local Hue = (os.clock() * 0.25) % 1
	local RainbowColor = Color3.fromHSV(Hue, 0.85, 1)

	for _, Data in pairs(ESPObjects) do

		if Data.Highlight then
			Data.Highlight.FillColor = RainbowColor
			Data.Highlight.OutlineColor = RainbowColor
		end

		if Data.Line then
			Data.Line.Color = ColorSequence.new(
				RainbowColor
			)
		end
	end
end)

Players.PlayerAdded:Connect(function(Player)

	Player.CharacterAdded:Connect(function()

		task.wait(0.5)

		if State.ESP or State.ESPLines then
			CreateESP(Player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	RemoveESP(Player)
end)

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "VioletCore_B10"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--========================================================
-- FX BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "FXButton"

OpenButton.Size = UDim2.fromOffset(58, 58)
OpenButton.Position = UDim2.new(1, -78, 0, 120)

OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.BackgroundTransparency = 0.04

OpenButton.BorderSizePixel = 0

OpenButton.Text = "FX"
OpenButton.TextColor3 = Colors.Accent
OpenButton.TextSize = 17
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true

OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")

OpenCorner.CornerRadius = UDim.new(0, 14)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")

OpenStroke.Color = Colors.Accent
OpenStroke.Thickness = 2

OpenStroke.Parent = OpenButton

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")

Window.Name = "MainWindow"

Window.Size = UDim2.fromOffset(720, 470)

Window.Position =
	UDim2.new(
		0.5,
		-360,
		0.5,
		-235
	)

Window.BackgroundColor3 = Colors.Background
Window.BackgroundTransparency = 0.02

Window.BorderSizePixel = 0

Window.Visible = false

Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")

WindowCorner.CornerRadius = UDim.new(0, 14)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")

WindowStroke.Color = Colors.Border
WindowStroke.Thickness = 1

WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1, 0, 0, 64)

Header.BackgroundColor3 = Colors.Panel
Header.BorderSizePixel = 0

Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")

HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -150, 0, 26)

Title.Position = UDim2.fromOffset(18, 9)

Title.BackgroundTransparency = 1

Title.Text = "Violet Core"

Title.TextColor3 = Colors.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")

Creator.Size = UDim2.new(1, -150, 0, 16)

Creator.Position = UDim2.fromOffset(19, 35)

Creator.BackgroundTransparency = 1

Creator.Text = "José FX"

Creator.TextColor3 = Colors.Accent

Creator.TextSize = 9
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left

Creator.ZIndex = 12
Creator.Parent = Header

--========================================================
-- HEADER BUTTONS
--========================================================

local MinButton = Instance.new("TextButton")

MinButton.Size = UDim2.fromOffset(34, 34)

MinButton.Position =
	UDim2.new(1, -82, 0, 15)

MinButton.BackgroundColor3 = Colors.Panel2

MinButton.BorderSizePixel = 0

MinButton.Text = "—"

MinButton.TextColor3 = Colors.SubText

MinButton.TextSize = 17
MinButton.Font = Enum.Font.GothamBold

MinButton.AutoButtonColor = false

MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")

MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")

CloseButton.Size = UDim2.fromOffset(34, 34)

CloseButton.Position =
	UDim2.new(1, -42, 0, 15)

CloseButton.BackgroundColor3 = Colors.Panel2

CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"

CloseButton.TextColor3 = Colors.SubText

CloseButton.TextSize = 19
CloseButton.Font = Enum.Font.GothamBold

CloseButton.AutoButtonColor = false

CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")

CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

--========================================================
-- DRAG
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

Content.Size = UDim2.new(
	1,
	-16,
	1,
	-72
)

Content.Position = UDim2.fromOffset(8, 70)

Content.BackgroundTransparency = 1

Content.ZIndex = 11
Content.Parent = Window

--========================================================
-- CATEGORIES
--========================================================

local Categories = Instance.new("ScrollingFrame")

Categories.Size = UDim2.new(
	0,
	190,
	1,
	0
)

Categories.Position = UDim2.fromOffset(0, 0)

Categories.BackgroundColor3 = Colors.Panel

Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 3
Categories.ScrollBarImageColor3 = Colors.Accent

Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y

Categories.CanvasSize = UDim2.new()

Categories.ZIndex = 12
Categories.Parent = Content

local CatCorner = Instance.new("UICorner")

CatCorner.CornerRadius = UDim.new(0, 10)
CatCorner.Parent = Categories

local CatPadding = Instance.new("UIPadding")

CatPadding.PaddingTop = UDim.new(0, 8)
CatPadding.PaddingBottom = UDim.new(0, 8)
CatPadding.PaddingLeft = UDim.new(0, 7)
CatPadding.PaddingRight = UDim.new(0, 7)

CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")

CatLayout.Padding = UDim.new(0, 5)

CatLayout.SortOrder = Enum.SortOrder.LayoutOrder

CatLayout.Parent = Categories

--========================================================
-- SEARCH
--========================================================

local Search = Instance.new("TextBox")

Search.Size = UDim2.new(
	1,
	-14,
	0,
	36
)

Search.Position = UDim2.fromOffset(7, 7)

Search.BackgroundColor3 = Colors.Panel2

Search.BorderSizePixel = 0

Search.PlaceholderText = "Search"

Search.PlaceholderColor3 = Colors.SubText

Search.Text = ""

Search.TextColor3 = Colors.Text

Search.TextSize = 10
Search.Font = Enum.Font.GothamMedium

Search.ClearTextOnFocus = false

Search.ZIndex = 14
Search.Parent = Categories

local SearchCorner = Instance.new("UICorner")

SearchCorner.CornerRadius = UDim.new(0, 9)
SearchCorner.Parent = Search

local SearchPadding = Instance.new("UIPadding")

SearchPadding.PaddingLeft = UDim.new(0, 12)

SearchPadding.Parent = Search

--========================================================
-- OPTIONS
--========================================================

local Options = Instance.new("ScrollingFrame")

Options.Size = UDim2.new(
	1,
	-199,
	1,
	0
)

Options.Position = UDim2.fromOffset(199, 0)

Options.BackgroundColor3 = Colors.Panel

Options.BorderSizePixel = 0

Options.ScrollBarThickness = 3

Options.ScrollBarImageColor3 = Colors.Accent

Options.AutomaticCanvasSize = Enum.AutomaticSize.Y

Options.CanvasSize = UDim2.new()

Options.ZIndex = 12
Options.Parent = Content

local OptionsCorner = Instance.new("UICorner")

OptionsCorner.CornerRadius = UDim.new(0, 10)
OptionsCorner.Parent = Options

local OptionsPadding = Instance.new("UIPadding")

OptionsPadding.PaddingTop = UDim.new(0, 10)
OptionsPadding.PaddingBottom = UDim.new(0, 10)
OptionsPadding.PaddingLeft = UDim.new(0, 10)
OptionsPadding.PaddingRight = UDim.new(0, 10)

OptionsPadding.Parent = Options

local OptionsLayout = Instance.new("UIListLayout")

OptionsLayout.Padding = UDim.new(0, 6)

OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

OptionsLayout.Parent = Options

--========================================================
-- SECTIONS
--========================================================

local Sections = {

	{
		Name = "Hitbox & ESP",
		Icon = "◎",

		Items = {
			{"toggle","Player ESP","ESP"},
			{"toggle","ESP Lines","ESPLines"},
			{"toggle","Rainbow ESP","ESPRainbow"},
			{"toggle","Track Target","ESPTrack"}
		}
	},

	{
		Name = "Combat",
		Icon = "◎",

		Items = {
			{"toggle","Aimbot","Aimbot"},
			{"toggle","Silent Aim","SilentAim"},
			{"selector","Target Part","TargetPart"},
			{"toggle","Auto Shoot","AutoShoot"},
			{"toggle","Auto Shoot Aggressive","AutoShootAggressive"},
			{"toggle","Auto Equip","AutoEquip"},
			{"toggle","Long Range","LongRange"}
		}
	},

	{
		Name = "Auto Farm",
		Icon = "◉",

		Items = {
			{"toggle","Auto Farm","AutoFarm"},
			{"toggle","Auto Collect","AutoCollect"}
		}
	},

	{
		Name = "Movement",
		Icon = "✥",

		Items = {
			{"toggle","Activate Speed","Speed"},
			{"slider","Speed Slider","SpeedValue",16,100},
			{"toggle","Infinite Jump","InfiniteJump"},
			{"toggle","Custom Jump","CustomJump"},
			{"slider","Jump Power","JumpValue",50,150}
		}
	},

	{
		Name = "Animations",
		Icon = "♙",

		Items = {
			{"toggle","Zombie","AnimZombie"},
			{"toggle","Ghost","AnimGhost"},
			{"toggle","Goat","AnimGoat"}
		}
	},

	{
		Name = "Performance",
		Icon = "⚡",

		Items = {
			{"toggle","120 GPS","GPS120"},
			{"toggle","80 GPS","GPS80"},
			{"toggle","FPS Optimization","FPSOptimization"}
		}
	},

	{
		Name = "Configuración",
		Icon = "⚙",

		Items = {
			{"toggle","Save Configuration","SaveConfig"},
			{"toggle","Load Configuration","LoadConfig"},
			{"toggle","Reset Configuration","ResetConfig"}
		}
	},

	{
		Name = "Información",
		Icon = "ⓘ",

		Items = {
			{"info","Created by","José FX"},
			{"info","Version","B10"},
			{"info","Status","Optimized UI"}
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
-- TOGGLE
--========================================================

local function CreateToggle(Name, Key, Description)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(
		1,
		0,
		0,
		Description and 58 or 44
	)

	Row.BackgroundColor3 = Colors.Panel2

	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(
		1,
		-75,
		0,
		20
	)

	Label.Position = UDim2.fromOffset(12, 7)

	Label.BackgroundTransparency = 1

	Label.Text = Name

	Label.TextColor3 = Colors.Text

	Label.TextSize = 11
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.ZIndex = 14
	Label.Parent = Row

	if Description then

		local Desc = Instance.new("TextLabel")

		Desc.Size = UDim2.new(
			1,
			-75,
			0,
			18
		)

		Desc.Position = UDim2.fromOffset(12, 29)

		Desc.BackgroundTransparency = 1

		Desc.Text = Description

		Desc.TextColor3 = Colors.SubText

		Desc.TextSize = 8

		Desc.Font = Enum.Font.Gotham

		Desc.TextXAlignment = Enum.TextXAlignment.Left

		Desc.ZIndex = 14
		Desc.Parent = Row
	end

	local Switch = Instance.new("TextButton")

	Switch.Size = UDim2.fromOffset(46, 24)

	Switch.Position =
		UDim2.new(
			1,
			-58,
			0.5,
			-12
		)

	Switch.BackgroundColor3 = Colors.Off

	Switch.BorderSizePixel = 0

	Switch.Text = ""

	Switch.AutoButtonColor = false

	Switch.ZIndex = 15
	Switch.Parent = Row

	local SwitchCorner = Instance.new("UICorner")

	SwitchCorner.CornerRadius = UDim.new(1, 0)

	SwitchCorner.Parent = Switch

	local Knob = Instance.new("Frame")

	Knob.Size = UDim2.fromOffset(18, 18)

	Knob.Position = UDim2.fromOffset(3, 3)

	Knob.BackgroundColor3 = Colors.White

	Knob.BorderSizePixel = 0

	Knob.ZIndex = 16
	Knob.Parent = Switch

	local KnobCorner = Instance.new("UICorner")

	KnobCorner.CornerRadius = UDim.new(1, 0)

	KnobCorner.Parent = Knob

	local function UpdateVisual()

		if State[Key] then

			Switch.BackgroundColor3 = Colors.On

			Knob.Position =
				UDim2.new(
					1,
					-21,
					0,
					3
				)

		else

			Switch.BackgroundColor3 = Colors.Off

			Knob.Position =
				UDim2.fromOffset(3, 3)
		end
	end

	Switch.MouseButton1Click:Connect(function()

		State[Key] = not State[Key]

		UpdateVisual()

		if Key == "Speed"
			or Key == "CustomSpeed" then

			UpdateSpeed()
		end

		if Key == "CustomJump" then
			UpdateJump()
		end

		if Key == "InfiniteJump" then
			UpdateJump()
		end

		if Key == "ESP"
			or Key == "ESPLines"
			or Key == "ESPRainbow" then

			UpdateAllESP()
		end

		if Key == "ESPRainbow" then
			UpdateAllESP()
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
-- SLIDER
--========================================================

local function CreateSlider(Name, Key, Min, Max)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(
		1,
		0,
		0,
		58
	)

	Row.BackgroundColor3 = Colors.Panel2

	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(
		1,
		-70,
		0,
		20
	)

	Label.Position = UDim2.fromOffset(12, 5)

	Label.BackgroundTransparency = 1

	Label.Text = Name

	Label.TextColor3 = Colors.Text

	Label.TextSize = 10
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.ZIndex = 14
	Label.Parent = Row

	local ValueLabel = Instance.new("TextLabel")

	ValueLabel.Size = UDim2.fromOffset(45, 20)

	ValueLabel.Position =
		UDim2.new(
			1,
			-57,
			0,
			5
		)

	ValueLabel.BackgroundTransparency = 1

	ValueLabel.Text = tostring(State[Key])

	ValueLabel.TextColor3 = Colors.SubText

	ValueLabel.TextSize = 9

	ValueLabel.Font = Enum.Font.GothamBold

	ValueLabel.ZIndex = 14
	ValueLabel.Parent = Row

	local Bar = Instance.new("Frame")

	Bar.Size = UDim2.new(
		1,
		-24,
		0,
		5
	)

	Bar.Position =
		UDim2.fromOffset(
			12,
			40
		)

	Bar.BackgroundColor3 = Colors.Panel3

	Bar.BorderSizePixel = 0

	Bar.ZIndex = 14
	Bar.Parent = Row

	local BarCorner = Instance.new("UICorner")

	BarCorner.CornerRadius = UDim.new(1, 0)

	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")

	Fill.Size = UDim2.new(
		0,
		0,
		1,
		0
	)

	Fill.BackgroundColor3 = Colors.Accent

	Fill.BorderSizePixel = 0

	Fill.ZIndex = 15
	Fill.Parent = Bar

	local FillCorner = Instance.new("UICorner")

	FillCorner.CornerRadius = UDim.new(1, 0)

	FillCorner.Parent = Fill

	local Knob = Instance.new("TextButton")

	Knob.Size = UDim2.fromOffset(20, 20)

	Knob.AnchorPoint = Vector2.new(
		0.5,
		0.5
	)

	Knob.BackgroundColor3 = Colors.White

	Knob.BorderSizePixel = 0

	Knob.Text = ""

	Knob.ZIndex = 16
	Knob.Parent = Bar

	local KnobCorner = Instance.new("UICorner")

	KnobCorner.CornerRadius = UDim.new(1, 0)

	KnobCorner.Parent = Knob

	local DraggingSlider = false

	local function SetValue(Value)

		Value = math.clamp(
			math.floor(Value + 0.5),
			Min,
			Max
		)

		State[Key] = Value

		local Alpha =
			(Value - Min)
			/
			(Max - Min)

		Fill.Size = UDim2.new(
			Alpha,
			0,
			1,
			0
		)

		Knob.Position = UDim2.new(
			Alpha,
			0,
			0.5,
			0
		)

		ValueLabel.Text =
			tostring(Value)

		if Key == "SpeedValue" then
			UpdateSpeed()
		end

		if Key == "JumpValue" then
			UpdateJump()
		end
	end

	local function UpdateFromInput(Input)

		local X =
			Input.Position.X

		local StartX =
			Bar.AbsolutePosition.X

		local Width =
			Bar.AbsoluteSize.X

		local Alpha =
			math.clamp(
				(X - StartX)
				/
				Width,
				0,
				1
			)

		SetValue(
			Min
			+
			((Max - Min) * Alpha)
		)
	end

	Bar.InputBegan:Connect(function(Input)

		if Input.UserInputType
			== Enum.UserInputType.MouseButton1
			or Input.UserInputType
			== Enum.UserInputType.Touch then

			DraggingSlider = true

			UpdateFromInput(Input)
		end
	end)

	Knob.MouseButton1Down:Connect(function()
		DraggingSlider = true
	end)

	UserInputService.InputEnded:Connect(function(Input)

		if Input.UserInputType
			== Enum.UserInputType.MouseButton1
			or Input.UserInputType
			== Enum.UserInputType.Touch then

			DraggingSlider = false
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)

		if not DraggingSlider then
			return
		end

		if Input.UserInputType
			~= Enum.UserInputType.MouseMovement
			and Input.UserInputType
			~= Enum.UserInputType.Touch then

			return
		end

		UpdateFromInput(Input)
	end)

	SetValue(State[Key])
end

--========================================================
-- SELECTOR
--========================================================

local function CreateSelector(Name)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(
		1,
		0,
		0,
		48
	)

	Row.BackgroundColor3 = Colors.Panel2

	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius = UDim.new(0, 9)

	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(
		0.5,
		0,
		1,
		0
	)

	Label.Position =
		UDim2.fromOffset(12, 0)

	Label.BackgroundTransparency = 1

	Label.Text = Name

	Label.TextColor3 = Colors.Text

	Label.TextSize = 10
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left

	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(
		105,
		30
	)

	Button.Position =
		UDim2.new(
			1,
			-117,
			0.5,
			-15
		)

	Button.BackgroundColor3 =
		Colors.Panel

	Button.BorderSizePixel = 0

	Button.Text =
		State.TargetPart

	Button.TextColor3 =
		Colors.Accent

	Button.TextSize = 9
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false

	Button.ZIndex = 15
	Button.Parent = Row

	local Corner2 = Instance.new("UICorner")

	Corner2.CornerRadius =
		UDim.new(0, 8)

	Corner2.Parent = Button

	local Values = {
		"Head",
		"Torso",
		"Feet"
	}

	local Index = 1

	for I, Value in ipairs(Values) do

		if Value == State.TargetPart then
			Index = I
		end
	end

	Button.MouseButton1Click:Connect(function()

		Index += 1

		if Index > #Values then
			Index = 1
		end

		State.TargetPart =
			Values[Index]

		Button.Text =
			State.TargetPart
	end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name, Value)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(
		1,
		0,
		0,
		48
	)

	Row.BackgroundColor3 =
		Colors.Panel2

	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 9)

	Corner.Parent = Row

	local NameLabel =
		Instance.new("TextLabel")

	NameLabel.Size =
		UDim2.new(
			1,
			-24,
			0,
			16
		)

	NameLabel.Position =
		UDim2.fromOffset(12, 5)

	NameLabel.BackgroundTransparency = 1

	NameLabel.Text = Name

	NameLabel.TextColor3 =
		Colors.SubText

	NameLabel.TextSize = 8

	NameLabel.Font =
		Enum.Font.GothamMedium

	NameLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	NameLabel.ZIndex = 14
	NameLabel.Parent = Row

	local ValueLabel =
		Instance.new("TextLabel")

	ValueLabel.Size =
		UDim2.new(
			1,
			-24,
			0,
			18
		)

	ValueLabel.Position =
		UDim2.fromOffset(12, 22)

	ValueLabel.BackgroundTransparency = 1

	ValueLabel.Text = Value

	ValueLabel.TextColor3 =
		Colors.Text

	ValueLabel.TextSize = 10

	ValueLabel.Font =
		Enum.Font.GothamBold

	ValueLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	ValueLabel.ZIndex = 14
	ValueLabel.Parent = Row
end

--========================================================
-- SHOW SECTION
--========================================================

local function ShowSection(Section)

	ClearOptions()

	local HeaderLabel =
		Instance.new("TextLabel")

	HeaderLabel.Size =
		UDim2.new(
			1,
			0,
			0,
			32
		)

	HeaderLabel.BackgroundTransparency = 1

	HeaderLabel.Text =
		Section.Icon
		.. "   "
		.. Section.Name

	HeaderLabel.TextColor3 =
		Colors.Text

	HeaderLabel.TextSize = 14

	HeaderLabel.Font =
		Enum.Font.GothamBold

	HeaderLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	HeaderLabel.ZIndex = 14

	HeaderLabel.Parent =
		Options

	for _, Item in ipairs(Section.Items) do

		if Item[1] == "toggle" then

			CreateToggle(
				Item[2],
				Item[3]
			)

		elseif Item[1] == "selector" then

			CreateSelector(
				Item[2]
			)

		elseif Item[1] == "slider" then

			CreateSlider(
				Item[2],
				Item[3],
				Item[4],
				Item[5]
			)

		elseif Item[1] == "info" then

			CreateInfo(
				Item[2],
				Item[3]
			)
		end
	end
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do

	local Button =
		Instance.new("TextButton")

	Button.Name =
		Section.Name

	Button.Size =
		UDim2.new(
			1,
			0,
			0,
			38
		)

	Button.BackgroundColor3 =
		Colors.Panel

	Button.BorderSizePixel = 0

	Button.Text =
		Section.Icon
		.. "   "
		.. Section.Name

	Button.TextColor3 =
		Colors.SubText

	Button.TextSize = 10

	Button.Font =
		Enum.Font.GothamMedium

	Button.TextXAlignment =
		Enum.TextXAlignment.Left

	Button.AutoButtonColor = false

	Button.LayoutOrder =
		Index + 1

	Button.ZIndex = 13

	Button.Parent =
		Categories

	local Padding =
		Instance.new("UIPadding")

	Padding.PaddingLeft =
		UDim.new(0, 10)

	Padding.Parent =
		Button

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 8)

	Corner.Parent =
		Button

	CategoryButtons[
		Section.Name
	] = Button

	Button.MouseButton1Click:Connect(function()

		for _, Other in pairs(
			CategoryButtons
		) do

			Other.BackgroundColor3 =
				Colors.Panel

			Other.TextColor3 =
				Colors.SubText
		end

		Button.BackgroundColor3 =
			Colors.AccentDark

		Button.TextColor3 =
			Colors.White

		ShowSection(Section)
	end)
end

--========================================================
-- SEARCH SYSTEM
--========================================================

Search:GetPropertyChangedSignal(
	"Text"
):Connect(function()

	local Query =
		string.lower(
			Search.Text
		)

	for _, Section in ipairs(Sections) do

		local Button =
			CategoryButtons[
				Section.Name
			]

		if Button then

			if Query == "" then

				Button.Visible = true

			else

				local NameMatch =
					string.find(
						string.lower(
							Section.Name
						),
						Query,
						1,
						true
					)

				local ItemMatch = false

				for _, Item in ipairs(
					Section.Items
				) do

					if string.find(
						string.lower(
							tostring(
								Item[2]
							)
						),
						Query,
						1,
						true
					) then

						ItemMatch = true
						break
					end
				end

				Button.Visible =
					NameMatch ~= nil
					or ItemMatch
			end
		end
	end
end)

--========================================================
-- OPEN / CLOSE
--========================================================

OpenButton.MouseButton1Click:Connect(function()

	Window.Visible =
		not Window.Visible

	OpenButton.Visible =
		true
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

	Minimized =
		not Minimized

	Content.Visible =
		not Minimized

	if Minimized then

		Window.Size =
			UDim2.fromOffset(
				720,
				64
			)

	else

		Window.Size =
			UDim2.fromOffset(
				720,
				470
			)
	end
end)

--========================================================
-- CHARACTER RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(0.5)

	UpdateSpeed()
	UpdateJump()

	if State.ESP
		or State.ESPLines then

		UpdateAllESP()
	end
end)

--========================================================
-- INITIAL STATE
--========================================================

Window.Visible = false
OpenButton.Visible = true

local CombatButton =
	CategoryButtons["Combat"]

if CombatButton then

	CombatButton.BackgroundColor3 =
		Colors.AccentDark

	CombatButton.TextColor3 =
		Colors.White
end

ShowSection(Sections[2])

print("====================================")
print("Violet Core B10")
print("Created by José FX")
print("Optimized UI initialized")
print("FX button initialized")
print("All categories initialized")
print("====================================")
