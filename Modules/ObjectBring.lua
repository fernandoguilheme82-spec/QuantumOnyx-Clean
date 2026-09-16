local ObjectBring = {}

function ObjectBring:Init(Window)
    local Tab = Window:CreateTab({
        name = "Object Bring",
    })

    Tab:CreateParagraph({
        title = "Object Bring",
        content = "Sistema de objetos carregado.",
    })

    print("[Desgraça Eclipse] ObjectBring iniciado")
end

return ObjectBring
