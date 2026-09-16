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
    if not model:IsA("Model") then
        return false
    end

    if model == Player.Character then
        return false
    end

    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local root = model:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return false
    end

    if humanoid.Health <= 0 then
        return false
    end

    return not root.Anchored
end

function MobController:GetNearbyMobs()
    local playerRoot = getRoot()

    if not playerRoot then
        return {}
    end

    local mobs = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isNPC(obj) then
            local root = obj:FindFirstChild("HumanoidRootPart")

            if root then
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

    if not playerRoot or not mobRoot then
        return
    end

    local offset = mobRoot.Position - playerRoot.Position
    local distance = offset.Magnitude

    if distance <= self.Radius and distance > self.PullDistance then
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
