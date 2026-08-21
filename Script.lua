--[[
    JOSE FX HUB
    V5
    Roblox Studio - versión para tu propia experiencia

    Estructura:
    ESP
    Combat
    Auto Farm
    Movimiento
    Animaciones
    Performance
    Configuración
    Información
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--==================================================
-- CONFIGURACIÓN
--==================================================

local CONFIG = {
    Speed = 16,
    FOV = 70,

    ESP = false,
    Hitbox = false,

    InfiniteJump = false,
    SpeedEnabled = false,
    FOVEnabled = false,

    Invisible = false,

    Saved = false
}

local ESPObjects = {}

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JoseFX_V5"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--==================================================
-- FUNCIONES VISUALES
--==================================================

local function Corner(object, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = object
end

local function Stroke(object, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = 0
    s.Parent = object
end

local function Tween(object, properties, duration)
    TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    ):Play()
end

--==================================================
-- BOTÓN PRINCIPAL
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.new(0, 235, 0, 58)
OpenButton.Position = UDim2.new(0.5, -117, 0, 55)
OpenButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
OpenButton.BackgroundTransparency = 0.05
OpenButton.Text = ""
OpenButton.AutoButtonColor = false
OpenButton.Parent = ScreenGui

Corner(OpenButton, 30)

local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 220))
})
OpenGradient.Rotation = 0
OpenGradient.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Thickness = 2.5
OpenStroke.Color = Color3.fromRGB(100, 160, 255)
OpenStroke.Parent = OpenButton

local OpenInner = Instance.new("Frame")
OpenInner.Size = UDim2.new(1, -6, 1, -6)
OpenInner.Position = UDim2.new(0, 3, 0, 3)
OpenInner.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
OpenInner.Parent = OpenButton
Corner(OpenInner, 27)

local DragIcon = Instance.new("TextLabel")
DragIcon.Size = UDim2.new(0, 50, 1, 0)
DragIcon.BackgroundTransparency = 1
DragIcon.Text = "✣"
DragIcon.TextColor3 = Color3.fromRGB(210, 210, 220)
DragIcon.TextSize = 27
DragIcon.Font = Enum.Font.GothamBold
DragIcon.Parent = OpenInner

local OpenTitle = Instance.new("TextLabel")
OpenTitle.Position = UDim2.new(0, 50, 0, 0)
OpenTitle.Size = UDim2.new(1, -55, 1, 0)
OpenTitle.BackgroundTransparency = 1
OpenTitle.Text = "Jose FX"
OpenTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
OpenTitle.TextSize = 19
OpenTitle.Font = Enum.Font.GothamBold
OpenTitle.Parent = OpenInner

--==================================================
-- MENÚ PRINCIPAL
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 720, 0, 470)
Main.Position = UDim2.new(0.5, -360, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(18, 17, 22)
Main.BackgroundTransparency = 0.08
Main.Visible = false
Main.Parent = ScreenGui

Corner(Main, 16)
Stroke(Main, Color3.fromRGB(90, 75, 130), 1.5)

--==================================================
-- HEADER
--==================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Position = UDim2.new(0, 18, 0, 7)
Title.Size = UDim2.new(0, 300, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Jose FX"
Title.TextColor3 = Color3.fromRGB(245,245,250)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Position = UDim2.new(0, 20, 0, 31)
SubTitle.Size = UDim2.new(0, 250, 0, 18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "V5 • Control Panel"
SubTitle.TextColor3 = Color3.fromRGB(140,140,150)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -48, 0, 8)
Close.BackgroundColor3 = Color3.fromRGB(35, 34, 40)
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(220,220,225)
Close.TextSize = 25
Close.Font = Enum.Font.Gotham
Close.Parent = Header
Corner(Close, 10)

--==================================================
-- SIDEBAR
--==================================================

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.new(0, 10, 0, 62)
Sidebar.Size = UDim2.new(0, 215, 1, -72)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
Sidebar.BackgroundTransparency = 0.15
Sidebar.Parent = Main
Corner(Sidebar, 14)

local Search = Instance.new("TextBox")
Search.Position = UDim2.new(0, 10, 0, 10)
Search.Size = UDim2.new(1, -20, 0, 42)
Search.BackgroundColor3 = Color3.fromRGB(32, 31, 36)
Search.PlaceholderText = "⌕  Search"
Search.PlaceholderColor3 = Color3.fromRGB(125,125,135)
Search.TextColor3 = Color3.fromRGB(240,240,245)
Search.TextSize = 14
Search.Font = Enum.Font.Gotham
Search.ClearTextOnFocus = false
Search.Parent = Sidebar
Corner(Search, 10)

local CategoryHolder = Instance.new("ScrollingFrame")
CategoryHolder.Position = UDim2.new(0, 5, 0, 62)
CategoryHolder.Size = UDim2.new(1, -10, 1, -67)
CategoryHolder.BackgroundTransparency = 1
CategoryHolder.BorderSizePixel = 0
CategoryHolder.ScrollBarThickness = 3
CategoryHolder.CanvasSize = UDim2.new()
CategoryHolder.Parent = Sidebar

local CategoryLayout = Instance.new("UIListLayout")
CategoryLayout.Padding = UDim.new(0, 5)
CategoryLayout.Parent = CategoryHolder

--==================================================
-- CONTENT
--==================================================

local Content = Instance.new("Frame")
Content.Position = UDim2.new(0, 235, 0, 62)
Content.Size = UDim2.new(1, -245, 1, -72)
Content.BackgroundColor3 = Color3.fromRGB(20, 19, 24)
Content.BackgroundTransparency = 0.1
Content.Parent = Main
Corner(Content, 14)

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Position = UDim2.new(0, 12, 0, 12)
ContentScroll.Size = UDim2.new(1, -24, 1, -24)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 4
ContentScroll.CanvasSize = UDim2.new()
ContentScroll.Parent = Content

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentScroll

--==================================================
-- CATEGORÍAS
--==================================================

local Categories = {
    {"◉", "ESP"},
    {"◎", "Combat"},
    {"◌", "Auto Farm"},
    {"✣", "Movimiento"},
    {"♙", "Animaciones"},
    {"◔", "Performance"},
    {"⚙", "Configuración"},
    {"ⓘ", "Información"}
}

local CurrentCategory = nil
local CategoryButtons = {}

--==================================================
-- CONTROLES
--==================================================

local function ClearContent()
    for _, child in ipairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end

local function CreateSection(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(245,245,250)
    label.TextSize = 17
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = ContentScroll
end

local function CreateToggle(name, description, callback, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 65)
    frame.BackgroundColor3 = Color3.fromRGB(35,34,40)
    frame.Parent = ContentScroll
    Corner(frame, 12)

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 15, 0, 8)
    label.Size = UDim2.new(1, -90, 0, 23)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(240,240,245)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    if description then
        local desc = Instance.new("TextLabel")
        desc.Position = UDim2.new(0, 15, 0, 32)
        desc.Size = UDim2.new(1, -90, 0, 20)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = Color3.fromRGB(145,145,155)
        desc.TextSize = 11
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = frame
    end

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 58, 0, 30)
    button.Position = UDim2.new(1, -70, 0.5, -15)
    button.BackgroundColor3 = Color3.fromRGB(65,64,72)
    button.Text = ""
    button.Parent = frame
    Corner(button, 20)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 24, 0, 24)
    knob.Position = UDim2.new(0, 3, 0.5, -12)
    knob.BackgroundColor3 = Color3.fromRGB(245,245,245)
    knob.Parent = button
    Corner(knob, 20)

    local state = default == true

    local function Update()
        if state then
            button.BackgroundColor3 = Color3.fromRGB(35, 205, 105)
            Tween(knob, {
                Position = UDim2.new(1, -27, 0.5, -12)
            }, 0.15)
        else
            button.BackgroundColor3 = Color3.fromRGB(65,64,72)
            Tween(knob, {
                Position = UDim2.new(0, 3, 0.5, -12)
            }, 0.15)
        end

        callback(state)
    end

    button.MouseButton1Click:Connect(function()
        state = not state
        Update()
    end)

    return {
        Frame = frame,
        Get = function()
            return state
        end,
        Set = function(value)
            state = value
            Update()
        end
    }
end

local function CreateSlider(name, minimum, maximum, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(35,34,40)
    frame.Parent = ContentScroll
    Corner(frame, 12)

    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 15, 0, 9)
    label.Size = UDim2.new(0, 150, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(235,235,240)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Position = UDim2.new(1, -65, 0, 9)
    valueLabel.Size = UDim2.new(0, 45, 0, 25)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(190,190,200)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.Text = tostring(default)
    valueLabel.Parent = frame

    local bar = Instance.new("Frame")
    bar.Position = UDim2.new(0, 15, 0, 43)
    bar.Size = UDim2.new(1, -30, 0, 5)
    bar.BackgroundColor3 = Color3.fromRGB(55,54,62)
    bar.Parent = frame
    Corner(bar, 5)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(
        (default - minimum) / (maximum - minimum),
        0,
        1,
        0
    )
    fill.BackgroundColor3 = Color3.fromRGB(125,85,255)
    fill.Parent = bar
    Corner(fill, 5)

    local dragging = false

    local function SetValue(value)
        value = math.clamp(value, minimum, maximum)
        value = math.floor(value)

        local percent = (value - minimum) / (maximum - minimum)

        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(value)

        callback(value)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true

            local percent =
                math.clamp(
                    (input.Position.X - bar.AbsolutePosition.X) /
                    bar.AbsoluteSize.X,
                    0,
                    1
                )

            SetValue(minimum + (maximum - minimum) * percent)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then

            local percent =
                math.clamp(
                    (input.Position.X - bar.AbsolutePosition.X) /
                    bar.AbsoluteSize.X,
                    0,
                    1
                )

            SetValue(minimum + (maximum - minimum) * percent)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return frame
end

--==================================================
-- ESP
--==================================================

local function RemoveESP()
    for player, highlight in pairs(ESPObjects) do
        if highlight then
            highlight:Destroy()
        end
        ESPObjects[player] = nil
    end
end

local function ApplyESP()
    RemoveESP()

    if not CONFIG.ESP then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "JoseFX_ESP"
            highlight.FillColor = Color3.fromRGB(255, 60, 60)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.65
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = player.Character

            ESPObjects[player] = highlight
        end
    end
end

Players.PlayerAdded:Connect(function()
    task.wait(1)
    ApplyESP()
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        ESPObjects[player]:Destroy()
        ESPObjects[player] = nil
    end
end)

--==================================================
-- MOVIMIENTO
--==================================================

local function UpdateMovement()
    local character = Player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if CONFIG.SpeedEnabled then
        humanoid.WalkSpeed = CONFIG.Speed
    else
        humanoid.WalkSpeed = 16
    end
end

Player.CharacterAdded:Connect(function()
    task.wait(1)
    UpdateMovement()
end)

UserInputService.JumpRequest:Connect(function()
    if CONFIG.InfiniteJump then
        local character = Player.Character
        if not character then return end

        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

--==================================================
-- FOV
--==================================================

local function UpdateFOV()
    if CONFIG.FOVEnabled then
        Camera.FieldOfView = CONFIG.FOV
    else
        Camera.FieldOfView = 70
    end
end

--==================================================
-- INVISIBLE LOCAL
--==================================================

local function SetLocalInvisible(enabled)
    local character = Player.Character
    if not character then return end

    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart") then

            if enabled then
                object.LocalTransparencyModifier = 0.65
            else
                object.LocalTransparencyModifier = 0
            end

        elseif object:IsA("Decal") then

            if enabled then
                object.Transparency = 0.65
            else
                object.Transparency = 0
            end
        end
    end
end

--==================================================
-- CONTENIDO DE CATEGORÍAS
--==================================================

local function ShowESP()
    ClearContent()

    CreateSection("ESP")

    CreateToggle(
        "Activar ESP",
        "Muestra jugadores a través de obstáculos.",
        function(value)
            CONFIG.ESP = value
            ApplyESP()
        end,
        CONFIG.ESP
    )

    CreateSlider(
        "Distancia ESP",
        50,
        1000,
        250,
        function(value)
            -- Preparado para conectar la distancia máxima del ESP.
        end
    )

    CreateSection("Hitbox")

    CreateToggle(
        "Activar Hitbox",
        "Control de hitbox para tu propia experiencia.",
        function(value)
            CONFIG.Hitbox = value
        end,
        CONFIG.Hitbox
    )

    CreateSlider(
        "Tamaño Hitbox",
        5,
        30,
        15,
        function(value)
            -- Preparado para la lógica server-side de tu juego.
        end
    )
end

local function ShowCombat()
    ClearContent()

    CreateSection("Combat")

    CreateToggle(
        "Aimbot",
        "Apunta al objetivo seleccionado de tu propia experiencia.",
        function(value)
            -- Aquí irá la lógica de combate de tu juego.
        end,
        false
    )

    CreateToggle(
        "Silent Aim",
        "Sistema de apuntado controlado por tu experiencia.",
        function(value)
            -- Preparado para la lógica server-side.
        end,
        false
    )

    CreateToggle(
        "Auto Shoot",
        "Disparo automático para tu sistema de combate.",
        function(value)
            -- Preparado para conectar con tu arma.
        end,
        false
    )

    CreateToggle(
        "Apuntar a Cabeza",
        "Selecciona Head como objetivo.",
        function(value)
        end,
        false
    )

    CreateSlider(
        "FOV de Aimbot",
        10,
        180,
        70,
        function(value)
        end
    )
end

local function ShowAutoFarm()
    ClearContent()

    CreateSection("Auto Farm")

    CreateToggle(
        "Auto Farm",
        "Sistema de automatización de tu propia experiencia.",
        function(value)
        end,
        false
    )

    CreateToggle(
        "Auto Collect",
        "Recoge objetos permitidos por tu juego.",
        function(value)
        end,
        false
    )
end

local function ShowMovement()
    ClearContent()

    CreateSection("Player")

    CreateToggle(
        "Activar Speed",
        "Modifica la velocidad del jugador.",
        function(value)
            CONFIG.SpeedEnabled = value
            UpdateMovement()
        end,
        CONFIG.SpeedEnabled
    )

    CreateSlider(
        "Speed Slider",
        16,
        120,
        CONFIG.Speed,
        function(value)
            CONFIG.Speed = value
            UpdateMovement()
        end
    )

    CreateToggle(
        "Salto Infinito",
        "Permite volver a saltar en el aire.",
        function(value)
            CONFIG.InfiniteJump = value
        end,
        CONFIG.InfiniteJump
    )

    CreateToggle(
        "Activar FOV",
        "Modifica el campo de visión.",
        function(value)
            CONFIG.FOVEnabled = value
            UpdateFOV()
        end,
        CONFIG.FOVEnabled
    )

    CreateSlider(
        "Valor FOV",
        40,
        120,
        CONFIG.FOV,
        function(value)
            CONFIG.FOV = value
            UpdateFOV()
        end
    )
end

local function ShowAnimations()
    ClearContent()

    CreateSection("Animaciones")

    local animations = {
        "Zombie",
        "Fantasma",
        "Robot",
        "Gangster",
        "Dab",
        "Dance",
        "Idle"
    }

    for _, animationName in ipairs(animations) do
        CreateToggle(
            animationName,
            "Animación preparada para conectar con el AnimationId de tu juego.",
            function(value)
                -- Aquí se conectará el AnimationId correspondiente.
            end,
            false
        )
    end

    CreateSection("Invisible")

    CreateToggle(
        "Invisible",
        "Tú lo ves semitransparente.",
        function(value)
            CONFIG.Invisible = value
            SetLocalInvisible(value)
        end,
        CONFIG.Invisible
    )
end

local function ShowPerformance()
    ClearContent()

    CreateSection("Performance")

    CreateToggle(
        "Optimización",
        "Reduce efectos visuales locales.",
        function(value)
            if value then
                Lighting.GlobalShadows = false
            else
                Lighting.GlobalShadows = true
            end
        end,
        false
    )

    CreateToggle(
        "Low Graphics",
        "Modo visual ligero.",
        function(value)
            -- Preparado para el sistema gráfico de tu experiencia.
        end,
        false
    )
end

local function ShowSettings()
    ClearContent()

    CreateSection("Configuración")

    CreateToggle(
        "Guardar configuración",
        "Solo guarda cuando pulsas el botón.",
        function(value)
            -- El toggle visual no guarda automáticamente.
        end,
        false
    )

    local save = Instance.new("TextButton")
    save.Size = UDim2.new(1, -5, 0, 55)
    save.BackgroundColor3 = Color3.fromRGB(90,65,160)
    save.Text = "Guardar configuración"
    save.TextColor3 = Color3.fromRGB(255,255,255)
    save.TextSize = 15
    save.Font = Enum.Font.GothamBold
    save.Parent = ContentScroll
    Corner(save, 12)

    save.MouseButton1Click:Connect(function()
        CONFIG.Saved = true

        save.Text = "✓ Configuración guardada"

        task.delay(1.5, function()
            if save and save.Parent then
                save.Text = "Guardar configuración"
            end
        end)
    end)

    CreateSection("Interfaz")

    CreateToggle(
        "Mostrar botón Invisible",
        "Muestra u oculta el botón lateral.",
        function(value)
            InvisibleButton.Visible = value
        end,
        true
    )
end

local function ShowInformation()
    ClearContent()

    CreateSection("Información")

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -5, 0, 160)
    info.BackgroundColor3 = Color3.fromRGB(35,34,40)
    info.TextColor3 = Color3.fromRGB(225,225,230)
    info.TextSize = 14
    info.Font = Enum.Font.Gotham
    info.TextWrapped = true
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Text = [[
Jose FX

Versión: V5

Creado para la propia experiencia.

Créditos:
José

Discord:
AÑADE-AQUÍ-TU-DISCORD

Sistema de interfaz:
Jose FX UI
]]
    info.Parent = ContentScroll
    Corner(info, 12)
end

local CategoryFunctions = {
    ["ESP"] = ShowESP,
    ["Combat"] = ShowCombat,
    ["Auto Farm"] = ShowAutoFarm,
    ["Movimiento"] = ShowMovement,
    ["Animaciones"] = ShowAnimations,
    ["Performance"] = ShowPerformance,
    ["Configuración"] = ShowSettings,
    ["Información"] = ShowInformation
}

--==================================================
-- CREAR CATEGORÍAS
--==================================================

for _, data in ipairs(Categories) do

    local icon = data[1]
    local name = data[2]

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -5, 0, 43)
    button.BackgroundColor3 = Color3.fromRGB(25,24,29)
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = CategoryHolder
    Corner(button, 10)

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Position = UDim2.new(0, 12, 0, 0)
    iconLabel.Size = UDim2.new(0, 30, 1, 0)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = icon
    iconLabel.TextColor3 = Color3.fromRGB(160,160,170)
    iconLabel.TextSize = 18
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Parent = button

    local textLabel = Instance.new("TextLabel")
    textLabel.Position = UDim2.new(0, 45, 0, 0)
    textLabel.Size = UDim2.new(1, -50, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(220,220,225)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = button

    CategoryButtons[name] = button

    button.MouseButton1Click:Connect(function()

        for _, other in pairs(CategoryButtons) do
            other.BackgroundColor3 = Color3.fromRGB(25,24,29)
        end

        button.BackgroundColor3 = Color3.fromRGB(45,40,55)

        CurrentCategory = name

        local func = CategoryFunctions[name]

        if func then
            func()
        end
    end)
end

CategoryHolder.CanvasSize = UDim2.new(
    0,
    0,
    0,
    CategoryLayout.AbsoluteContentSize.Y + 10
)

--==================================================
-- BOTÓN INVISIBLE FIJO
--==================================================

InvisibleButton = Instance.new("TextButton")
InvisibleButton.Name = "InvisibleButton"
InvisibleButton.Size = UDim2.new(0, 185, 0, 58)
InvisibleButton.Position = UDim2.new(1, -205, 0.5, -29)
InvisibleButton.BackgroundColor3 = Color3.fromRGB(45,43,48)
InvisibleButton.Text = "INVISIBLE"
InvisibleButton.TextColor3 = Color3.fromRGB(170,170,180)
InvisibleButton.TextSize = 16
InvisibleButton.Font = Enum.Font.GothamBold
InvisibleButton.AutoButtonColor = false
InvisibleButton.Parent = ScreenGui
Corner(InvisibleButton, 15)

local InvisibleStroke = Instance.new("UIStroke")
InvisibleStroke.Color = Color3.fromRGB(100,90,110)
InvisibleStroke.Thickness = 2
InvisibleStroke.Parent = InvisibleButton

local invisibleState = false

local function UpdateInvisibleButton()
    if invisibleState then
        InvisibleButton.Text = "ACTIVE"
        InvisibleButton.TextColor3 = Color3.fromRGB(35,255,125)
        InvisibleButton.BackgroundColor3 = Color3.fromRGB(45,48,45)
        InvisibleStroke.Color = Color3.fromRGB(30,255,120)
    else
        InvisibleButton.Text = "INVISIBLE"
        InvisibleButton.TextColor3 = Color3.fromRGB(170,170,180)
        InvisibleButton.BackgroundColor3 = Color3.fromRGB(45,43,48)
        InvisibleStroke.Color = Color3.fromRGB(100,90,110)
    end
end

InvisibleButton.MouseButton1Click:Connect(function()
    invisibleState = not invisibleState
    CONFIG.Invisible = invisibleState

    UpdateInvisibleButton()
    SetLocalInvisible(invisibleState)

    -- IMPORTANTE:
    -- Para que otros jugadores también dejen de verte,
    -- aquí se debe llamar a un RemoteEvent del servidor.
end)

--==================================================
-- ABRIR / CERRAR MENÚ
--==================================================

OpenButton.MouseButton1Click:Connect(function()

    Main.Visible = not Main.Visible

    if Main.Visible then
        OpenButton.BackgroundTransparency = 0
    else
        OpenButton.BackgroundTransparency = 0.05
    end
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
end)

--==================================================
-- ARRASTRAR BOTÓN PRINCIPAL
--==================================================

local draggingButton = false
local dragStart
local startPosition

OpenButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        draggingButton = true
        dragStart = input.Position
        startPosition = OpenButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not draggingButton then return end

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

        draggingButton = false
    end
end)

--==================================================
-- ACTUALIZACIÓN CONTINUA
--==================================================

RunService.RenderStepped:Connect(function()

    if CONFIG.SpeedEnabled then
        UpdateMovement()
    end

    if CONFIG.FOVEnabled then
        UpdateFOV()
    end
end)

--==================================================
-- INICIO
--==================================================

ShowESP()
CategoryButtons["ESP"].BackgroundColor3 = Color3.fromRGB(45,40,55)

print("Jose FX V5 cargado correctamente.")
