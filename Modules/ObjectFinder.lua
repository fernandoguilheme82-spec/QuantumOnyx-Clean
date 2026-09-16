local Players = game:GetService("Players")

local Player = Players.LocalPlayer

local ObjectFinder = {
    Enabled = false,
    Radius = 1000,
    MaxSuggestions = 15,
    Index = {},
    Highlights = {},
}

local function normalize(value)
    return string.lower(tostring(value or ""))
end

local function getRoot()
    local character = Player.Character
    return character and character:FindFirstChild("HumanoidRootPart")
end

function ObjectFinder:Refresh()
    self.Index = {}

    for _, object in ipairs(workspace:GetDescendants()) do
        if object:IsA("Model") or object:IsA("BasePart") then
            table.insert(self.Index, object)
        end
    end
end

function ObjectFinder:ClearHighlights()
    for object, highlight in pairs(self.Highlights) do
        if highlight then
            highlight:Destroy()
        end

        self.Highlights[object] = nil
    end
end

function ObjectFinder:AddHighlight(object)
    if self.Highlights[object] then
        return
    end

    local model = object

    if not object:IsA("Model") then
        model = object:FindFirstAncestorOfClass("Model")
    end

    if not model then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ObjectFinderHighlight"
    highlight.Adornee = model
    highlight.FillColor = Color3.fromRGB(0, 255, 80)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 80)
    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0

    highlight.Parent = model

    self.Highlights[object] = highlight
end

function ObjectFinder:Search(query)
    local root = getRoot()

    if not root then
        return {}
    end

    query = normalize(query)

    if query == "" then
        self:ClearHighlights()
        return {}
    end

    local results = {}

    for _, object in ipairs(self.Index) do
        if object.Parent and string.find(
            normalize(object.Name),
            query,
            1,
            true
        ) then
            local position

            if object:IsA("Model") then
                position = object:GetPivot().Position
            elseif object:IsA("BasePart") then
                position = object.Position
            end

            if position then
                local distance =
                    (position - root.Position).Magnitude

                if distance <= self.Radius then
                    table.insert(results, {
                        Object = object,
                        Distance = distance,
                    })
                end
            end
        end
    end

    table.sort(results, function(a, b)
        return a.Distance < b.Distance
    end)

    self:ClearHighlights()

    if self.Enabled then
        for i = 1, math.min(#results, self.MaxSuggestions) do
            self:AddHighlight(results[i].Object)
        end
    end

    return results
end

function ObjectFinder:Init(Window)
    local Tab = Window:CreateTab({
        name = "Object Finder",
    })

    Tab:CreateToggle({
        name = "Object Finder",
        default = false,

        callback = function(enabled)
            self.Enabled = enabled

            if not enabled then
                self:ClearHighlights()
            end
        end,
    })

    Tab:CreateInput({
        name = "Nome do objeto",
        placeholder = "Digite o nome...",

        callback = function(text)
            local results = self:Search(text)

            print(
                "[Object Finder] "
                .. tostring(#results)
                .. " objetos encontrados."
            )

            for i, result in ipairs(results) do
                print(
                    i,
                    result.Object:GetFullName(),
                    math.floor(result.Distance),
                    "studs"
                )
            end
        end,
    })

    Tab:CreateButton({
        name = "Atualizar objetos",

        callback = function()
            self:Refresh()
            print("[Object Finder] Índice atualizado.")
        end,
    })

    Tab:CreateSlider({
        name = "Distância de busca",
        range = {100, 5000},
        increment = 100,
        suffix = " studs",
        currentValue = self.Radius,

        callback = function(value)
            self.Radius = value
        end,
    })

    self:Refresh()
end

return ObjectFinder
