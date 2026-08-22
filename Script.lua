```lua
--========================================================
-- VIOLET CORE FX
-- Created by José FX
-- Optimized / reorganized version
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

local Old = PlayerGui:FindFirstChild("VioletCore_FX")

if Old then
    Old:Destroy()
end

--========================================================
-- COLORS
--========================================================

local Colors = {
    Background = Color3.fromRGB(12, 12, 15),
    Panel = Color3.fromRGB(18, 18, 22),
    Panel2 = Color3.fromRGB(27, 27, 32),
    Panel3 = Color3.fromRGB(32, 32, 38),

    Border = Color3.fromRGB(48, 48, 56),

    Text = Color3.fromRGB(242, 242, 247),
    SubText = Color3.fromRGB(150, 150, 160),

    Accent = Color3.fromRGB(145, 85, 255),
    AccentDark = Color3.fromRGB(82, 48, 150),

    On = Color3.fromRGB(55, 200, 112),
    Off = Color3.fromRGB(66, 66, 75),

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

--========================================================
-- CONNECTION STORAGE
--========================================================

local Connections = {}

local ESPObjects = {}

local CurrentAnimationTrack = nil

local DEFAULT_SPEED = 16
local CUSTOM_SPEED = 32

local DEFAULT_JUMP = 50
local CUSTOM_JUMP = 75

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

--========================================================
-- CLOSEST TARGET
--========================================================

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
                        (
                            Vector2.new(
                                ScreenPosition.X,
                                ScreenPosition.Y
                            )
                            - MousePosition
                        ).Magnitude

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

local function UpdateAimbot()
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
end

Connections.Aimbot = RunService.RenderStepped:Connect(UpdateAimbot)

--========================================================
-- MOVEMENT
--========================================================

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

Connections.InfiniteJump =
    UserInputService.JumpRequest:Connect(function()

        if not State.InfiniteJump then
            return
        end

        local Humanoid = GetHumanoid()

        if Humanoid then
            Humanoid:ChangeState(
                Enum.HumanoidStateType.Jumping
            )
        end
    end)

--========================================================
-- ANIMATIONS
--========================================================
-- Put YOUR animation IDs here.
-- The menu itself does not invent animation IDs.

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
        warn(
            "[Violet Core FX] Missing animation ID:",
            Name
        )
        return
    end

    local Humanoid = GetHumanoid()

    if not Humanoid then
        return
    end

    local Animator =
        Humanoid:FindFirstChildOfClass("Animator")

    if not Animator then
        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    StopCurrentAnimation()

    local Animation = Instance.new("Animation")

    Animation.AnimationId =
        "rbxassetid://" .. tostring(Id)

    local Success, Track =
        pcall(function()
            return Animator:LoadAnimation(Animation)
        end)

    Animation:Destroy()

    if not Success or not Track then
        warn(
            "[Violet Core FX] Could not load animation:",
            Name
        )
        return
    end

    Track.Priority = Enum.AnimationPriority.Action
    Track:Play()

    CurrentAnimationTrack = Track
end

local function UpdateAnimation(Name, Enabled)

    if Enabled then
        PlayAnimation(Name)
    else
        StopCurrentAnimation()
    end
end

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

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Highlight = Instance.new("Highlight")

    Highlight.Name = "VioletFX_ESP"
    Highlight.Adornee = Character

    Highlight.FillTransparency = 0.65
    Highlight.OutlineTransparency = 0

    Highlight.FillColor = Colors.Accent
    Highlight.OutlineColor = Colors.White

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.Parent = Character

    local Data = {
        Highlight = Highlight
    }

    --====================================================
    -- ESP LINE
    --====================================================

    if State.ESPLines then

        local Attachment0 = Instance.new("Attachment")
        Attachment0.Name = "VioletFX_LineStart"
        Attachment0.Parent = Root

        local Beam = Instance.new("Beam")

        Beam.Name = "VioletFX_Line"
        Beam.Attachment0 = Attachment0
        Beam.FaceCamera = true

        Beam.Width0 = 0.025
        Beam.Width1 = 0.025

        Beam.Transparency =
            NumberSequence.new(0.15)

        Beam.Color =
            ColorSequence.new(Colors.Accent)

        Beam.Parent = Root

        Data.Attachment = Attachment0
        Data.Beam = Beam
    end

    ESPObjects[Player] = Data
end

local function UpdateESP()

    for Player in pairs(ESPObjects) do
        RemoveESP(Player)
    end

    if not State.ESP then
        return
    end

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            CreateESP(Player)
        end
    end
end

--========================================================
-- RAINBOW ESP
--========================================================

Connections.RainbowESP =
    RunService.RenderStepped:Connect(function()

        if not State.ESP
            or not State.ESPRainbow then
            return
        end

        local Hue =
            (os.clock() * 0.15) % 1

        local RainbowColor =
            Color3.fromHSV(Hue, 0.8, 1)

        for _, Data in pairs(ESPObjects) do

            if Data.Highlight then
                Data.Highlight.FillColor =
                    RainbowColor

                Data.Highlight.OutlineColor =
                    RainbowColor
            end

            if Data.Beam then
                Data.Beam.Color =
                    ColorSequence.new(
                        RainbowColor
                    )
            end
        end
    end)

--========================================================
-- TARGET TRACK
--========================================================

Connections.TargetTrack =
    RunService.RenderStepped:Connect(function()

        if not State.ESP
            or not State.ESPTrack then
            return
        end

        for Player, Data in pairs(ESPObjects) do

            local Character = Player.Character
            local Humanoid =
                Character
                and Character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if not Character
                or not Humanoid
                or Humanoid.Health <= 0 then

                RemoveESP(Player)
            elseif not Data.Highlight then
                CreateESP(Player)
            end
        end
    end)

--========================================================
-- PLAYER EVENTS
--========================================================

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

local ConfigName = "VioletCoreFX_Config"

local function GetConfigData()

    return {
        Aimbot = State.Aimbot,
        SilentAim = State.SilentAim,
        AutoShoot = State.AutoShoot,
        LongRange = State.LongRange,

        ESP = State.ESP,
        ESPLines = State.ESPLines,
        ESPRainbow = State.ESPRainbow,
        ESPTrack = State.ESPTrack,

        Speed = State.Speed,
        CustomSpeed = State.CustomSpeed,
        InfiniteJump = State.InfiniteJump,
        CustomJump = State.CustomJump,

        AnimZombie = State.AnimZombie,
        AnimGhost = State.AnimGhost,
        AnimGoat = State.AnimGoat,

        AutoFarm = State.AutoFarm,
        AutoCollect = State.AutoCollect,

        GPS120 = State.GPS120,
        GPS80 = State.GPS80,

        TargetPart = State.TargetPart
    }
end

local function ApplyConfig(Data)

    if type(Data) ~= "table" then
        return false
    end

    for Key, Value in pairs(Data) do

        if State[Key] ~= nil then
            State[Key] = Value
        end
    end

    UpdateSpeed()
    UpdateJump()
    UpdateESP()

    if State.AnimZombie then
        PlayAnimation("Zombie")
    elseif State.AnimGhost then
        PlayAnimation("Ghost")
    elseif State.AnimGoat then
        PlayAnimation("Goat")
    end

    return true
end

--========================================================
-- CONFIG API
--========================================================
-- These functions are intentionally isolated.
-- If your executor/game provides a persistence API,
-- connect it here instead of spreading it through the UI.

local SavedConfig = nil

local function SaveConfig()
    SavedConfig = GetConfigData()
    return true
end

local function LoadConfig()
    if not SavedConfig then
        return false
    end

    return ApplyConfig(SavedConfig)
end

local function ResetConfig()

    for Key, Value in pairs(State) do

        if typeof(Value) == "boolean" then
            State[Key] = false
        end
    end

    State.TargetPart = "Head"

    StopCurrentAnimation()
    UpdateSpeed()
    UpdateJump()
    UpdateESP()

    return true
end

--========================================================
-- ACTION ROUTER
--========================================================

local function ApplyOption(Key)

    if Key == "Speed"
        or Key == "CustomSpeed" then

        UpdateSpeed()
        return
    end

    if Key == "CustomJump"
        or Key == "InfiniteJump" then

        UpdateJump()
        return
    end

    if Key == "ESP"
        or Key == "ESPLines"
        or Key == "ESPRainbow"
        or Key == "ESPTrack" then

        UpdateESP()
        return
    end

    if Key == "AnimZombie" then
        UpdateAnimation(
            "Zombie",
            State.AnimZombie
        )
        return
    end

    if Key == "AnimGhost" then
        UpdateAnimation(
            "Ghost",
            State.AnimGhost
        )
        return
    end

    if Key == "AnimGoat" then
        UpdateAnimation(
            "Goat",
            State.AnimGoat
        )
        return
    end

    if Key == "SaveConfig" then
        SaveConfig()
        return
    end

    if Key == "LoadConfig" then
        LoadConfig()
        return
    end

    if Key == "ResetConfig" then
        ResetConfig()
        return
    end

    -- Combat options that require the game's
    -- own weapon/remotes are deliberately kept
    -- isolated here instead of pretending to work.
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "VioletCore_FX"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--========================================================
-- FX OPEN BUTTON
--========================================================

local OpenButton = Instance.new("TextButton")

OpenButton.Name = "FXButton"

OpenButton.Size =
    UDim2.fromOffset(52, 52)

OpenButton.Position =
    UDim2.new(1, -72, 0.5, -26)

OpenButton.BackgroundColor3 =
    Colors.Panel

OpenButton.BackgroundTransparency = 0.03

OpenButton.BorderSizePixel = 0

OpenButton.Text = "FX"

OpenButton.TextColor3 =
    Colors.White

OpenButton.TextSize = 15

OpenButton.Font =
    Enum.Font.GothamBold

OpenButton.AutoButtonColor = false

OpenButton.Visible = true

OpenButton.ZIndex = 100

OpenButton.Parent = Gui

local OpenCorner = Instance.new("UICorner")

OpenCorner.CornerRadius =
    UDim.new(0, 15)

OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")

OpenStroke.Color =
    Colors.Accent

OpenStroke.Thickness = 2

OpenStroke.Transparency = 0.05

OpenStroke.Parent = OpenButton

--========================================================
-- MAIN WINDOW
--========================================================

local Window = Instance.new("Frame")

Window.Name = "MainWindow"

Window.Size =
    UDim2.fromOffset(650, 430)

Window.Position =
    UDim2.new(
        0.5,
        -325,
        0.5,
        -215
    )

Window.BackgroundColor3 =
    Colors.Background

Window.BorderSizePixel = 0

Window.Visible = false

Window.ZIndex = 10

Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")

WindowCorner.CornerRadius =
    UDim.new(0, 14)

WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")

WindowStroke.Color =
    Colors.Border

WindowStroke.Thickness = 1

WindowStroke.Parent = Window

--========================================================
-- HEADER
--========================================================

local Header = Instance.new("Frame")

Header.Size =
    UDim2.new(1, 0, 0, 64)

Header.BackgroundColor3 =
    Colors.Panel

Header.BorderSizePixel = 0

Header.ZIndex = 11

Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")

HeaderCorner.CornerRadius =
    UDim.new(0, 14)

HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")

Title.Size =
    UDim2.new(1, -150, 0, 27)

Title.Position =
    UDim2.fromOffset(18, 8)

Title.BackgroundTransparency = 1

Title.Text = "Violet Core"

Title.TextColor3 =
    Colors.Text

Title.TextSize = 18

Title.Font =
    Enum.Font.GothamBold

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.ZIndex = 12

Title.Parent = Header

local Creator = Instance.new("TextLabel")

Creator.Size =
    UDim2.new(1, -150, 0, 15)

Creator.Position =
    UDim2.fromOffset(19, 36)

Creator.BackgroundTransparency = 1

Creator.Text = "José FX"

Creator.TextColor3 =
    Colors.Accent

Creator.TextSize = 9

Creator.Font =
    Enum.Font.GothamMedium

Creator.TextXAlignment =
    Enum.TextXAlignment.Left

Creator.ZIndex = 12

Creator.Parent = Header

--========================================================
-- HEADER BUTTONS
--========================================================

local MinButton = Instance.new("TextButton")

MinButton.Size =
    UDim2.fromOffset(34, 34)

MinButton.Position =
    UDim2.new(1, -78, 0, 15)

MinButton.BackgroundColor3 =
    Colors.Panel2

MinButton.BorderSizePixel = 0

MinButton.Text = "−"

MinButton.TextColor3 =
    Colors.SubText

MinButton.TextSize = 17

MinButton.Font =
    Enum.Font.GothamBold

MinButton.AutoButtonColor = false

MinButton.ZIndex = 12

MinButton.Parent = Header

local MinCorner = Instance.new("UICorner")

MinCorner.CornerRadius =
    UDim.new(0, 9)

MinCorner.Parent = MinButton

local CloseButton = Instance.new("TextButton")

CloseButton.Size =
    UDim2.fromOffset(34, 34)

CloseButton.Position =
    UDim2.new(1, -38, 0, 15)

CloseButton.BackgroundColor3 =
    Colors.Panel2

CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"

CloseButton.TextColor3 =
    Colors.SubText

CloseButton.TextSize = 18

CloseButton.Font =
    Enum.Font.GothamBold

CloseButton.AutoButtonColor = false

CloseButton.ZIndex = 12

CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")

CloseCorner.CornerRadius =
    UDim.new(0, 9)

CloseCorner.Parent = CloseButton

--========================================================
-- CONTENT
--========================================================

local Content = Instance.new("Frame")

Content.Size =
    UDim2.new(1, -14, 1, -72)

Content.Position =
    UDim2.fromOffset(7, 69)

Content.BackgroundTransparency = 1

Content.Parent = Window

--========================================================
-- CATEGORY PANEL
--========================================================

local Categories = Instance.new("ScrollingFrame")

Categories.Size =
    UDim2.fromOffset(190, 1)

Categories.Position =
    UDim2.fromOffset(0, 0)

Categories.BackgroundColor3 =
    Colors.Panel

Categories.BorderSizePixel = 0

Categories.ScrollBarThickness = 3

Categories.ScrollBarImageColor3 =
    Colors.Accent

Categories.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

Categories.CanvasSize =
    UDim2.new()

Categories.ZIndex = 12

Categories.Parent = Content

local CatCorner = Instance.new("UICorner")

CatCorner.CornerRadius =
    UDim.new(0, 10)

CatCorner.Parent = Categories

local CatPadding = Instance.new("UIPadding")

CatPadding.PaddingTop =
    UDim.new(0, 10)

CatPadding.PaddingBottom =
    UDim.new(0, 10)

CatPadding.PaddingLeft =
    UDim.new(0, 7)

CatPadding.PaddingRight =
    UDim.new(0, 7)

CatPadding.Parent = Categories

local CatLayout = Instance.new("UIListLayout")

CatLayout.Padding =
    UDim.new(0, 5)

CatLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

CatLayout.Parent = Categories

--========================================================
-- OPTIONS PANEL
--========================================================

local Options = Instance.new("ScrollingFrame")

Options.Size =
    UDim2.new(1, -197, 1, 0)

Options.Position =
    UDim2.fromOffset(197, 0)

Options.BackgroundColor3 =
    Colors.Panel

Options.BorderSizePixel = 0

Options.ScrollBarThickness = 4

Options.ScrollBarImageColor3 =
    Colors.Accent

Options.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

Options.CanvasSize =
    UDim2.new()

Options.ZIndex = 12

Options.Parent = Content

local OptionsCorner = Instance.new("UICorner")

OptionsCorner.CornerRadius =
    UDim.new(0, 10)

OptionsCorner.Parent = Options

local OptionsPadding = Instance.new("UIPadding")

OptionsPadding.PaddingTop =
    UDim.new(0, 13)

OptionsPadding.PaddingBottom =
    UDim.new(0, 13)

OptionsPadding.PaddingLeft =
    UDim.new(0, 13)

OptionsPadding.PaddingRight =
    UDim.new(0, 13)

OptionsPadding.Parent = Options

local OptionsLayout = Instance.new("UIListLayout")

OptionsLayout.Padding =
    UDim.new(0, 7)

OptionsLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

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
        Icon = "✦",
        Items = {
            {"toggle", "Speed", "Speed"},
            {"toggle", "Custom Speed", "CustomSpeed"},
            {"toggle", "Infinite Jump", "InfiniteJump"},
            {"toggle", "Custom Jump", "CustomJump"}
        }
    },

    {
        Name = "Animations",
        Icon = "♙",
        Items = {
            {"toggle", "Zombie", "AnimZombie"},
            {"toggle", "Ghost", "AnimGhost"},
            {"toggle", "Goat", "AnimGoat"}
        }
    },

    {
        Name = "Autofarm",
        Icon = "◉",
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
            {"toggle", "Save Configuration", "SaveConfig"},
            {"toggle", "Load Configuration", "LoadConfig"},
            {"toggle", "Reset Configuration", "ResetConfig"}
        }
    },

    {
        Name = "Information",
        Icon = "ⓘ",
        Items = {
            {"info", "Created by", "José FX"}
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
-- TOGGLE CREATOR
--========================================================

local function CreateToggle(Name, Key)

    local Row = Instance.new("Frame")

    Row.Size =
        UDim2.new(1, 0, 0, 52)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.ZIndex = 13

    Row.Parent = Options

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent = Row

    local Label = Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1, -75, 1, 0)

    Label.Position =
        UDim2.fromOffset(13, 0)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.Text

    Label.TextSize = 11

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.ZIndex = 14

    Label.Parent = Row

    local Switch = Instance.new("TextButton")

    Switch.Size =
        UDim2.fromOffset(42, 22)

    Switch.Position =
        UDim2.new(
            1,
            -55,
            0.5,
            -11
        )

    Switch.BackgroundColor3 =
        Colors.Off

    Switch.BorderSizePixel = 0

    Switch.Text = ""

    Switch.AutoButtonColor = false

    Switch.ZIndex = 15

    Switch.Parent = Row

    local SwitchCorner = Instance.new("UICorner")

    SwitchCorner.CornerRadius =
        UDim.new(1, 0)

    SwitchCorner.Parent = Switch

    local Knob = Instance.new("Frame")

    Knob.Size =
        UDim2.fromOffset(18, 18)

    Knob.Position =
        UDim2.fromOffset(2, 2)

    Knob.BackgroundColor3 =
        Colors.White

    Knob.BorderSizePixel = 0

    Knob.ZIndex = 16

    Knob.Parent = Switch

    local KnobCorner = Instance.new("UICorner")

    KnobCorner.CornerRadius =
        UDim.new(1, 0)

    KnobCorner.Parent = Knob

    local function UpdateVisual()

        if State[Key] then

            Switch.BackgroundColor3 =
                Colors.On

            Knob.Position =
                UDim2.new(
                    1,
                    -20,
                    0,
                    2
                )

        else

            Switch.BackgroundColor3 =
                Colors.Off

            Knob.Position =
                UDim2.fromOffset(2, 2)
        end
    end

    Switch.Activated:Connect(function()

        State[Key] =
            not State[Key]

        UpdateVisual()

        ApplyOption(Key)

        print(
            "[Violet Core FX]",
            Name,
            State[Key] and "ON" or "OFF"
        )
    end)

    UpdateVisual()
end

--========================================================
-- SELECTOR
--========================================================

local function CreateSelector(Name)

    local Row = Instance.new("Frame")

    Row.Size =
        UDim2.new(1, 0, 0, 52)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.ZIndex = 13

    Row.Parent = Options

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent = Row

    local Label = Instance.new("TextLabel")

    Label.Size =
        UDim2.new(
            1,
            -150,
            1,
            0
        )

    Label.Position =
        UDim2.fromOffset(13, 0)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.Text

    Label.TextSize = 11

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.ZIndex = 14

    Label.Parent = Row

    local Button = Instance.new("TextButton")

    Button.Size =
        UDim2.fromOffset(105, 32)

    Button.Position =
        UDim2.new(
            1,
            -118,
            0.5,
            -16
        )

    Button.BackgroundColor3 =
        Colors.Panel3

    Button.BorderSizePixel = 0

    Button.Text =
        State.TargetPart

    Button.TextColor3 =
        Colors.Accent

    Button.TextSize = 10

    Button.Font =
        Enum.Font.GothamBold

    Button.AutoButtonColor = false

    Button.ZIndex = 15

    Button.Parent = Row

    local ButtonCorner = Instance.new("UICorner")

    ButtonCorner.CornerRadius =
        UDim.new(0, 8)

    ButtonCorner.Parent = Button

    local Values = {
        "Head",
        "Torso",
        "Feet"
    }

    local Index = 1

    for Number, Value in ipairs(Values) do
        if Value == State.TargetPart then
            Index = Number
        end
    end

    Button.Activated:Connect(function()

        Index += 1

        if Index > #Values then
            Index = 1
        end

        State.TargetPart =
            Values[Index]

        Button.Text =
            State.TargetPart

        print(
            "[Violet Core FX] Target:",
            State.TargetPart
        )
    end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name, Value)

    local Row = Instance.new("Frame")

    Row.Size =
        UDim2.new(1, 0, 0, 58)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.ZIndex = 13

    Row.Parent = Options

    local Corner = Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent = Row

    local NameLabel = Instance.new("TextLabel")

    NameLabel.Size =
        UDim2.new(
            1,
            -26,
            0,
            18
        )

    NameLabel.Position =
        UDim2.fromOffset(13, 8)

    NameLabel.BackgroundTransparency = 1

    NameLabel.Text = Name

    NameLabel.TextColor3 =
        Colors.SubText

    NameLabel.TextSize = 9

    NameLabel.Font =
        Enum.Font.GothamMedium

    NameLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    NameLabel.Parent = Row

    local ValueLabel = Instance.new("TextLabel")

    ValueLabel.Size =
        UDim2.new(
            1,
            -26,
            0,
            22
        )

    ValueLabel.Position =
        UDim2.fromOffset(13, 29)

    ValueLabel.BackgroundTransparency = 1

    ValueLabel.Text = Value

    ValueLabel.TextColor3 =
        Colors.Text

    ValueLabel.TextSize = 11

    ValueLabel.Font =
        Enum.Font.GothamBold

    ValueLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    ValueLabel.Parent = Row
end

--========================================================
-- SECTION DISPLAY
--========================================================

local function ShowSection(Section)

    ClearOptions()

    local HeaderLabel =
        Instance.new("TextLabel")

    HeaderLabel.Size =
        UDim2.new(1, 0, 0, 30)

    HeaderLabel.BackgroundTransparency = 1

    HeaderLabel.Text =
        Section.Icon
        .. "   "
        .. Section.Name

    HeaderLabel.TextColor3 =
        Colors.Text

    HeaderLabel.TextSize = 15

    HeaderLabel.Font =
        Enum.Font.GothamBold

    HeaderLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    HeaderLabel.ZIndex = 14

    HeaderLabel.Parent = Options

    for _, Item in ipairs(Section.Items) do

        if Item[1] == "toggle" then

            CreateToggle(
                Item[2],
                Item[3]
            )

        elseif Item[1] == "selector" then

            CreateSelector(
                Item[2]
            )

        elseif Item[1] == "info" then

            CreateInfo(
                Item[2],
                Item[3]
            )
        end
    end

    task.defer(function()
        Options.CanvasPosition =
            Vector2.new(0, 0)
    end)
end

--========================================================
-- CATEGORY BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(Sections) do

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.new(1, 0, 0, 39)

    Button.BackgroundColor3 =
        Colors.Panel

    Button.BorderSizePixel = 0

    Button.Text =
        Section.Icon
        .. "   "
        .. Section.Name

    Button.TextColor3 =
        Colors.SubText

    Button.TextSize = 10

    Button.Font =
        Enum.Font.GothamMedium

    Button.TextXAlignment =
        Enum.TextXAlignment.Left

    Button.AutoButtonColor = false

    Button.LayoutOrder = Index

    Button.ZIndex = 13

    Button.Parent = Categories

    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingLeft =
        UDim.new(0, 12)

    Padding.Parent = Button

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 8)

    Corner.Parent = Button

    CategoryButtons[Section.Name] =
        Button

    Button.Activated:Connect(function()

        for _, Other in pairs(
            CategoryButtons
        ) do

            Other.BackgroundColor3 =
                Colors.Panel

            Other.TextColor3 =
                Colors.SubText
        end

        Button.BackgroundColor3 =
            Colors.AccentDark

        Button.TextColor3 =
            Colors.White

        ShowSection(Section)
    end)
end

--========================================================
-- OPEN / CLOSE
--========================================================

OpenButton.Activated:Connect(function()

    Window.Visible =
        not Window.Visible

    -- FX BUTTON ALWAYS REMAINS
    -- VISIBLE.
    OpenButton.Visible = true
end)

CloseButton.Activated:Connect(function()

    Window.Visible = false

    OpenButton.Visible = true
end)

--========================================================
-- MINIMIZE
--========================================================

local Minimized = false

MinButton.Activated:Connect(function()

    Minimized =
        not Minimized

    Content.Visible =
        not Minimized

    if Minimized then

        Window.Size =
            UDim2.fromOffset(
                650,
                64
            )

    else

        Window.Size =
            UDim2.fromOffset(
                650,
                430
            )
    end
end)

--========================================================
-- DRAGGING
--========================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Window.Position
    end
end)

Header.InputEnded:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or Input.UserInputType ==
        Enum.UserInputType.Touch then

        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and Input.UserInputType ~=
        Enum.UserInputType.Touch then

        return
    end

    local Delta =
        Input.Position - DragStart

    Window.Position =
        UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
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

    if State.AnimZombie then
        PlayAnimation("Zombie")
    elseif State.AnimGhost then
        PlayAnimation("Ghost")
    elseif State.AnimGoat then
        PlayAnimation("Goat")
    end
end)

--========================================================
-- INITIAL STATE
--========================================================

Window.Visible = false
OpenButton.Visible = true

local CombatButton =
    CategoryButtons["Combat"]

if CombatButton then

    CombatButton.BackgroundColor3 =
        Colors.AccentDark

    CombatButton.TextColor3 =
        Colors.White
end

ShowSection(Sections[1])

--========================================================
-- STARTUP
--========================================================

print("----------------------------------------")
print("Violet Core FX")
print("Created by José FX")
print("UI initialized")
print("FX button initialized")
print("Menu initialized CLOSED")
print("----------------------------------------")
```
