local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer

local MobController = {
    Enabled = false,
    Radius = 80,
    PullDistance = 12,
    UpdateRate = 0.25,
    MobTag = "Mob"
}

local function getRoot()
    local character = Player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function isValidMob(mob)
    if not mob:IsA("Model") then
        return false
    end

    if mob == Player.Character then
        return false
    end

    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    local root = mob:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return false
    end

    if humanoid.Health <= 0 or root.Anchored then
        return false
    end

    return true
end

function MobController:GetNearbyMobs()
    local playerRoot = getRoot()

    if not playerRoot then
        return {}
    end

    local mobs = {}

    for _, mob in ipairs(CollectionService:GetTagged(self.MobTag)) do
        if isValidMob(mob) then
            local root = mob:FindFirstChild("HumanoidRootPart")

            if root then
                local distance = (root.Position - playerRoot.Position).Magnitude

                if distance <= self.Radius then
                    table.insert(mobs, mob)
                end
            end
        end
    end

    return mobs
end

function MobController:BringMob(mob)
    if not isValidMob(mob) then
        return
    end

    local playerRoot = getRoot()
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")

    if not playerRoot or not mobRoot then
        return
    end

    local offset = mobRoot.Position - playerRoot.Position
    local distance = offset.Magnitude

    if distance > self.Radius or distance <= self.PullDistance then
        return
    end

    -- Move apenas uma vez por ciclo.
    -- Não mantém o NPC sendo reposicionado continuamente.
    mob:PivotTo(
        CFrame.new(
            playerRoot.Position + offset.Unit * self.PullDistance
        )
    )
end

function MobController:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            local mobs = self:GetNearbyMobs()

            for _, mob in ipairs(mobs) do
                self:BringMob(mob)
            end

            task.wait(self.UpdateRate)
        end
    end)
end

function MobController:Stop()
    self.Enabled = false
end

function MobController:Init(Window)
    local Tab = Window:CreateTab({
        name = "Mob Controller"
    })

    Tab:CreateToggle({
        name = "Mob Controller",
        default = false,
        callback = function(Value)
            if Value then
                self:Start()
            else
                self:Stop()
            end
        end
    })
end

return MobController
