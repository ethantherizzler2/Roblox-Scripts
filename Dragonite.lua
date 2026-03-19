local Dragonite = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Dragonite.Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Content = Color3.fromRGB(18, 18, 18),
    Accent = Color3.fromRGB(180, 20, 20),
    Outline = Color3.fromRGB(45, 45, 45),
    Inline = Color3.fromRGB(10, 10, 10),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(140, 140, 140)
}

Dragonite.Fonts = {
    Title = 16,
    Tab = 14,
    Default = 12,
    Small = 11
}

local function Create(class, props)
    local obj = Drawing.new(class)

    if class == "Text" then
        obj.Font = 2
        obj.Size = Dragonite.Fonts.Default
        obj.Outline = true
        obj.Center = false
    end

    for i, v in pairs(props) do
        obj[i] = v
    end

    return obj
end

local function MouseIn(pos, size)
    local m = UIS:GetMouseLocation()
    return m.X > pos.X and m.X < pos.X + size.X
        and m.Y > pos.Y and m.Y < pos.Y + size.Y
end

function Dragonite:CreateWindow(cfg)
    local Window = {
        Tabs = {},
        Position = Vector2.new(400, 300),
        Size = cfg.Size or Vector2.new(520, 420),
        Visible = true
    }

    local outerBorder = Create("Square", {Color = Color3.new(0,0,0), Thickness = 1, Filled = false})
    local bg = Create("Square", {Color = self.Theme.Main, Filled = true})
    local innerContent = Create("Square", {Color = self.Theme.Content, Filled = true})
    local innerOutline = Create("Square", {Color = self.Theme.Outline, Thickness = 1, Filled = false})
    local accentLine = Create("Square", {Color = self.Theme.Accent, Filled = true})

    local title = Create("Text", {
        Text = string.upper(cfg.Title or "Dragonite"),
        Size = self.Fonts.Title,
        Color = self.Theme.Text
    })

    local dragging = false
    local dragOffset = Vector2.new()

    UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            if MouseIn(Window.Position, Vector2.new(Window.Size.X, 25)) then
                dragging = true
                dragOffset = UIS:GetMouseLocation() - Window.Position
            end

            for _, tab in ipairs(Window.Tabs) do
                if MouseIn(tab.Instance.Position, Vector2.new(100, 24)) then
                    for _, t in ipairs(Window.Tabs) do t.Active = false end
                    tab.Active = true
                end
            end
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging then
            Window.Position = UIS:GetMouseLocation() - dragOffset
        end

        outerBorder.Position = Window.Position - Vector2.new(1, 1)
        outerBorder.Size = Window.Size + Vector2.new(2, 2)

        bg.Position = Window.Position
        bg.Size = Window.Size

        accentLine.Position = Window.Position
        accentLine.Size = Vector2.new(Window.Size.X, 2)

        innerContent.Position = Window.Position + Vector2.new(120, 35)
        innerContent.Size = Window.Size - Vector2.new(130, 45)

        innerOutline.Position = innerContent.Position
        innerOutline.Size = innerContent.Size

        title.Position = Window.Position + Vector2.new(12, 8)

        for i, tab in ipairs(Window.Tabs) do
            tab.Instance.Position = Window.Position + Vector2.new(15, 50 + (i-1)*26)
            tab.Instance.Color = tab.Active and Dragonite.Theme.Text or Dragonite.Theme.TextDark

            for _, el in ipairs(tab.Elements) do
                for _, draw in ipairs(el.Drawings) do
                    draw.Visible = tab.Active
                end
            end
        end
    end)

    function Window:CreateTab(name)
        local Tab = {
            Active = #Window.Tabs == 0,
            Elements = {}
        }

        Tab.Instance = Create("Text", {
            Text = string.upper(name),
            Size = Dragonite.Fonts.Tab
        })

        function Tab:CreateToggle(name, callback)
            local toggle = {
                Enabled = false,
                Drawings = {}
            }

            local yPos = 20 + (#Tab.Elements * 28)

            local boxOuter = Create("Square", {Size = Vector2.new(14, 14), Color = Color3.new(0,0,0), Filled = false, Thickness = 1})
            local box = Create("Square", {Size = Vector2.new(12, 12), Color = Dragonite.Theme.Outline, Filled = true})
            local label = Create("Text", {
                Text = string.upper(name),
                Size = Dragonite.Fonts.Default,
                Color = Dragonite.Theme.TextDark
            })

            RunService.RenderStepped:Connect(function()
                if Tab.Active then
                    local base = innerContent.Position + Vector2.new(15, yPos)

                    box.Position = base
                    boxOuter.Position = base - Vector2.new(1,1)
                    boxOuter.Size = box.Size + Vector2.new(2,2)

                    box.Color = toggle.Enabled and Dragonite.Theme.Accent or Color3.fromRGB(35,35,35)

                    label.Position = base + Vector2.new(22, -1)
                    label.Color = toggle.Enabled and Dragonite.Theme.Text or Dragonite.Theme.TextDark
                end
            end)

            UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and Tab.Active then
                    if MouseIn(box.Position, Vector2.new(160, 16)) then
                        toggle.Enabled = not toggle.Enabled
                        if callback then
                            callback(toggle.Enabled)
                        end
                    end
                end
            end)

            table.insert(toggle.Drawings, boxOuter)
            table.insert(toggle.Drawings, box)
            table.insert(toggle.Drawings, label)

            table.insert(Tab.Elements, toggle)
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return Dragonite
