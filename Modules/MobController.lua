local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local MobController = {
    Enabled = false,
    Radius = 80,
    PullDistance = 12,
    UpdateRate = 0.15
}

local function getRoot()
    local character = Player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function isNPC(model)
    if not model:IsA("Model") or model == Player.Character then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    return humanoid ~= nil
        and root ~= nil
        and humanoid.Health > 0
end

function MobController:GetNearbyMobs()
    local playerRoot = getRoot()
    if not playerRoot then
        return {}
    end

    local mobs = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            local root = obj.HumanoidRootPart

            if not root.Anchored then
                local distance = (root.Position - playerRoot.Position).Magnitude

                if distance <= self.Radius then
                    table.insert(mobs, obj)
                end
            end
        end
    end

    return mobs
end

function MobController:PullMob(mob)
    if not isNPC(mob) then
        return
    end

    local playerRoot = getRoot()
    local mobRoot = mob:FindFirstChild("HumanoidRootPart")

    if not playerRoot or not mobRoot or mobRoot.Anchored then
        return
    end

    local offset = mobRoot.Position - playerRoot.Position

    if offset.Magnitude > self.PullDistance
        and offset.Magnitude <= self.Radius then

        mobRoot.CFrame = CFrame.new(
            playerRoot.Position + offset.Unit * self.PullDistance
        )
    end
end

function MobController:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            for _, mob in ipairs(self:GetNearbyMobs()) do
                self:PullMob(mob)
            end

            task.wait(self.UpdateRate)
        end
    end)
end

function MobController:Stop()
    self.Enabled = false
end

function MobController:Toggle()
    if self.Enabled then
        self:Stop()
    else
        self:Start()
    end

    return self.Enabled
end

return MobController
