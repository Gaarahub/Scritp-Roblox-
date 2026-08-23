-- Script taken from https://robloxscripts.com website --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local fovRadius = 150
local aimSpeed = 1
local toggleKey = Enum.KeyCode.Q
local uiToggleKey = Enum.KeyCode.RightShift
local aimbotEnabled = false
local aimbot360Enabled = false
local teamCheckEnabled = false
local targetPlayer = nil
local listeningForKey = false
local listeningForUIKey = false
local espMasterEnabled = false
local espShowBoxes = false
local espShowNames = false
local noclipEnabled = false
local flying = false
local flySpeed = 50
local isDraggingSlider = false
local toggleAimbot

local flyLinearVelocity = nil
local flyAlignOrientation = nil
local flyAttachment = nil

local Theme = {
    Background         = Color3.fromRGB(12, 12, 16),
    SidebarBackground  = Color3.fromRGB(18, 18, 24),
    HeaderBackground   = Color3.fromRGB(24, 24, 32),
    Border             = Color3.fromRGB(50, 50, 60),
    AccentStart        = Color3.fromRGB(255, 255, 255),
    AccentEnd          = Color3.fromRGB(80, 80, 80),
    TextPrimary        = Color3.fromRGB(255, 255, 255),
    TextSecondary      = Color3.fromRGB(160, 160, 170),
    FontBold           = Enum.Font.GothamBold,
    FontMedium         = Enum.Font.GothamMedium,
    FontRegular        = Enum.Font.Gotham,

    ActiveRed          = Color3.fromRGB(200, 200, 200),
    ActiveGreen        = Color3.fromRGB(255, 255, 255),
    ActiveRedBg        = Color3.fromRGB(22, 22, 26),
}

if setfpscap then
    pcall(function() setfpscap(9999) end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "simple aimbot "
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 99999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.Position = UDim2.fromScale(0.5, 0.5)
FOVCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Parent = ScreenGui

local UICornerFOV = Instance.new("UICorner")
UICornerFOV.CornerRadius = UDim.new(1, 0)
UICornerFOV.Parent = FOVCircle

local UIStrokeFOV = Instance.new("UIStroke")
UIStrokeFOV.Color = Theme.AccentStart
UIStrokeFOV.Thickness = 1.5
UIStrokeFOV.Transparency = 0.5
UIStrokeFOV.Parent = FOVCircle

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.fromOffset(480, 380)
MainFrame.Position = UDim2.fromScale(0.1, 0.3)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local MainStrokeGradient = Instance.new("UIGradient")
MainStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.AccentStart),
    ColorSequenceKeypoint.new(1, Theme.AccentEnd)
})
MainStrokeGradient.Rotation = 45
MainStrokeGradient.Parent = MainStroke

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14))
})
MainGradient.Rotation = 90
MainGradient.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Size = UDim2.new(1, 0, 0, 42)
HeaderFrame.BackgroundColor3 = Theme.HeaderBackground
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = HeaderFrame

local HeaderOverlap = Instance.new("Frame")
HeaderOverlap.Size = UDim2.new(1, 0, 0, 10)
HeaderOverlap.Position = UDim2.new(0, 0, 1, -10)
HeaderOverlap.BackgroundColor3 = Theme.HeaderBackground
HeaderOverlap.BorderSizePixel = 0
HeaderOverlap.Parent = HeaderFrame

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)
HeaderDivider.Position = UDim2.new(0, 0, 1, 0)
HeaderDivider.BackgroundColor3 = Theme.Border
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Parent = HeaderFrame

local HeaderDividerGradient = Instance.new("UIGradient")
HeaderDividerGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.AccentStart),
    ColorSequenceKeypoint.new(1, Theme.AccentEnd)
})
HeaderDividerGradient.Rotation = 0
HeaderDividerGradient.Parent = HeaderDivider

local HeaderGradient = Instance.new("UIGradient")
HeaderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 26))
})
HeaderGradient.Rotation = 90
HeaderGradient.Parent = HeaderFrame

local HeaderLabel = Instance.new("TextLabel")
HeaderLabel.Size = UDim2.new(1, -50, 1, 0)
HeaderLabel.Position = UDim2.fromOffset(15, 0)
HeaderLabel.BackgroundTransparency = 1
HeaderLabel.Text = "SIMPLE AIMBOT made by deus"
HeaderLabel.TextColor3 = Theme.TextPrimary
HeaderLabel.Font = Theme.FontBold
HeaderLabel.TextSize = 14
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
HeaderLabel.Parent = HeaderFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Position = UDim2.new(1, -36, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextSecondary
CloseBtn.Font = Theme.FontBold
CloseBtn.TextSize = 22
CloseBtn.Active = true
CloseBtn.Parent = HeaderFrame

local function makeFrameDraggable(dragHandle, targetFrame)
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil

    dragHandle.InputBegan:Connect(function(input)
        if isDraggingSlider then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function makeDraggable(frame, clickCallback)
    local dragToggle = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil
    local isDragging = false

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            isDragging = false
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then isDragging = true end
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    if clickCallback then
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not isDragging then clickCallback() end
            end
        end)
    end
end

local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.fromOffset(90, 36)
OpenBtn.Position = UDim2.new(0.5, -45, 0, 20)
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
OpenBtn.Text = "open ui"
OpenBtn.TextColor3 = Theme.TextPrimary
OpenBtn.Font = Theme.FontBold
OpenBtn.TextSize = 13
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 8)
OpenCorner.Parent = OpenBtn

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(255, 255, 255)
OpenStroke.Thickness = 1.5
OpenStroke.Parent = OpenBtn

local OpenStrokeGradient = Instance.new("UIGradient")
OpenStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
})
OpenStrokeGradient.Rotation = 45
OpenStrokeGradient.Parent = OpenStroke

local OpenGradient = Instance.new("UIGradient")
OpenGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
OpenGradient.Rotation = 90
OpenGradient.Parent = OpenBtn

local OpenTextGradient = Instance.new("UIGradient")
OpenTextGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 160, 160))
})
OpenTextGradient.Rotation = 90
OpenTextGradient.Parent = OpenBtn

OpenBtn.MouseEnter:Connect(function()
    TweenService:Create(OpenBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 40, 48) }):Play()
end)
OpenBtn.MouseLeave:Connect(function()
    TweenService:Create(OpenBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(20, 20, 24) }):Play()
end)

local FloatingAimBtn = Instance.new("TextButton")
FloatingAimBtn.Name = "FloatingAimBtn"
FloatingAimBtn.Size = UDim2.fromOffset(55, 55)
FloatingAimBtn.Position = UDim2.new(0.85, 0, 0.6, 0)
FloatingAimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
FloatingAimBtn.Text = "AIM"
FloatingAimBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
FloatingAimBtn.Font = Theme.FontBold
FloatingAimBtn.TextSize = 14
FloatingAimBtn.Visible = false
FloatingAimBtn.Active = true
FloatingAimBtn.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingAimBtn

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = Color3.fromRGB(255, 255, 255)
FloatingStroke.Thickness = 2
FloatingStroke.Parent = FloatingAimBtn

local FloatingStrokeGradient = Instance.new("UIGradient")
FloatingStrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.AccentStart),
    ColorSequenceKeypoint.new(1, Theme.AccentEnd)
})
FloatingStrokeGradient.Rotation = 45
FloatingStrokeGradient.Parent = FloatingStroke

local FloatingGradient = Instance.new("UIGradient")
FloatingGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
})
FloatingGradient.Rotation = 90
FloatingGradient.Parent = FloatingAimBtn

local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 120, 1, -42)
Sidebar.Position = UDim2.fromOffset(0, 42)
Sidebar.BackgroundColor3 = Theme.SidebarBackground
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarOverlap = Instance.new("Frame")
SidebarOverlap.Size = UDim2.new(0, 20, 1, 0)
SidebarOverlap.Position = UDim2.new(1, -20, 0, 0)
SidebarOverlap.BackgroundColor3 = Theme.SidebarBackground
SidebarOverlap.BorderSizePixel = 0
SidebarOverlap.Parent = Sidebar

local SidebarOverlapBottom = Instance.new("Frame")
SidebarOverlapBottom.Size = UDim2.new(1, 0, 0, 10)
SidebarOverlapBottom.Position = UDim2.new(0, 0, 1, -10)
SidebarOverlapBottom.BackgroundColor3 = Theme.SidebarBackground
SidebarOverlapBottom.BorderSizePixel = 0
SidebarOverlapBottom.Parent = Sidebar

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
SidebarDivider.BackgroundColor3 = Theme.Border
SidebarDivider.BorderSizePixel = 0
SidebarDivider.Parent = Sidebar

local SidebarGradient = Instance.new("UIGradient")
SidebarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 16))
})
SidebarGradient.Rotation = 90
SidebarGradient.Parent = Sidebar

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -135, 1, -55)
ContentContainer.Position = UDim2.fromOffset(130, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local function createPage(parent)
    local page = Instance.new("Frame")
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Parent = parent
    return page
end

local AimbotPage  = createPage(ContentContainer)  AimbotPage.Visible  = true
local VisualsPage = createPage(ContentContainer)   VisualsPage.Visible = false
local PlayerPage  = createPage(ContentContainer)   PlayerPage.Visible  = false

local isAnimating = false
local originalSize = UDim2.fromOffset(480, 380)

local function closeMenu()
    if isAnimating then return end
    isAnimating = true
    local currentPos = MainFrame.Position
    local closeTween = TweenService:Create(MainFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {
            Size = UDim2.fromOffset(0, 0),
            Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset + (originalSize.X.Offset/2),
                                  currentPos.Y.Scale, currentPos.Y.Offset + (originalSize.Y.Offset/2))
        })
    closeTween.Completed:Connect(function()
        MainFrame.Visible = false
        MainFrame.Size = originalSize
        MainFrame.Position = currentPos
        isAnimating = false
        OpenBtn.Size = UDim2.fromOffset(0, 0)
        OpenBtn.Visible = true
        TweenService:Create(OpenBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Size = UDim2.fromOffset(90, 36) }):Play()
    end)
    closeTween:Play()
end

local function openMenu()
    if isAnimating then return end
    isAnimating = true
    local targetPos = MainFrame.Position
    MainFrame.Size = UDim2.fromOffset(0, 0)
    MainFrame.Position = UDim2.new(targetPos.X.Scale, targetPos.X.Offset + (originalSize.X.Offset/2),
                                    targetPos.Y.Scale, targetPos.Y.Offset + (originalSize.Y.Offset/2))
    MainFrame.Visible = true
    local openTween = TweenService:Create(MainFrame,
        TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        { Size = originalSize, Position = targetPos })
    openTween.Completed:Connect(function() isAnimating = false end)
    openTween:Play()
    local openShrink = TweenService:Create(OpenBtn,
        TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        { Size = UDim2.fromOffset(0, 0) })
    openShrink.Completed:Connect(function()
        OpenBtn.Visible = false
        OpenBtn.Size = UDim2.fromOffset(90, 36)
    end)
    openShrink:Play()
end

CloseBtn.MouseButton1Click:Connect(closeMenu)
makeFrameDraggable(HeaderFrame, MainFrame)
makeFrameDraggable(Sidebar, MainFrame)
makeDraggable(OpenBtn, openMenu)
makeDraggable(FloatingAimBtn, function() toggleAimbot() end)

local function createButton(parent, text, pos, size)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    btn.Text = text
    btn.TextColor3 = Theme.TextPrimary
    btn.Font = Theme.FontMedium
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = btn

    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentStart),
        ColorSequenceKeypoint.new(1, Theme.AccentEnd)
    })
    strokeGradient.Rotation = 45
    strokeGradient.Enabled = false
    strokeGradient.Parent = stroke

    local btnTextGradient = Instance.new("UIGradient")
    btnTextGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
    })
    btnTextGradient.Rotation = 90
    btnTextGradient.Parent = btn

    btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local color = btn.BackgroundColor3
        if color == Color3.fromRGB(0, 120, 200) or color == Color3.fromRGB(0, 162, 255) then
            btn.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
            btn.TextColor3 = Color3.fromRGB(15, 15, 20)
            stroke.Thickness = 1.5
            strokeGradient.Enabled = true
        elseif color == Color3.fromRGB(30, 30, 40) or color == Color3.fromRGB(20, 20, 26) or color == Color3.fromRGB(24, 24, 30) then
            btn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            btn.TextColor3 = Theme.TextPrimary
            stroke.Color = Theme.Border
            stroke.Thickness = 1
            strokeGradient.Enabled = false
        elseif color == Color3.fromRGB(50, 40, 40) then
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            btn.TextColor3 = Theme.TextPrimary
            stroke.Color = Color3.fromRGB(150, 150, 160)
            stroke.Thickness = 1
            strokeGradient.Enabled = false
        end
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255) }):Play()
    end)
    btn.MouseLeave:Connect(function()
        if strokeGradient.Enabled then
            TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255) }):Play()
        else
            TweenService:Create(stroke, TweenInfo.new(0.2), { Color = Theme.Border }):Play()
        end
    end)

    return btn
end

local function makeTabButton(btn)
    btn.TextColor3 = Theme.TextSecondary
    btn:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        local color = btn.BackgroundColor3
        if color == Theme.AccentStart or color == Color3.fromRGB(240, 240, 250) then
            btn.TextColor3 = Color3.fromRGB(15, 15, 20)
        else
            btn.TextColor3 = Theme.TextSecondary
        end
    end)
end

local function createSlider(parent, text, pos, defaultVal, maxVal, callback)
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Size = UDim2.new(1, -10, 0, 45)
    sliderContainer.Position = pos
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.fromScale(0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Theme.TextSecondary
    label.Font = Theme.FontMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.fromOffset(0, 26)
    track.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    track.BorderSizePixel = 0
    track.Active = true
    track.Parent = sliderContainer

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(defaultVal / maxVal, 1)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local fillGradient = Instance.new("UIGradient")
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentStart),
        ColorSequenceKeypoint.new(1, Theme.AccentEnd)
    })
    fillGradient.Rotation = 0
    fillGradient.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(12, 12)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.fromScale(defaultVal / maxVal, 0.5)
    knob.BackgroundColor3 = Theme.TextPrimary
    knob.BorderSizePixel = 0
    knob.Active = true
    knob.Parent = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local knobStroke = Instance.new("UIStroke")
    knobStroke.Color = Theme.AccentStart
    knobStroke.Thickness = 1.5
    knobStroke.Parent = knob

    local knobStrokeGradient = Instance.new("UIGradient")
    knobStrokeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.AccentStart),
        ColorSequenceKeypoint.new(1, Theme.AccentEnd)
    })
    knobStrokeGradient.Rotation = 45
    knobStrokeGradient.Parent = knobStroke

    local draggingSlider = false
    local function updateSlider(input)
        local relativeX = input.Position.X - track.AbsolutePosition.X
        local percentage = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
        knob.Position = UDim2.fromScale(percentage, 0.5)
        fill.Size = UDim2.fromScale(percentage, 1)
        local calculatedValue = callback(percentage)
        label.Text = text .. ": " .. calculatedValue
    end

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            isDraggingSlider = true
            TweenService:Create(knob, TweenInfo.new(0.15), { BackgroundColor3 = Theme.AccentStart }):Play()
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
            isDraggingSlider = false
            TweenService:Create(knob, TweenInfo.new(0.15), { BackgroundColor3 = Theme.TextPrimary }):Play()
        end
    end)
end

local AimbotTabBtn  = createButton(Sidebar, "Aimbot",       UDim2.fromOffset(10, 15),  UDim2.fromOffset(100, 35))
AimbotTabBtn.BackgroundColor3 = Theme.AccentStart
makeTabButton(AimbotTabBtn)

local VisualsTabBtn = createButton(Sidebar, "Visuals", UDim2.fromOffset(10, 60),  UDim2.fromOffset(100, 35))
makeTabButton(VisualsTabBtn)

local PlayerTabBtn  = createButton(Sidebar, "Player",        UDim2.fromOffset(10, 105), UDim2.fromOffset(100, 35))
makeTabButton(PlayerTabBtn)

local function resetTabs()
    AimbotPage.Visible  = false
    VisualsPage.Visible = false
    PlayerPage.Visible  = false
    AimbotTabBtn.BackgroundColor3  = Color3.fromRGB(24, 24, 30)
    VisualsTabBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    PlayerTabBtn.BackgroundColor3  = Color3.fromRGB(24, 24, 30)
end

AimbotTabBtn.MouseButton1Click:Connect(function()
    resetTabs(); AimbotPage.Visible = true; AimbotTabBtn.BackgroundColor3 = Theme.AccentStart
end)
VisualsTabBtn.MouseButton1Click:Connect(function()
    resetTabs(); VisualsPage.Visible = true; VisualsTabBtn.BackgroundColor3 = Theme.AccentStart
end)
PlayerTabBtn.MouseButton1Click:Connect(function()
    resetTabs(); PlayerPage.Visible = true; PlayerTabBtn.BackgroundColor3 = Theme.AccentStart
end)


local StatusCard = Instance.new("Frame")
StatusCard.Size = UDim2.new(1, -10, 0, 32)
StatusCard.Position = UDim2.fromOffset(0, 5)
StatusCard.BackgroundColor3 = Theme.ActiveRedBg
StatusCard.Parent = AimbotPage

local StatusCardCorner = Instance.new("UICorner")
StatusCardCorner.CornerRadius = UDim.new(0, 6)
StatusCardCorner.Parent = StatusCard

local StatusCardStroke = Instance.new("UIStroke")
StatusCardStroke.Color = Theme.ActiveRed
StatusCardStroke.Thickness = 1
StatusCardStroke.Parent = StatusCard

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.fromOffset(10, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "AIMBOT STATUS: DEACTIVATED"
StatusLabel.TextColor3 = Theme.ActiveRed
StatusLabel.Font = Theme.FontBold
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.TextSize = 13
StatusLabel.Parent = StatusCard

StatusLabel:GetPropertyChangedSignal("TextColor3"):Connect(function()
    local color = StatusLabel.TextColor3
    if color == Theme.ActiveGreen then
        TweenService:Create(StatusCardStroke, TweenInfo.new(0.3), { Color = Color3.fromRGB(255, 255, 255) }):Play()
        TweenService:Create(StatusCard,       TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(35, 35, 35) }):Play()
    else
        TweenService:Create(StatusCardStroke, TweenInfo.new(0.3), { Color = Color3.fromRGB(100, 100, 100) }):Play()
        TweenService:Create(StatusCard,       TweenInfo.new(0.3), { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }):Play()
    end
end)

local BindLabel = Instance.new("TextLabel")
BindLabel.Size = UDim2.new(0, 100, 0, 30)
BindLabel.Position = UDim2.fromOffset(0, 47)
BindLabel.BackgroundTransparency = 1
BindLabel.Text = "Aimbot Bind:"
BindLabel.TextColor3 = Theme.TextSecondary
BindLabel.Font = Theme.FontMedium
BindLabel.TextXAlignment = Enum.TextXAlignment.Left
BindLabel.TextSize = 13
BindLabel.Parent = AimbotPage

local KeybindBtn = createButton(AimbotPage, "[ " .. toggleKey.Name .. " ]", UDim2.fromOffset(110, 47), UDim2.fromOffset(120, 30))

local UIBindLabel = Instance.new("TextLabel")
UIBindLabel.Size = UDim2.new(0, 100, 0, 30)
UIBindLabel.Position = UDim2.fromOffset(0, 82)
UIBindLabel.BackgroundTransparency = 1
UIBindLabel.Text = "UI Toggle Bind:"
UIBindLabel.TextColor3 = Theme.TextSecondary
UIBindLabel.Font = Theme.FontMedium
UIBindLabel.TextXAlignment = Enum.TextXAlignment.Left
UIBindLabel.TextSize = 13
UIBindLabel.Parent = AimbotPage

local UIKeybindBtn = createButton(AimbotPage, "[ " .. uiToggleKey.Name .. " ]", UDim2.fromOffset(110, 82), UDim2.fromOffset(120, 30))

createSlider(AimbotPage, "FOV Radius", UDim2.fromOffset(0, 122), fovRadius, 400, function(percent)
    fovRadius = math.clamp(math.round(percent * 400), 10, 400)
    FOVCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
    return fovRadius
end)

createSlider(AimbotPage, "Aim Tracking speed", UDim2.fromOffset(0, 175), math.round(aimSpeed * 100), 100, function(percent)
    aimSpeed = math.clamp(percent, 0.02, 1)
    if aimSpeed >= 0.96 then aimSpeed = 1 end
    if aimSpeed == 1 then return "100% (Instant)" else return math.round(aimSpeed * 100) .. "%" end
end)

local TeamCheckBtn = createButton(AimbotPage, "Team Check: OFF", UDim2.fromOffset(0, 230), UDim2.fromOffset(160, 32))
TeamCheckBtn.MouseButton1Click:Connect(function()
    teamCheckEnabled = not teamCheckEnabled
    TeamCheckBtn.Text = teamCheckEnabled and "Team Check: ON" or "Team Check: OFF"
    TeamCheckBtn.BackgroundColor3 = teamCheckEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
end)

local Aimbot360Btn = createButton(AimbotPage, "360 Aimbot: OFF", UDim2.fromOffset(170, 230), UDim2.fromOffset(160, 32))
Aimbot360Btn.MouseButton1Click:Connect(function()
    aimbot360Enabled = not aimbot360Enabled
    Aimbot360Btn.Text = aimbot360Enabled and "360 Aimbot: ON" or "360 Aimbot: OFF"
    Aimbot360Btn.BackgroundColor3 = aimbot360Enabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
    FOVCircle.Visible = not aimbot360Enabled
end)

local MobileAimbotMenuBtn = createButton(AimbotPage, "Mobile aimbot: OFF", UDim2.fromOffset(0, 272), UDim2.fromOffset(330, 32))
MobileAimbotMenuBtn.MouseButton1Click:Connect(function()
    FloatingAimBtn.Visible = not FloatingAimBtn.Visible
    MobileAimbotMenuBtn.Text = FloatingAimBtn.Visible and "Mobile aimbot: ON" or "Mobile aimbot: OFF"
    MobileAimbotMenuBtn.BackgroundColor3 = FloatingAimBtn.Visible and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
end)



local MasterESPBtn = createButton(VisualsPage, "Master ESP: OFF",       UDim2.fromOffset(0, 10), UDim2.fromOffset(330, 32))
local BoxESPBtn    = createButton(VisualsPage, "Chams: OFF",             UDim2.fromOffset(0, 50), UDim2.fromOffset(330, 32))
local NameESPBtn   = createButton(VisualsPage, "Names and Health: OFF",  UDim2.fromOffset(0, 90), UDim2.fromOffset(330, 32))

local updateESPConfig

MasterESPBtn.MouseButton1Click:Connect(function()
    espMasterEnabled = not espMasterEnabled
    MasterESPBtn.Text = espMasterEnabled and "Master ESP: ON" or "Master ESP: OFF"
    MasterESPBtn.BackgroundColor3 = espMasterEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
    updateESPConfig()
end)
BoxESPBtn.MouseButton1Click:Connect(function()
    espShowBoxes = not espShowBoxes
    BoxESPBtn.Text = espShowBoxes and "Chams: ON" or "Chams: OFF"
    BoxESPBtn.BackgroundColor3 = espShowBoxes and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
    updateESPConfig()
end)
NameESPBtn.MouseButton1Click:Connect(function()
    espShowNames = not espShowNames
    NameESPBtn.Text = espShowNames and "Names and Health: ON" or "Names and Health: OFF"
    NameESPBtn.BackgroundColor3 = espShowNames and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
    updateESPConfig()
end)

local NoclipBtn = createButton(PlayerPage, "Noclip: OFF", UDim2.fromOffset(0, 10), UDim2.fromOffset(330, 32))
NoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipBtn.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
    NoclipBtn.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
end)

local function removeFlyConstraints()
    if flyLinearVelocity then flyLinearVelocity:Destroy(); flyLinearVelocity = nil end
    if flyAlignOrientation then flyAlignOrientation:Destroy(); flyAlignOrientation = nil end
    if flyAttachment then flyAttachment:Destroy(); flyAttachment = nil end
    
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

local FlyBtn = createButton(PlayerPage, "Fly: OFF", UDim2.fromOffset(0, 50), UDim2.fromOffset(330, 32))
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
    FlyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(30, 30, 40)
    
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then 
        if not flying then removeFlyConstraints() end
        return 
    end
    
    local hrp = char.HumanoidRootPart
    
    if flying then
        removeFlyConstraints() 
        
        flyAttachment = Instance.new("Attachment")
        flyAttachment.Name = "FlyConstraintAttachment"
        flyAttachment.Parent = hrp
        
        flyLinearVelocity = Instance.new("LinearVelocity")
        flyLinearVelocity.Name = "FlyLinearVelocity"
        flyLinearVelocity.Attachment0 = flyAttachment
        flyLinearVelocity.MaxForce = math.huge
        flyLinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        flyLinearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
        flyLinearVelocity.Parent = hrp
        
        flyAlignOrientation = Instance.new("AlignOrientation")
        flyAlignOrientation.Name = "FlyAlignOrientation"
        flyAlignOrientation.Attachment0 = flyAttachment
        flyAlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        flyAlignOrientation.MaxTorque = math.huge
        flyAlignOrientation.Responsiveness = 200
        flyAlignOrientation.CFrame = hrp.CFrame
        flyAlignOrientation.Parent = hrp
        
        char.Humanoid.PlatformStand = true
    else
        removeFlyConstraints()
    end
end)

local FpsContainer = Instance.new("Frame")
FpsContainer.Size = UDim2.new(0, 330, 0, 32)
FpsContainer.Position = UDim2.fromOffset(0, 95)
FpsContainer.BackgroundTransparency = 1
FpsContainer.Parent = PlayerPage

local FpsLabel = Instance.new("TextLabel")
FpsLabel.Size = UDim2.new(0, 200, 1, 0)
FpsLabel.Position = UDim2.fromOffset(0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS Spoofer limit (0 to uncap):"
FpsLabel.TextColor3 = Theme.TextSecondary
FpsLabel.Font = Theme.FontMedium
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.TextSize = 13
FpsLabel.Parent = FpsContainer

local FpsInput = Instance.new("TextBox")
FpsInput.Size = UDim2.fromOffset(120, 32)
FpsInput.Position = UDim2.new(1, -120, 0, 0)
FpsInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FpsInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsInput.Font = Theme.FontBold
FpsInput.TextSize = 13
FpsInput.Text = "60"
FpsInput.Parent = FpsContainer

local FpsCorner = Instance.new("UICorner")
FpsCorner.CornerRadius = UDim.new(0, 6)
FpsCorner.Parent = FpsInput

local FpsStroke = Instance.new("UIStroke")
FpsStroke.Color = Color3.fromRGB(255, 255, 255)
FpsStroke.Thickness = 1
FpsStroke.Parent = FpsInput

FpsInput.Focused:Connect(function()
    TweenService:Create(FpsStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(200, 200, 200) }):Play()
end)
FpsInput.FocusLost:Connect(function()
    TweenService:Create(FpsStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(255, 255, 255) }):Play()
    local num = tonumber(FpsInput.Text)
    if setfpscap then
        pcall(function()
            if num and num > 0 then
                setfpscap(num)
            else
                setfpscap(9999)
                FpsInput.Text = "9999"
            end
        end)
    end
end)



function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        StatusLabel.Text = "AIMBOT STATUS: ACTIVE"
        StatusLabel.TextColor3 = Theme.ActiveGreen
        FloatingAimBtn.TextColor3 = Color3.fromRGB(15, 15, 20)
        FloatingAimBtn.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
        FloatingStroke.Color = Theme.AccentStart
    else
        StatusLabel.Text = "AIMBOT STATUS: DEACTIVATED"
        StatusLabel.TextColor3 = Theme.ActiveRed
        FloatingAimBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        FloatingAimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        FloatingStroke.Color = Color3.fromRGB(255, 255, 255)
        targetPlayer = nil
    end
end

FloatingAimBtn.MouseEnter:Connect(function()
    if not aimbotEnabled then
        TweenService:Create(FloatingAimBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40, 40, 48) }):Play()
    end
end)
FloatingAimBtn.MouseLeave:Connect(function()
    if not aimbotEnabled then
        TweenService:Create(FloatingAimBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(20, 20, 24) }):Play()
    end
end)

KeybindBtn.MouseButton1Click:Connect(function()
    listeningForKey = true
    KeybindBtn.Text = "... Press Key ..."
    KeybindBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
end)
UIKeybindBtn.MouseButton1Click:Connect(function()
    listeningForUIKey = true
    UIKeybindBtn.Text = "... Press Key ..."
    UIKeybindBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 40)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        toggleKey = input.KeyCode
        listeningForKey = false
        KeybindBtn.Text = "[ " .. toggleKey.Name .. " ]"
        KeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        return
    end
    if listeningForUIKey and input.UserInputType == Enum.UserInputType.Keyboard then
        uiToggleKey = input.KeyCode
        listeningForUIKey = false
        UIKeybindBtn.Text = "[ " .. uiToggleKey.Name .. " ]"
        UIKeybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        return
    end
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == toggleKey then
        toggleAimbot()
    elseif input.KeyCode == uiToggleKey then
        if MainFrame.Visible then closeMenu() else openMenu() end
    end
end)

local function hasLineOfSight(targetCharacter, targetHead)
    local origin = Camera.CFrame.Position
    local direction = (targetHead.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local filterInstances = {LocalPlayer.Character}
    for _, obj in ipairs(targetCharacter:GetChildren()) do
        if obj:IsA("Accessory") then table.insert(filterInstances, obj) end
    end
    raycastParams.FilterDescendantsInstances = filterInstances
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    if not raycastResult or raycastResult.Instance:IsDescendantOf(targetCharacter) then
        return true
    end
    return false
end

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if teamCheckEnabled and LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team then
                continue
            end
            local character = player.Character
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if aimbot360Enabled then
                    local dist3D = (head.Position - Camera.CFrame.Position).Magnitude
                    if dist3D < shortestDistance and hasLineOfSight(character, head) then
                        shortestDistance = dist3D
                        closestPlayer = character
                    end
                else
                    if onScreen then
                        local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distanceToCenter <= fovRadius and distanceToCenter < shortestDistance then
                            if hasLineOfSight(character, head) then
                                shortestDistance = distanceToCenter
                                closestPlayer = character
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function clearESPElements(character)
    if character:FindFirstChild("ESPHighlight") then character.ESPHighlight:Destroy() end
    if character:FindFirstChild("ESPBillboard") then character.ESPBillboard:Destroy() end
end

local function applyESPToPlayer(player)
    local function onCharacterRender(character)
        clearESPElements(character)
        if not espMasterEnabled then return end
        if espShowBoxes then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Theme.AccentStart
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = character
        end
        if espShowNames then
            local head = character:WaitForChild("Head", 5)
            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPBillboard"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.fromOffset(120, 35)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.Adornee = head
                local label = Instance.new("TextLabel")
                label.Size = UDim2.fromScale(1, 1)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.Font = Theme.FontBold
                label.TextSize = 12
                label.Parent = billboard
                billboard.Parent = character
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local connection
                    local function syncStats()
                        if character.Parent and humanoid.Parent then
                            label.Text = string.format("%s\n[ HP: %d ]", player.Name, math.round(humanoid.Health))
                        else
                            if connection then connection:Disconnect() end
                        end
                    end
                    connection = humanoid:GetPropertyChangedSignal("Health"):Connect(syncStats)
                    syncStats()
                end
            end
        end
    end
    player.CharacterAdded:Connect(onCharacterRender)
    if player.Character then task.spawn(onCharacterRender, player.Character) end
end

function updateESPConfig()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            task.spawn(clearESPElements, player.Character)
            applyESPToPlayer(player)
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        if espMasterEnabled then applyESPToPlayer(player) end
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    if player.Character then clearESPElements(player.Character) end
end)

-- Clear constraints if player resets/spawns while flying
LocalPlayer.CharacterRemoving:Connect(function()
    removeFlyConstraints()
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

RunService.PreSimulation:Connect(function()
    if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local camCFrame = Camera.CFrame
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
        
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
            moveDir = moveDir + humanoid.MoveDirection
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end
        
        if flyLinearVelocity and flyAlignOrientation then
            flyLinearVelocity.VectorVelocity = moveDir * flySpeed
            flyAlignOrientation.CFrame = camCFrame
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        targetPlayer = getClosestTarget()
    end
    if aimbotEnabled and targetPlayer and targetPlayer:FindFirstChild("Head") then
        local targetHead = targetPlayer.Head
        local currentCFrame = Camera.CFrame
        local targetRotation = CFrame.new(currentCFrame.Position, targetHead.Position)
        if aimSpeed == 1 then
            Camera.CFrame = targetRotation
        else
            Camera.CFrame = currentCFrame:Lerp(targetRotation, aimSpeed)
        end
    end
end)
