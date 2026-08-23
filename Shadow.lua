local espConnections = {}

local function clearESPElements(character)
    if not character then return end

    local highlight = character:FindFirstChild("ESPHighlight")
    if highlight then
        highlight:Destroy()
    end

    local billboard = character:FindFirstChild("ESPBillboard")
    if billboard then
        billboard:Destroy()
    end
end

local function disconnectESPConnection(player)
    if espConnections[player] then
        espConnections[player]:Disconnect()
        espConnections[player] = nil
    end
end

local function applyESPToPlayer(player)
    if not player or player == LocalPlayer then
        return
    end

    disconnectESPConnection(player)

    local function onCharacterRender(character)
        if not character or not character.Parent then
            return
        end

        clearESPElements(character)

        if not espMasterEnabled then
            return
        end

        if espShowBoxes then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Adornee = character

            -- Visible through walls
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            highlight.FillColor = Theme.AccentStart
            highlight.FillTransparency = 0.6
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end

        if espShowNames then
            local head = character:FindFirstChild("Head")
                or character:WaitForChild("Head", 5)

            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if head then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPBillboard"
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 10000
                billboard.Size = UDim2.fromOffset(120, 35)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.Adornee = head
                billboard.Parent = character

                local label = Instance.new("TextLabel")
                label.Size = UDim2.fromScale(1, 1)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextStrokeTransparency = 0
                label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                label.Font = Theme.FontBold
                label.TextSize = 12
                label.Parent = billboard

                local function syncStats()
                    if not label.Parent then
                        return
                    end

                    if humanoid and humanoid.Parent then
                        label.Text = string.format(
                            "%s\n[ HP: %d ]",
                            player.Name,
                            math.max(0, math.round(humanoid.Health))
                        )
                    else
                        label.Text = player.Name
                    end
                end

                syncStats()

                if humanoid then
                    humanoid:GetPropertyChangedSignal("Health"):Connect(syncStats)
                end
            end
        end
    end

    espConnections[player] =
        player.CharacterAdded:Connect(function(character)
            task.wait(0.15)

            if player.Parent then
                onCharacterRender(character)
            end
        end)

    if player.Character then
        task.spawn(onCharacterRender, player.Character)
    end
end

function updateESPConfig()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player.Character then
                clearESPElements(player.Character)
            end

            if espMasterEnabled then
                applyESPToPlayer(player)
            else
                disconnectESPConnection(player)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        applyESPToPlayer(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    disconnectESPConnection(player)

    if player.Character then
        clearESPElements(player.Character)
    end
end)
