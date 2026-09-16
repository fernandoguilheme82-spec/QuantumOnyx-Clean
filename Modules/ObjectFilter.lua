local ObjectFilter = {}

function ObjectFilter.Filter(objects, text)
    text = tostring(text or ""):lower()

    if text == "" then
        return objects
    end

    local result = {}

    for _, objectData in ipairs(objects) do
        if objectData.Name:lower():find(text, 1, true) then
            table.insert(result, objectData)
        end
    end

    return result
end

return ObjectFilter
