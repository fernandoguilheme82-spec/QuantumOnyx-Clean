local Players = game:GetService("Players")

local AutoFarm = {
    Enabled = false,
    Target = nil
}

function AutoFarm:FindNPC(name)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model")
            and obj ~= Players.LocalPlayer.Character
            and obj:FindFirstChildOfClass("Humanoid")
            and obj:FindFirstChild("HumanoidRootPart") then

            if not name or obj.Name:lower():find(name:lower(), 1, true) then
                return obj
            end
        end
    end

    return nil
end

function AutoFarm:GoToNPC(npc)
    local character = Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local root = npc and npc:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return false
    end

    humanoid:MoveTo(root.Position)
    return true
end

function AutoFarm:SetTarget(npc)
    self.Target = npc
end

function AutoFarm:Start()
    if self.Enabled then
        return
    end

    self.Enabled = true

    task.spawn(function()
        while self.Enabled do
            if not self.Target then
                self.Target = self:FindNPC()
            end

            if self.Target and self.Target.Parent then
                self:GoToNPC(self.Target)
            else
                self.Target = nil
            end

            task.wait(0.5)
        end
    end)
end

function AutoFarm:Stop()
    self.Enabled = false
    self.Target = nil
end

return AutoFarm
