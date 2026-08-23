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

-- Función agregada del ESP
local function clearESPElements(character)
    if not character then return end
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant.Name == "HighlightESP" or descendant.Name == "TextESP" then
            descendant:Destroy()
        end
    end
end

-- Aquí va el resto de la lógica del script original de Murder Duels:
local rawScript = game:HttpGet("https://raw.githubusercontent.com/imshrak/murder-duels/refs/heads/main/main")
-- (Si necesitas integrar funciones internas del loadstring original, avísame y las fundimos bien).

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        clearESPElements(player.Character)
    end
end)
