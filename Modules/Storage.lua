local HttpService = game:GetService("HttpService")

local Storage = {}

local FOLDER = "DesgracaEclipse"
local FILE = FOLDER .. "/Config.json"

local isfileFunc = isfile or function()
    return false
end

local readfileFunc = readfile or function()
    return ""
end

local writefileFunc = writefile or function()
end

local isfolderFunc = isfolder or function()
    return false
end

local makefolderFunc = makefolder or function()
end

function Storage.Save(data)
    pcall(function()
        if not isfolderFunc(FOLDER) then
            makefolderFunc(FOLDER)
        end

        writefileFunc(
            FILE,
            HttpService:JSONEncode(data or {})
        )
    end)
end

function Storage.Load()
    if not isfolderFunc(FOLDER) or not isfileFunc(FILE) then
        return {}
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(
            readfileFunc(FILE)
        )
    end)

    if success and type(data) == "table" then
        return data
    end

    return {}
end

function Storage.Clear()
    Storage.Save({})
end

return Storage
