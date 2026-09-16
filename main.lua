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

-- Módulos
local Modules = {
    "Modules/AimNPC.lua",
}

-- Carregador
for _, File in ipairs(Modules) do
    local Success, Module = pcall(function()
        return loadstring(game:HttpGet(BASE .. File))()
    end)

    if Success and Module then
        if Module.Init then
            local InitSuccess, InitError = pcall(function()
                Module:Init(Window)
            end)

            if InitSuccess then
                print("[Desgraça Eclipse] Módulo carregado: " .. File)
            else
                warn("[Desgraça Eclipse] Erro ao iniciar " .. File)
                warn(InitError)
            end
        else
            print("[Desgraça Eclipse] Módulo carregado: " .. File)
        end
    else
        warn("[Desgraça Eclipse] Falha ao carregar: " .. File)
        warn(Module)
    end
end
