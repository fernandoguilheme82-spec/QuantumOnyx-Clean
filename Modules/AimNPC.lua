local AimNPC = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

AimNPC.Enabled = false
AimNPC.Range = 150
AimNPC.UpdateRate = 0.05
AimNPC.CurrentTarget = nil

local Connection = nil

local function GetCharacter()
    return LocalPlayer and LocalPlayer.Character
end

local function GetRoot()
    local Character = GetCharacter()
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

local function GetNPCHead(Model)
    if not Model:IsA("Model") then
        return nil
    end

    local Humanoid = Model:FindFirstChildOfClass("Humanoid")
    local Head = Model:FindFirstChild("Head")

    if not Humanoid or Humanoid.Health <= 0 then
        return nil
    end

    if not Head or not Head:IsA("BasePart") then
        return nil
    end

    return Head
end

function AimNPC.FindNearest()
    local Root = GetRoot()
    if not Root then
        return nil
    end

    local BestHead = nil
    local BestDistance = AimNPC.Range

    for _, Object in ipairs(workspace:GetDescendants()) do
        local Head = GetNPCHead(Object)

        if Head and not Object:IsDescendantOf(GetCharacter()) then
            local Distance = (Head.Position - Root.Position).Magnitude

            if Distance <= BestDistance then
                BestDistance = Distance
                BestHead = Head
            end
        end
    end

    return BestHead, BestDistance
end

function AimNPC.GetTarget()
    return AimNPC.CurrentTarget
end

function AimNPC.SetRange(Value)
    Value = tonumber(Value)

    if Value then
        AimNPC.Range = math.clamp(Value, 5, 1000)
    end
end

function AimNPC.Start()
    if AimNPC.Enabled then
        return
    end

    AimNPC.Enabled = true

    local Timer = 0

    Connection = RunService.Heartbeat:Connect(function(Delta)
        Timer += Delta

        if Timer < AimNPC.UpdateRate then
            return
        end

        Timer = 0

        local Head = AimNPC.FindNearest()
        AimNPC.CurrentTarget = Head
    end)
end

function AimNPC.Stop()
    AimNPC.Enabled = false
    AimNPC.CurrentTarget = nil

    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

function AimNPC.Toggle(State)
    if State then
        AimNPC.Start()
    else
        AimNPC.Stop()
    end
end

function AimNPC.Init(Window)
    local Tab = Window:CreateTab({
        name = "Aim NPC",
    })

    Tab:CreateToggle({
        name = "Aim NPC",
        currentValue = false,
        callback = function(Value)
            AimNPC.Toggle(Value)
        end,
    })

    Tab:CreateInput({
        name = "Distância",
        placeholder = "150",
        callback = function(Value)
            AimNPC.SetRange(Value)
        end,
    })

    Tab:CreateInput({
        name = "Atualização",
        placeholder = "0.05",
        callback = function(Value)
            local Number = tonumber(Value)

            if Number then
                AimNPC.UpdateRate = math.clamp(Number, 0.01, 1)
            end
        end,
    })

    Tab:CreateButton({
        name = "Selecionar NPC mais próximo",
        callback = function()
            local Head, Distance = AimNPC.FindNearest()

            AimNPC.CurrentTarget = Head

            if Head then
                print(
                    "[Aim NPC] Alvo:",
                    Head.Parent.Name,
                    "Distância:",
                    math.floor(Distance)
                )
            else
                print("[Aim NPC] Nenhum NPC encontrado.")
            end
        end,
    })

    return AimNPC
end

return AimNPC
