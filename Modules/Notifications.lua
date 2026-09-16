local StarterGui = game:GetService("StarterGui")

local Notifications = {}

function Notifications.Notify(title, description, accent, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Desgraça Eclipse",
            Text = description or "",
            Duration = duration or 5,
        })
    end)
end

return Notifications
