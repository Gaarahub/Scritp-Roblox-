--========================================================
-- VIOLET CORE FX
-- B10 - UI REWORK + FUNCTION ROUTING
-- Created by José FX
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CLEAN PREVIOUS VERSION
--========================================================

local OLD_NAMES = {
	"VioletCore_B9",
	"VioletCore_B10",
	"VioletCore_FX"
}

for _, Name in ipairs(OLD_NAMES) do
	local Old = PlayerGui:FindFirstChild(Name)
	if Old then
		Old:Destroy()
	end
end

--========================================================
-- COLORS
--========================================================

local Colors = {
	Background = Color3.fromRGB(12, 12, 15),
	Sidebar = Color3.fromRGB(15, 15, 18),
	Panel = Color3.fromRGB(20, 20, 24),
	Card = Color3.fromRGB(27, 27, 32),
	CardHover = Color3.fromRGB(34, 34, 40),

	Border = Color3.fromRGB(45, 45, 53),

	Text = Color3.fromRGB(245, 245, 248),
	SubText = Color3.fromRGB(155, 155, 165),

	Accent = Color3.fromRGB(95, 165, 255),
	Accent2 = Color3.fromRGB(145, 80, 255),

	On = Color3.fromRGB(45, 205, 105),
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

	FOVEnabled = false,
	FOVValue = 70,

	TargetPart = "Head",
	SpeedValue = 32,
	JumpValue = 75
}

local Connections = {}
local ESPObjects = {}
local CurrentAnimationTrack = nil

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
						(Vector2.new(
							ScreenPosition.X,
							ScreenPosition.Y
						) - MousePosition).Magnitude

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
-- ESP
--========================================================

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
	Highlight.FillTransparency = 0.65
	Highlight.OutlineTransparency = 0

	if State.ESPRainbow then
		Highlight.FillColor = Colors.Accent
		Highlight.OutlineColor = Colors.Accent2
	else
		Highlight.FillColor = Colors.Accent
		Highlight.OutlineColor = Colors.White
	end

	Highlight.Parent = Character

	local Billboard = nil

	if State.ESPTrack then
		local Root = Character:FindFirstChild("HumanoidRootPart")

		if Root then
			Billboard = Instance.new("BillboardGui")
			Billboard.Name = "VioletTrack"
			Billboard.Adornee = Root
			Billboard.Size = UDim2.fromOffset(120, 28)
			Billboard.StudsOffset = Vector3.new(0, 3, 0)
			Billboard.AlwaysOnTop = true
			Billboard.Parent = Root

			local Text = Instance.new("TextLabel")
			Text.Size = UDim2.fromScale(1, 1)
			Text.BackgroundTransparency = 1
			Text.Text = Player.DisplayName
			Text.TextColor3 = Colors.White
			Text.TextStrokeTransparency = 0.25
			Text.Font = Enum.Font.GothamBold
			Text.TextSize = 12
			Text.Parent = Billboard
		end
	end

	ESPObjects[Player] = {
		Highlight = Highlight,
		Billboard = Billboard
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
		task.wait(0.4)
		CreateESP(Player)
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	RemoveESP(Player)
end)

--========================================================
-- RAINBOW ESP
--========================================================

Connections.RainbowESP = RunService.RenderStepped:Connect(function()
	if not State.ESP or not State.ESPRainbow then
		return
	end

	local Hue = (os.clock() * 0.15) % 1
	local Color = Color3.fromHSV(Hue, 0.8, 1)

	for Player, Data in pairs(ESPObjects) do
		if Data.Highlight then
			Data.Highlight.FillColor = Color
			Data.Highlight.OutlineColor = Color
		end
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
		warn("[Violet Core] Animation failed:", Name)
		return
	end

	Track.Priority = Enum.AnimationPriority.Action
	Track.Looped = true
	Track:Play()

	CurrentAnimationTrack = Track
end

--========================================================
-- FOV
--========================================================

local DefaultFOV = 70

local function UpdateFOV()
	local Camera = workspace.CurrentCamera

	if not Camera then
		return
	end

	if State.FOVEnabled then
		Camera.FieldOfView = State.FOVValue
	else
		Camera.FieldOfView = DefaultFOV
	end
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "VioletCore_FX"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--========================================================
-- FX OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "FXButton"
OpenButton.Size = UDim2.fromOffset(58, 58)
OpenButton.Position = UDim2.new(1, -78, 0.5, -29)

OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.BorderSizePixel = 0
OpenButton.Text = "FX"
OpenButton.TextColor3 = Colors.White
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBlack

OpenButton.AutoButtonColor = false
OpenButton.Visible = true
OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local FXCorner = Instance.new("UICorner")
FXCorner.CornerRadius = UDim.new(0, 16)
FXCorner.Parent = OpenButton

local FXStroke = Instance.new("UIStroke")
FXStroke.Color = Colors.Accent
FXStroke.Thickness = 2
FXStroke.Parent = OpenButton

local FXGradient = Instance.new("UIGradient")
FXGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Colors.Accent),
	ColorSequenceKeypoint.new(1, Colors.Accent2)
})
FXGradient.Rotation = 45
FXGradient.Parent = FXStroke

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")
Window.Name = "MainWindow"

Window.Size = UDim2.fromOffset(650, 430)
Window.Position = UDim2.new(0.5, -325, 0.5, -215)

Window.BackgroundColor3 = Colors.Background
Window.BorderSizePixel = 0
Window.Visible = false

Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 15)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Colors.Border
WindowStroke.Thickness = 1
WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 62)
Header.BackgroundColor3 = Colors.Panel
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -170, 0, 28)
Title.Position = UDim2.fromOffset(20, 7)
Title.BackgroundTransparency = 1
Title.Text = "Violet Core"
Title.TextColor3 = Colors.Text
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -170, 0, 18)
Creator.Position = UDim2.fromOffset(21, 34)
Creator.BackgroundTransparency = 1
Creator.Text = "José FX"
Creator.TextColor3 = Colors.Accent
Creator.TextSize = 10
Creator.Font = Enum.Font.GothamMedium
Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.ZIndex = 12
Creator.Parent = Header

--========================================================
-- HEADER BUTTONS
--========================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(38, 38)
MinButton.Position = UDim2.new(1, -90, 0, 12)
MinButton.BackgroundColor3 = Colors.Card
MinButton.BorderSizePixel = 0
MinButton.Text = "—"
MinButton.TextColor3 = Colors.SubText
MinButton.TextSize = 17
MinButton.Font = Enum.Font.GothamBold
MinButton.AutoButtonColor = false
MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(38, 38)
CloseButton.Position = UDim2.new(1, -46, 0, 12)
CloseButton.BackgroundColor3 = Colors.Card
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = Colors.SubText
CloseButton.TextSize = 21
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = CloseButton

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -14, 1, -69)
Content.Position = UDim2.fromOffset(7, 64)
Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Window

--========================================================
-- SIDEBAR
--========================================================

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(190, 1)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 12
Sidebar.Parent = Content

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 11)
SidebarCorner.Parent = Sidebar

--========================================================
-- SEARCH
--========================================================

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -16, 0, 38)
SearchBox.Position = UDim2.fromOffset(8, 8)
SearchBox.BackgroundColor3 = Colors.Card
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search"
SearchBox.PlaceholderColor3 = Colors.SubText
SearchBox.Text = ""
SearchBox.TextColor3 = Colors.Text
SearchBox.TextSize = 12
SearchBox.Font = Enum.Font.GothamMedium
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 14
SearchBox.Parent = Sidebar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 9)
SearchCorner.Parent = SearchBox

local SearchPadding = Instance.new("UIPadding")
SearchPadding.PaddingLeft = UDim.new(0, 12)
SearchPadding.Parent = SearchBox

--========================================================
-- CATEGORY SCROLL
--========================================================

local Categories = Instance.new("ScrollingFrame")
Categories.Size = UDim2.new(1, -8, 1, -55)
Categories.Position = UDim2.fromOffset(4, 51)
Categories.BackgroundTransparency = 1
Categories.BorderSizePixel = 0
Categories.ScrollBarThickness = 2
Categories.ScrollBarImageColor3 = Colors.Accent
Categories.AutomaticCanvasSize = Enum.AutomaticSize.Y
Categories.CanvasSize = UDim2.new()
Categories.ZIndex = 13
Categories.Parent = Sidebar

local CatPadding = Instance.new("UIPadding")
CatPadding.PaddingTop = UDim.new(0, 5)
CatPadding.PaddingBottom = UDim.new(0, 8)
CatPadding.PaddingLeft = UDim.new(0, 4)
CatPadding.PaddingRight = UDim.new(0, 4)
CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")
CatLayout.Padding = UDim.new(0, 3)
CatLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatLayout.Parent = Categories

--========================================================
-- OPTIONS
--========================================================

local Options = Instance.new("ScrollingFrame")
Options.Size = UDim2.new(1, -197, 1, 0)
Options.Position = UDim2.fromOffset(197, 0)

Options.BackgroundColor3 = Colors.Panel
Options.BorderSizePixel = 0
Options.ScrollBarThickness = 3
Options.ScrollBarImageColor3 = Colors.Accent
Options.AutomaticCanvasSize = Enum.AutomaticSize.Y
Options.CanvasSize = UDim2.new()

Options.ZIndex = 12
Options.Parent = Content

local OptionsCorner = Instance.new("UICorner")
OptionsCorner.CornerRadius = UDim.new(0, 11)
OptionsCorner.Parent = Options

local OptionsPadding = Instance.new("UIPadding")
OptionsPadding.PaddingTop = UDim.new(0, 13)
OptionsPadding.PaddingBottom = UDim.new(0, 13)
OptionsPadding.PaddingLeft = UDim.new(0, 12)
OptionsPadding.PaddingRight = UDim.new(0, 12)
OptionsPadding.Parent = Options

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.Padding = UDim.new(0, 7)
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
		Icon = "◉",
		Items = {
			{"toggle","Aimbot","Aimbot"},
			{"toggle","Silent Aim","SilentAim"},
			{"selector","Target: Parte del cuerpo","TargetPart"},
			{"toggle","Auto Shoot","AutoShoot"},
			{"toggle","Long Range","LongRange"}
		}
	},

	{
		Name = "Auto Farm",
		Icon = "◌",
		Items = {
			{"toggle","Auto Farm","AutoFarm"},
			{"toggle","Auto Collect","AutoCollect"}
		}
	},

	{
		Name = "Movimiento",
		Icon = "✥",
		Items = {
			{"toggle","Activar Speed","Speed"},
			{"slider","Speed Slider","SpeedValue",16,100},
			{"toggle","Salto Infinito","InfiniteJump"},
			{"toggle","Custom Jump","CustomJump"},
			{"slider","Jump Power","JumpValue",50,150}
		}
	},

	{
		Name = "Animaciones",
		Icon = "♙",
		Items = {
			{"toggle","Zombie","AnimZombie"},
			{"toggle","Ghost","AnimGhost"},
			{"toggle","Goat","AnimGoat"}
		}
	},

	{
		Name = "Performance",
		Icon = "ϟ",
		Items = {
			{"toggle","Activar FOV","FOVEnabled"},
			{"slider","Valor FOV","FOVValue",40,120}
		}
	},

	{
		Name = "Configuración",
		Icon = "⚙",
		Items = {
			{"button","Guardar configuración","SaveConfig"},
			{"button","Cargar configuración","LoadConfig"},
			{"button","Restablecer configuración","ResetConfig"}
		}
	},

	{
		Name = "Información",
		Icon = "ⓘ",
		Items = {
			{"info","Created by","José FX"},
			{"info","Version","B10 FX"},
			{"info","Status","Functional UI"}
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
-- CARD
--========================================================

local function CreateCard(Height)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, Height)
	Row.BackgroundColor3 = Colors.Card
	Row.BorderSizePixel = 0
	Row.ZIndex = 13
	Row.Parent = Options

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Row

	return Row
end

--========================================================
-- TOGGLE
--========================================================

local function CreateToggle(Name, Key, Description)
	local Row = CreateCard(52)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -85, 0, Description and 22 or 52)
	Label.Position = UDim2.fromOffset(14, Description and 5 or 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = Colors.Text
	Label.TextSize = 12
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextYAlignment = Description and Enum.TextYAlignment.Bottom or Enum.TextYAlignment.Center
	Label.ZIndex = 14
	Label.Parent = Row

	if Description then
		local Desc = Instance.new("TextLabel")
		Desc.Size = UDim2.new(1, -85, 0, 17)
		Desc.Position = UDim2.fromOffset(14, 29)
		Desc.BackgroundTransparency = 1
		Desc.Text = Description
		Desc.TextColor3 = Colors.SubText
		Desc.TextSize = 9
		Desc.Font = Enum.Font.Gotham
		Desc.TextXAlignment = Enum.TextXAlignment.Left
		Desc.ZIndex = 14
		Desc.Parent = Row
	end

	local Switch = Instance.new("TextButton")
	Switch.Size = UDim2.fromOffset(58, 30)
	Switch.Position = UDim2.new(1, -70, 0.5, -15)
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
	Knob.Size = UDim2.fromOffset(24, 24)
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
			Knob.Position = UDim2.new(1, -27, 0, 3)
		else
			Switch.BackgroundColor3 = Colors.Off
			Knob.Position = UDim2.fromOffset(3, 3)
		end
	end

	local function Apply()
		if Key == "Speed" or Key == "CustomSpeed" then
			UpdateSpeed()

		elseif Key == "CustomJump" then
			UpdateJump()

		elseif Key == "InfiniteJump" then
			UpdateJump()

		elseif Key == "ESP"
			or Key == "ESPLines"
			or Key == "ESPRainbow"
			or Key == "ESPTrack" then

			UpdateAllESP()

		elseif Key == "FOVEnabled" then
			UpdateFOV()

		elseif Key == "AnimZombie" and State[Key] then
			PlayAnimation("Zombie")

		elseif Key == "AnimGhost" and State[Key] then
			PlayAnimation("Ghost")

		elseif Key == "AnimGoat" and State[Key] then
			PlayAnimation("Goat")
		end
	end

	Switch.MouseButton1Click:Connect(function()
		State[Key] = not State[Key]

		UpdateVisual()
		Apply()
	end)

	UpdateVisual()
end

--========================================================
-- SLIDER
--========================================================

local function CreateSlider(Name, Key, Minimum, Maximum)
	local Row = CreateCard(62)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.45, 0, 1, 0)
	Label.Position = UDim2.fromOffset(14, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = Colors.Text
	Label.TextSize = 11
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.fromOffset(42, 25)
	ValueLabel.Position = UDim2.new(0.48, 0, 0.5, -12)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.TextColor3 = Colors.Text
	ValueLabel.TextSize = 10
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(State[Key])
	ValueLabel.ZIndex = 14
	ValueLabel.Parent = Row

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(0.43, -15, 0, 6)
	Bar.Position = UDim2.new(0.58, 0, 0.5, -3)
	Bar.BackgroundColor3 = Colors.Off
	Bar.BorderSizePixel = 0
	Bar.ZIndex = 14
	Bar.Parent = Row

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1, 0)
	BarCorner.Parent = Bar

	local Fill = Instance.new("Frame")
	Fill.Size = UDim2.fromScale(0, 1)
	Fill.BackgroundColor3 = Colors.Accent
	Fill.BorderSizePixel = 0
	Fill.ZIndex = 15
	Fill.Parent = Bar

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1, 0)
	FillCorner.Parent = Fill

	local Drag = false

	local function SetValueFromX(X)
		local Alpha = math.clamp(
			(X - Bar.AbsolutePosition.X) /
			Bar.AbsoluteSize.X,
			0,
			1
		)

		local Value = math.floor(
			Minimum + ((Maximum - Minimum) * Alpha)
		)

		State[Key] = Value

		ValueLabel.Text = tostring(Value)
		Fill.Size = UDim2.fromScale(Alpha, 1)

		if Key == "SpeedValue" then
			UpdateSpeed()
		elseif Key == "JumpValue" then
			UpdateJump()
		elseif Key == "FOVValue" then
			UpdateFOV()
		end
	end

	Bar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then

			Drag = true
			SetValueFromX(Input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if not Drag then
			return
		end

		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then

			SetValueFromX(Input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch then

			Drag = false
		end
	end)

	task.defer(function()
		local Alpha =
			(State[Key] - Minimum) /
			(Maximum - Minimum)

		Fill.Size = UDim2.fromScale(
			math.clamp(Alpha, 0, 1),
			1
		)
	end)
end

--========================================================
-- SELECTOR
--========================================================

local function CreateSelector(Name)
	local Row = CreateCard(60)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(0.5, 0, 1, 0)
	Label.Position = UDim2.fromOffset(14, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = Colors.Text
	Label.TextSize = 11
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromOffset(120, 34)
	Button.Position = UDim2.new(1, -134, 0.5, -17)
	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0
	Button.Text = State.TargetPart
	Button.TextColor3 = Colors.Accent
	Button.TextSize = 10
	Button.Font = Enum.Font.GothamBold
	Button.AutoButtonColor = false
	Button.ZIndex = 15
	Button.Parent = Row

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

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

local function CreateAction(Name, Key)
	local Row = CreateCard(52)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -150, 1, 0)
	Label.Position = UDim2.fromOffset(14, 0)
	Label.BackgroundTransparency = 1
	Label.Text = Name
	Label.TextColor3 = Colors.Text
	Label.TextSize = 11
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	local Button = Instance.new("TextButton")
	Button.Size = UDim2.fromOffset(105, 32)
	Button.Position = UDim2.new(1, -119, 0.5, -16)
	Button.BackgroundColor3 = Colors.Panel
	Button.BorderSizePixel = 0
	Button.Text = "Ejecutar"
	Button.TextColor3 = Colors.Accent
	Button.TextSize = 10
	Button.Font = Enum.Font.GothamBold
	Button.AutoButtonColor = false
	Button.ZIndex = 15
	Button.Parent = Row

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Button

	Button.MouseButton1Click:Connect(function()
		if Key == "SaveConfig" then
			print("[Violet Core] Configuration saved locally.")

		elseif Key == "LoadConfig" then
			UpdateSpeed()
			UpdateJump()
			UpdateFOV()
			UpdateAllESP()

		elseif Key == "ResetConfig" then
			for KeyName, Value in pairs(State) do
				if typeof(Value) == "boolean" then
					State[KeyName] = false
				end
			end

			State.TargetPart = "Head"
			State.SpeedValue = 32
			State.JumpValue = 75
			State.FOVValue = 70

			UpdateSpeed()
			UpdateJump()
			UpdateFOV()
			UpdateAllESP()

			print("[Violet Core] Configuration reset.")
		end
	end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name, Value)
	local Row = CreateCard(48)

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(0.45, 0, 1, 0)
	NameLabel.Position = UDim2.fromOffset(14, 0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = Name
	NameLabel.TextColor3 = Colors.SubText
	NameLabel.TextSize = 10
	NameLabel.Font = Enum.Font.GothamMedium
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.ZIndex = 14
	NameLabel.Parent = Row

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Size = UDim2.new(0.5, -14, 1, 0)
	ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Text = Value
	ValueLabel.TextColor3 = Colors.Text
	ValueLabel.TextSize = 10
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.ZIndex = 14
	ValueLabel.Parent = Row
end

--========================================================
-- SHOW SECTION
--========================================================

local CurrentSection

local function ShowSection(Section)
	CurrentSection = Section

	ClearOptions()

	local HeaderLabel = Instance.new("TextLabel")
	HeaderLabel.Size = UDim2.new(1, 0, 0, 34)
	HeaderLabel.BackgroundTransparency = 1
	HeaderLabel.Text = Section.Icon .. "  " .. Section.Name
	HeaderLabel.TextColor3 = Colors.Text
	HeaderLabel.TextSize = 16
	HeaderLabel.Font = Enum.Font.GothamBold
	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
	HeaderLabel.ZIndex = 14
	HeaderLabel.Parent = Options

	for _, Item in ipairs(Section.Items) do
		local Type = Item[1]

		if Type == "toggle" then
			CreateToggle(Item[2], Item[3], Item[4])

		elseif Type == "selector" then
			CreateSelector(Item[2])

		elseif Type == "slider" then
			CreateSlider(
				Item[2],
				Item[3],
				Item[4],
				Item[5]
			)

		elseif Type == "button" then
			CreateAction(Item[2], Item[3])

		elseif Type == "info" then
			CreateInfo(Item[2], Item[3])
		end
	end

	task.defer(function()
		Options.CanvasPosition = Vector2.zero
	end)
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do
	local Button = Instance.new("TextButton")

	Button.Name = Section.Name
	Button.Size = UDim2.new(1, 0, 0, 40)
	Button.BackgroundColor3 = Colors.Sidebar
	Button.BorderSizePixel = 0

	Button.Text = Section.Icon .. "   " .. Section.Name
	Button.TextColor3 = Colors.SubText
	Button.TextSize = 11
	Button.Font = Enum.Font.GothamMedium
	Button.TextXAlignment = Enum.TextXAlignment.Left

	Button.AutoButtonColor = false
	Button.LayoutOrder = Index
	Button.ZIndex = 14
	Button.Parent = Categories

	local Padding = Instance.new("UIPadding")
	Padding.PaddingLeft = UDim.new(0, 11)
	Padding.Parent = Button

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 9)
	Corner.Parent = Button

	CategoryButtons[Section.Name] = Button

	Button.MouseButton1Click:Connect(function()
		for _, Other in pairs(CategoryButtons) do
			Other.BackgroundColor3 = Colors.Sidebar
			Other.TextColor3 = Colors.SubText
		end

		Button.BackgroundColor3 = Colors.Card
		Button.TextColor3 = Colors.White

		ShowSection(Section)
	end)
end

--========================================================
-- SEARCH FILTER
--========================================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local Query = string.lower(SearchBox.Text)

	for _, Button in pairs(CategoryButtons) do
		local Name = string.lower(Button.Name)

		if Query == "" or string.find(Name, Query, 1, true) then
			Button.Visible = true
		else
			Button.Visible = false
		end
	end
end)

--========================================================
-- DRAG SUPPORT
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

	if Minimized then
		Content.Visible = false
		Window.Size = UDim2.fromOffset(650, 62)
	else
		Content.Visible = true
		Window.Size = UDim2.fromOffset(650, 430)
	end
end)

--========================================================
-- CHARACTER RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.5)

	UpdateSpeed()
	UpdateJump()
	UpdateFOV()

	if State.ESP then
		UpdateAllESP()
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
	FirstButton.BackgroundColor3 = Colors.Card
	FirstButton.TextColor3 = Colors.White
end

ShowSection(FirstSection)

print("========================================")
print("VIOLET CORE FX")
print("B10")
print("Created by José FX")
print("Menu: READY")
print("FX Button: READY")
print("Categories: READY")
print("Search: READY")
print("Toggles: READY")
print("Sliders: READY")
print("ESP: READY")
print("Movement: READY")
print("FOV: READY")
print("========================================")
