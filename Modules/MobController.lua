local MobController = {}

function MobController:Init(Window)
    local Tab = Window:CreateTab({
        name = "Mob Controller",
    })

    Tab:CreateParagraph({
        title = "Mob Controller",
        content = "Controlador de NPC carregado.",
    })

    print("[Desgraça Eclipse] MobController iniciado")
end

return MobController
