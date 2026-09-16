local TweenService = game:GetService("TweenService")

local UIUtils = {}

function UIUtils.Tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quint
    direction = direction or Enum.EasingDirection.Out

    local tween = TweenService:Create(
        obj,
        TweenInfo.new(duration, style, direction),
        props
    )

    tween:Play()
    return tween
end

function UIUtils.New(className, props, parent)
    local instance = Instance.new(className)

    for key, value in pairs(props or {}) do
        if key ~= "Children" and key ~= "Parent" then
            pcall(function()
                instance[key] = value
            end)
        end
    end

    if props and props.Children then
        for _, child in ipairs(props.Children) do
            pcall(function()
                child.Parent = instance
            end)
        end
    end

    instance.Parent = (props and props.Parent) or parent

    return instance
end

function UIUtils.CircleRipple(button, mouseX, mouseY)
    task.spawn(function()
        button.ClipsDescendants = true

        local x = mouseX - button.AbsolutePosition.X
        local y = mouseY - button.AbsolutePosition.Y

        local size = math.max(
            button.AbsoluteSize.X,
            button.AbsoluteSize.Y
        ) * 1.6

        local ripple = UIUtils.New("ImageLabel", {
            Name = "Ripple",
            Image = "rbxassetid://266543268",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            ImageTransparency = 0.82,
            BackgroundTransparency = 1,
            ZIndex = button.ZIndex + 5,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, x, 0, y),
        }, button)

        UIUtils.Tween(
            ripple,
            {
                Size = UDim2.new(0, size, 0, size),
                Position = UDim2.new(
                    0.5, -size / 2,
                    0.5, -size / 2
                )
            },
            0.45,
            Enum.EasingStyle.Quad
        )

        UIUtils.Tween(
            ripple,
            { ImageTransparency = 1 },
            0.45,
            Enum.EasingStyle.Linear
        )

        task.wait(0.46)

        if ripple then
            ripple:Destroy()
        end
    end)
end

return UIUtils
