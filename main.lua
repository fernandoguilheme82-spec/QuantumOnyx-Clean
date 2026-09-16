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
    "Modules/ObjectFinder.lua",
    "Modules/ObjectFilter.lua",
    "Modules/ObjectESP.lua",
    "Modules/ObjectBring.lua",
    "Modules/MobController.lua",
}

for _, File in ipairs(Modules) do
    local Success, Module = pcall(function()
        return loadstring(game:HttpGet(BASE .. File))()
    end)

    if Success and type(Module) == "table" then
        if type(Module.Init) == "function" then
            local InitSuccess, InitError = pcall(function()
                Module:Init(Window)
            end)

            if InitSuccess then
                print("[Desgraça Eclipse] OK: " .. File)
            else
                warn("[Desgraça Eclipse] INIT ERROR: " .. File)
                warn(InitError)
            end
        end
    else
        warn("[Desgraça Eclipse] LOAD ERROR: " .. File)
        warn(Module)
    end
end
