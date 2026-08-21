--========================================================
-- VIOLET CORE B9.1
-- Created by José FX
-- LOCAL SCRIPT
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- REMOVE OLD GUI
--========================================================

local OldGui = PlayerGui:FindFirstChild("VioletCore_B9")
if OldGui then
	OldGui:Destroy()
end

--========================================================
-- COLORS
--========================================================

local BG = Color3.fromRGB(10, 10, 12)
local PANEL = Color3.fromRGB(18, 18, 21)
local PANEL2 = Color3.fromRGB(25, 25, 29)
local BORDER = Color3.fromRGB(48, 48, 55)

local TEXT = Color3.fromRGB(235, 235, 240)
local SUBTEXT = Color3.fromRGB(145, 145, 155)

local ACCENT = Color3.fromRGB(135, 75, 235)
local ACCENT_DARK = Color3.fromRGB(80, 45, 135)

local ON_COLOR = Color3.fromRGB(70, 200, 115)
local OFF_COLOR = Color3.fromRGB(65, 65, 72)

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

	Zombie = false,
	Ghost = false,
	Goat = false,

	AutoFarm = false,
	AutoCollect = false,

	GPS120 = false,
	GPS80 = false
}

local TargetParts = {
	"Head",
	"Torso",
	"Feet"
}

local TargetIndex = 1

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "VioletCore_B9"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(42, 42)
OpenButton.Position = UDim2.new(1, -58, 0, 70)

OpenButton.BackgroundColor3 = PANEL
OpenButton.BackgroundTransparency = 0.08
OpenButton.BorderSizePixel = 0

OpenButton.Text = "V"
OpenButton.TextColor3 = TEXT
OpenButton.TextSize = 15
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 9)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = ACCENT
OpenStroke.Thickness = 1
OpenStroke.Parent = OpenButton

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")
Window.Name = "MainWindow"

Window.Size = UDim2.fromOffset(500, 330)
Window.Position = UDim2.new(0.5, -250, 0.5, -165)

Window.BackgroundColor3 = BG
Window.BackgroundTransparency = 0.05
Window.BorderSizePixel = 0

Window.Visible = false
Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 11)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = BORDER
WindowStroke.Thickness = 1
WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)

Header.BackgroundColor3 = PANEL
Header.BorderSizePixel = 0

Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 11)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 23)
Title.Position = UDim2.fromOffset(15, 7)

Title.BackgroundTransparency = 1
Title.Text = "Violet Core"

Title.TextColor3 = TEXT
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -100, 0, 14)
Creator.Position = UDim2.fromOffset(16, 30)

Creator.BackgroundTransparency = 1
Creator.Text = "José FX"

Creator.TextColor3 = ACCENT
Creator.TextSize = 8
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.ZIndex = 12
Creator.Parent = Header

--========================================================
-- MINIMIZE
--========================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(26, 26)
MinButton.Position = UDim2.new(1, -63, 0, 14)

MinButton.BackgroundColor3 = PANEL2
MinButton.BorderSizePixel = 0

MinButton.Text = "—"
MinButton.TextColor3 = SUBTEXT
MinButton.TextSize = 13
MinButton.Font = Enum.Font.GothamBold

MinButton.AutoButtonColor = false
MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinButton

--========================================================
-- CLOSE
--========================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(26, 26)
CloseButton.Position = UDim2.new(1, -32, 0, 14)

CloseButton.BackgroundColor3 = PANEL2
CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"
CloseButton.TextColor3 = SUBTEXT
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold

CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
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
Content.Size = UDim2.new(1, -14, 1, -63)
Content.Position = UDim2.fromOffset(7, 58)

Content.BackgroundTransparency = 1
Content.Parent = Window

--========================================================
-- CATEGORY LIST
--========================================================

local CategoryList = Instance.new("ScrollingFrame")

CategoryList.Size = UDim2.fromOffset(142, 1)
CategoryList.Position = UDim2.fromOffset(0, 0)

CategoryList.BackgroundColor3 = PANEL
CategoryList.BorderSizePixel = 0

CategoryList.ScrollBarThickness = 3
CategoryList.ScrollBarImageColor3 = ACCENT

CategoryList.CanvasSize = UDim2.new(0, 0, 0, 0)
CategoryList.AutomaticCanvasSize = Enum.AutomaticSize.Y

CategoryList.Parent = Content

local CategoryCorner = Instance.new("UICorner")
CategoryCorner.CornerRadius = UDim.new(0, 8)
CategoryCorner.Parent = CategoryList

local CategoryPadding = Instance.new("UIPadding")
CategoryPadding.PaddingTop = UDim.new(0, 6)
CategoryPadding.PaddingBottom = UDim.new(0, 6)
CategoryPadding.PaddingLeft = UDim.new(0, 5)
CategoryPadding.PaddingRight = UDim.new(0, 5)
CategoryPadding.Parent = CategoryList

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.Padding = UDim.new(0, 4)
CategoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
CategoryLayout.Parent = CategoryList

--========================================================
-- OPTION LIST
--========================================================

local OptionList = Instance.new("ScrollingFrame")

OptionList.Size = UDim2.new(1, -149, 1, 0)
OptionList.Position = UDim2.fromOffset(149, 0)

OptionList.BackgroundColor3 = PANEL
OptionList.BorderSizePixel = 0

OptionList.ScrollBarThickness = 3
OptionList.ScrollBarImageColor3 = ACCENT

OptionList.CanvasSize = UDim2.new(0, 0, 0, 0)
OptionList.AutomaticCanvasSize = Enum.AutomaticSize.Y

OptionList.Parent = Content

local OptionCorner = Instance.new("UICorner")
OptionCorner.CornerRadius = UDim.new(0, 8)
OptionCorner.Parent = OptionList

local OptionPadding = Instance.new("UIPadding")
OptionPadding.PaddingTop = UDim.new(0, 7)
OptionPadding.PaddingBottom = UDim.new(0, 7)
OptionPadding.PaddingLeft = UDim.new(0, 7)
OptionPadding.PaddingRight = UDim.new(0, 7)
OptionPadding.Parent = OptionList

local OptionLayout = Instance.new("UIListLayout")
OptionLayout.Padding = UDim.new(0, 4)
OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptionLayout.Parent = OptionList

--========================================================
-- SECTION DATA
--========================================================

local Sections = {
	{
		Name = "Combat",
		Icon = "⚔",
		Options = {
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
		Options = {
			{"toggle", "Player ESP", "ESP"},
			{"toggle", "ESP Lines", "ESPLines"},
			{"toggle", "Rainbow ESP", "ESPRainbow"},
			{"toggle", "Track Target", "ESPTrack"}
		}
	},

	{
		Name = "Movement",
		Icon = "➤",
		Options = {
			{"toggle", "Speed", "Speed"},
			{"toggle", "Custom Speed", "CustomSpeed"},
			{"toggle", "Infinite Jump", "InfiniteJump"},
			{"toggle", "Custom Jump", "CustomJump"}
		}
	},

	{
		Name = "Animations",
		Icon = "♟",
		Options = {
			{"toggle", "Zombie", "Zombie"},
			{"toggle", "Ghost", "Ghost"},
			{"toggle", "Goat", "Goat"}
		}
	},

	{
		Name = "Autofarm",
		Icon = "$",
		Options = {
			{"toggle", "Auto Farm", "AutoFarm"},
			{"toggle", "Auto Collect", "AutoCollect"}
		}
	},

	{
		Name = "GPS",
		Icon = "⚡",
		Options = {
			{"toggle", "120 GPS", "GPS120"},
			{"toggle", "80 GPS", "GPS80"}
		}
	},

	{
		Name = "Settings",
		Icon = "⚙",
		Options = {
			{"info", "Configuration", "Manual save system"}
		}
	},

	{
		Name = "Information",
		Icon = "ⓘ",
		Options = {
			{"info", "Created by", "José FX"},
			{"info", "Discord", "Community"},
			{"info", "Credits", "José FX"}
		}
	}
}

--========================================================
-- CLEAR OPTIONS
--========================================================

local function ClearOptions()

	for _, Object in ipairs(OptionList:GetChildren()) do

		if not Object:IsA("UIListLayout")
			and not Object:IsA("UIPadding") then

			Object:Destroy()
		end
	end
end

--========================================================
-- TOGGLE CREATOR
--========================================================

local function CreateToggle(Name, Key)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 34)

	Row.BackgroundColor3 = PANEL2
	Row.BorderSizePixel = 0

	Row.Parent = OptionList

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(1, -55, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = Name

	Label.TextColor3 = TEXT
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Switch = Instance.new("TextButton")

	Switch.Size = UDim2.fromOffset(29, 16)
	Switch.Position = UDim2.new(1, -38, 0.5, -8)

	Switch.BackgroundColor3 = OFF_COLOR
	Switch.BorderSizePixel = 0

	Switch.Text = ""
	Switch.AutoButtonColor = false

	Switch.Parent = Row

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = Switch

	local Knob = Instance.new("Frame")

	Knob.Size = UDim2.fromOffset(12, 12)
	Knob.Position = UDim2.fromOffset(2, 2)

	Knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Knob.BorderSizePixel = 0

	Knob.Parent = Switch

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local function Update()

		if State[Key] then

			Switch.BackgroundColor3 = ON_COLOR
			Knob.Position = UDim2.new(1, -14, 0, 2)

		else

			Switch.BackgroundColor3 = OFF_COLOR
			Knob.Position = UDim2.fromOffset(2, 2)
		end
	end

	Switch.MouseButton1Click:Connect(function()

		State[Key] = not State[Key]

		Update()

		print(
			"[Violet Core]",
			Name,
			State[Key] and "ON" or "OFF"
		)
	end)

	Update()
end

--========================================================
-- SELECTOR
--========================================================

local function CreateTargetSelector()

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 34)
	Row.BackgroundColor3 = PANEL2
	Row.BorderSizePixel = 0
	Row.Parent = OptionList

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")

	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.fromOffset(9, 0)

	Label.BackgroundTransparency = 1
	Label.Text = "Target Part"

	Label.TextColor3 = TEXT
	Label.TextSize = 9
	Label.Font = Enum.Font.GothamMedium

	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Row

	local Button = Instance.new("TextButton")

	Button.Size = UDim2.fromOffset(80, 23)
	Button.Position = UDim2.new(1, -89, 0.5, -11)

	Button.BackgroundColor3 = BG
	Button.BorderSizePixel = 0

	Button.Text = TargetParts[TargetIndex]
	Button.TextColor3 = ACCENT

	Button.TextSize = 8
	Button.Font = Enum.Font.GothamBold

	Button.AutoButtonColor = false
	Button.Parent = Row

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0, 6)
	ButtonCorner.Parent = Button

	Button.MouseButton1Click:Connect(function()

		TargetIndex += 1

		if TargetIndex > #TargetParts then
			TargetIndex = 1
		end

		Button.Text = TargetParts[TargetIndex]

		print(
			"[Violet Core] Target:",
			TargetParts[TargetIndex]
		)
	end)
end

--========================================================
-- INFORMATION
--========================================================

local function CreateInfo(Name, Value)

	local Row = Instance.new("Frame")

	Row.Size = UDim2.new(1, 0, 0, 42)
	Row.BackgroundColor3 = PANEL2
	Row.BorderSizePixel = 0
	Row.Parent = OptionList

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Top = Instance.new("TextLabel")

	Top.Size = UDim2.new(1, -18, 0, 14)
	Top.Position = UDim2.fromOffset(9, 4)

	Top.BackgroundTransparency = 1
	Top.Text = Name

	Top.TextColor3 = SUBTEXT
	Top.TextSize = 7
	Top.Font = Enum.Font.GothamMedium

	Top.TextXAlignment = Enum.TextXAlignment.Left
	Top.Parent = Row

	local Bottom = Instance.new("TextLabel")

	Bottom.Size = UDim2.new(1, -18, 0, 17)
	Bottom.Position = UDim2.fromOffset(9, 20)

	Bottom.BackgroundTransparency = 1
	Bottom.Text = Value

	Bottom.TextColor3 = TEXT
	Bottom.TextSize = 9
	Bottom.Font = Enum.Font.GothamBold

	Bottom.TextXAlignment = Enum.TextXAlignment.Left
	Bottom.Parent = Row
end

--========================================================
-- SHOW SECTION
--========================================================

local function ShowSection(Section)

	ClearOptions()

	local SectionTitle = Instance.new("TextLabel")

	SectionTitle.Size = UDim2.new(1, 0, 0, 25)

	SectionTitle.BackgroundTransparency = 1
	SectionTitle.Text = Section.Icon .. "   " .. Section.Name

	SectionTitle.TextColor3 = TEXT
	SectionTitle.TextSize = 12
	SectionTitle.Font = Enum.Font.GothamBold

	SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
	SectionTitle.Parent = OptionList

	for _, Data in ipairs(Section.Options) do

		if Data[1] == "toggle" then

			CreateToggle(Data[2], Data[3])

		elseif Data[1] == "selector" then

			CreateTargetSelector()

		elseif Data[1] == "info" then

			CreateInfo(Data[2], Data[3])
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

	Button.BackgroundColor3 = PANEL
	Button.BorderSizePixel = 0

	Button.Text = Section.Icon .. "   " .. Section.Name

	Button.TextColor3 = SUBTEXT
	Button.TextSize = 8
	Button.Font = Enum.Font.GothamMedium

	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.AutoButtonColor = false

	Button.LayoutOrder = Index
	Button.Parent = CategoryList

	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 8)
	Padding.Parent = Button

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 6)
	Corner.Parent = Button

	CategoryButtons[Section.Name] = Button

	Button.MouseButton1Click:Connect(function()

		for _, OtherButton in pairs(CategoryButtons) do
			OtherButton.BackgroundColor3 = PANEL
			OtherButton.TextColor3 = SUBTEXT
		end

		Button.BackgroundColor3 = ACCENT_DARK
		Button.TextColor3 = Color3.fromRGB(255,255,255)

		ShowSection(Section)
	end)
end

--========================================================
-- OPEN / CLOSE
--========================================================

OpenButton.MouseButton1Click:Connect(function()

	Window.Visible = not Window.Visible

	-- NEVER HIDE THIS BUTTON
	OpenButton.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()

	Window.Visible = false

	-- NEVER HIDE THIS BUTTON
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
-- INITIALIZATION
--========================================================

Window.Visible = false
OpenButton.Visible = true

local CombatButton = CategoryButtons["Combat"]

if CombatButton then

	CombatButton.BackgroundColor3 = ACCENT_DARK
	CombatButton.TextColor3 = Color3.fromRGB(255,255,255)

end

ShowSection(Sections[1])

print("====================================")
print("VIOLET CORE B9.1 LOADED")
print("Created by José FX")
print("Menu: CLOSED")
print("Open Button: ACTIVE")
print("====================================")
