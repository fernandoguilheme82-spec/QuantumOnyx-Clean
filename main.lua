--[[
                    DESGRAÇA ECLIPSE
              By Bombix Dominante / Nox
                    Apoio: Blox Brasil
                  Direitos autorais: Lucas
]]--

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "Desgraça Eclipse",
    subtitle = "Desgraça Eclipse",
    sidebarLayout = true,
})

local Tab = Window:CreateTab({
    name = "Principal",
})

Tab:CreateButton({
    name = "Teste",
    callback = function()
        print("[Desgraça Eclipse] Rayfield funcionando!")
    end,
})
