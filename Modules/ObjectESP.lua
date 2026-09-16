local ObjectESP = {}

local highlights = {}

function ObjectESP.Add(object)
    if not object or not object:IsA("BasePart") then
        return
    end

    if highlights[object] then
        return
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ObjectFinderESP"
    highlight.Adornee = object
    highlight.Parent = object

    highlights[object] = highlight
end

function ObjectESP.Remove(object)
    local highlight = highlights[object]

    if highlight then
        highlight:Destroy()
        highlights[object] = nil
    end
end

function ObjectESP.Clear()
    for object, highlight in pairs(highlights) do
        if highlight then
            highlight:Destroy()
        end

        highlights[object] = nil
    end
end

function ObjectESP.Show(objects)
    ObjectESP.Clear()

    for _, data in ipairs(objects) do
        ObjectESP.Add(data.Instance)
    end
end

return ObjectESP
