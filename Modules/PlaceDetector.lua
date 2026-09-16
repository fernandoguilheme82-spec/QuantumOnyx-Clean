local PlaceDetector = {}

function PlaceDetector.Get()
    return game.PlaceId
end

function PlaceDetector.Is(placeId)
    return tostring(game.PlaceId) == tostring(placeId)
end

return PlaceDetector
