local Players = game:GetService("Players")

local AutoFarm = {
    Enabled = false,
    Target = nil
}

function AutoFarm:SetTarget(npc)
    self.Target = npc
end

function AutoFarm:FindNPC(name)
    local npc = workspace:FindFirstChild(name, true)

    if npc and npc:IsA("Model") then
        return npc
    end

    return nil
end

function AutoFarm:GoToNPC(npc)
    local player = Players.LocalPlayer
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid or not npc then
        return false
    end

    local target = npc:FindFirstChild("HumanoidRootPart")
        or npc.PrimaryPart

    if not target then
        return false
    end

    humanoid:MoveTo(target.Position)
    return true
end

function AutoFarm:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            if self.Target then
                self:GoToNPC(self.Target)
            end

            task.wait(0.5)
        end
    end)
end

function AutoFarm:Stop()
    self.Enabled = false
end

return AutoFarm
