local ObjectFilter = {}

function ObjectFilter:Init(Window)
    local Tab = Window:CreateTab({
        name = "Object Filter",
    })

    Tab:CreateParagraph({
        title = "Object Filter",
        content = "Filtro de objetos carregado.",
    })

    print("[Desgraça Eclipse] ObjectFilter iniciado")
end

return ObjectFilter
