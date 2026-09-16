local ObjectFinder = {
    Root = workspace,
    MaxSuggestions = 12,
    Index = {},
    Ready = false,
}

local function normalize(text)
    return string.lower(tostring(text or ""))
end

function ObjectFinder:BuildIndex(root)
    self.Root = root or workspace
    self.Index = {}

    table.insert(self.Index, self.Root)

    for _, object in ipairs(self.Root:GetDescendants()) do
        table.insert(self.Index, object)
    end

    self.Ready = true

    print(
        "[Desgraça Eclipse] ObjectFinder:",
        #self.Index,
        "objetos indexados"
    )
end

function ObjectFinder:Search(query)
    query = normalize(query)

    if query == "" then
        return {}
    end

    if not self.Ready then
        self:BuildIndex(self.Root)
    end

    local results = {}

    for _, object in ipairs(self.Index) do
        local name = normalize(object.Name)

        if string.find(name, query, 1, true) then
            table.insert(results, object)

            if #results >= self.MaxSuggestions then
                break
            end
        end
    end

    return results
end

function ObjectFinder:GetPath(object)
    if not object then
        return "nil"
    end

    local path = object.Name
    local parent = object.Parent

    while parent and parent ~= self.Root do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end

    return path
end

function ObjectFinder:Refresh()
    self:BuildIndex(self.Root)
end

function ObjectFinder:Init(Window)
    local Tab = Window:CreateTab({
        name = "Object Finder",
    })

    Tab:CreateInput({
        name = "Procurar objeto",
        placeholder = "Digite o nome...",
        removeTextAfterFocusLost = false,

        callback = function(text)
            local results = self:Search(text)

            print(
                "[Desgraça Eclipse] Encontrados:",
                #results
            )

            for i, object in ipairs(results) do
                print(
                    i .. ".",
                    object.Name,
                    "|",
                    self:GetPath(object)
                )
            end
        end,
    })

    Tab:CreateButton({
        name = "Atualizar objetos",

        callback = function()
            self:Refresh()
        end,
    })
end

return ObjectFinder
