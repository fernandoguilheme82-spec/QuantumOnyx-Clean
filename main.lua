--[[
                      DESGRAÇA ECLIPSE
                By Bombix Dominante / Nox
                      Apoio: Blox Brasil
                    Direitos autorais: Lucas
]]--

local BASE = "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/Modules/"

local Modules = {
    "ObjectFinder.lua",
    "ObjectFilter.lua",
    "ObjectESP.lua",
    "ObjectBring.lua",
    "PlaceDetector.lua",
}

for _, FileName in ipairs(Modules) do
    task.spawn(function()
        local URL = BASE .. FileName

        local Success, Result = pcall(function()
            return loadstring(game:HttpGet(URL))()
        end)

        if Success then
            print("[Desgraça Eclipse] ✓ " .. FileName)
        else
            warn("[Desgraça Eclipse] ✗ " .. FileName)
            warn(Result)
        end
    end)
end

-- Aim NPC: módulo independente
local AimNPC = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/Modules/AimNPC.lua"
))()

AimNPC.Init(Window)
