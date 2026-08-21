--========================================================
-- VIOLET CORE B10
-- Created by José FX
-- UI + LOCAL TEST FRAMEWORK
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CLEAN PREVIOUS VERSION
--========================================================

local Old = PlayerGui:FindFirstChild("VioletCore_B10")
if Old then
	Old:Destroy()
end

--========================================================
-- COLORS
--========================================================

local Colors = {
	Background = Color3.fromRGB(12, 12, 15),
	Panel = Color3.fromRGB(18, 18, 22),
	Panel2 = Color3.fromRGB(27, 27, 32),
	Panel3 = Color3.fromRGB(34, 34, 40),

	Border = Color3.fromRGB(48, 48, 57),

	Text = Color3.fromRGB(242, 242, 246),
	SubText = Color3.fromRGB(155, 155, 165),

	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(83, 45, 145),

	On = Color3.fromRGB(55, 205, 110),
	Off = Color3.fromRGB(67, 67, 76),

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
	InfiniteJump = false,
	CustomSpeed = false,
	CustomJump = false,

	AnimZombie = false,
	AnimGhost = false,
	AnimGoat = false,

	AutoFarm = false,
	AutoCollect = false,

	SaveConfig = false,
	LoadConfig = false,

	TargetPart = "Head"
}

--========================================================
-- CONNECTION STORAGE
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
local CUSTOM_SPEED_VALUE = 32

local DEFAULT_JUMP = 50
local CUSTOM_JUMP_VALUE = 75

local function UpdateMovement()

	local Humanoid = GetHumanoid()

	if not Humanoid then
		return
	end

	if State.Speed or State.CustomSpeed then
		Humanoid.WalkSpeed = CUSTOM_SPEED_VALUE
	else
		Humanoid.WalkSpeed = DEFAULT_SPEED
	end

	if State.CustomJump then
		Humanoid.JumpPower = CUSTOM_JUMP_VALUE
	else
		Humanoid.JumpPower = DEFAULT_JUMP
	end
end

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
-- ANIMATIONS
--========================================================

local AnimationIds = {
	Zombie = "",
	Ghost = "",
	Goat = ""
}

local CurrentAnimationTrack

local function StopCurrentAnimation()

	if CurrentAnimationTrack then
		pcall(function()
			CurrentAnimationTrack:Stop()
			CurrentAnimationTrack:Destroy()
		end)

		CurrentAnimationTrack = nil
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

	StopCurrentAnimation()

	local Animation = Instance.new("Animation")
	Animation.AnimationId = "rbxassetid://" .. tostring(Id)

	local Success, Track = pcall(function()
		return Animator:LoadAnimation(Animation)
	end)

	Animation:Destroy()

	if not Success or not Track then
		warn("[Violet Core] Could not load animation:", Name)
		return
	end

	Track.Priority = Enum.AnimationPriority.Action
	Track.Looped = true
	Track:Play()

	CurrentAnimationTrack = Track
end

--========================================================
-- ESP
--========================================================

local ESPObjects = {}

local function RemoveESP(Player)

	local Data = ESPObjects[Player]

	if not Data then
		return
	end

	for _, Object in pairs(Data) do
		if typeof(Object) == "Instance" then
			Object:Destroy()
		end
	end

	ESPObjects[Player] = nil
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

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "VioletCoreESP"
	Highlight.Adornee = Character
	Highlight.FillTransparency = 0.72
	Highlight.OutlineTransparency = 0.05
	Highlight.FillColor = Colors.Accent
	Highlight.OutlineColor = Colors.White
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Parent = Character

	ESPObjects[Player] = {
		Highlight = Highlight
	}
end

local function UpdateAllESP()

	for _, Player in ipairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer then
			CreateESP(Player)
		end
	end
end

Players.PlayerAdded:Connect(function(Player)

	Player.CharacterAdded:Connect(function()

		task.wait(0.5)

		if State.ESP then
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
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenMenu"
OpenButton.Size = UDim2.fromOffset(48, 48)
OpenButton.Position = UDim2.new(1, -64, 0, 82)

OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.BackgroundTransparency = 0.02
OpenButton.BorderSizePixel = 0

OpenButton.Text = "V"
OpenButton.TextColor3 = Colors.White
OpenButton.TextSize = 17
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true
OpenButton.Active = true
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Colors.Accent
OpenStroke.Thickness = 1.5
OpenStroke.Transparency = 0.1
OpenStroke.Parent = OpenButton

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")

Window.Name = "MainWindow"
Window.Size = UDim2.fromOffset(570, 390)
Window.Position = UDim2.new(0.5, -285, 0.5, -195)

Window.BackgroundColor3 = Colors.Background
Window.BorderSizePixel = 0

Window.Visible = false
Window.Active = true
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

Title.Size = UDim2.new(1, -130, 0, 25)
Title.Position = UDim2.fromOffset(18, 8)

Title.BackgroundTransparency = 1
Title.Text = "Violet Core"
Title.TextColor3 = Colors.Text
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")

Creator.Size = UDim2.new(1, -130, 0, 15)
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

local function HeaderButton(Text, Position)

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(31, 31)
	Button.Position = Position

	Button.BackgroundColor3 = Colors.Panel2
	Button.BorderSizePixel = 0

	Button.Text = Text
	Button.TextColor3 = Colors.SubText
	Button.TextSize = 15
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false
	Button.ZIndex = 13
	Button.Parent = Header

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	return Button
end

local MinButton =
	HeaderButton("—", UDim2.new(1, -75, 0, 16))

local FullButton =
	HeaderButton("□", UDim2.new(1, -39, 0, 16))

local CloseButton =
	HeaderButton("×", UDim2.new(1, -39, 0, 16))

CloseButton.Position = UDim2.new(1, -39, 0, 16)

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

Content.Size = UDim2.new(1, -14, 1, -72)
Content.Position = UDim2.fromOffset(7, 68)

Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Window

--========================================================
-- LEFT SIDEBAR
--========================================================

local Categories = Instance.new("ScrollingFrame")

Categories.Name = "Categories"
Categories.Size = UDim2.fromOffset(175, 1)
Categories.Position = UDim2.fromOffset(0, 0)

Categories.BackgroundColor3 = Colors.Panel
Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 3
Categories.ScrollBarImageColor3 = Colors.Accent

Categories.CanvasSize = UDim2.new()
Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y

Categories.ZIndex = 12
Categories.Parent = Content

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 11)
CatCorner.Parent = Categories

local CatPadding = Instance.new("UIPadding")
CatPadding.PaddingTop = UDim.new(0, 9)
CatPadding.PaddingBottom = UDim.new(0, 9)
CatPadding.PaddingLeft = UDim.new(0, 8)
CatPadding.PaddingRight = UDim.new(0, 8)
CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")
CatLayout.Padding = UDim.new(0, 3)
CatLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatLayout.Parent = Categories

--========================================================
-- SEARCH
--========================================================

local SearchBox = Instance.new("TextBox")

SearchBox.Size = UDim2.new(1, 0, 0, 36)

SearchBox.BackgroundColor3 = Colors.Panel2
SearchBox.BorderSizePixel = 0

SearchBox.PlaceholderText = "Search"
SearchBox.PlaceholderColor3 = Colors.SubText

SearchBox.Text = ""
SearchBox.TextColor3 = Colors.Text
SearchBox.TextSize = 11
SearchBox.Font = Enum.Font.GothamMedium

SearchBox.ClearTextOnFocus = false
SearchBox.LayoutOrder = 0
SearchBox.ZIndex = 13
SearchBox.Parent = Categories

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 9)
SearchCorner.Parent = SearchBox

local SearchPadding = Instance.new("UIPadding")
SearchPadding.PaddingLeft = UDim.new(0, 11)
SearchPadding.Parent = SearchBox

--========================================================
-- OPTIONS PANEL
--========================================================

local Options = Instance.new("ScrollingFrame")

Options.Name = "Options"
Options.Size = UDim2.new(1, -182, 1, 0)
Options.Position = UDim2.fromOffset(182, 0)

Options.BackgroundColor3 = Colors.Panel
Options.BorderSizePixel = 0

Options.ScrollBarThickness = 4
Options.ScrollBarImageColor3 = Colors.Accent

Options.CanvasSize = UDim2.new()
Options.AutomaticCanvasSize = Enum.AutomaticSize.Y

Options.ZIndex = 12
Options.Parent = Content

local OptionsCorner = Instance.new("UICorner")
OptionsCorner.CornerRadius = UDim.new(0, 11)
OptionsCorner.Parent = Options

local OptionsPadding = Instance.new("UIPadding")
OptionsPadding.PaddingTop = UDim.new(0, 10)
OptionsPadding.PaddingBottom = UDim.new(0, 12)
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
			{"group","Macro"},
			{"toggle","Macro","Aimbot"},
			{"selector","Target: Body Part"},
			{"toggle","Macro Normal","AutoShoot"},

			{"group","Silent Aim"},
			{"toggle","Activate Silent Aim","SilentAim"},
			{"selector","Silent Aim Target"},

			{"group","Auto Shoot"},
			{"toggle","Auto Shoot","AutoShoot"},
			{"toggle","Auto Shoot Aggressive","AutoShootAggressive"},
			{"toggle","Auto Equip","AutoEquip"}
		}
	},

	{
		Name = "Auto Farm",
		Icon = "◉",
		Items = {
			{"group","Funciones Automáticas"},
			{"toggle","Auto Farm","AutoFarm"},
			{"toggle","Auto Collect","AutoCollect"}
		}
	},

	{
		Name = "Movimiento",
		Icon = "✥",
		Items = {
			{"group","Player"},
			{"toggle","Activar Speed","Speed"},
			{"toggle","Custom Speed","CustomSpeed"},
			{"toggle","Salto Infinito","InfiniteJump"},
			{"toggle","Custom Jump","CustomJump"}
		}
	},

	{
		Name = "Animaciones",
		Icon = "♙",
		Items = {
			{"group","Animaciones"},
			{"toggle","Zombie","AnimZombie"},
			{"toggle","Ghost","AnimGhost"},
			{"toggle","Goat","AnimGoat"}
		}
	},

	{
		Name = "Performance ⚡",
		Icon = "◔",
		Items = {
			{"group","Performance"},
			{"info","Estado","Violet Core B10"},
			{"info","FPS","Local client performance"},
			{"info","Optimización","UI optimized"}
		}
	},

	{
		Name = "Configuración",
		Icon = "⚙",
		Items = {
			{"group","Configuración"},
			{"toggle","Save Configuration","SaveConfig"},
			{"toggle","Load Configuration","LoadConfig"}
		}
	},

	{
		Name = "Información",
		Icon = "ⓘ",
		Items = {
			{"group","Información"},
			{"info","Creado por","José FX"},
			{"info","Versión","B10"}
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

	Options.CanvasPosition = Vector2.zero
end

--========================================================
-- GROUP HEADER
--========================================================

local function CreateGroup(Name)

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, 0, 0, 27)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 13
	Label.Font = Enum.Font.GothamBold

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Options
end

--========================================================
-- TOGGLE
--========================================================

local function CreateToggle(Name, Key)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 43)

	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -70, 1, 0)
	Label.Position = UDim2.fromOffset(12, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 10
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	-- Small switch
	local Switch = Instance.new("TextButton")

	Switch.Name = "Switch"
	Switch.Size = UDim2.fromOffset(39, 21)
	Switch.Position = UDim2.new(1, -51, 0.5, -10)

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

	Knob.Size = UDim2.fromOffset(17, 17)
	Knob.Position = UDim2.fromOffset(2, 2)

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
			Knob.Position = UDim2.new(1, -19, 0, 2)

		else

			Switch.BackgroundColor3 = Colors.Off
			Knob.Position = UDim2.fromOffset(2, 2)
		end
	end

	Switch.MouseButton1Click:Connect(function()

		State[Key] = not State[Key]

		UpdateVisual()

		-- Movement
		if Key == "Speed"
			or Key == "CustomSpeed"
			or Key == "CustomJump" then

			UpdateMovement()
		end

		-- ESP
		if Key == "ESP" then
			UpdateAllESP()
		end

		-- Animations
		if Key == "AnimZombie" then

			if State.AnimZombie then
				PlayAnimation("Zombie")
			else
				StopCurrentAnimation()
			end
		end

		if Key == "AnimGhost" then

			if State.AnimGhost then
				PlayAnimation("Ghost")
			else
				StopCurrentAnimation()
			end
		end

		if Key == "AnimGoat" then

			if State.AnimGoat then
				PlayAnimation("Goat")
			else
				StopCurrentAnimation()
			end
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

	Row.Size = UDim2.new(1, 0, 0, 47)

	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.fromOffset(12, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 10
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(125, 29)
	Button.Position = UDim2.new(1, -137, 0.5, -14)

	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0

	Button.Text = State.TargetPart
	Button.TextColor3 = Colors.Text

	Button.TextSize = 10
	Button.Font = Enum.Font.GothamMedium

	Button.AutoButtonColor = false
	Button.ZIndex = 15
	Button.Parent = Row

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 8)
	ButtonCorner.Parent = Button

	local Arrow = Instance.new("TextLabel")

	Arrow.Size = UDim2.fromOffset(20, 20)
	Arrow.Position = UDim2.new(1, -25, 0.5, -10)

	Arrow.BackgroundTransparency = 1
	Arrow.Text = "⌃"
	Arrow.TextColor3 = Colors.SubText
	Arrow.TextSize = 13
	Arrow.Font = Enum.Font.GothamBold
	Arrow.ZIndex = 16
	Arrow.Parent = Button

	local Values = {
		"Head",
		"Torso",
		"Feet"
	}

	local Index = table.find(Values, State.TargetPart) or 1

	Button.MouseButton1Click:Connect(function()

		Index += 1

		if Index > #Values then
			Index = 1
		end

		State.TargetPart = Values[Index]

		Button.Text = State.TargetPart
	end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name, Value)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 46)

	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Row

	local NameLabel = Instance.new("TextLabel")

	NameLabel.Size = UDim2.new(1, -20, 0, 16)
	NameLabel.Position = UDim2.fromOffset(12, 5)

	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name

	NameLabel.TextColor3 = Colors.SubText
	NameLabel.TextSize = 8
	NameLabel.Font = Enum.Font.GothamMedium

	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.ZIndex = 14
	NameLabel.Parent = Row

	local ValueLabel = Instance.new("TextLabel")

	ValueLabel.Size = UDim2.new(1, -20, 0, 18)
	ValueLabel.Position = UDim2.fromOffset(12, 22)

	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = Value

	ValueLabel.TextColor3 = Colors.Text
	ValueLabel.TextSize = 10
	ValueLabel.Font = Enum.Font.GothamBold

	ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
	ValueLabel.ZIndex = 14
	ValueLabel.Parent = Row
end

--========================================================
-- SHOW SECTION
--========================================================

local function ShowSection(Section)

	ClearOptions()

	local HeaderLabel = Instance.new("TextLabel")

	HeaderLabel.Size = UDim2.new(1, 0, 0, 32)

	HeaderLabel.BackgroundTransparency = 1
	HeaderLabel.Text = Section.Icon .. "   " .. Section.Name

	HeaderLabel.TextColor3 = Colors.Text
	HeaderLabel.TextSize = 14
	HeaderLabel.Font = Enum.Font.GothamBold

	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left

	HeaderLabel.ZIndex = 14
	HeaderLabel.Parent = Options

	for _, Item in ipairs(Section.Items) do

		local Type = Item[1]

		if Type == "toggle" then

			CreateToggle(
				Item[2],
				Item[3]
			)

		elseif Type == "selector" then

			CreateSelector(Item[2])

		elseif Type == "info" then

			CreateInfo(
				Item[2],
				Item[3]
			)

		elseif Type == "group" then

			CreateGroup(Item[2])
		end
	end
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do

	local Button = Instance.new("TextButton")

	Button.Name = Section.Name
	Button.Size = UDim2.new(1, 0, 0, 37)

	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0

	Button.Text = Section.Icon .. "   " .. Section.Name
	Button.TextColor3 = Colors.SubText

	Button.TextSize = 10
	Button.Font = Enum.Font.GothamMedium

	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.AutoButtonColor = false

	Button.LayoutOrder = Index + 1

	Button.ZIndex = 13
	Button.Parent = Categories

	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 10)
	Padding.Parent = Button

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	CategoryButtons[Section.Name] = Button

	Button.MouseButton1Click:Connect(function()

		for _, Other in pairs(CategoryButtons) do
			Other.BackgroundColor3 = Colors.Panel
			Other.TextColor3 = Colors.SubText
		end

		Button.BackgroundColor3 = Colors.AccentDark
		Button.TextColor3 = Colors.White

		ShowSection(Section)
	end)
end

--========================================================
-- SEARCH FILTER
--========================================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()

	local Query = string.lower(SearchBox.Text)

	for Name, Button in pairs(CategoryButtons) do

		if Query == "" then

			Button.Visible = true

		else

			Button.Visible =
				string.find(
					string.lower(Name),
					Query,
					1,
					true
				) ~= nil
		end
	end
end)

--========================================================
-- OPEN / CLOSE
--========================================================

OpenButton.MouseButton1Click:Connect(function()

	Window.Visible = not Window.Visible

	-- IMPORTANT:
	-- The V button never disappears.
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
		Window.Size = UDim2.fromOffset(570, 64)
	else
		Window.Size = UDim2.fromOffset(570, 390)
	end
end)

--========================================================
-- FULLSCREEN
--========================================================

local Fullscreen = false

FullButton.MouseButton1Click:Connect(function()

	Fullscreen = not Fullscreen

	if Fullscreen then

		Window.Size = UDim2.new(0.9, 0, 0.85, 0)
		Window.Position = UDim2.new(0.05, 0, 0.075, 0)

	else

		Window.Size = UDim2.fromOffset(570, 390)
		Window.Position = UDim2.new(0.5, -285, 0.5, -195)
	end
end)

--========================================================
-- CHARACTER RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()

	task.wait(0.5)

	UpdateMovement()

	if State.ESP then
		UpdateAllESP()
	end
end)

--========================================================
-- INITIAL STATE
--========================================================

Window.Visible = false
OpenButton.Visible = true

local FirstSection = Sections[1]
local FirstButton = CategoryButtons[FirstSection.Name]

if FirstButton then

	FirstButton.BackgroundColor3 = Colors.AccentDark
	FirstButton.TextColor3 = Colors.White
end

ShowSection(FirstSection)

--========================================================
-- INITIAL UPDATE
--========================================================

UpdateMovement()

print("======================================")
print("Violet Core B10")
print("Created by José FX")
print("UI initialized successfully")
print("Menu: CLOSED")
print("Open button: VISIBLE")
print("======================================")
