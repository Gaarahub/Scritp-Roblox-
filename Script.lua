--// Violet Core | B7
--// José FX
--// UI base + categorías + switches + scroll + menú móvil

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local COLORS = {
	Background = Color3.fromRGB(10, 10, 12),
	Panel = Color3.fromRGB(17, 17, 20),
	Panel2 = Color3.fromRGB(22, 22, 26),
	Border = Color3.fromRGB(48, 48, 55),
	Text = Color3.fromRGB(235, 235, 240),
	SubText = Color3.fromRGB(145, 145, 155),
	Accent = Color3.fromRGB(145, 85, 255),
	AccentDark = Color3.fromRGB(90, 45, 170),
	Off = Color3.fromRGB(70, 70, 76),
	On = Color3.fromRGB(90, 210, 125),
	White = Color3.fromRGB(255, 255, 255),
}

local TWEEN = TweenInfo.new(
	0.16,
	Enum.EasingStyle.Quad,
	Enum.EasingDirection.Out
)

--==================================================
-- LIMPIAR VERSION ANTERIOR
--==================================================

local old = PlayerGui:FindFirstChild("VioletCore_B7")
if old then
	old:Destroy()
end

--==================================================
-- ESTADOS
--==================================================

local States = {}

local function SetState(name, value)
	States[name] = value
end

local function GetState(name)
	return States[name] == true
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "VioletCore_B7"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- BOTÓN ABRIR / CERRAR
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(42, 42)

-- posición fija arriba, como pediste
OpenButton.Position = UDim2.new(1, -62, 0, 70)

OpenButton.BackgroundColor3 = COLORS.Panel
OpenButton.BackgroundTransparency = 0.08
OpenButton.BorderSizePixel = 0
OpenButton.Text = "V"
OpenButton.TextColor3 = COLORS.Text
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.ZIndex = 50
OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 10)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = COLORS.Accent
OpenStroke.Thickness = 1
OpenStroke.Transparency = 0.25
OpenStroke.Parent = OpenButton

--==================================================
-- VENTANA PRINCIPAL
--==================================================

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(540, 350)
Window.Position = UDim2.new(0.5, -270, 0.5, -175)
Window.BackgroundColor3 = COLORS.Background
Window.BackgroundTransparency = 0.06
Window.BorderSizePixel = 0
Window.Visible = true
Window.ZIndex = 10
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = COLORS.Border
WindowStroke.Thickness = 1
WindowStroke.Parent = Window

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 58)
Header.BackgroundColor3 = COLORS.Panel
Header.BackgroundTransparency = 0.05
Header.BorderSizePixel = 0
Header.ZIndex = 11
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderBottom = Instance.new("Frame")
HeaderBottom.Size = UDim2.new(1, 0, 0, 12)
HeaderBottom.Position = UDim2.new(0, 0, 1, -12)
HeaderBottom.BackgroundColor3 = COLORS.Panel
HeaderBottom.BorderSizePixel = 0
HeaderBottom.ZIndex = 11
HeaderBottom.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 0, 24)
Title.Position = UDim2.fromOffset(16, 7)
Title.BackgroundTransparency = 1
Title.Text = "Violet Core"
Title.TextColor3 = COLORS.Text
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 12
Title.Parent = Header

local Creator = Instance.new("TextLabel")
Creator.Size = UDim2.new(1, -100, 0, 16)
Creator.Position = UDim2.fromOffset(17, 31)
Creator.BackgroundTransparency = 1
Creator.Text = "José FX"
Creator.TextColor3 = COLORS.Accent
Creator.TextSize = 9
Creator.Font = Enum.Font.GothamMedium
Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.ZIndex = 12
Creator.Parent = Header

--==================================================
-- CONTROLES HEADER
--==================================================

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(28, 28)
MinButton.Position = UDim2.new(1, -66, 0, 15)
MinButton.BackgroundColor3 = COLORS.Panel2
MinButton.BorderSizePixel = 0
MinButton.Text = "—"
MinButton.TextColor3 = COLORS.SubText
MinButton.TextSize = 16
MinButton.Font = Enum.Font.GothamBold
MinButton.AutoButtonColor = false
MinButton.ZIndex = 12
MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 7)
MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(28, 28)
CloseButton.Position = UDim2.new(1, -34, 0, 15)
CloseButton.BackgroundColor3 = COLORS.Panel2
CloseButton.BorderSizePixel = 0
CloseButton.Text = "×"
CloseButton.TextColor3 = COLORS.SubText
CloseButton.TextSize = 17
CloseButton.Font = Enum.Font.GothamBold
CloseButton.AutoButtonColor = false
CloseButton.ZIndex = 12
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = CloseButton

--==================================================
-- DRAG DEL MENÚ
--==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Window.Position
	end
end)

Header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - dragStart

	Window.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end)

--==================================================
-- CONTENEDOR
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -16, 1, -70)
Content.Position = UDim2.fromOffset(8, 62)
Content.BackgroundTransparency = 1
Content.ZIndex = 11
Content.Parent = Window

--==================================================
-- CATEGORÍAS
--==================================================

local Categories = Instance.new("Frame")
Categories.Size = UDim2.fromOffset(145, 1)
Categories.Position = UDim2.new(0, 0, 0, 0)
Categories.BackgroundColor3 = COLORS.Panel
Categories.BackgroundTransparency = 0.08
Categories.BorderSizePixel = 0
Categories.ZIndex = 12
Categories.Parent = Content

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 9)
CatCorner.Parent = Categories

local CatLayout = Instance.new("UIListLayout")
CatLayout.Padding = UDim.new(0, 4)
CatLayout.SortOrder = Enum.SortOrder.LayoutOrder
CatLayout.Parent = Categories

local CatPadding = Instance.new("UIPadding")
CatPadding.PaddingTop = UDim.new(0, 7)
CatPadding.PaddingBottom = UDim.new(0, 7)
CatPadding.PaddingLeft = UDim.new(0, 6)
CatPadding.PaddingRight = UDim.new(0, 6)
CatPadding.Parent = Categories

--==================================================
-- PANEL DE OPCIONES
--==================================================

local Options = Instance.new("ScrollingFrame")
Options.Name = "Options"
Options.Size = UDim2.new(1, -153, 1, 0)
Options.Position = UDim2.new(0, 153, 0, 0)
Options.BackgroundColor3 = COLORS.Panel
Options.BackgroundTransparency = 0.10
Options.BorderSizePixel = 0
Options.ScrollBarThickness = 3
Options.ScrollBarImageColor3 = COLORS.Accent
Options.CanvasSize = UDim2.new()
Options.AutomaticCanvasSize = Enum.AutomaticSize.Y
Options.ZIndex = 12
Options.Parent = Content

local OptCorner = Instance.new("UICorner")
OptCorner.CornerRadius = UDim.new(0, 9)
OptCorner.Parent = Options

local OptPadding = Instance.new("UIPadding")
OptPadding.PaddingTop = UDim.new(0, 8)
OptPadding.PaddingBottom = UDim.new(0, 8)
OptPadding.PaddingLeft = UDim.new(0, 8)
OptPadding.PaddingRight = UDim.new(0, 8)
OptPadding.Parent = Options

local OptLayout = Instance.new("UIListLayout")
OptLayout.Padding = UDim.new(0, 5)
OptLayout.SortOrder = Enum.SortOrder.LayoutOrder
OptLayout.Parent = Options

--==================================================
-- DATOS
--==================================================

local Sections = {
	{
		Name = "Combate",
		Icon = "⚔",
		Items = {
			{"Aimbot", "Aimbot"},
			{"Aimbot silencioso", "SilentAim"},
			{"Apuntar a cabeza", "HeadAim"},
			{"Auto Shoot", "AutoShoot"},
			{"Distancia larga", "LongRange"},
		}
	},

	{
		Name = "ESP",
		Icon = "◉",
		Items = {
			{"Ver enemigos", "ESP"},
			{"Líneas", "ESP_Lines"},
			{"Rainbow ESP", "ESP_Rainbow"},
			{"Seguir objetivo", "ESP_Track"},
		}
	},

	{
		Name = "Movimiento",
		Icon = "➤",
		Items = {
			{"Speed", "Speed"},
			{"Velocidad personalizada", "CustomSpeed"},
			{"Salto infinito", "InfiniteJump"},
			{"Salto personalizado", "CustomJump"},
		}
	},

	{
		Name = "Animaciones",
		Icon = "♟",
		Items = {
			{"Ghost", "AnimGhost"},
			{"Zombie", "AnimZombie"},
			{"Goat", "AnimGoat"},
			{"Caminar", "AnimWalk"},
			{"Correr", "AnimRun"},
			{"Salto", "AnimJump"},
			{"Caída", "AnimFall"},
			{"Inactividad", "AnimIdle"},
			{"Invisible", "Invisible"},
		}
	},

	{
		Name = "Autofarm",
		Icon = "$",
		Items = {
			{"Auto Farm", "AutoFarm"},
			{"Auto Collect", "AutoCollect"},
		}
	},

	{
		Name = "GPS",
		Icon = "⚡",
		Items = {
			{"120 GPS", "GPS120"},
			{"80 GPS", "GPS80"},
		}
	},

	{
		Name = "Configuración",
		Icon = "⚙",
		Items = {
			{"Guardar configuración", "SaveConfig"},
			{"Cargar configuración", "LoadConfig"},
			{"Restablecer", "ResetConfig"},
		}
	},

	{
		Name = "Información",
		Icon = "ⓘ",
		Items = {
			{"Discord", "Discord"},
			{"Créditos", "Credits"},
		}
	},
}

--==================================================
-- FUNCIÓN REAL DE CATEGORÍAS
--==================================================

local CurrentSection = nil
local CategoryButtons = {}

local function ClearOptions()
	for _, child in ipairs(Options:GetChildren()) do
		if not child:IsA("UIListLayout")
			and not child:IsA("UIPadding") then
			child:Destroy()
		end
	end
end

--==================================================
-- SWITCH
--==================================================

local function CreateToggle(parent, text, stateName)
	local Row = Instance.new("Frame")
	Row.Size = UDim2.new(1, 0, 0, 38)
	Row.BackgroundColor3 = COLORS.Panel2
	Row.BackgroundTransparency = 0.08
	Row.BorderSizePixel = 0
	Row.ZIndex = 13
	Row.Parent = parent

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Row

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -60, 1, 0)
	Label.Position = UDim2.fromOffset(10, 0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = COLORS.Text
	Label.TextSize = 10
	Label.Font = Enum.Font.GothamMedium
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 14
	Label.Parent = Row

	-- switch pequeño
	local Switch = Instance.new("TextButton")
	Switch.Size = UDim2.fromOffset(31, 17)
	Switch.Position = UDim2.new(1, -41, 0.5, -8)
	Switch.BackgroundColor3 = COLORS.Off
	Switch.BorderSizePixel = 0
	Switch.Text = ""
	Switch.AutoButtonColor = false
	Switch.ZIndex = 15
	Switch.Parent = Row

	local SwitchCorner = Instance.new("UICorner")
	SwitchCorner.CornerRadius = UDim.new(1, 0)
	SwitchCorner.Parent = Switch

	local Knob = Instance.new("Frame")
	Knob.Size = UDim2.fromOffset(13, 13)
	Knob.Position = UDim2.fromOffset(2, 2)
	Knob.BackgroundColor3 = COLORS.White
	Knob.BorderSizePixel = 0
	Knob.ZIndex = 16
	Knob.Parent = Switch

	local KnobCorner = Instance.new("UICorner")
	KnobCorner.CornerRadius = UDim.new(1, 0)
	KnobCorner.Parent = Knob

	local function UpdateVisual()
		local enabled = GetState(stateName)

		TweenService:Create(
			Switch,
			TWEEN,
			{
				BackgroundColor3 = enabled
					and COLORS.On
					or COLORS.Off
			}
		):Play()

		TweenService:Create(
			Knob,
			TWEEN,
			{
				Position = enabled
					and UDim2.new(1, -15, 0, 2)
					or UDim2.fromOffset(2, 2)
			}
		):Play()
	end

	Switch.MouseButton1Click:Connect(function()
		SetState(stateName, not GetState(stateName))
		UpdateVisual()

		-- Aquí se conecta la función real de TU juego.
		-- Cada sistema puede escuchar States[stateName].
		-- La interfaz no cambia aunque cambie la lógica.

		print(
			"[Violet Core]",
			stateName,
			GetState(stateName) and "ON" or "OFF"
		)
	end)

	UpdateVisual()

	return Row
end

--==================================================
-- MOSTRAR SECCIÓN
--==================================================

local function ShowSection(section)
	CurrentSection = section
	ClearOptions()

	local HeaderLabel = Instance.new("TextLabel")
	HeaderLabel.Size = UDim2.new(1, 0, 0, 27)
	HeaderLabel.BackgroundTransparency = 1
	HeaderLabel.Text = section.Icon .. "  " .. section.Name
	HeaderLabel.TextColor3 = COLORS.Text
	HeaderLabel.TextSize = 13
	HeaderLabel.Font = Enum.Font.GothamBold
	HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
	HeaderLabel.ZIndex = 14
	HeaderLabel.Parent = Options

	for _, item in ipairs(section.Items) do
		CreateToggle(
			Options,
			item[1],
			item[2]
		)
	end
end

--==================================================
-- BOTONES DE CATEGORÍA
--==================================================

for index, section in ipairs(Sections) do

	local Button = Instance.new("TextButton")
	Button.Name = section.Name
	Button.Size = UDim2.new(1, 0, 0, 34)
	Button.BackgroundColor3 = COLORS.Panel
	Button.BorderSizePixel = 0
	Button.Text = section.Icon .. "  " .. section.Name
	Button.TextColor3 = COLORS.SubText
	Button.TextSize = 9
	Button.Font = Enum.Font.GothamMedium
	Button.TextXAlignment = Enum.TextXAlignment.Left
	Button.AutoButtonColor = false
	Button.LayoutOrder = index
	Button.ZIndex = 13
	Button.Parent = Categories

	local Pad = Instance.new("UIPadding")
	Pad.PaddingLeft = UDim.new(0, 8)
	Pad.Parent = Button

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 7)
	Corner.Parent = Button

	CategoryButtons[section.Name] = Button

	Button.MouseButton1Click:Connect(function()

		for _, other in pairs(CategoryButtons) do
			TweenService:Create(
				other,
				TWEEN,
				{
					BackgroundColor3 = COLORS.Panel,
					TextColor3 = COLORS.SubText
				}
			):Play()
		end

		TweenService:Create(
			Button,
			TWEEN,
			{
				BackgroundColor3 = COLORS.AccentDark,
				TextColor3 = COLORS.White
			}
		):Play()

		ShowSection(section)
	end)
end

--==================================================
-- BOTÓN INVISIBLE EXTERNO
--==================================================

local InvisibleButton = Instance.new("TextButton")
InvisibleButton.Name = "InvisibleButton"
InvisibleButton.Size = UDim2.fromOffset(48, 30)
InvisibleButton.Position = UDim2.new(1, -58, 0.5, -15)
InvisibleButton.BackgroundColor3 = COLORS.Off
InvisibleButton.BorderSizePixel = 0
InvisibleButton.Text = "INVIS"
InvisibleButton.TextColor3 = COLORS.White
InvisibleButton.TextSize = 8
InvisibleButton.Font = Enum.Font.GothamBold
InvisibleButton.Visible = false
InvisibleButton.AutoButtonColor = false
InvisibleButton.ZIndex = 40
InvisibleButton.Parent = Gui

local InvisCorner = Instance.new("UICorner")
InvisCorner.CornerRadius = UDim.new(0, 7)
InvisCorner.Parent = InvisibleButton

InvisibleButton.MouseButton1Click:Connect(function()
	SetState("Invisible", not GetState("Invisible"))

	InvisibleButton.BackgroundColor3 =
		GetState("Invisible")
		and COLORS.On
		or COLORS.Off

	-- Aquí irá la lógica de invisibilidad del personaje.
end)

--==================================================
-- VISIBILIDAD DEL BOTÓN INVISIBLE
--==================================================

local function UpdateInvisibleButton()
	InvisibleButton.Visible = GetState("InvisibleButtonEnabled")

	if not InvisibleButton.Visible then
		SetState("Invisible", false)
	end
end

--==================================================
-- CONECTAR ESTADO INVISIBLE
--==================================================

local oldSetState = SetState

SetState = function(name, value)
	oldSetState(name, value)

	if name == "Invisible" then
		InvisibleButton.BackgroundColor3 =
			value and COLORS.On or COLORS.Off
	end

	if name == "InvisibleButtonEnabled" then
		UpdateInvisibleButton()
	end
end

--==================================================
-- MINIMIZAR
--==================================================

local minimized = false

MinButton.MouseButton1Click:Connect(function()
	minimized = not minimized

	Content.Visible = not minimized

	if minimized then
		Window.Size = UDim2.fromOffset(540, 58)
	else
		Window.Size = UDim2.fromOffset(540, 350)
	end
end)

--==================================================
-- CERRAR
--==================================================

CloseButton.MouseButton1Click:Connect(function()
	Window.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Window.Visible = not Window.Visible
end)

--==================================================
-- ESTADO INICIAL
--==================================================

OpenButton.Visible = false

SetState("InvisibleButtonEnabled", false)

-- abrir Combate inicialmente
ShowSection(Sections[1])

TweenService:Create(
	CategoryButtons["Combate"],
	TWEEN,
	{
		BackgroundColor3 = COLORS.AccentDark,
		TextColor3 = COLORS.White
	}
):Play()

print("Violet Core B7 cargado correctamente.")
print("José FX")
