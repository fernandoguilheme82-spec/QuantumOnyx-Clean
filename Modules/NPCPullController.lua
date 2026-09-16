local CollectionService = game:GetService("CollectionService")

local NPCPullController = {
    Enabled = false,
    Distance = 35,
    PullHeight = -5,
    UpdateRate = 0.1,
    MobTag = "Mob",
}

local function getRoot(model)
    return model:FindFirstChild("HumanoidRootPart")
end

local function isValidNPC(npc)
    if not npc:IsA("Model") then
        return false
    end

    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    local root = getRoot(npc)

    return humanoid
        and root
        and humanoid.Health > 0
end

function NPCPullController:GetNearbyNPCs(player)
    local character = player.Character
    local playerRoot = character and character:FindFirstChild("HumanoidRootPart")

    if not playerRoot then
        return {}
    end

    local result = {}

    for _, npc in ipairs(CollectionService:GetTagged(self.MobTag)) do
        if isValidNPC(npc) then
            local root = getRoot(npc)

            if (root.Position - playerRoot.Position).Magnitude <= self.Distance then
                table.insert(result, npc)
            end
        end
    end

    return result
end

function NPCPullController:PullNPC(npc, player)
    if not isValidNPC(npc) then
        return
    end

    local character = player.Character
    local playerRoot = character and character:FindFirstChild("HumanoidRootPart")
    local npcRoot = getRoot(npc)

    if not playerRoot or not npcRoot then
        return
    end

    local target = playerRoot.Position
        + Vector3.new(0, self.PullHeight, 0)

    npcRoot.CFrame = CFrame.new(target)
    npcRoot.AssemblyLinearVelocity = Vector3.zero
    npcRoot.AssemblyAngularVelocity = Vector3.zero
end

function NPCPullController:Update(player)
    if not self.Enabled then
        return
    end

    for _, npc in ipairs(self:GetNearbyNPCs(player)) do
        self:PullNPC(npc, player)
    end
end

function NPCPullController:Start(player)
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            self:Update(player)
            task.wait(self.UpdateRate)
        end
    end)
end

function NPCPullController:Stop()
    self.Enabled = false
end

return NPCPullController
