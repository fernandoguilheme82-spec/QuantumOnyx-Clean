local GameConfig = {}

GameConfig.PlaceId = game.PlaceId
GameConfig.GameId = game.GameId

function GameConfig.IsPlace(placeId)
    return tostring(game.PlaceId) == tostring(placeId)
end

function GameConfig.GetPlaceId()
    return game.PlaceId
end

function GameConfig.GetGameId()
    return game.GameId
end

return GameConfig
