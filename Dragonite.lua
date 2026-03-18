local Dragonite = {}
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

Dragonite.Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Panel = Color3.fromRGB(28, 28, 28),
    Accent = Color3.fromRGB(180, 20, 20),
    Outline = Color3.fromRGB(45, 45, 45),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 160)
}

local function Create(class, props)
    local obj = Drawing.new(class)
    for i, v in pairs(props) do obj[i] = v end
    return obj
end

local function MouseIn(pos, size)
    local m = UIS:GetMouseLocation()
    return m.X > pos.X and m.X < pos.X + size.X and m.Y > pos.Y and m.Y < pos.Y + size.Y
end

function Dragonite:CreateWindow(cfg)
    local Window = {
        Tabs = {},
        Elements = {}, -- All drawings for movement
        Position = Vector2.new(300, 200),
        Size = cfg.Size or Vector2.new(550, 350),
        Visible = true
    }

    -- 1. DROP SHADOW (The Depth)
    local shadow = Create("Square", {Size = Window.Size + Vector2.new(8, 8), Color = Color3.new(0,0,0), Transparency = 0.35, Filled = true, Visible = true})
    
    -- 2. MAIN BG
    local bg = Create("Square", {Size = Window.Size, Color = self.Theme.Background, Filled = true, Visible = true})
    
    -- 3. INLINE BORDER (The Sharp Look)
    local border = Create("Square", {Size = Window.Size, Color = self.Theme.Outline, Filled = false, Thickness = 1, Visible = true})
    
    -- 4. SIDEBAR
    local sidebar = Create("Square", {Size = Vector2.new(120, Window.Size.Y), Color = self.Theme.Panel, Filled = true, Visible = true})
    
    -- 5. ACCENT LINE (Tactical Top Bar)
    local accent = Create("Square", {Size = Vector2.new(Window.Size.X, 2), Color = self.Theme.Accent, Filled = true, Visible = true})

    local title = Create("Text", {Text = string.upper(cfg.Title or "DRAGONITE"), Size = 16, Color = self.Theme.Text, Center = false, Outline = true, Visible = true})

    -- SMOOTH DRAGGING LOGIC
    local dragging = false
    local dragOffset = Vector2.new(0, 0)

    UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 and MouseIn(Window.Position, Vector2.new(Window.Size.X, 30)) then
            dragging = true
            dragOffset = UIS:GetMouseLocation() - Window.Position
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    -- THE RENDER LOOP (Ensures everything stays attached)
    RunService.RenderStepped:Connect(function()
        if dragging then
            Window.Position = UIS:GetMouseLocation() - dragOffset
        end

        shadow.Position = Window.Position - Vector2.new(4, 4)
        bg.Position = Window.Position
        border.Position = Window.Position
        sidebar.Position = Window.Position
        accent.Position = Window.Position
        title.Position = Window.Position + Vector2.new(130, 8)

        -- Update Tabs and Elements
        for i, tab in ipairs(Window.Tabs) do
            tab.Instance.Position = Window.Position + Vector2.new(15, 50 + (i-1)*25)
            if tab.Active then
                tab.Instance.Color = Dragonite.Theme.Accent
                for _, el in ipairs(tab.Elements) do
                    for _, draw in ipairs(el.Drawings) do
                        draw.Visible = true
                        -- Move elements relative to Window.Position here if needed
                    end
                end
            else
                tab.Instance.Color = Dragonite.Theme.TextDark
            end
        end
    end)

    function Window:CreateTab(name)
        local Tab = {Active = #Window.Tabs == 0, Elements = {}}
        
        local tabBtn = Create("Text", {
            Text = string.upper(name),
            Size = 14,
            Color = Dragonite.Theme.TextDark,
            Outline = true,
            Visible = true
        })
        
        Tab.Instance = tabBtn

        function Tab:CreateToggle(name, callback)
            local toggleData = {Enabled = false, Drawings = {}}
            local yOffset = 60 + (#Tab.Elements * 25)

            local label = Create("Text", {
                Text = string.upper(name),
                Size = 14,
                Color = Dragonite.Theme.Text,
                Outline = true,
                Visible = Tab.Active
            })

            -- Logic for movement in RenderStepped (simplified for brevity)
            RunService.RenderStepped:Connect(function()
                label.Position = Window.Position + Vector2.new(140, yOffset)
                label.Text = string.upper(name) .. (toggleData.Enabled and " [ ON ]" or " [ OFF ]")
                label.Color = toggleData.Enabled and Dragonite.Theme.Accent or Dragonite.Theme.Text
            end)

            UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and Tab.Active and MouseIn(label.Position, Vector2.new(150, 20)) then
                    toggleData.Enabled = not toggleData.Enabled
                    callback(toggleData.Enabled)
                end
            end)

            table.insert(toggleData.Drawings, label)
            table.insert(Tab.Elements, toggleData)
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return Dragonite
