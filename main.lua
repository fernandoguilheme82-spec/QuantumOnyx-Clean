--[[
                    DESGRAÇA ECLIPSE
              By Bombix Dominante / Nox
                    Apoio: Blox Brasil
                  Direitos autorais: Lucas
]]

local BASE =
    "https://raw.githubusercontent.com/fernandoguilheme82-spec/QuantumOnyx-Clean/main/"

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/gen2")
)()

local Window = Rayfield:CreateWindow({
    name = "Desgraça Eclipse",
    subtitle = "Desgraça Eclipse",
    sidebarLayout = true,
})

local function LoadModule(file)
    local ok, result = pcall(function()
        return loadstring(
            game:HttpGet(BASE .. file)
        )()
    end)

    if not ok then
        warn("[Desgraça Eclipse] Falha: " .. file)
        warn(result)
        return nil
    end

    return result
end

local MobController = LoadModule(
    "Modules/MobController.lua"
)

if MobController and MobController.Init then
    MobController:Init(Window)
end

local ObjectFinder = LoadModule(
    "Modules/ObjectFinder.lua"
)

if ObjectFinder and ObjectFinder.Init then
    ObjectFinder:Init(Window)
end

print("[Desgraça Eclipse] Todos os módulos carregados.")
