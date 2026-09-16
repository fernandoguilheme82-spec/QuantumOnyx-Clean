local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")

local Player = Players.LocalPlayer

local MobController = {
    Enabled = false,
    Radius = 80,
    PullDistance = 6,
    UpdateRate = 0.15,
    MobTag = "Mob",
}

local function getRoot()
    local character = Player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function getMobRoot(mob)
    if not mob or not mob:IsA("Model") then
        return nil
    end

    local humanoid = mob:FindFirstChildOfClass("Humanoid")
    local root = mob:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root or humanoid.Health <= 0 then
        return nil
    end

    return root
end

function MobController:GetNearbyMobs()
    local playerRoot = getRoot()
    if not playerRoot then
        return {}
    end

    local result = {}

    for _, mob in ipairs(CollectionService:GetTagged(self.MobTag)) do
        local root = getMobRoot(mob)

        if root then
            local distance =
                (root.Position - playerRoot.Position).Magnitude

            if distance <= self.Radius then
                table.insert(result, mob)
            end
        end
    end

    return result
end

function MobController:BringMob(mob)
    local playerRoot = getRoot()
    local mobRoot = getMobRoot(mob)

    if not playerRoot or not mobRoot then
        return
    end

    local target =
        playerRoot.Position
        + Vector3.new(0, -self.PullDistance, 0)

    -- Move o modelo inteiro de uma vez.
    mob:PivotTo(CFrame.new(target))

    -- Evita que a física imediatamente empurre o NPC para longe.
    for _, part in ipairs(mob:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = Vector3.zero
            part.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

function MobController:Update()
    if not self.Enabled then
        return
    end

    for _, mob in ipairs(self:GetNearbyMobs()) do
        self:BringMob(mob)
    end
end

function MobController:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            self:Update()
            task.wait(self.UpdateRate)
        end
    end)
end

function MobController:Stop()
    self.Enabled = false
end

function MobController:Init(Window)
    local Tab = Window:CreateTab({
        name = "Mob Controller",
    })

    Tab:CreateToggle({
        name = "Bring Mobs",
        default = false,

        callback = function(enabled)
            if enabled then
                self:Start()
            else
                self:Stop()
            end
        end,
    })

    Tab:CreateSlider({
        name = "Distância",
        range = {20, 300},
        increment = 5,
        suffix = " studs",
        currentValue = self.Radius,

        callback = function(value)
            self.Radius = value
        end,
    })

    Tab:CreateSlider({
        name = "Altura abaixo do jogador",
        range = {1, 20},
        increment = 1,
        suffix = " studs",
        currentValue = self.PullDistance,

        callback = function(value)
            self.PullDistance = value
        end,
    })
end

return MobController
