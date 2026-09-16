--[[
                      DESGRAÇA ECLIPSE
                By Bombix Dominante / Nox
                      Apoio: Blox Brasil
                    Direitos autorais: Lucas
]]--

local BASE = "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/"

-- Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- Janela principal
local Window = Rayfield:CreateWindow({
    name = "Desgraça Eclipse",
    subtitle = "Desgraça Eclipse",
    sidebarLayout = true,
})

-- Todos os módulos registrados aqui
local Modules = {
    "Modules/AimNPC.lua",
    "Modules/ObjectFinder.lua",
    "Modules/ObjectFilter.lua",
    "Modules/ObjectESP.lua",
    "Modules/ObjectBring.lua",
    "Modules/MobController.lua",
}

-- Carregar módulos
for _, File in ipairs(Modules) do
    local Success, Module = pcall(function()
        local Source = game:HttpGet(BASE .. File)
        return loadstring(Source)()
    end)

    if Success and Module then
        if type(Module.Init) == "function" then
            local InitSuccess, InitError = pcall(function()
                Module:Init(Window)
            end)

            if InitSuccess then
                print("[Desgraça Eclipse] OK: " .. File)
            else
                warn("[Desgraça Eclipse] ERRO INIT: " .. File)
                warn(InitError)
            end
        else
            print("[Desgraça Eclipse] OK: " .. File)
        end
    else
        warn("[Desgraça Eclipse] FALHA: " .. File)
        warn(Module)
    end
end

print("[Desgraça Eclipse] Todos os módulos foram processados.")
