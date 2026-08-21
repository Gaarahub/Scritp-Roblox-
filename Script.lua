--[[
    VioletCore
    José FX
    Framework / UI Base
]]

local VioletCore = {}

VioletCore.Name = "VioletCore"
VioletCore.Creator = "José FX"
VioletCore.Version = "1.0.0"

--==================================================
-- CONFIGURACIÓN
--==================================================

local Config = {
    Theme = "Purple",

    Colors = {
        Background = Color3.fromRGB(18, 12, 25),
        Panel = Color3.fromRGB(30, 20, 40),
        Button = Color3.fromRGB(39, 27, 50),
        Purple = Color3.fromRGB(145, 70, 255),
        Green = Color3.fromRGB(40, 220, 100),
        Text = Color3.fromRGB(245, 245, 245),
        Muted = Color3.fromRGB(160, 155, 170),
    },

    Saved = {}
}

--==================================================
-- SERVICIOS
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--==================================================
-- GUI PRINCIPAL
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VioletCore"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- BOTÓN DE ABRIR / CERRAR
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(190, 48)
OpenButton.Position = UDim2.new(0.5, -95, 0, 70)

OpenButton.BackgroundColor3 = Config.Colors.Panel
OpenButton.TextColor3 = Config.Colors.Text
OpenButton.Text = "✦  VioletCore"
OpenButton.TextSize = 17
OpenButton.Font = Enum.Font.GothamMedium

OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 18)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Config.Colors.Purple
OpenStroke.Thickness = 2
OpenStroke.Parent = OpenButton

--==================================================
-- MENÚ
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(330, 520)
Main.Position = UDim2.new(0.5, -165, 0.5, -260)

Main.BackgroundColor3 = Config.Colors.Background
Main.Visible = false
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Config.Colors.Purple
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.25
MainStroke.Parent = Main

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(20, 15)
Title.Size = UDim2.new(1, -40, 0, 30)

Title.Text = "VioletCore"
Title.TextColor3 = Config.Colors.Text
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = Main

local Creator = Instance.new("TextLabel")
Creator.BackgroundTransparency = 1
Creator.Position = UDim2.fromOffset(22, 42)
Creator.Size = UDim2.new(1, -44, 0, 20)

Creator.Text = "José FX"
Creator.TextColor3 = Config.Colors.Muted
Creator.TextSize = 12
Creator.Font = Enum.Font.GothamMedium
Creator.TextXAlignment = Enum.TextXAlignment.Left

Creator.Parent = Main

--==================================================
-- CONTENEDOR DE PESTAÑAS
--==================================================

local Tabs = Instance.new("ScrollingFrame")
Tabs.Name = "Tabs"
Tabs.Position = UDim2.fromOffset(10, 75)
Tabs.Size = UDim2.new(1, -20, 1, -85)

Tabs.BackgroundTransparency = 1
Tabs.BorderSizePixel = 0

Tabs.ScrollBarThickness = 3
Tabs.ScrollBarImageColor3 = Config.Colors.Purple

Tabs.CanvasSize = UDim2.new(0, 0, 0, 0)
Tabs.AutomaticCanvasSize = Enum.AutomaticSize.Y

Tabs.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 7)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Tabs

--==================================================
-- CREAR BOTÓN DE PESTAÑA
--==================================================

local function CreateTab(Name, Icon)

    local Button = Instance.new("TextButton")

    Button.Name = Name
    Button.Size = UDim2.new(1, -4, 0, 48)

    Button.BackgroundColor3 = Config.Colors.Button
    Button.BackgroundTransparency = 0.05

    Button.TextColor3 = Config.Colors.Text
    Button.Text = Icon .. "   " .. Name

    Button.TextSize = 15
    Button.Font = Enum.Font.GothamMedium

    Button.TextXAlignment = Enum.TextXAlignment.Left

    Button.Parent = Tabs

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.Parent = Button

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Button

    return Button
end

--==================================================
-- PESTAÑAS
--==================================================

CreateTab("Search", "⌕")
CreateTab("Hitbox & ESP", "◎")
CreateTab("Combat", "◉")
CreateTab("Auto Farm", "◌")
CreateTab("Movimiento", "✣")
CreateTab("Animaciones", "♙")
CreateTab("Performance", "ϟ")
CreateTab("Configuración", "⚙")
CreateTab("Información", "ⓘ")

--==================================================
-- BOTÓN INVISIBLE
--==================================================

local InvisibleButton = Instance.new("TextButton")

InvisibleButton.Name = "InvisibleButton"
InvisibleButton.Size = UDim2.fromOffset(145, 45)

-- Posición fija a la derecha y centro de la pantalla
InvisibleButton.Position = UDim2.new(1, -165, 0.5, -22)

InvisibleButton.BackgroundColor3 = Config.Colors.Panel
InvisibleButton.Text = "INVISIBLE"
InvisibleButton.TextColor3 = Config.Colors.Muted
InvisibleButton.TextSize = 14
InvisibleButton.Font = Enum.Font.GothamBold

InvisibleButton.Parent = ScreenGui

local InvisibleCorner = Instance.new("UICorner")
InvisibleCorner.CornerRadius = UDim.new(0, 13)
InvisibleCorner.Parent = InvisibleButton

local InvisibleStroke = Instance.new("UIStroke")
InvisibleStroke.Color = Config.Colors.Purple
InvisibleStroke.Thickness = 2
InvisibleStroke.Parent = InvisibleButton

local InvisibleEnabled = false

InvisibleButton.MouseButton1Click:Connect(function()

    InvisibleEnabled = not InvisibleEnabled

    if InvisibleEnabled then
        InvisibleButton.Text = "ACTIVE"
        InvisibleButton.TextColor3 = Config.Colors.Green
        InvisibleStroke.Color = Config.Colors.Green
    else
        InvisibleButton.Text = "INVISIBLE"
        InvisibleButton.TextColor3 = Config.Colors.Muted
        InvisibleStroke.Color = Config.Colors.Purple
    end

end)

--==================================================
-- ABRIR / CERRAR MENÚ
--==================================================

OpenButton.MouseButton1Click:Connect(function()

    Main.Visible = not Main.Visible

end)

--==================================================
-- SISTEMA DE TEMA
--==================================================

function VioletCore:SetTheme(Color)

    Config.Colors.Purple = Color

    OpenStroke.Color = Color
    MainStroke.Color = Color
    InvisibleStroke.Color = Color

end

--==================================================
-- CONFIGURACIÓN MANUAL
--==================================================

function VioletCore:SaveConfiguration()

    -- Aquí irá el sistema de guardado.
    -- Se ejecutará ÚNICAMENTE cuando el usuario
    -- pulse el botón "Guardar configuración".

    print("VioletCore: configuración guardada.")

end

function VioletCore:LoadConfiguration()

    -- Aquí irá el sistema para cargar
    -- la configuración previamente guardada.

    print("VioletCore: configuración cargada.")

end

--==================================================
-- INFORMACIÓN
--==================================================

function VioletCore:GetInformation()

    return {
        Name = VioletCore.Name,
        Creator = VioletCore.Creator,
        Version = VioletCore.Version
    }

end

print("VioletCore cargado - José FX")

return VioletCore
