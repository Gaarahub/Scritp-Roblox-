--==================================================
-- VIOLETCORE B4
-- José FX
-- UI FRAMEWORK
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- LIMPIAR VERSION ANTERIOR
--==================================================

local Old = PlayerGui:FindFirstChild("VioletCore")

if Old then
    Old:Destroy()
end

--==================================================
-- TEMA
--==================================================

local Theme = {
    Background = Color3.fromRGB(22, 15, 30),
    Panel = Color3.fromRGB(30, 21, 40),
    Item = Color3.fromRGB(43, 32, 54),

    Purple = Color3.fromRGB(150, 75, 255),
    PurpleDark = Color3.fromRGB(75, 40, 105),

    Green = Color3.fromRGB(45, 220, 110),
    Gray = Color3.fromRGB(80, 78, 85),

    White = Color3.fromRGB(245, 245, 250),
    Muted = Color3.fromRGB(165, 160, 175)
}

--==================================================
-- GUI
--==================================================

local GUI = Instance.new("ScreenGui")
GUI.Name = "VioletCore"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

--==================================================
-- UTILIDADES
--==================================================

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
    return c
end

local function Stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Parent = object
    return s
end

--==================================================
-- BOTÓN DE ABRIR / CERRAR
--==================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(210, 54)

-- Posición inicial solicitada
OpenButton.Position = UDim2.new(0.5, -105, 0, 70)

OpenButton.BackgroundColor3 = Theme.Panel
OpenButton.BackgroundTransparency = 0.12

OpenButton.Text = "☷   VioletCore"
OpenButton.TextColor3 = Theme.White
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Parent = GUI

Corner(OpenButton, 18)
Stroke(OpenButton, Theme.Purple, 2)

--==================================================
-- MENÚ PRINCIPAL
--==================================================

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = UDim2.fromOffset(720, 500)

Main.Position = UDim2.new(
    0.5,
    -360,
    0.5,
    -250
)

Main.BackgroundColor3 = Theme.Background
Main.BackgroundTransparency = 0.12

Main.Visible = false
Main.Active = true

Main.Parent = GUI

Corner(Main, 16)
Stroke(Main, Theme.PurpleDark, 1.5)

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")

Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 62)

Header.BackgroundColor3 = Theme.Panel
Header.BackgroundTransparency = 0.1

Header.Active = true
Header.Parent = Main

Corner(Header, 16)

local HeaderFill = Instance.new("Frame")

HeaderFill.Size = UDim2.new(1, 0, 0, 18)
HeaderFill.Position = UDim2.new(0, 0, 1, -18)

HeaderFill.BackgroundColor3 = Theme.Panel
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Header

--==================================================
-- TÍTULO
--==================================================

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -140, 0, 30)
Title.Position = UDim2.fromOffset(18, 8)

Title.BackgroundTransparency = 1

Title.Text = "VioletCore"
Title.TextColor3 = Theme.White

Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

--==================================================
-- AUTOR
--==================================================

local Creator = Instance.new("TextLabel")

Creator.Size = UDim2.new(1, -140, 0, 20)
Creator.Position = UDim2.fromOffset(20, 35)

Creator.BackgroundTransparency = 1

Creator.Text = "José FX"
Creator.TextColor3 = Theme.Muted

Creator.TextSize = 11
Creator.Font = Enum.Font.GothamMedium

Creator.TextXAlignment = Enum.TextXAlignment.Left
Creator.Parent = Header

--==================================================
-- VERSIÓN
--==================================================

local Version = Instance.new("TextLabel")

Version.Size = UDim2.fromOffset(70, 25)
Version.Position = UDim2.new(1, -85, 0, 18)

Version.BackgroundTransparency = 1

Version.Text = "B4"
Version.TextColor3 = Theme.Muted

Version.TextSize = 12
Version.Font = Enum.Font.GothamBold

Version.Parent = Header

--==================================================
-- NAVEGACIÓN
--==================================================

local Navigation = Instance.new("Frame")

Navigation.Name = "Navigation"

Navigation.Size = UDim2.new(
    0,
    210,
    1,
    -75
)

Navigation.Position = UDim2.fromOffset(10, 70)

Navigation.BackgroundColor3 = Theme.Panel
Navigation.BackgroundTransparency = 0.12

Navigation.Parent = Main

Corner(Navigation, 12)

local NavPadding = Instance.new("UIPadding")

NavPadding.PaddingTop = UDim.new(0, 8)
NavPadding.PaddingLeft = UDim.new(0, 7)
NavPadding.PaddingRight = UDim.new(0, 7)

NavPadding.Parent = Navigation

local NavLayout = Instance.new("UIListLayout")

NavLayout.Padding = UDim.new(0, 5)
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder

NavLayout.Parent = Navigation

--==================================================
-- CONTENIDO
--==================================================

local Content = Instance.new("Frame")

Content.Name = "Content"

Content.Size = UDim2.new(
    1,
    -230,
    1,
    -75
)

Content.Position = UDim2.fromOffset(
    220,
    70
)

Content.BackgroundColor3 = Theme.Panel
Content.BackgroundTransparency = 0.08

Content.Parent = Main

Corner(Content, 12)

--==================================================
-- PÁGINAS
--==================================================

local Pages = {}

local function ClearContent()

    for _, child in ipairs(Content:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

end

local function HeaderText(text)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, -30, 0, 40)
    Label.Position = UDim2.fromOffset(15, 10)

    Label.BackgroundTransparency = 1

    Label.Text = text
    Label.TextColor3 = Theme.White

    Label.TextSize = 20
    Label.Font = Enum.Font.GothamBold

    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.Parent = Content

end

--==================================================
-- TOGGLE
--==================================================

local function Toggle(text, callback, y)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(
        1,
        -30,
        0,
        50
    )

    Button.Position = UDim2.fromOffset(15, y)

    Button.BackgroundColor3 = Theme.Item
    Button.BorderSizePixel = 0

    Button.Text = ""
    Button.AutoButtonColor = false

    Button.Parent = Content

    Corner(Button, 10)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(
        1,
        -90,
        1,
        0
    )

    Label.Position = UDim2.fromOffset(15, 0)

    Label.BackgroundTransparency = 1

    Label.Text = text
    Label.TextColor3 = Theme.White

    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium

    Label.TextXAlignment = Enum.TextXAlignment.Left

    Label.Parent = Button

    local Switch = Instance.new("Frame")

    Switch.Size = UDim2.fromOffset(50, 26)

    Switch.Position = UDim2.new(
        1,
        -65,
        0.5,
        -13
    )

    Switch.BackgroundColor3 = Theme.Gray
    Switch.Parent = Button

    Corner(Switch, 20)

    local Knob = Instance.new("Frame")

    Knob.Size = UDim2.fromOffset(20, 20)
    Knob.Position = UDim2.fromOffset(3, 3)

    Knob.BackgroundColor3 = Theme.White
    Knob.Parent = Switch

    Corner(Knob, 20)

    local Enabled = false

    Button.MouseButton1Click:Connect(function()

        Enabled = not Enabled

        if Enabled then

            Switch.BackgroundColor3 = Theme.Green

            Knob.Position = UDim2.new(
                1,
                -23,
                0,
                3
            )

        else

            Switch.BackgroundColor3 = Theme.Gray

            Knob.Position = UDim2.fromOffset(
                3,
                3
            )

        end

        if callback then
            callback(Enabled)
        end

    end)

    return Button
end

--==================================================
-- SLIDER
--==================================================

local function Slider(
    text,
    min,
    max,
    default,
    callback,
    y
)

    local Holder = Instance.new("Frame")

    Holder.Size = UDim2.new(
        1,
        -30,
        0,
        65
    )

    Holder.Position = UDim2.fromOffset(
        15,
        y
    )

    Holder.BackgroundColor3 = Theme.Item

    Holder.Parent = Content

    Corner(Holder, 10)

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(
        1,
        -30,
        0,
        25
    )

    Label.Position = UDim2.fromOffset(
        15,
        5
    )

    Label.BackgroundTransparency = 1

    Label.Text =
        text .. ": " .. default

    Label.TextColor3 = Theme.White

    Label.TextSize = 14
    Label.Font = Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Holder

    local Bar = Instance.new("Frame")

    Bar.Size = UDim2.new(
        1,
        -30,
        0,
        5
    )

    Bar.Position = UDim2.fromOffset(
        15,
        45
    )

    Bar.BackgroundColor3 = Theme.Gray
    Bar.Parent = Holder

    Corner(Bar, 10)

    local Fill = Instance.new("Frame")

    local initial =
        (default - min) /
        (max - min)

    Fill.Size = UDim2.new(
        initial,
        0,
        1,
        0
    )

    Fill.BackgroundColor3 = Theme.Purple
    Fill.Parent = Bar

    Corner(Fill, 10)

    local dragging = false

    Bar.InputBegan:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = true

        end

    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or input.UserInputType ==
            Enum.UserInputType.Touch then

            dragging = false

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if not dragging then
            return
        end

        if input.UserInputType ~=
            Enum.UserInputType.MouseMovement
            and input.UserInputType ~=
            Enum.UserInputType.Touch then

            return
        end

        local percent = math.clamp(
            (
                input.Position.X -
                Bar.AbsolutePosition.X
            ) / Bar.AbsoluteSize.X,
            0,
            1
        )

        local value = math.floor(
            min +
            ((max - min) * percent)
        )

        Fill.Size = UDim2.new(
            percent,
            0,
            1,
            0
        )

        Label.Text =
            text .. ": " .. value

        if callback then
            callback(value)
        end

    end)

    return Holder

end

--==================================================
-- CATEGORÍAS
--==================================================

local function CreateCategory(
    name,
    icon,
    pageFunction
)

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(
        1,
        0,
        0,
        40
    )

    Button.BackgroundColor3 =
        Theme.Item

    Button.BackgroundTransparency = 1

    Button.Text =
        icon .. "   " .. name

    Button.TextColor3 =
        Theme.White

    Button.TextSize = 13
    Button.Font = Enum.Font.GothamMedium

    Button.TextXAlignment =
        Enum.TextXAlignment.Left

    Button.AutoButtonColor = false
    Button.Parent = Navigation

    Corner(Button, 8)

    Pages[name] = Button

    Button.MouseButton1Click:Connect(function()

        for _, item in pairs(Pages) do
            item.BackgroundTransparency = 1
        end

        Button.BackgroundTransparency = 0

        ClearContent()
        pageFunction()

    end)

    return Button
end

--==================================================
-- ESP
--==================================================

local function ESPPage()

    HeaderText("ESP")

    Toggle(
        "Activar ESP",
        function(enabled)
            -- Sistema ESP de la experiencia
        end,
        60
    )

    Toggle(
        "Mostrar líneas",
        function(enabled)
        end,
        120
    )

    Toggle(
        "Mostrar nombres",
        function(enabled)
        end,
        180
    )

    Toggle(
        "Rainbow",
        function(enabled)
        end,
        240
    )

end

--==================================================
-- COMBAT
--==================================================

local function CombatPage()

    HeaderText("Combat")

    Toggle(
        "Aimbot",
        function(enabled)
            -- Conectar con la lógica de combate
            -- de tu propia experiencia.
        end,
        60
    )

    Toggle(
        "Silent Aim",
        function(enabled)
            -- Conectar con el sistema de combate
            -- implementado por el desarrollador.
        end,
        120
    )

    Toggle(
        "Auto Shoot",
        function(enabled)
        end,
        180
    )

    Slider(
        "FOV",
        10,
        180,
        70,
        function(value)
        end,
        245
    )

end

--==================================================
-- AUTO FARM
--==================================================

local function FarmPage()

    HeaderText("Auto Farm")

    Toggle(
        "Auto Farm",
        function(enabled)
        end,
        60
    )

    Toggle(
        "Auto Collect",
        function(enabled)
        end,
        120
    )

end

--==================================================
-- MOVIMIENTO
--==================================================

local function MovementPage()

    HeaderText("Movimiento")

    Toggle(
        "Speed",
        function(enabled)
        end,
        60
    )

    Slider(
        "Velocidad",
        1,
        120,
        16,
        function(value)
        end,
        120
    )

    Toggle(
        "Infinite Jump",
        function(enabled)
        end,
        195
    )

    Slider(
        "Salto",
        1,
        120,
        50,
        function(value)
        end,
        255
    )

end

--==================================================
-- ANIMACIONES
--==================================================

local function AnimationsPage()

    HeaderText("Animaciones")

    Toggle(
        "Invisible",
        function(enabled)
            -- Conectar con el sistema de personaje
            -- de tu propia experiencia.
        end,
        60
    )

    Toggle(
        "Ghost",
        function(enabled)
        end,
        120
    )

    Toggle(
        "Zombie",
        function(enabled)
        end,
        180
    )

    Toggle(
        "Animación personalizada",
        function(enabled)
        end,
        240
    )

end

--==================================================
-- FPS
--==================================================

local function FPSPage()

    HeaderText("FPS / Performance")

    Toggle(
        "Modo rendimiento",
        function(enabled)
        end,
        60
    )

    Toggle(
        "Reducir efectos",
        function(enabled)
        end,
        120
    )

    Slider(
        "FPS objetivo",
        30,
        120,
        60,
        function(value)
        end,
        195
    )

end

--==================================================
-- CONFIGURACIÓN
--==================================================

local function ConfigPage()

    HeaderText("Configuración")

    Toggle(
        "Animaciones del menú",
        function(enabled)
        end,
        60
    )

    Toggle(
        "Mostrar al iniciar",
        function(enabled)
        end,
        120
    )

    local Save = Instance.new("TextButton")

    Save.Size = UDim2.new(
        1,
        -30,
        0,
        50
    )

    Save.Position =
        UDim2.fromOffset(15, 195)

    Save.BackgroundColor3 =
        Theme.Purple

    Save.Text =
        "Guardar configuración"

    Save.TextColor3 =
        Theme.White

    Save.TextSize = 14
    Save.Font = Enum.Font.GothamBold

    Save.Parent = Content

    Corner(Save, 10)

    Save.MouseButton1Click:Connect(function()

        Save.Text =
            "Configuración guardada ✓"

        task.delay(1.5, function()

            if Save.Parent then
                Save.Text =
                    "Guardar configuración"
            end

        end)

    end)

end

--==================================================
-- INFORMACIÓN
--==================================================

local function InfoPage()

    HeaderText("Información")

    local Info = Instance.new("TextLabel")

    Info.Size = UDim2.new(
        1,
        -30,
        0,
        150
    )

    Info.Position =
        UDim2.fromOffset(15, 65)

    Info.BackgroundTransparency = 1

    Info.Text =
        "VioletCore\n\n" ..
        "Creado por José FX\n\n" ..
        "Créditos\n" ..
        "Discord: próximamente"

    Info.TextColor3 =
        Theme.White

    Info.TextSize = 15
    Info.Font = Enum.Font.GothamMedium

    Info.TextXAlignment =
        Enum.TextXAlignment.Left

    Info.TextYAlignment =
        Enum.TextYAlignment.Top

    Info.Parent = Content

end

--==================================================
-- CREAR CATEGORÍAS
--==================================================

CreateCategory(
    "ESP",
    "◎",
    ESPPage
)

CreateCategory(
    "Combat",
    "◉",
    CombatPage
)

CreateCategory(
    "Auto Farm",
    "◌",
    FarmPage
)

CreateCategory(
    "Movimiento",
    "✣",
    MovementPage
)

CreateCategory(
    "Animaciones",
    "♙",
    AnimationsPage
)

CreateCategory(
    "FPS",
    "ϟ",
    FPSPage
)

CreateCategory(
    "Configuración",
    "⚙",
    ConfigPage
)

CreateCategory(
    "Información",
    "ⓘ",
    InfoPage
)

--==================================================
-- BOTÓN INVISIBLE EXTERNO
--==================================================

local InvisibleButton =
    Instance.new("TextButton")

InvisibleButton.Name =
    "InvisibleButton"

InvisibleButton.Size =
    UDim2.fromOffset(145, 45)

-- FIJO A LA DERECHA
InvisibleButton.Position =
    UDim2.new(
        1,
        -165,
        0.5,
        -22
    )

InvisibleButton.BackgroundColor3 =
    Theme.Panel

InvisibleButton.BackgroundTransparency =
    0.08

InvisibleButton.Text =
    "INVISIBLE"

InvisibleButton.TextColor3 =
    Theme.Muted

InvisibleButton.TextSize =
    13

InvisibleButton.Font =
    Enum.Font.GothamBold

InvisibleButton.AutoButtonColor =
    false

InvisibleButton.Parent =
    GUI

Corner(InvisibleButton, 13)

local InvisibleStroke =
    Stroke(
        InvisibleButton,
        Theme.Purple,
        2
    )

local InvisibleEnabled = false

InvisibleButton.MouseButton1Click:Connect(function()

    InvisibleEnabled =
        not InvisibleEnabled

    if InvisibleEnabled then

        InvisibleButton.Text =
            "INVISIBLE • ON"

        InvisibleButton.TextColor3 =
            Theme.Green

        InvisibleStroke.Color =
            Theme.Green

    else

        InvisibleButton.Text =
            "INVISIBLE"

        InvisibleButton.TextColor3 =
            Theme.Muted

        InvisibleStroke.Color =
            Theme.Purple

    end

end)

--==================================================
-- ABRIR / CERRAR
--==================================================

local Open = false

OpenButton.MouseButton1Click:Connect(function()

    Open = not Open

    Main.Visible = Open

end)

--==================================================
-- ARRASTRAR MENÚ
--==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true

        dragStart =
            input.Position

        startPosition =
            Main.Position

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and input.UserInputType ~=
        Enum.UserInputType.Touch then

        return
    end

    local delta =
        input.Position - dragStart

    Main.Position =
        UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,

            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = false

    end

end)

--==================================================
-- PÁGINA INICIAL
--==================================================

Pages["ESP"].BackgroundTransparency = 0

ClearContent()
ESPPage()

print("VioletCore B4 cargado | José FX")
