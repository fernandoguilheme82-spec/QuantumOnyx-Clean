local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ToggleAura =
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ToggleNPCAura")

local NPCCombatButton = {}

function NPCCombatButton:Init(Tab)
    Tab:CreateToggle({
        name = "Kill Aura NPC",
        default = false,

        callback = function(enabled)
            ToggleAura:FireServer(enabled)

            print(
                "[Desgraça Eclipse] Kill Aura NPC:",
                enabled and "ON" or "OFF"
            )
        end,
    })
end

return NPCCombatButton
