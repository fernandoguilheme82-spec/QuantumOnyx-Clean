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

local AutoFarm = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/Modules/MobController.lua"
))()

Tab:CreateToggle({
    name = "Mob Controller",
    default = false,
    callback = function(Value)
        if Value then
            AutoFarm:Start()
            print("[Desgraça Eclipse] Mob Controller: ON")
        else
            AutoFarm:Stop()
            print("[Desgraça Eclipse] Mob Controller: OFF")
        end
    end,
})
