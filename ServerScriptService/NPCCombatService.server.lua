-- NPCCombatService.server.lua
-- Servidor autoritativo: ataque + posicionamento acima do NPC

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if not Remotes then
    Remotes = Instance.new("Folder")
    Remotes.Name = "Remotes"
    Remotes.Parent = ReplicatedStorage
end

local ToggleAura = Remotes:FindFirstChild("ToggleNPCAura")
if not ToggleAura then
    ToggleAura = Instance.new("RemoteEvent")
    ToggleAura.Name = "ToggleNPCAura"
    ToggleAura.Parent = Remotes
end

local ToggleAbove = Remotes:FindFirstChild("ToggleAboveNPC")
if not ToggleAbove then
    ToggleAbove = Instance.new("RemoteEvent")
    ToggleAbove.Name = "ToggleAboveNPC"
    ToggleAbove.Parent = Remotes
end

local CONFIG = {
    DefaultDistance = 20,
    MinDistance = 5,
    MaxDistance = 100,
    Damage = 10,
    AttackCooldown = 0.6,
    AboveHeight = 8,
    UpdateRate = 0.1,
    MobTag = "Mob",
}

local state = {}

local function getRoot(player)
    local character = player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getNPC(npc)
    if not npc:IsA("Model") then
        return
    end

    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local root = npc:FindFirstChild("HumanoidRootPart")

    if humanoid and root and humanoid.Health > 0 then
        return humanoid, root
    end
end

local function getNearestNPC(player, distance)
    local playerRoot = getRoot(player)
    if not playerRoot then
        return
    end

    local nearest
    local nearestDistance = distance

    for _, npc in ipairs(CollectionService:GetTagged(CONFIG.MobTag)) do
        local humanoid, root = getNPC(npc)

        if humanoid and root then
            local d = (root.Position - playerRoot.Position).Magnitude

            if d <= nearestDistance then
                nearest = npc
                nearestDistance = d
            end
        end
    end

    return nearest
end

ToggleAura.OnServerEvent:Connect(function(player, enabled, distance)
    if typeof(enabled) ~= "boolean" then
        return
    end

    distance = math.clamp(
        tonumber(distance) or CONFIG.DefaultDistance,
        CONFIG.MinDistance,
        CONFIG.MaxDistance
    )

    state[player] = state[player] or {
        Aura = false,
        Above = false,
        Distance = CONFIG.DefaultDistance,
        LastAttack = {},
    }

    state[player].Aura = enabled
    state[player].Distance = distance

    if not enabled then
        state[player].LastAttack = {}
    end
end)

ToggleAbove.OnServerEvent:Connect(function(player, enabled)
    if typeof(enabled) ~= "boolean" then
        return
    end

    state[player] = state[player] or {
        Aura = false,
        Above = false,
        Distance = CONFIG.DefaultDistance,
        LastAttack = {},
    }

    state[player].Above = enabled
end)

task.spawn(function()
    while true do
        for player, data in pairs(state) do
            if data.Aura then
                local playerRoot = getRoot(player)

                if playerRoot then
                    for _, npc in ipairs(CollectionService:GetTagged(CONFIG.MobTag)) do
                        local humanoid, npcRoot = getNPC(npc)

                        if humanoid and npcRoot then
                            local distance =
                                (npcRoot.Position - playerRoot.Position).Magnitude

                            if distance <= data.Distance then
                                local now = os.clock()
                                local last = data.LastAttack[npc] or 0

                                if now - last >= CONFIG.AttackCooldown then
                                    data.LastAttack[npc] = now
                                    humanoid:TakeDamage(CONFIG.Damage)
                                end
                            end
                        end
                    end
                end
            end
        end

        task.wait(CONFIG.UpdateRate)
    end
end)

task.spawn(function()
    while true do
        for player, data in pairs(state) do
            if data.Above then
                local playerRoot = getRoot(player)

                if playerRoot then
                    local npc = getNearestNPC(player, data.Distance)

                    if npc then
                        local _, npcRoot = getNPC(npc)

                        if npcRoot then
                            local position =
                                npcRoot.Position
                                + Vector3.new(0, CONFIG.AboveHeight, 0)

                            playerRoot.CFrame = CFrame.new(
                                position,
                                npcRoot.Position
                            )
                        end
                    end
                end
            end
        end

        task.wait(CONFIG.UpdateRate)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    state[player] = nil
end)
