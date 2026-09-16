local ObjectFinder = {}

local Players = game:GetService("Players")

function ObjectFinder.GetRoot()
    local character = Players.LocalPlayer.Character
    if not character then return nil end

    return character:FindFirstChild("HumanoidRootPart")
end

function ObjectFinder.GetObjects(radius)
    local root = ObjectFinder.GetRoot()
    if not root then return {} end

    radius = tonumber(radius) or 50

    local found = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local distance = (obj.Position - root.Position).Magnitude

            if distance <= radius then
                table.insert(found, {
                    Instance = obj,
                    Name = obj.Name,
                    Distance = math.floor(distance)
                })
            end
        end
    end

    table.sort(found, function(a, b)
        return a.Distance < b.Distance
    end)

    return found
end

function ObjectFinder.FindByName(name, radius)
    local objects = ObjectFinder.GetObjects(radius)
    local result = {}

    name = tostring(name or ""):lower()

    for _, data in ipairs(objects) do
        if name == "" or data.Name:lower():find(name, 1, true) then
            table.insert(result, data)
        end
    end

    return result
end

return ObjectFinder
