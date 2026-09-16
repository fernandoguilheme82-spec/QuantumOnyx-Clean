local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer

local NPCAttackTest = {
    Enabled = false,
    Distance = 20,
    UpdateRate = 0.25,
    MobTag = "Mob",

    -- Defina esta função no seu sistema de combate.
    AttackFunction = nil
}

local function getRoot()
    local character = Player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function isValidMob(mob)
    if not mob:IsA("Model") or mob == Player.Character then
        return false
    end

    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    local root = mob:FindFirstChild("HumanoidRootPart")

    return humanoid
        and root
        and humanoid.Health > 0
end

function NPCAttackTest:SetDistance(value)
    self.Distance = math.clamp(tonumber(value) or 20, 5, 100)
end

function NPCAttackTest:GetNearbyMobs()
    local playerRoot = getRoot()
    if not playerRoot then
        return {}
    end

    local result = {}

    for _, mob in ipairs(CollectionService:GetTagged(self.MobTag)) do
        if isValidMob(mob) then
            local root = mob:FindFirstChild("HumanoidRootPart")

            if root and (root.Position - playerRoot.Position).Magnitude <= self.Distance then
                table.insert(result, mob)
            end
        end
    end

    return result
end

function NPCAttackTest:Attack(mob)
    if not self.AttackFunction then
        return
    end

    self.AttackFunction(mob)
end

function NPCAttackTest:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            for _, mob in ipairs(self:GetNearbyMobs()) do
                self:Attack(mob)
            end

            task.wait(self.UpdateRate)
        end
    end)
end

function NPCAttackTest:Stop()
    self.Enabled = false
end

function NPCAttackTest:Init(Window)
    local Tab = Window:CreateTab({
        name = "NPC Attack"
    })

    Tab:CreateToggle({
        name = "NPC Attack Test",
        default = false,
        callback = function(value)
            if value then
                self:Start()
            else
                self:Stop()
            end
        end
    })

    Tab:CreateSlider({
        name = "Distância",
        range = {5, 100},
        increment = 5,
        suffix = " studs",
        currentValue = self.Distance,
        callback = function(value)
            self:SetDistance(value)
        end
    })
end

return NPCAttackTest
