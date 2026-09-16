local ObjectESP = {}

function ObjectESP:Init(Window)
    local Tab = Window:CreateTab({
        name = "Object ESP",
    })

    Tab:CreateParagraph({
        title = "Object ESP",
        content = "Sistema visual carregado.",
    })

    print("[Desgraça Eclipse] ObjectESP iniciado")
end

return ObjectESP
