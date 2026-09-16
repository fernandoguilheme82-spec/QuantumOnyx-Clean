--[[
                    DESGRAÇA ECLIPSE
              By Bombix Dominante / Nox
                    Apoio: Blox Brasil
                  Direitos autorais: Lucas
]]--

local BASE = "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/"

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

local Window = Rayfield:CreateWindow({
    name = "Desgraça Eclipse",
    subtitle = "Desgraça Eclipse",
    sidebarLayout = true,
})

local Modules = {
    {
        Name = "Mob Controller",
        File = "Modules/MobController.lua"
    },
}

for _, moduleInfo in ipairs(Modules) do
    local url = BASE .. moduleInfo.File

    local success, module = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if success and module then
        if module.Init then
            module:Init(Window)
        end

        print("[Desgraça Eclipse] Carregado: " .. moduleInfo.Name)
    else
        warn("[Desgraça Eclipse] Falha ao carregar: " .. moduleInfo.Name)
        warn(module)
    end
end
