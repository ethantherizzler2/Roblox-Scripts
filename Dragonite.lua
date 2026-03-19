local Dragonite = {}

local UIS = game:GetService("UserInputService")

Dragonite.Theme = {
    Background = Color3.fromRGB(18,18,18),
    Panel = Color3.fromRGB(24,24,24),
    Accent = Color3.fromRGB(180,20,20),
    Text = Color3.fromRGB(255,255,255)
}

Dragonite.UI = {
    TitleSize = 18,
    TabSize = 16,
    ElementSize = 15,
    SmallSize = 13,

    TabSpacing = 28,
    ElementSpacing = 26
}

local function Create(class,props)
    local obj = Drawing.new(class)

    if class == "Text" then
        obj.Font = 2
        obj.Outline = true
    end

    for i,v in pairs(props) do
        obj[i] = v
    end

    return obj
end

local function MouseIn(pos,size)
    local m = UIS:GetMouseLocation()
    return m.X > pos.X
    and m.X < pos.X + size.X
    and m.Y > pos.Y
    and m.Y < pos.Y + size.Y
end

function Dragonite:CreateWindow(cfg)

    local Window = {}
    Window.Tabs = {}
    Window.Position = Vector2.new(300,200)
    Window.Size = cfg.Size or Vector2.new(600,400)

    local bg = Create("Square",{
        Size = Window.Size,
        Position = Window.Position,
        Color = self.Theme.Background,
        Filled = true,
        Visible = true
    })

    local sidebar = Create("Square",{
        Size = Vector2.new(90,Window.Size.Y),
        Position = Window.Position,
        Color = self.Theme.Panel,
        Filled = true,
        Visible = true
    })

    local accent = Create("Square",{
        Size = Vector2.new(2,Window.Size.Y),
        Position = Window.Position + Vector2.new(90,0),
        Color = self.Theme.Accent,
        Filled = true,
        Visible = true
    })

    local title = Create("Text",{
        Text = cfg.Title or "Dragonite",
        Size = self.UI.TitleSize,
        Color = self.Theme.Text,
        Position = Window.Position + Vector2.new(100,10),
        Visible = true
    })

    local dragging = false
    local dragOffset

    UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            if MouseIn(Window.Position,Vector2.new(Window.Size.X,30)) then
                dragging = true
                dragOffset = UIS:GetMouseLocation() - Window.Position
            end
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UIS:GetMouseLocation()

            Window.Position = mouse - dragOffset

            bg.Position = Window.Position
            sidebar.Position = Window.Position
            accent.Position = Window.Position + Vector2.new(90,0)
            title.Position = Window.Position + Vector2.new(100,10)
        end
    end)

    function Window:CreateTab(name,icon)

        local Tab = {}
        Tab.Elements = {}

        local tabIndex = #Window.Tabs

        local tabBtn = Create("Text",{
            Text = icon.." "..name,
            Size = Dragonite.UI.TabSize,
            Position = Window.Position + Vector2.new(10,50 + tabIndex * Dragonite.UI.TabSpacing),
            Color = Dragonite.Theme.Text,
            Visible = true
        })

        local function NextY()
            return 60 + (#Tab.Elements * Dragonite.UI.ElementSpacing)
        end

        function Tab:CreateButton(name,callback)

            local y = NextY()

            local txt = Create("Text",{
                Text = name,
                Size = Dragonite.UI.ElementSize,
                Position = Window.Position + Vector2.new(110,y),
                Color = Dragonite.Theme.Text,
                Visible = true
            })

            UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    if MouseIn(txt.Position,Vector2.new(150,20)) then
                        callback()
                    end
                end
            end)

            table.insert(Tab.Elements,txt)
        end

        function Tab:CreateToggle(name,callback)

            local state = false
            local y = NextY()

            local txt = Create("Text",{
                Text = name.." : OFF",
                Size = Dragonite.UI.ElementSize,
                Position = Window.Position + Vector2.new(110,y),
                Color = Dragonite.Theme.Text,
                Visible = true
            })

            UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    if MouseIn(txt.Position,Vector2.new(150,20)) then
                        state = not state
                        txt.Text = name.." : "..(state and "ON" or "OFF")
                        callback(state)
                    end
                end
            end)

            table.insert(Tab.Elements,txt)
        end

        function Tab:CreateSlider(name,min,max,callback)

            local value = min
            local y = NextY()

            local txt = Create("Text",{
                Text = name.." : "..value,
                Size = Dragonite.UI.ElementSize,
                Position = Window.Position + Vector2.new(110,y),
                Color = Dragonite.Theme.Text,
                Visible = true
            })

            UIS.InputChanged:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseMovement then
                    if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                    and MouseIn(txt.Position,Vector2.new(150,20)) then

                        local m = UIS:GetMouseLocation()
                        local percent = (m.X - txt.Position.X) / 150
                        percent = math.clamp(percent,0,1)

                        value = math.floor(min + (max-min)*percent)
                        txt.Text = name.." : "..value

                        callback(value)
                    end
                end
            end)

            table.insert(Tab.Elements,txt)
        end

        table.insert(Window.Tabs,Tab)
        return Tab
    end

    return Window
end

return Dragonite
