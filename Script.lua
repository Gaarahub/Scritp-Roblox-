--==================================================
-- VioletCore B2
-- José FX
-- UI Base / Corrección de B1
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Evitar duplicados
local OldGui = PlayerGui:FindFirstChild("VioletCore")
if OldGui then
    OldGui:Destroy()
end

--==================================================
-- CONFIGURACIÓN
--==================================================

local Colors = {
    Background = Color3.fromRGB(18, 12, 25),
    Panel = Color3.fromRGB(30, 20, 40),
    Button = Color3.fromRGB(42, 28, 55),

    Purple = Color3.fromRGB(145, 70, 255),
    PurpleDark = Color3.fromRGB(75, 35, 110),

    Green = Color3.fromRGB(40, 220, 100),

    Text = Color3.fromRGB(245, 245, 245),
    Muted = Color3.fromRGB(165, 155, 175)
}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VioletCore"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--==================================================
-- FUNCIÓN CORNER
--==================================================

local function AddCorner(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

--==================================================
-- FUNCIÓN STROKE
--==================================================

local function AddStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Parent = object
    return stroke
end

--==================================================
-- BOTÓN PRINCIPAL
--==================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(190, 48)

-- Posición inicial
OpenButton.Position = UDim2.new(0.5, -95, 0, 70)

OpenButton.BackgroundColor3 = Colors.Panel
OpenButton.BorderSizePixel = 0

OpenButton.Text = "✦  VioletCore"
OpenButton.TextColor3 = Colors.Text
OpenButton.TextSize = 17
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Active = true

OpenButton.Parent = ScreenGui

AddCorner(OpenButton, 16)

local OpenStroke = AddStroke(
    OpenButton,
    Colors.Purple,
    2
)

--==================================================
-- ARRASTRAR BOTÓN PRINCIPAL
--==================================================

local ButtonDragging = false
local ButtonDragStart
local ButtonStartPosition

OpenButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        ButtonDragging = true
        ButtonDragStart = input.Position
        ButtonStartPosition = OpenButton.Position
    end
end)

OpenButton.InputEnded:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        ButtonDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not ButtonDragging then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Delta = input.Position - ButtonDragStart

    OpenButton.Position = UDim2.new(
        ButtonStartPosition.X.Scale,
        ButtonStartPosition.X.Offset + Delta.X,

        ButtonStartPosition.Y.Scale,
        ButtonStartPosition.Y.Offset + Delta.Y
    )
end)

--==================================================
-- MENÚ PRINCIPAL
--==================================================

local Main = Instance.new("Frame")

Main.Name = "Main"
Main.Size = UDim2.fromOffset(340, 530)

Main.Position = UDim2.new(
    0.5,
    -170,
    0.5,
    -265
)

Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0

Main.Visible = false
Main.Active = true

Main.Parent = ScreenGui

AddCorner(Main, 18)

local MainStroke = AddStroke(
    Main,
    Colors.Purple,
    1.5
)

MainStroke.Transparency = 0.15

--==================================================
-- CABECERA
--==================================================

local Header = Instance.new("Frame")

Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 70)

Header.BackgroundColor3 = Colors.Panel
Header.BorderSizePixel = 0

Header.Parent = Main

AddCorner(Header, 18)

-- Parte inferior de la cabecera para evitar
-- que las esquinas inferiores queden redondeadas
local HeaderFill = Instance.new("Frame")

HeaderFill.Size = UDim2.new(1, 0, 0, 18)
HeaderFill.Position = UDim2.new(0, 0, 1, -18)

HeaderFill.BackgroundColor3 = Colors.Panel
HeaderFill.BorderSizePixel = 0

HeaderFill.Parent = Header

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")

Title.Name = "Title"
Title.BackgroundTransparency = 1

Title.Position = UDim2.fromOffset(18, 10)
Title.Size = UDim2.new(1, -36, 0, 30)

Title.Text = "VioletCore"
Title.TextColor3 = Colors.Text

Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = Header

--==================================================
-- CREADOR
--==================================================

local Creator = Instance.new("TextLabel")

Creator.Name = "Creator"
Creator.BackgroundTransparency = 1

Creator.Position = UDim2.fromOffset(20, 38)
Creator.Size = UDim2.new(1, -40, 0, 20)

Creator.Text = "José FX"
Creator.TextColor3 = Colors.Muted

Creator.TextSize = 12
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left

Creator.Parent = Header

--==================================================
-- CONTENEDOR
--==================================================

local Content = Instance.new("ScrollingFrame")

Content.Name = "Content"

Content.Position = UDim2.fromOffset(10, 80)
Content.Size = UDim2.new(1, -20, 1, -90)

Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0

Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Colors.Purple

Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y

Content.Parent = Main

local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

Layout.Parent = Content

--==================================================
-- CREAR OPCIÓN
--==================================================

local function CreateOption(name, icon)

    local Button = Instance.new("TextButton")

    Button.Name = name
    Button.Size = UDim2.new(1, -4, 0, 48)

    Button.BackgroundColor3 = Colors.Button
    Button.BorderSizePixel = 0

    Button.Text = icon .. "   " .. name

    Button.TextColor3 = Colors.Text
    Button.TextSize = 15

    Button.Font = Enum.Font.GothamMedium

    Button.TextXAlignment = Enum.TextXAlignment.Left

    Button.AutoButtonColor = false

    Button.Parent = Content

    AddCorner(Button, 12)

    local Padding = Instance.new("UIPadding")

    Padding.PaddingLeft = UDim.new(0, 15)

    Padding.Parent = Button

    return Button
end

--==================================================
-- SECCIONES
--==================================================

CreateOption("Search", "⌕")
CreateOption("Hitbox & ESP", "◎")
CreateOption("Combat", "◉")
CreateOption("Auto Farm", "◌")
CreateOption("Movimiento", "✣")
CreateOption("Animaciones", "♙")
CreateOption("Performance", "ϟ")
CreateOption("Configuración", "⚙")
CreateOption("Información", "ⓘ")

--==================================================
-- BOTÓN INVISIBLE
-- FIJO / NO ARRASTRABLE
--==================================================

local InvisibleButton = Instance.new("TextButton")

InvisibleButton.Name = "InvisibleButton"

InvisibleButton.Size = UDim2.fromOffset(145, 45)

-- Posición fija
InvisibleButton.Position = UDim2.new(
    1,
    -165,
    0.5,
    -22
)

InvisibleButton.BackgroundColor3 = Colors.Panel
InvisibleButton.BorderSizePixel = 0

InvisibleButton.Text = "INVISIBLE"

InvisibleButton.TextColor3 = Colors.Muted
InvisibleButton.TextSize = 13

InvisibleButton.Font = Enum.Font.GothamBold

InvisibleButton.AutoButtonColor = false

InvisibleButton.Parent = ScreenGui

AddCorner(InvisibleButton, 13)

local InvisibleStroke = AddStroke(
    InvisibleButton,
    Colors.Purple,
    2
)

local InvisibleEnabled = false

--==================================================
-- INVISIBLE TOGGLE
--==================================================

InvisibleButton.MouseButton1Click:Connect(function()

    InvisibleEnabled = not InvisibleEnabled

    if InvisibleEnabled then

        InvisibleButton.Text = "ACTIVE"

        InvisibleButton.TextColor3 = Colors.Green

        InvisibleStroke.Color = Colors.Green

    else

        InvisibleButton.Text = "INVISIBLE"

        InvisibleButton.TextColor3 = Colors.Muted

        InvisibleStroke.Color = Colors.Purple
    end
end)

--==================================================
-- ABRIR / CERRAR
--==================================================

local MenuOpen = false

local function SetMenuVisible(state)

    MenuOpen = state
    Main.Visible = state
end

OpenButton.MouseButton1Click:Connect(function()

    SetMenuVisible(not MenuOpen)

end)

--==================================================
-- API
--==================================================

local VioletCore = {}

function VioletCore:Open()

    SetMenuVisible(true)

end

function VioletCore:Close()

    SetMenuVisible(false)

end

function VioletCore:Toggle()

    SetMenuVisible(not MenuOpen)

end

function VioletCore:IsOpen()

    return MenuOpen

end

print("VioletCore B2 | José FX | Loaded")

return VioletCore
