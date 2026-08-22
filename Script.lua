--========================================================
-- VIOLET CORE B10
-- Created by José FX
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

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
	Background = Color3.fromRGB(9, 9, 11),
	Panel = Color3.fromRGB(16, 16, 19),
	Panel2 = Color3.fromRGB(23, 23, 27),
	Panel3 = Color3.fromRGB(29, 29, 34),

	Border = Color3.fromRGB(48, 48, 55),

	Text = Color3.fromRGB(238, 238, 242),
	SubText = Color3.fromRGB(145, 145, 155),

	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(83, 46, 145),

	On = Color3.fromRGB(70, 200, 115),
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

	TargetPart = "Head"
}

local DEFAULTS = {}

for Key, Value in pairs(State) do
	DEFAULTS[Key] = Value
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
local CUSTOM_SPEED = 32

local DEFAULT_JUMP = 50
local CUSTOM_JUMP = 75

local function UpdateSpeed()
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

local function UpdateJump()
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

-- Put your own animation IDs here.
local AnimationIds = {
	Zombie = "",
	Ghost = "",
	Goat = ""
}

local CurrentAnimation

local function StopAnimation()
	if CurrentAnimation then
		CurrentAnimation:Stop()
		CurrentAnimation:Destroy()
		CurrentAnimation = nil
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

	CurrentAnimation = Track
end

--========================================================
-- TARGET PART
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
	end

	if State.TargetPart == "Feet" then
		return Character:FindFirstChild("LeftFoot")
			or Character:FindFirstChild("RightFoot")
			or Character:FindFirstChild("Left Leg")
	end

	return nil
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

			if Character and Humanoid and Humanoid.Health > 0 then
				local Part = GetTargetPart(Character)

				if Part then
					local Position, Visible =
						Camera:WorldToViewportPoint(Part.Position)

					if Visible then
						local ScreenPosition =
							Vector2.new(Position.X, Position.Y)

						local Distance =
							(ScreenPosition - MousePosition).Magnitude

						if Distance < ClosestDistance then
							ClosestDistance = Distance
							ClosestCharacter = Character
						end
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

RunService.RenderStepped:Connect(function()
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

	local Character = Player.Character

	if not Character then
		return
	end

	RemoveESP(Player)

	local Highlight

	if State.ESP then
		Highlight = Instance.new("Highlight")
		Highlight.Name = "VioletCoreESP"
		Highlight.Adornee = Character
		Highlight.FillTransparency = 0.65
		Highlight.OutlineTransparency = 0
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		Highlight.Parent = Character
	end

	ESPObjects[Player] = {
		Highlight = Highlight
	}
end

local function UpdateESP()
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
-- CONFIGURATION
--========================================================

local CONFIG_KEY = "VioletCore_B10_Config"

local function GetConfig()
	local Config = {}

	for Key, Value in pairs(State) do
		if typeof(Value) == "boolean"
			or typeof(Value) == "string" then
			Config[Key] = Value
		end
	end

	return Config
end

local function ApplyConfig(Config)
	if typeof(Config) ~= "table" then
		return
	end

	for Key, Value in pairs(Config) do
		if State[Key] ~= nil
			and (typeof(Value) == "boolean"
			or typeof(Value) == "string") then

			State[Key] = Value
		end
	end

	UpdateSpeed()
	UpdateJump()
	UpdateESP()
end

local function SaveConfiguration()
	-- Local scripts cannot reliably persist data between
	-- separate sessions by themselves.
	-- This function intentionally exposes the data so that
	-- it can later be connected to your server DataStore system.

	local Config = GetConfig()

	print("[Violet Core] Configuration prepared for saving:")
	print(HttpService:JSONEncode(Config))

	return Config
end

local function ResetConfiguration()
	for Key, Value in pairs(DEFAULTS) do
		State[Key] = Value
	end

	StopAnimation()
	UpdateSpeed()
	UpdateJump()
	UpdateESP()
end

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
OpenButton.Size = UDim2.fromOffset(40, 40)
OpenButton.Position = UDim2.new(1, -58, 0, 75)

OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.BackgroundTransparency = 0.05
OpenButton.BorderSizePixel = 0

OpenButton.Text = "FX"
OpenButton.TextColor3 = Colors.Text
OpenButton.TextSize = 11
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Colors.Accent
OpenStroke.Thickness = 1
OpenStroke.Transparency = 0.15
OpenStroke.Parent = OpenButton

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")
Window.Name = "MainWindow"

Window.Size = UDim2.fromOffset(500, 330)
Window.Position = UDim2.new(0.5, -250, 0.5, -165)

Window.BackgroundColor3 = Colors.Background
Window.BackgroundTransparency = 0.08
Window.BorderSizePixel = 0

Window.Visible = false
Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 11)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Colors.Border
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.15
WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)

Header.BackgroundColor3 = Colors.Panel
Header.BackgroundTransparency = 0.04
Header.BorderSizePixel = 0

Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 11)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -125, 0, 22)
Title.Position = UDim2.fromOffset(15, 6)

Title.BackgroundTransparency = 1
Title.Text = "Violet Core"

Title.TextColor3 = Colors.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -125, 0, 13)
Creator.Position = UDim2.fromOffset(16, 29)

Creator.BackgroundTransparency = 1
Creator.Text = "José FX"

Creator.TextColor3 = Colors.Accent
Creator.TextSize = 8
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.ZIndex = 12
Creator.Parent = Header

--========================================================
-- HEADER BUTTONS
--========================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(27, 27)
MinButton.Position = UDim2.new(1, -65, 0, 14)

MinButton.BackgroundColor3 = Colors.Panel2
MinButton.BorderSizePixel = 0

MinButton.Text = "—"
MinButton.TextColor3 = Colors.SubText
MinButton.TextSize = 13
MinButton.Font = Enum.Font.GothamBold

MinButton.AutoButtonColor = false
MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(27, 27)
CloseButton.Position = UDim2.new(1, -34, 0, 14)

CloseButton.BackgroundColor3 = Colors.Panel2
CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"
CloseButton.TextColor3 = Colors.SubText
CloseButton.TextSize = 17
CloseButton.Font = Enum.Font.GothamBold

CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--========================================================
-- DRAG SYSTEM
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
Content.Size = UDim2.new(1, -14, 1, -63)
Content.Position = UDim2.fromOffset(7, 60)

Content.BackgroundTransparency = 1
Content.Parent = Window

--========================================================
-- CATEGORY PANEL
--========================================================

local Categories = Instance.new("ScrollingFrame")

Categories.Size = UDim2.fromOffset(142, 1)
Categories.Position = UDim2.fromOffset(0, 0)

Categories.BackgroundColor3 = Colors.Panel
Categories.BackgroundTransparency = 0.03
Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 3
Categories.ScrollBarImageColor3 = Colors.Accent

Categories.CanvasSize = UDim2.new(0, 0, 0, 0)
Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y

Categories.ZIndex = 12
Categories.Parent = Content

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 8)
CatCorner.Parent = Categories

local CatPadding = Instance.new("UIPadding")
CatPadding.PaddingTop = UDim.new(0, 6)
CatPadding.PaddingBottom = UDim.new(0, 6)
CatPadding.PaddingLeft = UDim.new(0, 5)
CatPadding.PaddingRight = UDim.new(0, 5)
CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")
CatLayout.Padding = UDim.new(0, 4)
CatLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatLayout.Parent = Categories

--========================================================
-- OPTIONS PANEL
--========================================================

local Options = Instance.new("ScrollingFrame")

Options.Size = UDim2.new(1, -149, 1, 0)
Options.Position = UDim2.fromOffset(149, 0)

Options.BackgroundColor3 = Colors.Panel
Options.BackgroundTransparency = 0.03
Options.BorderSizePixel = 0

Options.ScrollBarThickness = 3
Options.ScrollBarImageColor3 = Colors.Accent

Options.CanvasSize = UDim2.new(0, 0, 0, 0)
Options.AutomaticCanvasSize = Enum.AutomaticSize.Y

Options.ZIndex = 12
Options.Parent = Content

local OptionsCorner = Instance.new("UICorner")
OptionsCorner.CornerRadius = UDim.new(0, 8)
OptionsCorner.Parent = Options

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
			{"toggle", "Auto Shoot", "AutoShoot"},
			{"toggle", "Long Range", "LongRange"}
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
			{"action", "Save Configuration", "save"},
			{"action", "Reset Configuration", "reset"}
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

	Options.CanvasPosition = Vector2.new(0, 0)
end

--========================================================
-- TOGGLE VISUAL
--========================================================

local function CreateToggle(Name, Key)
	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -57, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Switch = Instance.new("TextButton")

	Switch.Size = UDim2.fromOffset(28, 15)
	Switch.Position = UDim2.new(1, -36, 0.5, -7)

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

	Knob.Size = UDim2.fromOffset(11, 11)
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
			Knob.Position = UDim2.new(1, -13, 0, 2)
		else
			Switch.BackgroundColor3 = Colors.Off
			Knob.Position = UDim2.fromOffset(2, 2)
		end
	end

	Switch.MouseButton1Click:Connect(function()
		State[Key] = not State[Key]

		UpdateVisual()

		if Key == "Speed"
			or Key == "CustomSpeed" then

			UpdateSpeed()
		end

		if Key == "CustomJump"
			or Key == "InfiniteJump" then

			UpdateJump()
		end

		if Key == "ESP" then
			UpdateESP()
		end

		if Key == "AnimZombie"
			and State[Key] then

			PlayAnimation("Zombie")
		end

		if Key == "AnimGhost"
			and State[Key] then

			PlayAnimation("Ghost")
		end

		if Key == "AnimGoat"
			and State[Key] then

			PlayAnimation("Goat")
		end

		if Key == "AnimZombie"
			and not State[Key]
			and CurrentAnimation then

			StopAnimation()
		end

		if Key == "AnimGhost"
			and not State[Key]
			and CurrentAnimation then

			StopAnimation()
		end

		if Key == "AnimGoat"
			and not State[Key]
			and CurrentAnimation then

			StopAnimation()
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
-- TARGET SELECTOR
--========================================================

local function CreateSelector(Name)
	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(76, 22)
	Button.Position = UDim2.new(1, -85, 0.5, -11)

	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0

	Button.Text = State.TargetPart
	Button.TextColor3 = Colors.Accent

	Button.TextSize = 8
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false
	Button.ZIndex = 15
	Button.Parent = Row

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 6)
	ButtonCorner.Parent = Button

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
-- ACTION BUTTON
--========================================================

local function CreateAction(Name, Action)
	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 32)
	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -90, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = Colors.Text
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromOffset(62, 21)
	Button.Position = UDim2.new(1, -70, 0.5, -10)

	Button.BackgroundColor3 = Colors.AccentDark
	Button.BorderSizePixel = 0

	Button.Text = "APPLY"
	Button.TextColor3 = Colors.White
	Button.TextSize = 7
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false
	Button.ZIndex = 15
	Button.Parent = Row

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 6)
	ButtonCorner.Parent = Button

	Button.MouseButton1Click:Connect(function()
		if Action == "save" then
			SaveConfiguration()
		elseif Action == "reset" then
			ResetConfiguration()
		end
	end)
end

--========================================================
-- INFORMATION
--========================================================

local function CreateInfo(Name, Value)
	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 42)
	Row.BackgroundColor3 = Colors.Panel2
	Row.BorderSizePixel = 0

	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -18, 0, 14)
	NameLabel.Position = UDim2.fromOffset(9, 4)

	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name

	NameLabel.TextColor3 = Colors.SubText
	NameLabel.TextSize = 7
	NameLabel.Font = Enum.Font.GothamMedium

	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.ZIndex = 14
	NameLabel.Parent = Row

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(1, -18, 0, 18)
	ValueLabel.Position = UDim2.fromOffset(9, 19)

	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = Value

	ValueLabel.TextColor3 = Colors.Text
	ValueLabel.TextSize = 9
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

	HeaderLabel.Size = UDim2.new(1, 0, 0, 25)
	HeaderLabel.BackgroundTransparency = 1

	HeaderLabel.Text =
		Section.Icon .. "   " .. Section.Name

	HeaderLabel.TextColor3 = Colors.Text
	HeaderLabel.TextSize = 12
	HeaderLabel.Font = Enum.Font.GothamBold

	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
	HeaderLabel.ZIndex = 14
	HeaderLabel.Parent = Options

	for _, Item in ipairs(Section.Items) do
		if Item[1] == "toggle" then
			CreateToggle(Item[2], Item[3])

		elseif Item[1] == "selector" then
			CreateSelector(Item[2])

		elseif Item[1] == "action" then
			CreateAction(Item[2], Item[3])

		elseif Item[1] == "info" then
			CreateInfo(Item[2], Item[3])
		end
	end
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do
	local Button = Instance.new("TextButton")

	Button.Size = UDim2.new(1, 0, 0, 32)

	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0

	Button.Text =
		Section.Icon .. "   " .. Section.Name

	Button.TextColor3 = Colors.SubText
	Button.TextSize = 8
	Button.Font = Enum.Font.GothamMedium

	Button.TextXAlignment = Enum.TextXAlignment.Left

	Button.AutoButtonColor = false
	Button.LayoutOrder = Index

	Button.ZIndex = 13
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
			Other.BackgroundColor3 = Colors.Panel
			Other.TextColor3 = Colors.SubText
		end

		Button.BackgroundColor3 = Colors.AccentDark
		Button.TextColor3 = Colors.White

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
		Window.Size = UDim2.fromOffset(500, 55)
	else
		Window.Size = UDim2.fromOffset(500, 330)
	end
end)

--========================================================
-- RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)

	UpdateSpeed()
	UpdateJump()

	if State.ESP then
		UpdateESP()
	end
end)

--========================================================
-- INITIALIZATION
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

print("====================================")
print("Violet Core B10")
print("Created by José FX")
print("Initialized successfully")
print("Menu: CLOSED")
print("FX Button: VISIBLE")
print("====================================")
