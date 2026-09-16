local TimeUtils = {}

function TimeUtils.ToTime(expire)
    if not expire or expire <= 0 then
        return "Lifetime"
    end

    local remaining = expire - os.time()

    if remaining < 0 then
        return "Expired"
    end

    local days = math.floor(remaining / 86400)
    local hours = math.floor((remaining % 86400) / 3600)
    local minutes = math.floor((remaining % 3600) / 60)

    if days > 0 then
        return string.format("%dd %dh", days, hours)
    end

    if hours > 0 then
        return string.format("%dh %dm", hours, minutes)
    end

    return string.format("%dm", minutes)
end

return TimeUtils
