local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local NPCPullController = require(
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NPCPullController")
)

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

local CONFIG = {
    Distance = 35,
    Damage = 10,
    AttackCooldown = 0.6,
    UpdateRate = 0.1,
    PullHeight = -5,
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

ToggleAura.OnServerEvent:Connect(function(player, enabled)
    if typeof(enabled) ~= "boolean" then
        return
    end

    state[player] = state[player] or {
        Enabled = false,
        LastAttack = {},
    }

    state[player].Enabled = enabled

    NPCPullController.Distance = CONFIG.Distance
    NPCPullController.PullHeight = CONFIG.PullHeight

    if enabled then
        NPCPullController:Start(player)
    else
        NPCPullController:Stop()
        state[player].LastAttack = {}
    end
end)

task.spawn(function()
    while true do
        for player, data in pairs(state) do
            if data.Enabled then
                local playerRoot = getRoot(player)

                if playerRoot then
                    for _, npc in ipairs(
                        CollectionService:GetTagged("Mob")
                    ) do
                        local humanoid, npcRoot = getNPC(npc)

                        if humanoid and npcRoot then
                            local distance =
                                (npcRoot.Position - playerRoot.Position).Magnitude

                            if distance <= CONFIG.Distance then
                                local now = os.clock()
                                local last =
                                    data.LastAttack[npc] or 0

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

Players.PlayerRemoving:Connect(function(player)
    state[player] = nil
    NPCPullController:Stop()
end)
