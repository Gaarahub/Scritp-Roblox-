--========================================================
-- VIOLET CORE B10
-- Created by José FX
-- LocalScript
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--========================================================
-- CLEAN OLD VERSION
--========================================================

local Old = PlayerGui:FindFirstChild("VioletCore_B10")
if Old then
    Old:Destroy()
end

--========================================================
-- COLORS
--========================================================

local Colors = {
    Background = Color3.fromRGB(12,12,15),
    Panel = Color3.fromRGB(18,18,22),
    Panel2 = Color3.fromRGB(27,27,32),
    Panel3 = Color3.fromRGB(34,34,40),

    Border = Color3.fromRGB(52,52,60),

    Text = Color3.fromRGB(242,242,247),
    SubText = Color3.fromRGB(150,150,160),

    Accent = Color3.fromRGB(145,85,255),
    AccentDark = Color3.fromRGB(87,48,155),

    On = Color3.fromRGB(50,205,110),
    Off = Color3.fromRGB(65,65,73),

    White = Color3.fromRGB(255,255,255)
}

--========================================================
-- STATE
--========================================================

local State = {

    Aimbot = false,
    SilentAim = false,
    AutoShoot = false,
    AutoShootAggressive = false,
    AutoEquip = false,
    LongRange = false,

    ESP = false,
    ESPLines = false,
    ESPRainbow = false,
    ESPTrack = false,

    Speed = false,
    InfiniteJump = false,
    FOVEnabled = false,

    AnimZombie = false,
    AnimGhost = false,
    AnimGoat = false,

    AutoFarm = false,
    AutoCollect = false,

    TargetPart = "Head",

    SpeedValue = 32,
    FOVValue = 70
}

--========================================================
-- CONNECTION STORAGE
--========================================================

local Connections = {}
local ESPData = {}

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

local DefaultWalkSpeed = 16

local function UpdateSpeed()

    local Humanoid = GetHumanoid()

    if not Humanoid then
        return
    end

    if State.Speed then
        Humanoid.WalkSpeed = State.SpeedValue
    else
        Humanoid.WalkSpeed = DefaultWalkSpeed
    end
end

local function UpdateFOV()

    local Camera = workspace.CurrentCamera

    if not Camera then
        return
    end

    if State.FOVEnabled then
        Camera.FieldOfView = State.FOVValue
    else
        Camera.FieldOfView = 70
    end
end

--========================================================
-- INFINITE JUMP
--========================================================

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
-- TARGET PART
--========================================================

local function GetTargetPart(Character)

    if not Character then
        return nil
    end

    if State.TargetPart == "Head" then

        return Character:FindFirstChild("Head")

    elseif State.TargetPart == "Torso" then

        return Character:FindFirstChild("UpperTorso")
            or Character:FindFirstChild("Torso")
            or Character:FindFirstChild("HumanoidRootPart")

    elseif State.TargetPart == "Feet" then

        return Character:FindFirstChild("LeftFoot")
            or Character:FindFirstChild("RightFoot")
            or Character:FindFirstChild("Left Leg")
            or Character:FindFirstChild("Right Leg")
    end

    return Character:FindFirstChild("HumanoidRootPart")
end

--========================================================
-- CLOSEST PLAYER
--========================================================

local function GetClosestTarget()

    local Camera = workspace.CurrentCamera

    if not Camera then
        return nil
    end

    local Viewport = Camera.ViewportSize

    local Center = Vector2.new(
        Viewport.X / 2,
        Viewport.Y / 2
    )

    local Closest = nil
    local ClosestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            local Character = Player.Character
            local Humanoid =
                Character and
                Character:FindFirstChildOfClass("Humanoid")

            if Character
                and Humanoid
                and Humanoid.Health > 0 then

                local Part = GetTargetPart(Character)

                if Part then

                    local Position, Visible =
                        Camera:WorldToViewportPoint(
                            Part.Position
                        )

                    if Visible and Position.Z > 0 then

                        local Distance =
                            (
                                Vector2.new(
                                    Position.X,
                                    Position.Y
                                ) - Center
                            ).Magnitude

                        if Distance < ClosestDistance then

                            ClosestDistance = Distance
                            Closest = Character

                        end
                    end
                end
            end
        end
    end

    return Closest
end

--========================================================
-- AIMBOT
--========================================================

Connections.Aimbot =
    RunService.RenderStepped:Connect(function()

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

        Camera.CFrame =
            CFrame.lookAt(
                Camera.CFrame.Position,
                Part.Position
            )
    end)

--========================================================
-- ESP OBJECT CREATION
--========================================================

local function RemoveESP(Player)

    local Data = ESPData[Player]

    if not Data then
        return
    end

    for _, Object in pairs(Data) do

        if typeof(Object) == "Instance" then

            if Object.Parent then
                Object:Destroy()
            end

        end
    end

    ESPData[Player] = nil
end

local function CreateESP(Player)

    if Player == LocalPlayer then
        return
    end

    RemoveESP(Player)

    local Character = Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Data = {}

    --====================================================
    -- HIGHLIGHT
    --====================================================

    if State.ESP then

        local Highlight = Instance.new("Highlight")

        Highlight.Name = "VioletESP"
        Highlight.Adornee = Character

        Highlight.FillTransparency = 0.65
        Highlight.OutlineTransparency = 0

        Highlight.FillColor = Colors.Accent
        Highlight.OutlineColor = Colors.White

        Highlight.Parent = Character

        Data.Highlight = Highlight
    end

    --====================================================
    -- LINE
    --====================================================

    if State.ESPLines then

        local Line = Instance.new("Beam")

        local Attachment0 =
            Instance.new("Attachment")

        local Attachment1 =
            Instance.new("Attachment")

        local LocalRoot = GetRoot()

        if LocalRoot then

            Attachment0.Parent = LocalRoot
            Attachment1.Parent = Root

            Line.Attachment0 = Attachment0
            Line.Attachment1 = Attachment1

            Line.Width0 = 0.05
            Line.Width1 = 0.05

            Line.FaceCamera = true

            Line.Color = ColorSequence.new(
                Colors.Accent
            )

            Line.Parent = LocalRoot

            Data.Line = Line
            Data.Attachment0 = Attachment0
            Data.Attachment1 = Attachment1
        end
    end

    ESPData[Player] = Data
end

--========================================================
-- RAINBOW ESP
--========================================================

Connections.Rainbow =
    RunService.RenderStepped:Connect(function()

        if not State.ESPRainbow then
            return
        end

        local Hue =
            (os.clock() % 5) / 5

        local Color =
            Color3.fromHSV(
                Hue,
                0.85,
                1
            )

        for Player, Data in pairs(ESPData) do

            if Data.Highlight
                and Data.Highlight.Parent then

                Data.Highlight.FillColor = Color
                Data.Highlight.OutlineColor = Color
            end

            if Data.Line
                and Data.Line.Parent then

                Data.Line.Color =
                    ColorSequence.new(Color)
            end
        end
    end)

--========================================================
-- TRACK TARGET
--========================================================

local TargetMarker

local function RemoveTargetMarker()

    if TargetMarker then

        TargetMarker:Destroy()
        TargetMarker = nil

    end
end

local function UpdateTargetMarker()

    RemoveTargetMarker()

    if not State.ESPTrack then
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

    TargetMarker = Instance.new("Highlight")

    TargetMarker.Name = "VioletTarget"
    TargetMarker.Adornee = Target

    TargetMarker.FillTransparency = 0.85
    TargetMarker.OutlineTransparency = 0

    TargetMarker.FillColor = Colors.Accent
    TargetMarker.OutlineColor = Colors.White

    TargetMarker.Parent = Target
end

Connections.TargetTrack =
    RunService.Heartbeat:Connect(function()

        if State.ESPTrack then
            UpdateTargetMarker()
        else
            RemoveTargetMarker()
        end
    end)

--========================================================
-- UPDATE ESP
--========================================================

local function UpdateESP()

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do

        if Player ~= LocalPlayer then
            CreateESP(Player)
        end
    end
end

Players.PlayerAdded:Connect(function(Player)

    Player.CharacterAdded:Connect(function()

        task.wait(0.4)

        if State.ESP
            or State.ESPLines
            or State.ESPRainbow
            or State.ESPTrack then

            CreateESP(Player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(Player)

    RemoveESP(Player)
end)

--========================================================
-- ANIMATION SYSTEM
--========================================================

local AnimationIds = {

    Zombie = "",
    Ghost = "",
    Goat = ""
}

local CurrentAnimation

local function StopAnimation()

    if CurrentAnimation then

        pcall(function()
            CurrentAnimation:Stop()
            CurrentAnimation:Destroy()
        end)

        CurrentAnimation = nil
    end
end

local function PlayAnimation(Name)

    local Id = AnimationIds[Name]

    if not Id or Id == "" then

        warn(
            "[Violet Core] Missing AnimationId:",
            Name
        )

        return
    end

    local Humanoid = GetHumanoid()

    if not Humanoid then
        return
    end

    local Animator =
        Humanoid:FindFirstChildOfClass(
            "Animator"
        )

    if not Animator then

        Animator = Instance.new("Animator")
        Animator.Parent = Humanoid
    end

    StopAnimation()

    local Animation =
        Instance.new("Animation")

    Animation.AnimationId =
        "rbxassetid://" .. tostring(Id)

    local Track

    local Success, Error =
        pcall(function()

            Track =
                Animator:LoadAnimation(
                    Animation
                )

        end)

    if not Success then

        warn(
            "[Violet Core] Animation error:",
            Error
        )

        Animation:Destroy()

        return
    end

    Track.Priority =
        Enum.AnimationPriority.Action

    Track:Play()

    CurrentAnimation = Track
end

--========================================================
-- GUI
--========================================================

local Gui =
    Instance.new("ScreenGui")

Gui.Name = "VioletCore_B10"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true

Gui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--========================================================
-- OPEN BUTTON
--========================================================

local OpenButton =
    Instance.new("TextButton")

OpenButton.Name = "MenuButton"

OpenButton.Size =
    UDim2.fromOffset(48,48)

OpenButton.Position =
    UDim2.new(1,-68,0,90)

OpenButton.BackgroundColor3 =
    Colors.Panel

OpenButton.BorderSizePixel = 0

OpenButton.Text = "V"
OpenButton.TextColor3 =
    Colors.White

OpenButton.TextSize = 18
OpenButton.Font =
    Enum.Font.GothamBold

OpenButton.AutoButtonColor = false
OpenButton.Visible = true

OpenButton.ZIndex = 100
OpenButton.Parent = Gui

local OpenCorner =
    Instance.new("UICorner")

OpenCorner.CornerRadius =
    UDim.new(0,14)

OpenCorner.Parent =
    OpenButton

local OpenStroke =
    Instance.new("UIStroke")

OpenStroke.Color =
    Colors.Accent

OpenStroke.Thickness = 2

OpenStroke.Parent =
    OpenButton

--========================================================
-- WINDOW
--========================================================

local Window =
    Instance.new("Frame")

Window.Name = "MainWindow"

Window.Size =
    UDim2.fromOffset(640,410)

Window.Position =
    UDim2.new(
        0.5,-320,
        0.5,-205
    )

Window.BackgroundColor3 =
    Colors.Background

Window.BorderSizePixel = 0

Window.Visible = false

Window.Parent = Gui

local WindowCorner =
    Instance.new("UICorner")

WindowCorner.CornerRadius =
    UDim.new(0,14)

WindowCorner.Parent =
    Window

local WindowStroke =
    Instance.new("UIStroke")

WindowStroke.Color =
    Colors.Border

WindowStroke.Thickness = 1

WindowStroke.Parent =
    Window

--========================================================
-- HEADER
--========================================================

local Header =
    Instance.new("Frame")

Header.Size =
    UDim2.new(1,0,0,58)

Header.BackgroundColor3 =
    Colors.Panel

Header.BorderSizePixel = 0

Header.Parent = Window

local Title =
    Instance.new("TextLabel")

Title.Size =
    UDim2.new(1,-130,0,25)

Title.Position =
    UDim2.fromOffset(18,7)

Title.BackgroundTransparency = 1

Title.Text =
    "Violet Core"

Title.TextColor3 =
    Colors.Text

Title.TextSize = 18
Title.Font =
    Enum.Font.GothamBold

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent = Header

local Creator =
    Instance.new("TextLabel")

Creator.Size =
    UDim2.new(1,-130,0,16)

Creator.Position =
    UDim2.fromOffset(19,32)

Creator.BackgroundTransparency = 1

Creator.Text =
    "José FX"

Creator.TextColor3 =
    Colors.Accent

Creator.TextSize = 9

Creator.Font =
    Enum.Font.GothamMedium

Creator.TextXAlignment =
    Enum.TextXAlignment.Left

Creator.Parent = Header

--========================================================
-- CLOSE / MINIMIZE
--========================================================

local MinButton =
    Instance.new("TextButton")

MinButton.Size =
    UDim2.fromOffset(30,30)

MinButton.Position =
    UDim2.new(1,-72,0,14)

MinButton.BackgroundColor3 =
    Colors.Panel2

MinButton.BorderSizePixel = 0

MinButton.Text = "−"

MinButton.TextColor3 =
    Colors.SubText

MinButton.TextSize = 16

MinButton.Font =
    Enum.Font.GothamBold

MinButton.Parent = Header

local CloseButton =
    Instance.new("TextButton")

CloseButton.Size =
    UDim2.fromOffset(30,30)

CloseButton.Position =
    UDim2.new(1,-36,0,14)

CloseButton.BackgroundColor3 =
    Colors.Panel2

CloseButton.BorderSizePixel = 0

CloseButton.Text = "×"

CloseButton.TextColor3 =
    Colors.SubText

CloseButton.TextSize = 17

CloseButton.Font =
    Enum.Font.GothamBold

CloseButton.Parent = Header

--========================================================
-- CONTENT
--========================================================

local Content =
    Instance.new("Frame")

Content.Size =
    UDim2.new(1,-14,1,-66)

Content.Position =
    UDim2.fromOffset(7,62)

Content.BackgroundTransparency = 1

Content.Parent = Window

--========================================================
-- SIDEBAR
--========================================================

local Sidebar =
    Instance.new("ScrollingFrame")

Sidebar.Size =
    UDim2.fromOffset(180,0)

Sidebar.BackgroundColor3 =
    Colors.Panel

Sidebar.BorderSizePixel = 0

Sidebar.ScrollBarThickness = 3

Sidebar.ScrollBarImageColor3 =
    Colors.Accent

Sidebar.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

Sidebar.CanvasSize =
    UDim2.new()

Sidebar.Parent = Content

local SidebarPadding =
    Instance.new("UIPadding")

SidebarPadding.PaddingTop =
    UDim.new(0,8)

SidebarPadding.PaddingBottom =
    UDim.new(0,8)

SidebarPadding.PaddingLeft =
    UDim.new(0,8)

SidebarPadding.PaddingRight =
    UDim.new(0,8)

SidebarPadding.Parent =
    Sidebar

local SidebarLayout =
    Instance.new("UIListLayout")

SidebarLayout.Padding =
    UDim.new(0,5)

SidebarLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

SidebarLayout.Parent =
    Sidebar

--========================================================
-- OPTIONS
--========================================================

local Options =
    Instance.new("ScrollingFrame")

Options.Size =
    UDim2.new(1,-188,1,0)

Options.Position =
    UDim2.fromOffset(188,0)

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

Options.Parent = Content

local OptionsPadding =
    Instance.new("UIPadding")

OptionsPadding.PaddingTop =
    UDim.new(0,12)

OptionsPadding.PaddingBottom =
    UDim.new(0,12)

OptionsPadding.PaddingLeft =
    UDim.new(0,12)

OptionsPadding.PaddingRight =
    UDim.new(0,12)

OptionsPadding.Parent =
    Options

local OptionsLayout =
    Instance.new("UIListLayout")

OptionsLayout.Padding =
    UDim.new(0,7)

OptionsLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

OptionsLayout.Parent =
    Options

--========================================================
-- SECTIONS
--========================================================

local Sections = {

    {
        Name = "Hitbox & ESP",
        Icon = "◉",

        Items = {

            {"toggle","Player ESP","ESP"},
            {"toggle","ESP Lines","ESPLines"},
            {"toggle","Rainbow ESP","ESPRainbow"},
            {"toggle","Track Target","ESPTrack"}
        }
    },

    {
        Name = "Combat",
        Icon = "◎",

        Items = {

            {"toggle","Aimbot","Aimbot"},
            {"toggle","Silent Aim","SilentAim"},

            {"selector","Target: Body Part"},

            {"toggle","Auto Shoot","AutoShoot"},
            {"toggle","Auto Shoot Aggressive","AutoShootAggressive"},
            {"toggle","Auto Equip","AutoEquip"},
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
        Name = "Movement",
        Icon = "✥",

        Items = {

            {"toggle","Activate Speed","Speed"},
            {"slider","Speed Slider","SpeedValue",16,100},

            {"toggle","Infinite Jump","InfiniteJump"},

            {"toggle","Activate FOV","FOVEnabled"},
            {"slider","FOV Value","FOVValue",40,120}
        }
    },

    {
        Name = "Animations",
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

            {"info","FPS","Local client performance"},
            {"info","Optimization","Lightweight UI / local rendering"}
        }
    },

    {
        Name = "Configuration",
        Icon = "⚙",

        Items = {

            {"info","Configuration","Ready for game-specific save system"}
        }
    },

    {
        Name = "Information",
        Icon = "ⓘ",

        Items = {

            {"info","Created by","José FX"},
            {"info","Version","B10"}
        }
    }
}

--========================================================
-- CLEAR OPTIONS
--========================================================

local function ClearOptions()

    for _, Object in ipairs(
        Options:GetChildren()
    ) do

        if not Object:IsA("UIListLayout")
            and not Object:IsA("UIPadding") then

            Object:Destroy()
        end
    end
end

--========================================================
-- TOGGLE VISUAL
--========================================================

local function CreateToggle(Name,Key)

    local Row =
        Instance.new("Frame")

    Row.Size =
        UDim2.new(1,0,0,58)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.Parent = Options

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,10)

    Corner.Parent = Row

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1,-80,0,25)

    Label.Position =
        UDim2.fromOffset(15,7)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.Text

    Label.TextSize = 12

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Row

    local Switch =
        Instance.new("TextButton")

    Switch.Size =
        UDim2.fromOffset(48,25)

    Switch.Position =
        UDim2.new(1,-61,0.5,-12)

    Switch.BackgroundColor3 =
        Colors.Off

    Switch.BorderSizePixel = 0

    Switch.Text = ""

    Switch.AutoButtonColor = false

    Switch.Parent = Row

    local SwitchCorner =
        Instance.new("UICorner")

    SwitchCorner.CornerRadius =
        UDim.new(1,0)

    SwitchCorner.Parent = Switch

    local Knob =
        Instance.new("Frame")

    Knob.Size =
        UDim2.fromOffset(19,19)

    Knob.Position =
        UDim2.fromOffset(3,3)

    Knob.BackgroundColor3 =
        Colors.White

    Knob.BorderSizePixel = 0

    Knob.Parent = Switch

    local KnobCorner =
        Instance.new("UICorner")

    KnobCorner.CornerRadius =
        UDim.new(1,0)

    KnobCorner.Parent = Knob

    local function UpdateVisual()

        if State[Key] then

            Switch.BackgroundColor3 =
                Colors.On

            Knob.Position =
                UDim2.new(
                    1,-22,
                    0,3
                )

        else

            Switch.BackgroundColor3 =
                Colors.Off

            Knob.Position =
                UDim2.fromOffset(3,3)
        end
    end

    Switch.MouseButton1Click:Connect(function()

        State[Key] =
            not State[Key]

        UpdateVisual()

        --================================================
        -- ROUTING
        --================================================

        if Key == "Speed" then
            UpdateSpeed()
        end

        if Key == "FOVEnabled" then
            UpdateFOV()
        end

        if Key == "ESP"
            or Key == "ESPLines"
            or Key == "ESPRainbow" then

            UpdateESP()
        end

        if Key == "ESPTrack" then

            if not State.ESPTrack then
                RemoveTargetMarker()
            end
        end

        if Key == "AnimZombie"
            and State[Key] then

            State.AnimGhost = false
            State.AnimGoat = false

            PlayAnimation("Zombie")
        end

        if Key == "AnimGhost"
            and State[Key] then

            State.AnimZombie = false
            State.AnimGoat = false

            PlayAnimation("Ghost")
        end

        if Key == "AnimGoat"
            and State[Key] then

            State.AnimZombie = false
            State.AnimGhost = false

            PlayAnimation("Goat")
        end

        if Key == "AnimZombie"
            or Key == "AnimGhost"
            or Key == "AnimGoat" then

            if not State.AnimZombie
                and not State.AnimGhost
                and not State.AnimGoat then

                StopAnimation()
            end
        end
    end)

    UpdateVisual()
end

--========================================================
-- SELECTOR
--========================================================

local function CreateSelector(Name)

    local Row =
        Instance.new("Frame")

    Row.Size =
        UDim2.new(1,0,0,58)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.Parent = Options

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,10)

    Corner.Parent = Row

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.new(0.5,0,1,0)

    Label.Position =
        UDim2.fromOffset(15,0)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.Text

    Label.TextSize = 12

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Row

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.fromOffset(120,34)

    Button.Position =
        UDim2.new(1,-135,0.5,-17)

    Button.BackgroundColor3 =
        Colors.Panel3

    Button.BorderSizePixel = 0

    Button.Text =
        State.TargetPart

    Button.TextColor3 =
        Colors.Text

    Button.TextSize = 11

    Button.Font =
        Enum.Font.GothamMedium

    Button.AutoButtonColor = false

    Button.Parent = Row

    local Values = {
        "Head",
        "Torso",
        "Feet"
    }

    local Index = 1

    Button.MouseButton1Click:Connect(function()

        Index += 1

        if Index > #Values then
            Index = 1
        end

        State.TargetPart =
            Values[Index]

        Button.Text =
            State.TargetPart
    end)
end

--========================================================
-- SLIDER
--========================================================

local function CreateSlider(
    Name,
    Key,
    Minimum,
    Maximum
)

    local Row =
        Instance.new("Frame")

    Row.Size =
        UDim2.new(1,0,0,72)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.Parent = Options

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,10)

    Corner.Parent = Row

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1,-30,0,22)

    Label.Position =
        UDim2.fromOffset(15,7)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.Text

    Label.TextSize = 12

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Row

    local Value =
        Instance.new("TextLabel")

    Value.Size =
        UDim2.fromOffset(40,22)

    Value.Position =
        UDim2.new(1,-55,0,7)

    Value.BackgroundTransparency = 1

    Value.Text =
        tostring(State[Key])

    Value.TextColor3 =
        Colors.SubText

    Value.TextSize = 11

    Value.Font =
        Enum.Font.GothamMedium

    Value.Parent = Row

    local Bar =
        Instance.new("Frame")

    Bar.Size =
        UDim2.new(1,-30,0,5)

    Bar.Position =
        UDim2.fromOffset(15,49)

    Bar.BackgroundColor3 =
        Colors.Off

    Bar.BorderSizePixel = 0

    Bar.Parent = Row

    local BarCorner =
        Instance.new("UICorner")

    BarCorner.CornerRadius =
        UDim.new(1,0)

    BarCorner.Parent = Bar

    local Knob =
        Instance.new("Frame")

    Knob.Size =
        UDim2.fromOffset(20,20)

    Knob.BackgroundColor3 =
        Colors.White

    Knob.BorderSizePixel = 0

    Knob.Parent = Bar

    local KnobCorner =
        Instance.new("UICorner")

    KnobCorner.CornerRadius =
        UDim.new(1,0)

    KnobCorner.Parent = Knob

    local Dragging = false

    local function SetValue(X)

        local Percent =
            math.clamp(
                (X-Bar.AbsolutePosition.X)
                / Bar.AbsoluteSize.X,
                0,
                1
            )

        local NewValue =
            math.floor(
                Minimum +
                (Maximum-Minimum)
                * Percent
            )

        State[Key] =
            NewValue

        Value.Text =
            tostring(NewValue)

        Knob.Position =
            UDim2.new(
                Percent,-10,
                0.5,-10
            )

        if Key == "SpeedValue" then
            UpdateSpeed()
        end

        if Key == "FOVValue" then
            UpdateFOV()
        end
    end

    Bar.InputBegan:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true
            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            SetValue(Input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = false
        end
    end)

    task.defer(function()

        local Percent =
            math.clamp(
                (State[Key]-Minimum)
                /(Maximum-Minimum),
                0,
                1
            )

        Knob.Position =
            UDim2.new(
                Percent,-10,
                0.5,-10
            )
    end)
end

--========================================================
-- INFO
--========================================================

local function CreateInfo(Name,Value)

    local Row =
        Instance.new("Frame")

    Row.Size =
        UDim2.new(1,0,0,52)

    Row.BackgroundColor3 =
        Colors.Panel2

    Row.BorderSizePixel = 0

    Row.Parent = Options

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,10)

    Corner.Parent = Row

    local Label =
        Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1,-30,0,20)

    Label.Position =
        UDim2.fromOffset(15,5)

    Label.BackgroundTransparency = 1

    Label.Text = Name

    Label.TextColor3 =
        Colors.SubText

    Label.TextSize = 9

    Label.Font =
        Enum.Font.GothamMedium

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Row

    local ValueLabel =
        Instance.new("TextLabel")

    ValueLabel.Size =
        UDim2.new(1,-30,0,20)

    ValueLabel.Position =
        UDim2.fromOffset(15,24)

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
-- SHOW SECTION
--========================================================

local function ShowSection(Section)

    ClearOptions()

    local Header =
        Instance.new("TextLabel")

    Header.Size =
        UDim2.new(1,0,0,35)

    Header.BackgroundTransparency = 1

    Header.Text =
        Section.Icon ..
        "   " ..
        Section.Name

    Header.TextColor3 =
        Colors.Text

    Header.TextSize = 16

    Header.Font =
        Enum.Font.GothamBold

    Header.TextXAlignment =
        Enum.TextXAlignment.Left

    Header.Parent = Options

    for _, Item in ipairs(
        Section.Items
    ) do

        if Item[1] == "toggle" then

            CreateToggle(
                Item[2],
                Item[3]
            )

        elseif Item[1] == "selector" then

            CreateSelector(
                Item[2]
            )

        elseif Item[1] == "slider" then

            CreateSlider(
                Item[2],
                Item[3],
                Item[4],
                Item[5]
            )

        elseif Item[1] == "info" then

            CreateInfo(
                Item[2],
                Item[3]
            )
        end
    end
end

--========================================================
-- SIDEBAR BUTTONS
--========================================================

local CategoryButtons = {}

for Index, Section in ipairs(
    Sections
) do

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.new(1,0,0,40)

    Button.BackgroundColor3 =
        Colors.Panel

    Button.BorderSizePixel = 0

    Button.Text =
        Section.Icon ..
        "   " ..
        Section.Name

    Button.TextColor3 =
        Colors.SubText

    Button.TextSize = 11

    Button.Font =
        Enum.Font.GothamMedium

    Button.TextXAlignment =
        Enum.TextXAlignment.Left

    Button.AutoButtonColor = false

    Button.LayoutOrder =
        Index

    Button.Parent = Sidebar

    local Padding =
        Instance.new("UIPadding")

    Padding.PaddingLeft =
        UDim.new(0,10)

    Padding.Parent = Button

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,8)

    Corner.Parent = Button

    CategoryButtons[
        Section.Name
    ] = Button

    Button.MouseButton1Click:Connect(function()

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

OpenButton.MouseButton1Click:Connect(function()

    Window.Visible =
        not Window.Visible

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

    Minimized =
        not Minimized

    Content.Visible =
        not Minimized

    if Minimized then

        Window.Size =
            UDim2.fromOffset(
                640,58
            )

    else

        Window.Size =
            UDim2.fromOffset(
                640,410
            )
    end
end)

--========================================================
-- DRAG
--========================================================

local Dragging = false
local DragStart
local StartPosition

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
        Input.Position -
        DragStart

    Window.Position =
        UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset +
            Delta.X,

            StartPosition.Y.Scale,
            StartPosition.Y.Offset +
            Delta.Y
        )
end)

--========================================================
-- CHARACTER RESPAWN
--========================================================

LocalPlayer.CharacterAdded:Connect(function()

    task.wait(0.5)

    UpdateSpeed()
    UpdateFOV()

    if State.ESP
        or State.ESPLines
        or State.ESPRainbow then

        UpdateESP()
    end
end)

--========================================================
-- INITIALIZATION
--========================================================

Window.Visible = false
OpenButton.Visible = true

local First =
    CategoryButtons[
        Sections[1].Name
    ]

if First then

    First.BackgroundColor3 =
        Colors.AccentDark

    First.TextColor3 =
        Colors.White
end

ShowSection(Sections[1])

print(
    "===================================="
)

print(
    "Violet Core B10 initialized"
)

print(
    "Created by José FX"
)

print(
    "All local UI systems loaded"
)

print(
    "===================================="
)
