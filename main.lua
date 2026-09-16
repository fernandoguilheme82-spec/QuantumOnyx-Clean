--[[
                    DESGRAÇA ECLIPSE
              By Bombix Dominante / Nox
                    Apoio: Blox Brasil
                  Direitos autorais: Lucas
]]

local BASE = "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/"

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/gen2")
)()

local Window = Rayfield:CreateWindow({
    name = "Desgraça Eclipse",
    subtitle = "Desgraça Eclipse",
    sidebarLayout = true,
})

local Tab = Window:CreateTab({
    name = "Principal",
})

local function LoadModule(path)
    local url = BASE .. path

    local ok, result = pcall(function()
        return loadstring(game:HttpGet(url))()
    end)

    if not ok then
        warn("[Desgraça Eclipse] Erro ao carregar " .. path)
        warn(result)
        return nil
    end

    return result
end

-- Módulo de controle de NPC
local MobController = LoadModule("Modules/MobController.lua")

if MobController and MobController.Init then
    MobController:Init(Window)
end

-- Módulo de teste de combate do próprio jogo
local NPCAttackTest = LoadModule("Modules/NPCAttackTest.lua")

if NPCAttackTest and NPCAttackTest.Init then
    NPCAttackTest:Init(Window)
end

print("[Desgraça Eclipse] Sistema carregado.")

-- Object Finder
local ObjectFinder = LoadModule("Modules/ObjectFinder.lua")

if ObjectFinder and ObjectFinder.Init then
    ObjectFinder:BuildIndex(workspace)
    ObjectFinder:Init(Window)
end
