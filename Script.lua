--// VIOLET CORE V8
--// Created by José FX
--// UI framework for your own Roblox experience

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- CLEAN OLD UI
--==================================================

local Old = PlayerGui:FindFirstChild("VioletCore_V8")
if Old then
	Old:Destroy()
end

--==================================================
-- COLORS
--==================================================

local C = {
	Background = Color3.fromRGB(9, 9, 11),
	Panel = Color3.fromRGB(15, 15, 18),
	Panel2 = Color3.fromRGB(21, 21, 25),

	Border = Color3.fromRGB(48, 48, 55),

	Text = Color3.fromRGB(235, 235, 240),
	SubText = Color3.fromRGB(145, 145, 155),

	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(90, 45, 170),

	On = Color3.fromRGB(80, 205, 120),
	Off = Color3.fromRGB(68, 68, 75),

	White = Color3.fromRGB(255, 255, 255),
}

local Tween = TweenInfo.new(
	0.15,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

--==================================================
-- STATE
--==================================================

local State = {}

local function SetState(Name, Value)
	State[Name] = Value
end

local function GetState(Name)
	return State[Name] == true
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "VioletCore_V8"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- OPEN BUTTON
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(40, 40)
OpenButton.Position = UDim2.new(1, -58, 0, 68)

OpenButton.BackgroundColor3 = C.Panel
OpenButton.BackgroundTransparency = 0.05
OpenButton.BorderSizePixel = 0

OpenButton.Text = "V"
OpenButton.TextColor3 = C.Text
OpenButton.TextSize = 16
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = false
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 9)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = C.Accent
OpenStroke.Thickness = 1
OpenStroke.Transparency = 0.2
OpenStroke.Parent = OpenButton

--==================================================
-- MAIN WINDOW
--==================================================

local Window = Instance.new("Frame")
Window.Name = "MainWindow"
Window.Size = UDim2.fromOffset(500, 330)
Window.Position = UDim2.new(0.5, -250, 0.5, -165)

Window.BackgroundColor3 = C.Background
Window.BackgroundTransparency = 0.04
Window.BorderSizePixel = 0

Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 11)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = C.Border
WindowStroke.Thickness = 1
WindowStroke.Parent = Window

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 56)

Header.BackgroundColor3 = C.Panel
Header.BackgroundTransparency = 0.03
Header.BorderSizePixel = 0

Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 11)
HeaderCorner.Parent = Header

local HeaderFill = Instance.new("Frame")
HeaderFill.Size = UDim2.new(1, 0, 0, 12)
HeaderFill.Position = UDim2.new(0, 0, 1, -12)

Header.BackgroundColor3 = C.Panel
HeaderFill.BorderSizePixel = 0

HeaderFill.ZIndex = 11
HeaderFill.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 23)
Title.Position = UDim2.fromOffset(15, 6)

Title.BackgroundTransparency = 1
Title.Text = "Violet Core"

Title.TextColor3 = C.Text
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -100, 0, 14)
Creator.Position = UDim2.fromOffset(16, 30)

Creator.BackgroundTransparency = 1
Creator.Text = "Created by José FX"

Creator.TextColor3 = C.Accent
Creator.TextSize = 8
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.ZIndex = 12
Creator.Parent = Header

--==================================================
-- HEADER BUTTONS
--==================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(27, 27)
MinButton.Position = UDim2.new(1, -64, 0, 14)

MinButton.BackgroundColor3 = C.Panel2
MinButton.BorderSizePixel = 0

MinButton.Text = "—"
MinButton.TextColor3 = C.SubText
MinButton.TextSize = 15
MinButton.Font = Enum.Font.GothamBold

MinButton.AutoButtonColor = false
MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(27, 27)
CloseButton.Position = UDim2.new(1, -33, 0, 14)

CloseButton.BackgroundColor3 = C.Panel2
CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"
CloseButton.TextColor3 = C.SubText
CloseButton.TextSize = 17
CloseButton.Font = Enum.Font.GothamBold

CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

--==================================================
-- DRAG
--==================================================

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

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -14, 1, -65)
Content.Position = UDim2.fromOffset(7, 60)

Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0

Content.ZIndex = 11
Content.Parent = Window

--==================================================
-- CATEGORY SCROLL
--==================================================

local Categories = Instance.new("ScrollingFrame")
Categories.Name = "Categories"

Categories.Size = UDim2.fromOffset(142, 1)
Categories.Position = UDim2.fromOffset(0, 0)

Categories.BackgroundColor3 = C.Panel
Categories.BackgroundTransparency = 0.04
Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 3
Categories.ScrollBarImageColor3 = C.Accent

Categories.CanvasSize = UDim2.new()
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

--==================================================
-- OPTIONS PANEL
--==================================================

local Options = Instance.new("ScrollingFrame")
Options.Name = "Options"

Options.Size = UDim2.new(1, -149, 1, 0)
Options.Position = UDim2.fromOffset(149, 0)

Options.BackgroundColor3 = C.Panel
Options.BackgroundTransparency = 0.05
Options.BorderSizePixel = 0

Options.ScrollBarThickness = 3
Options.ScrollBarImageColor3 = C.Accent

Options.CanvasSize = UDim2.new()
Options.AutomaticCanvasSize = Enum.AutomaticSize.Y

Options.ZIndex = 12
Options.Parent = Content

local OptCorner = Instance.new("UICorner")
OptCorner.CornerRadius = UDim.new(0, 8)
OptCorner.Parent = Options

local OptPadding = Instance.new("UIPadding")
OptPadding.PaddingTop = UDim.new(0, 7)
OptPadding.PaddingBottom = UDim.new(0, 7)
OptPadding.PaddingLeft = UDim.new(0, 7)
OptPadding.PaddingRight = UDim.new(0, 7)
OptPadding.Parent = Options

local OptLayout = Instance.new("UIListLayout")
OptLayout.Padding = UDim.new(0, 4)
OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptLayout.Parent = Options

--==================================================
-- SECTIONS
--==================================================

local Sections = {

	{
		Name = "Combat",
		Icon = "⚔",

		Items = {
			{
				Type = "toggle",
				Name = "Aimbot",
				Key = "Aimbot"
			},

			{
				Type = "toggle",
				Name = "Silent Aim",
				Key = "SilentAim"
			},

			{
				Type = "selector",
				Name = "Target Part",
				Key = "TargetPart",

				Values = {
					"Head",
					"Torso",
					"Feet"
				}
			},

			{
				Type = "toggle",
				Name = "Auto Shoot",
				Key = "AutoShoot"
			},

			{
				Type = "toggle",
				Name = "Long Range",
				Key = "LongRange"
			},
		}
	},

	{
		Name = "ESP",
		Icon = "◉",

		Items = {
			{
				Type = "toggle",
				Name = "Player ESP",
				Key = "ESP"
			},

			{
				Type = "toggle",
				Name = "ESP Lines",
				Key = "ESPLines"
			},

			{
				Type = "toggle",
				Name = "Rainbow ESP",
				Key = "ESPRainbow"
			},

			{
				Type = "toggle",
				Name = "Track Target",
				Key = "ESPTrack"
			},
		}
	},

	{
		Name = "Movement",
		Icon = "➤",

		Items = {
			{
				Type = "toggle",
				Name = "Speed",
				Key = "Speed"
			},

			{
				Type = "toggle",
				Name = "Custom Speed",
				Key = "CustomSpeed"
			},

			{
				Type = "toggle",
				Name = "Infinite Jump",
				Key = "InfiniteJump"
			},

			{
				Type = "toggle",
				Name = "Custom Jump",
				Key = "CustomJump"
			},
		}
	},

	{
		Name = "Animations",
		Icon = "♟",

		Items = {
			{
				Type = "toggle",
				Name = "Zombie",
				Key = "AnimZombie"
			},

			{
				Type = "toggle",
				Name = "Ghost",
				Key = "AnimGhost"
			},

			{
				Type = "toggle",
				Name = "Goat",
				Key = "AnimGoat"
			},
		}
	},

	{
		Name = "Autofarm",
		Icon = "$",

		Items = {
			{
				Type = "toggle",
				Name = "Auto Farm",
				Key = "AutoFarm"
			},

			{
				Type = "toggle",
				Name = "Auto Collect",
				Key = "AutoCollect"
			},
		}
	},

	{
		Name = "GPS",
		Icon = "⚡",

		Items = {
			{
				Type = "toggle",
				Name = "120 GPS",
				Key = "GPS120"
			},

			{
				Type = "toggle",
				Name = "80 GPS",
				Key = "GPS80"
			},
		}
	},

	{
		Name = "Settings",
		Icon = "⚙",

		Items = {
			{
				Type = "toggle",
				Name = "Save Configuration",
				Key = "SaveConfig"
			},

			{
				Type = "toggle",
				Name = "Load Configuration",
				Key = "LoadConfig"
			},

			{
				Type = "toggle",
				Name = "Reset Configuration",
				Key = "ResetConfig"
			},
		}
	},

	{
		Name = "Information",
		Icon = "ⓘ",

		Items = {
			{
				Type = "info",
				Name = "Created by",
				Value = "José FX"
			},

			{
				Type = "info",
				Name = "Discord",
				Value = "Community / Social"
			},

			{
				Type = "info",
				Name = "Credits",
				Value = "José FX"
			},
		}
	},
}

--==================================================
-- CATEGORY BUTTONS
--==================================================

local CategoryButtons = {}

local function ClearOptions()
	for _, Object in ipairs(Options:GetChildren()) do

		if not Object:IsA("UIListLayout")
			and not Object:IsA("UIPadding") then

			Object:Destroy()
		end
	end
end

--==================================================
-- SMALL SWITCH
--==================================================

local function CreateToggle(Item)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 35)

	Row.BackgroundColor3 = C.Panel2
	Row.BackgroundTransparency = 0.06

	Row.BorderSizePixel = 0
	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Item.Name

	Label.TextColor3 = C.Text
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	-- Small switch
	local Switch = Instance.new("TextButton")

	Switch.Size = UDim2.fromOffset(29, 16)
	Switch.Position = UDim2.new(1, -38, 0.5, -8)

	Switch.BackgroundColor3 = C.Off
	Switch.BorderSizePixel = 0

	Switch.Text = ""
	Switch.AutoButtonColor = false

	Switch.ZIndex = 15
	Switch.Parent = Row

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = Switch

	local Knob = Instance.new("Frame")

	Knob.Size = UDim2.fromOffset(12, 12)
	Knob.Position = UDim2.fromOffset(2, 2)

	Knob.BackgroundColor3 = C.White
	Knob.BorderSizePixel = 0

	Knob.ZIndex = 16
	Knob.Parent = Switch

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local function Update()

		local Enabled = GetState(Item.Key)

		TweenService:Create(
			Switch,
			Tween,
			{
				BackgroundColor3 =
					Enabled and C.On or C.Off
			}
		):Play()

		TweenService:Create(
			Knob,
			Tween,
			{
				Position =
					Enabled
					and UDim2.new(1, -14, 0, 2)
					or UDim2.fromOffset(2, 2)
			}
		):Play()
	end

	Switch.MouseButton1Click:Connect(function()

		SetState(
			Item.Key,
			not GetState(Item.Key)
		)

		Update()

		-- Hook point for the actual game system.
		-- Example:
		-- State.Aimbot
		-- State.ESP
		-- State.Speed
		-- etc.

		print(
			Item.Name,
			GetState(Item.Key) and "ON" or "OFF"
		)
	end)

	Update()
end

--==================================================
-- SELECTOR
--==================================================

local function CreateSelector(Item)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 35)

	Row.BackgroundColor3 = C.Panel2
	Row.BackgroundTransparency = 0.06

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
	Label.Text = Item.Name

	Label.TextColor3 = C.Text
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Selector = Instance.new("TextButton")

	Selector.Size = UDim2.fromOffset(82, 23)
	Selector.Position = UDim2.new(1, -91, 0.5, -11)

	Selector.BackgroundColor3 = C.Panel
	Selector.BorderSizePixel = 0

	Selector.Text = ""
	Selector.AutoButtonColor = false

	Selector.ZIndex = 15
	Selector.Parent = Row

	local SelectorCorner = Instance.new("UICorner")
	SelectorCorner.CornerRadius = UDim.new(0, 6)
	SelectorCorner.Parent = Selector

	local SelectorStroke = Instance.new("UIStroke")
	SelectorStroke.Color = C.Border
	SelectorStroke.Thickness = 1
	SelectorStroke.Parent = Selector

	local Value = Instance.new("TextLabel")

	Value.Size = UDim2.new(1, -20, 1, 0)
	Value.Position = UDim2.fromOffset(5, 0)

	Value.BackgroundTransparency = 1

	Value.TextColor3 = C.Accent
	Value.TextSize = 8
	Value.Font = Enum.Font.GothamBold

	Value.TextXAlignment = Enum.TextXAlignment.Center
	Value.ZIndex = 16
	Value.Parent = Selector

	local Arrow = Instance.new("TextLabel")

	Arrow.Size = UDim2.fromOffset(12, 1)
	Arrow.Position = UDim2.new(1, -15, 0.5, -5)

	Arrow.BackgroundTransparency = 1
	Arrow.Text = "›"

	Arrow.TextColor3 = C.SubText
	Arrow.TextSize = 12
	Arrow.Font = Enum.Font.GothamBold

	Arrow.ZIndex = 16
	Arrow.Parent = Selector

	local Index = 1

	State[Item.Key] = Item.Values[Index]
	Value.Text = Item.Values[Index]

	Selector.MouseButton1Click:Connect(function()

		Index += 1

		if Index > #Item.Values then
			Index = 1
		end

		State[Item.Key] = Item.Values[Index]

		Value.Text = Item.Values[Index]

		print(
			Item.Name .. ":",
			State[Item.Key]
		)
	end)
end

--==================================================
-- INFO ROW
--==================================================

local function CreateInfo(Item)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 45)

	Row.BackgroundColor3 = C.Panel2
	Row.BackgroundTransparency = 0.08

	Row.BorderSizePixel = 0
	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Name = Instance.new("TextLabel")

	Name.Size = UDim2.new(1, -18, 0, 16)
	Name.Position = UDim2.fromOffset(9, 5)

	Name.BackgroundTransparency = 1
	Name.Text = Item.Name

	Name.TextColor3 = C.SubText
	Name.TextSize = 7
	Name.Font = Enum.Font.GothamMedium

	Name.TextXAlignment = Enum.TextXAlignment.Left
	Name.ZIndex = 14
	Name.Parent = Row

	local Value = Instance.new("TextLabel")

	Value.Size = UDim2.new(1, -18, 0, 18)
	Value.Position = UDim2.fromOffset(9, 21)

	Value.BackgroundTransparency = 1
	Value.Text = Item.Value

	Value.TextColor3 = C.Text
	Value.TextSize = 9
	Value.Font = Enum.Font.GothamBold

	Value.TextXAlignment = Enum.TextXAlignment.Left
	Value.ZIndex = 14
	Value.Parent = Row
end

--==================================================
-- SHOW SECTION
--==================================================

local function ShowSection(Section)

	ClearOptions()

	local SectionTitle = Instance.new("TextLabel")

	SectionTitle.Size = UDim2.new(1, 0, 0, 25)

	SectionTitle.BackgroundTransparency = 1

	SectionTitle.Text =
		Section.Icon .. "  " .. Section.Name

	SectionTitle.TextColor3 = C.Text
	SectionTitle.TextSize = 12
	SectionTitle.Font = Enum.Font.GothamBold

	SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

	SectionTitle.ZIndex = 14
	SectionTitle.Parent = Options

	for _, Item in ipairs(Section.Items) do

		if Item.Type == "toggle" then

			CreateToggle(Item)

		elseif Item.Type == "selector" then

			CreateSelector(Item)

		elseif Item.Type == "info" then

			CreateInfo(Item)
		end
	end
end

--==================================================
-- CREATE CATEGORIES
--==================================================

for Index, Section in ipairs(Sections) do

	local Button = Instance.new("TextButton")

	Button.Name = Section.Name

	Button.Size = UDim2.new(1, 0, 0, 32)

	Button.BackgroundColor3 = C.Panel
	Button.BorderSizePixel = 0

	Button.Text =
		Section.Icon .. "  " .. Section.Name

	Button.TextColor3 = C.SubText
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

			TweenService:Create(
				Other,
				Tween,
				{
					BackgroundColor3 = C.Panel,
					TextColor3 = C.SubText
				}
			):Play()
		end

		TweenService:Create(
			Button,
			Tween,
			{
				BackgroundColor3 = C.AccentDark,
				TextColor3 = C.White
			}
		):Play()

		ShowSection(Section)
	end)
end

--==================================================
-- INVISIBLE BUTTON
--==================================================

local InvisibleButton = Instance.new("TextButton")

InvisibleButton.Name = "InvisibleButton"

InvisibleButton.Size = UDim2.fromOffset(48, 29)

InvisibleButton.Position =
	UDim2.new(1, -58, 0.5, -14)

InvisibleButton.BackgroundColor3 = C.Off
InvisibleButton.BorderSizePixel = 0

InvisibleButton.Text = "INVIS"
InvisibleButton.TextColor3 = C.White
InvisibleButton.TextSize = 7
InvisibleButton.Font = Enum.Font.GothamBold

InvisibleButton.AutoButtonColor = false
InvisibleButton.Visible = false

InvisibleButton.ZIndex = 90
InvisibleButton.Parent = Gui

local InvisCorner = Instance.new("UICorner")
InvisCorner.CornerRadius = UDim.new(0, 7)
InvisCorner.Parent = InvisibleButton

-- Invisible is NOT part of animations.
-- It is controlled separately.

local function UpdateInvisibleButton()

	local Enabled =
		GetState("InvisibleFeature")

	InvisibleButton.Visible = Enabled

	if not Enabled then
		SetState("Invisible", false)
	end
end

InvisibleButton.MouseButton1Click:Connect(function()

	SetState(
		"Invisible",
		not GetState("Invisible")
	)

	InvisibleButton.BackgroundColor3 =
		GetState("Invisible")
		and C.On
		or C.Off

	-- Connect the actual invisibility system
	-- of your own game here.
end)

--==================================================
-- MINIMIZE
--==================================================

local Minimized = false

MinButton.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	Content.Visible = not Minimized

	if Minimized then

		TweenService:Create(
			Window,
			Tween,
			{
				Size = UDim2.fromOffset(500, 56)
			}
		):Play()

	else

		TweenService:Create(
			Window,
			Tween,
			{
				Size = UDim2.fromOffset(500, 330)
			}
		):Play()
	end
end)

--==================================================
-- CLOSE / OPEN
--==================================================

CloseButton.MouseButton1Click:Connect(function()

	Window.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()

	Window.Visible = true
	OpenButton.Visible = false
end)

--==================================================
-- INITIAL STATE
--==================================================

SetState("InvisibleFeature", false)
SetState("Invisible", false)

-- Combat first
ShowSection(Sections[1])

TweenService:Create(
	CategoryButtons["Combat"],
	Tween,
	{
		BackgroundColor3 = C.AccentDark,
		TextColor3 = C.White
	}
):Play()

print("================================")
print("Violet Core V8")
print("Created by José FX")
print("Loaded successfully")
print("================================")
