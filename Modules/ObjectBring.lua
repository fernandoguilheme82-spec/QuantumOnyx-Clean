local ObjectBring = {}

function ObjectBring.SetTarget(object)
    ObjectBring.Target = object
end

function ObjectBring.GetTarget()
    return ObjectBring.Target
end

function ObjectBring.Clear()
    ObjectBring.Target = nil
end

return ObjectBring
