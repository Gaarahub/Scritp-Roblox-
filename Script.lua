--[[
    VIOLET CORE - B6
    José FX
    UI Base / Sistema modular
    Para tu propio juego de Roblox
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURACIÓN
--==================================================

local CONFIG = {
    Name = "Violet Core",
    Version = "B6",

    Background = Color3.fromRGB(10, 10, 12),
    Panel = Color3.fromRGB(17, 17, 20),
    Panel2 = Color3.fromRGB(23, 23, 27),
    Hover = Color3.fromRGB(32, 32, 38),
    Selected = Color3.fromRGB(38, 38, 44),

    Text = Color3.fromRGB(235, 235, 240),
    SubText = Color3.fromRGB(145, 145, 155),

    Accent = Color3.fromRGB(155, 155, 165),
    Green = Color3.fromRGB(70, 200, 105),
    Red = Color3.fromRGB(220, 70, 70),

    Transparency = 0.08
}

local function tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

local function corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 6)
    c.Parent = object
end

local function stroke(object, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.new(1,1,1)
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = object
    return s
end

--==================================================
-- LIMPIAR VERSION ANTERIOR
--==================================================

local old = PlayerGui:FindFirstChild("VioletCore_B6")
if old then
    old:Destroy()
end

--==================================================
-- SCREEN GUI
--==================================================

local Screen = Instance.new("ScreenGui")
Screen.Name = "VioletCore_B6"
Screen.ResetOnSpawn = false
Screen.IgnoreGuiInset = true
Screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Screen.Parent = PlayerGui

--==================================================
-- BOTÓN PRINCIPAL
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(42, 42)
OpenButton.Position = UDim2.new(0, 18, 0, 65)
OpenButton.BackgroundColor3 = CONFIG.Panel
OpenButton.BackgroundTransparency = 0.05
OpenButton.BorderSizePixel = 0
OpenButton.Text = "V"
OpenButton.TextColor3 = CONFIG.Text
OpenButton.TextSize = 18
OpenButton.Font = Enum.Font.GothamBold
OpenButton.AutoButtonColor = false
OpenButton.Parent = Screen

corner(OpenButton, 9)
stroke(OpenButton, Color3.fromRGB(65,65,70), 1)

-- El botón puede moverse
do
    local dragging = false
    local dragStart
    local startPosition

    OpenButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = OpenButton.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            OpenButton.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--==================================================
-- VENTANA PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(600, 370)
Main.Position = UDim2.new(0.5, -300, 0.5, -185)
Main.BackgroundColor3 = CONFIG.Background
Main.BackgroundTransparency = CONFIG.Transparency
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = Screen

corner(Main, 10)
stroke(Main, Color3.fromRGB(50,50,55), 1)

--==================================================
-- BARRA SUPERIOR
--==================================================

local Top = Instance.new("Frame")
Top.Name = "TopBar"
Top.Size = UDim2.new(1, 0, 0, 42)
Top.BackgroundColor3 = CONFIG.Panel
Top.BackgroundTransparency = 0.03
Top.BorderSizePixel = 0
Top.Parent = Main

corner(Top, 10)

local TopFill = Instance.new("Frame")
TopFill.Size = UDim2.new(1,0,0,10)
TopFill.Position = UDim2.new(0,0,1,-10)
TopFill.BackgroundColor3 = CONFIG.Panel
TopFill.BorderSizePixel = 0
TopFill.Parent = Top

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-150,1,0)
Title.Position = UDim2.fromOffset(15,0)
Title.BackgroundTransparency = 1
Title.Text = CONFIG.Name
Title.TextColor3 = CONFIG.Text
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Top

local Version = Instance.new("TextLabel")
Version.Size = UDim2.fromOffset(60,20)
Version.Position = UDim2.new(1,-145,0.5,-10)
Version.BackgroundTransparency = 1
Version.Text = CONFIG.Version
Version.TextColor3 = CONFIG.SubText
Version.TextSize = 10
Version.Font = Enum.Font.GothamMedium
Version.Parent = Top

--==================================================
-- CONTROLES SUPERIORES
--==================================================

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(30,30)
Minimize.Position = UDim2.new(1,-105,0.5,-15)
Minimize.BackgroundTransparency = 1
Minimize.Text = "−"
Minimize.TextColor3 = CONFIG.SubText
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamMedium
Minimize.AutoButtonColor = false
Minimize.Parent = Top

local Resize = Instance.new("TextButton")
Resize.Size = UDim2.fromOffset(30,30)
Resize.Position = UDim2.new(1,-72,0.5,-15)
Resize.BackgroundTransparency = 1
Resize.Text = "↗"
Resize.TextColor3 = CONFIG.SubText
Resize.TextSize = 14
Resize.Font = Enum.Font.GothamMedium
Resize.AutoButtonColor = false
Resize.Parent = Top

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30,30)
Close.Position = UDim2.new(1,-38,0.5,-15)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = CONFIG.SubText
Close.TextSize = 18
Close.Font = Enum.Font.GothamMedium
Close.AutoButtonColor = false
Close.Parent = Top

--==================================================
-- DRAG DEL MENÚ
--==================================================

do
    local dragging = false
    local dragStart
    local startPosition

    Top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            Main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--==================================================
-- CONTENEDOR
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1,-16,1,-52)
Content.Position = UDim2.fromOffset(8,48)
Content.BackgroundTransparency = 1
Content.Parent = Main

--==================================================
-- PANEL IZQUIERDO
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0,170,1,0)
Sidebar.BackgroundColor3 = CONFIG.Panel
Sidebar.BackgroundTransparency = 0.03
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Content

corner(Sidebar, 8)
stroke(Sidebar, Color3.fromRGB(40,40,45), 1)

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1,-16,0,32)
Search.Position = UDim2.fromOffset(8,8)
Search.BackgroundColor3 = CONFIG.Panel2
Search.BorderSizePixel = 0
Search.PlaceholderText = "Buscar..."
Search.PlaceholderColor3 = CONFIG.SubText
Search.Text = ""
Search.TextColor3 = CONFIG.Text
Search.TextSize = 11
Search.Font = Enum.Font.GothamMedium
Search.ClearTextOnFocus = false
Search.Parent = Sidebar

corner(Search, 6)

local CategoryScroll = Instance.new("ScrollingFrame")
CategoryScroll.Name = "Categories"
CategoryScroll.Size = UDim2.new(1,-8,1,-50)
CategoryScroll.Position = UDim2.fromOffset(4,46)
CategoryScroll.BackgroundTransparency = 1
CategoryScroll.BorderSizePixel = 0
CategoryScroll.ScrollBarThickness = 2
CategoryScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,85)
CategoryScroll.CanvasSize = UDim2.new(0,0,0,0)
CategoryScroll.Parent = Sidebar

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.Padding = UDim.new(0,3)
CategoryLayout.Parent = CategoryScroll

--==================================================
-- PANEL DERECHO
--==================================================

local OptionsPanel = Instance.new("Frame")
OptionsPanel.Name = "Options"
OptionsPanel.Size = UDim2.new(1,-180,1,0)
OptionsPanel.Position = UDim2.fromOffset(180,0)
OptionsPanel.BackgroundColor3 = CONFIG.Panel2
OptionsPanel.BackgroundTransparency = 0.08
OptionsPanel.BorderSizePixel = 0
OptionsPanel.Parent = Content

corner(OptionsPanel, 8)
stroke(OptionsPanel, Color3.fromRGB(42,42,47), 1)

local CategoryTitle = Instance.new("TextLabel")
CategoryTitle.Size = UDim2.new(1,-20,0,32)
CategoryTitle.Position = UDim2.fromOffset(10,5)
CategoryTitle.BackgroundTransparency = 1
CategoryTitle.Text = "Combat"
CategoryTitle.TextColor3 = CONFIG.Text
CategoryTitle.TextSize = 13
CategoryTitle.Font = Enum.Font.GothamBold
CategoryTitle.TextXAlignment = Enum.TextXAlignment.Left
CategoryTitle.Parent = OptionsPanel

local OptionsScroll = Instance.new("ScrollingFrame")
OptionsScroll.Name = "OptionsScroll"
OptionsScroll.Size = UDim2.new(1,-10,1,-45)
OptionsScroll.Position = UDim2.fromOffset(5,40)
OptionsScroll.BackgroundTransparency = 1
OptionsScroll.BorderSizePixel = 0
OptionsScroll.ScrollBarThickness = 2
OptionsScroll.ScrollBarImageColor3 = Color3.fromRGB(90,90,95)
OptionsScroll.CanvasSize = UDim2.new(0,0,0,0)
OptionsScroll.Parent = OptionsPanel

local OptionsLayout = Instance.new("UIListLayout")
OptionsLayout.Padding = UDim.new(0,5)
OptionsLayout.Parent = OptionsScroll

--==================================================
-- CATEGORÍAS
--==================================================

local Categories = {
    {"◉", "ESP"},
    {"⚔", "Combat"},
    {"◈", "Auto Farm"},
    {"↔", "Movimiento"},
    {"♟", "Animaciones"},
    {"⚡", "Performance"},
    {"▣", "Configuración"},
    {"ⓘ", "Información"}
}

local CurrentCategory = nil

local function clearOptions()
    for _, child in ipairs(OptionsScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

--==================================================
-- SWITCH
--==================================================

local function createSwitch(parent, name, callback)

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-6,0,42)
    Row.BackgroundColor3 = CONFIG.Panel
    Row.BorderSizePixel = 0
    Row.Parent = parent

    corner(Row, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-70,1,0)
    Label.Position = UDim2.fromOffset(10,0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = CONFIG.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.fromOffset(42,22)
    Switch.Position = UDim2.new(1,-52,0.5,-11)
    Switch.BackgroundColor3 = Color3.fromRGB(55,55,60)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = Row

    corner(Switch, 11)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.fromOffset(16,16)
    Knob.Position = UDim2.fromOffset(3,3)
    Knob.BackgroundColor3 = Color3.fromRGB(220,220,225)
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    corner(Knob, 8)

    local enabled = false

    Switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        if enabled then
            tween(Switch, {
                BackgroundColor3 = CONFIG.Green
            })

            tween(Knob, {
                Position = UDim2.new(1,-19,0,3)
            })
        else
            tween(Switch, {
                BackgroundColor3 = Color3.fromRGB(55,55,60)
            })

            tween(Knob, {
                Position = UDim2.fromOffset(3,3)
            })
        end

        if callback then
            callback(enabled)
        end
    end)

    return Row
end

--==================================================
-- SLIDER
--==================================================

local function createSlider(parent, name, min, max, default, callback)

    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1,-6,0,58)
    Row.BackgroundColor3 = CONFIG.Panel
    Row.BorderSizePixel = 0
    Row.Parent = parent

    corner(Row, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-70,0,24)
    Label.Position = UDim2.fromOffset(10,3)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = CONFIG.Text
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.fromOffset(55,20)
    Value.Position = UDim2.new(1,-65,0,3)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(default)
    Value.TextColor3 = CONFIG.SubText
    Value.TextSize = 10
    Value.Font = Enum.Font.GothamMedium
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Row

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1,-20,0,5)
    Bar.Position = UDim2.fromOffset(10,38)
    Bar.BackgroundColor3 = Color3.fromRGB(55,55,60)
    Bar.BorderSizePixel = 0
    Bar.Parent = Row

    corner(Bar, 4)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(
        math.clamp((default-min)/(max-min),0,1),
        0,1,0
    )
    Fill.BackgroundColor3 = CONFIG.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    corner(Fill, 4)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,1,10)
    Button.Position = UDim2.fromOffset(0,-5)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Bar

    local function update(inputX)
        local alpha = math.clamp(
            (inputX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
            0,1
        )

        local value = math.floor(
            min + ((max-min) * alpha)
        )

        Fill.Size = UDim2.new(alpha,0,1,0)
        Value.Text = tostring(value)

        if callback then
            callback(value)
        end
    end

    Button.MouseButton1Down:Connect(function(x)
        update(x)
    end)

    Button.MouseButton1Click:Connect(function(x)
        update(x)
    end)

    return Row
end

--==================================================
-- CONTENIDO DE CATEGORÍAS
--==================================================

local CategoryData = {

    ["ESP"] = function()

        createSwitch(OptionsScroll, "Ver jugadores", function(enabled)
            -- Conectar al sistema ESP del juego
        end)

        createSwitch(OptionsScroll, "ESP a través de paredes", function(enabled)
            -- Conectar al sistema ESP
        end)

        createSwitch(OptionsScroll, "Líneas hacia jugadores", function(enabled)
            -- Conectar al sistema de líneas
        end)

        createSwitch(OptionsScroll, "Rainbow ESP", function(enabled)
            -- Conectar al sistema Rainbow
        end)

    end,

    ["Combat"] = function()

        createSwitch(OptionsScroll, "Aimbot", function(enabled)
            -- Conectar al sistema de combate del juego
        end)

        createSwitch(OptionsScroll, "Silent Aim", function(enabled)
            -- Conectar al sistema de combate del juego
        end)

        createSwitch(OptionsScroll, "Apuntar a la cabeza", function(enabled)
            -- Selección de objetivo
        end)

        createSwitch(OptionsScroll, "Auto Shoot", function(enabled)
            -- Conectar al sistema de armas
        end)

        createSlider(
            OptionsScroll,
            "Distancia",
            50,
            1000,
            250,
            function(value)
                -- Distancia de objetivo
            end
        )

    end,

    ["Auto Farm"] = function()

        createSwitch(OptionsScroll, "Auto Farm", function(enabled)
            -- Sistema Auto Farm del juego
        end)

        createSwitch(OptionsScroll, "Recoger automáticamente", function(enabled)
            -- Sistema de recogida
        end)

    end,

    ["Movimiento"] = function()

        createSwitch(OptionsScroll, "Infinite Jump", function(enabled)

            -- Preparado para conectar al sistema de movimiento

        end)

        createSwitch(OptionsScroll, "Velocidad personalizada", function(enabled)

            -- Preparado para conectar al sistema de movimiento

        end)

        createSlider(
            OptionsScroll,
            "Velocidad",
            16,
            150,
            16,
            function(value)

                -- Aquí se conecta la velocidad real

            end
        )

        createSlider(
            OptionsScroll,
            "Salto",
            25,
            150,
            50,
            function(value)

                -- Aquí se conecta el salto real

            end
        )

    end,

    ["Animaciones"] = function()

        createSwitch(OptionsScroll, "Invisible", function(enabled)

            -- El botón externo aparece/desaparece
            -- La lógica real de invisibilidad
            -- se conectará al sistema servidor.

        end)

        createSwitch(OptionsScroll, "Animación de correr", function(enabled)
            -- Sistema de animaciones
        end)

        createSwitch(OptionsScroll, "Animación de caminar", function(enabled)
            -- Sistema de animaciones
        end)

        createSwitch(OptionsScroll, "Animación de salto", function(enabled)
            -- Sistema de animaciones
        end)

        createSwitch(OptionsScroll, "Animación de caída", function(enabled)
            -- Sistema de animaciones
        end)

    end,

    ["Performance"] = function()

        createSwitch(OptionsScroll, "Optimizar efectos", function(enabled)
            -- Optimización del juego
        end)

        createSwitch(OptionsScroll, "Reducir partículas", function(enabled)
            -- Optimización
        end)

        createSwitch(OptionsScroll, "Modo rendimiento", function(enabled)
            -- Optimización
        end)

    end,

    ["Configuración"] = function()

        createSwitch(OptionsScroll, "Guardar configuración", function(enabled)
            -- El guardado se hará mediante el botón.
        end)

        createSwitch(OptionsScroll, "Cargar configuración", function(enabled)
            -- Carga manual.
        end)

        createSwitch(OptionsScroll, "Restaurar valores", function(enabled)
            -- Restaurar configuración.
        end)

    end,

    ["Información"] = function()

        createSwitch(OptionsScroll, "José FX", function()
            -- Créditos
        end)

        local Info = Instance.new("TextLabel")
        Info.Size = UDim2.new(1,-15,0,90)
        Info.BackgroundTransparency = 1
        Info.Text =
            "Violet Core\n\n" ..
            "Creado por José FX\n" ..
            "Versión B6\n\n" ..
            "Sistema modular para tu juego."
        Info.TextColor3 = CONFIG.SubText
        Info.TextSize = 11
        Info.Font = Enum.Font.GothamMedium
        Info.TextWrapped = true
        Info.TextXAlignment = Enum.TextXAlignment.Left
        Info.TextYAlignment = Enum.TextYAlignment.Top
        Info.Parent = OptionsScroll

    end
}

--==================================================
-- CREAR CATEGORÍAS
--==================================================

for _, data in ipairs(Categories) do

    local icon = data[1]
    local name = data[2]

    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1,-4,0,35)
    Button.BackgroundColor3 = CONFIG.Panel
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = CategoryScroll

    corner(Button, 6)

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.fromOffset(28,35)
    Icon.Position = UDim2.fromOffset(5,0)
    Icon.BackgroundTransparency = 1
    Icon.Text = icon
    Icon.TextColor3 = CONFIG.SubText
    Icon.TextSize = 14
    Icon.Font = Enum.Font.GothamBold
    Icon.Parent = Button

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,-40,1,0)
    Label.Position = UDim2.fromOffset(38,0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = CONFIG.SubText
    Label.TextSize = 10
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    Button.MouseEnter:Connect(function()
        if CurrentCategory ~= name then
            tween(Button, {BackgroundColor3 = CONFIG.Hover})
        end
    end)

    Button.MouseLeave:Connect(function()
        if CurrentCategory ~= name then
            tween(Button, {BackgroundColor3 = CONFIG.Panel})
        end
    end)

    Button.MouseButton1Click:Connect(function()

        CurrentCategory = name

        for _, categoryButton in ipairs(CategoryScroll:GetChildren()) do
            if categoryButton:IsA("TextButton") then
                tween(categoryButton, {
                    BackgroundColor3 =
                        categoryButton.Name == name
                        and CONFIG.Selected
                        or CONFIG.Panel
                })
            end
        end

        CategoryTitle.Text = name

        clearOptions()

        if CategoryData[name] then
            CategoryData[name]()
        end

        OptionsScroll.CanvasPosition = Vector2.zero
    end)
end

--==================================================
-- CANVAS AUTOMÁTICO
--==================================================

CategoryLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CategoryScroll.CanvasSize = UDim2.new(
        0,0,
        0,
        CategoryLayout.AbsoluteContentSize.Y + 8
    )
end)

OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    OptionsScroll.CanvasSize = UDim2.new(
        0,0,
        0,
        OptionsLayout.AbsoluteContentSize.Y + 8
    )
end)

--==================================================
-- BOTÓN INVISIBLE EXTERNO
--==================================================

local InvisibleButton = Instance.new("TextButton")
InvisibleButton.Name = "InvisibleButton"
InvisibleButton.Size = UDim2.fromOffset(92,34)
InvisibleButton.Position = UDim2.new(1,-105,0.5,-17)
InvisibleButton.BackgroundColor3 = CONFIG.Panel
InvisibleButton.BackgroundTransparency = 0.05
InvisibleButton.BorderSizePixel = 0
InvisibleButton.Text = "Invisible"
InvisibleButton.TextColor3 = CONFIG.SubText
InvisibleButton.TextSize = 10
InvisibleButton.Font = Enum.Font.GothamBold
InvisibleButton.AutoButtonColor = false
InvisibleButton.Visible = false
InvisibleButton.Parent = Screen

corner(InvisibleButton, 7)
stroke(InvisibleButton, Color3.fromRGB(55,55,60), 1)

local invisibleEnabled = false

InvisibleButton.MouseButton1Click:Connect(function()

    invisibleEnabled = not invisibleEnabled

    if invisibleEnabled then

        InvisibleButton.Text = "Invisible • ON"

        tween(InvisibleButton, {
            BackgroundColor3 = CONFIG.Green,
            TextColor3 = Color3.fromRGB(10,10,10)
        })

        -- Aquí se conecta la invisibilidad real
        -- mediante el sistema servidor de tu juego.

    else

        InvisibleButton.Text = "Invisible"

        tween(InvisibleButton, {
            BackgroundColor3 = CONFIG.Panel,
            TextColor3 = CONFIG.SubText
        })

        -- Restaurar apariencia del personaje.

    end
end)

--==================================================
-- CONTROL DEL BOTÓN INVISIBLE DESDE ANIMACIONES
--==================================================

local function SetInvisibleButtonVisible(value)
    InvisibleButton.Visible = value

    if not value then
        invisibleEnabled = false

        InvisibleButton.Text = "Invisible"

        InvisibleButton.BackgroundColor3 = CONFIG.Panel
        InvisibleButton.TextColor3 = CONFIG.SubText
    end
end

--==================================================
-- MINIMIZAR
--==================================================

local minimized = false

Minimize.MouseButton1Click:Connect(function()

    minimized = not minimized

    if minimized then

        Content.Visible = false

        tween(Main, {
            Size = UDim2.fromOffset(600,42)
        }, 0.2)

    else

        Content.Visible = true

        tween(Main, {
            Size = UDim2.fromOffset(600,370)
        }, 0.2)

    end
end)

--==================================================
-- CERRAR
--==================================================

Close.MouseButton1Click:Connect(function()

    Main.Visible = false

    OpenButton.Visible = true

end)

OpenButton.MouseButton1Click:Connect(function()

    Main.Visible = not Main.Visible

end)

--==================================================
-- REDIMENSIONAR
--==================================================

local large = false

Resize.MouseButton1Click:Connect(function()

    large = not large

    if large then
        tween(Main, {
            Size = UDim2.fromOffset(700,430)
        }, 0.2)
    else
        tween(Main, {
            Size = UDim2.fromOffset(600,370)
        }, 0.2)
    end
end)

--==================================================
-- HOVER CONTROLES
--==================================================

for _, button in ipairs({Minimize, Resize, Close}) do

    button.MouseEnter:Connect(function()
        tween(button, {
            TextColor3 = CONFIG.Text
        })
    end)

    button.MouseLeave:Connect(function()
        tween(button, {
            TextColor3 = CONFIG.SubText
        })
    end)

end

--==================================================
-- INICIALIZAR
--==================================================

OpenButton.Visible = false
Main.Visible = true

-- Abrir Combat inicialmente
CategoryTitle.Text = "Combat"

if CategoryData["Combat"] then
    CategoryData["Combat"]()
end

CurrentCategory = "Combat"

for _, child in ipairs(CategoryScroll:GetChildren()) do
    if child:IsA("TextButton") and child.Name == "Combat" then
        child.BackgroundColor3 = CONFIG.Selected
    end
end

print("Violet Core " .. CONFIG.Version .. " cargado correctamente.")
