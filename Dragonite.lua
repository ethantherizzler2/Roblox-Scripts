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
        Position = Vector2.new(400, 300),
        Size = cfg.Size or Vector2.new(500, 400),
        Visible = true
    }

    local outerBorder = Create("Square", {Color = Color3.new(0,0,0), Thickness = 1, Filled = false, Visible = true})
    
    local bg = Create("Square", {Color = self.Theme.Main, Filled = true, Visible = true})
    
    local innerContent = Create("Square", {Color = self.Theme.Content, Filled = true, Visible = true})
    local innerOutline = Create("Square", {Color = self.Theme.Outline, Thickness = 1, Filled = false, Visible = true})
    
    local accentLine = Create("Square", {Size = Vector2.new(Window.Size.X, 2), Color = self.Theme.Accent, Filled = true, Visible = true})

    local title = Create("Text", {Text = string.upper(cfg.Title or "DRAGONITE"), Size = 13, Color = self.Theme.Text, Outline = true, Visible = true})

    local dragging, dragOffset = false, Vector2.new(0, 0)

    RunService.RenderStepped:Connect(function()
        if dragging then Window.Position = UIS:GetMouseLocation() - dragOffset end

        outerBorder.Position = Window.Position - Vector2.new(1, 1)
        outerBorder.Size = Window.Size + Vector2.new(2, 2)
        
        bg.Position = Window.Position
        bg.Size = Window.Size
        
        accentLine.Position = Window.Position
        accentLine.Size = Vector2.new(Window.Size.X, 1)
        
        innerContent.Position = Window.Position + Vector2.new(100, 30)
        innerContent.Size = Window.Size - Vector2.new(110, 40)
        
        innerOutline.Position = innerContent.Position
        innerOutline.Size = innerContent.Size
        
        title.Position = Window.Position + Vector2.new(10, 8)

        for i, tab in ipairs(Window.Tabs) do
            tab.Instance.Position = Window.Position + Vector2.new(15, 50 + (i-1)*22)
            tab.Instance.Color = tab.Active and Dragonite.Theme.Accent or Dragonite.Theme.TextDark
            
            for _, el in ipairs(tab.Elements) do
                for _, draw in ipairs(el.Drawings) do
                    draw.Visible = tab.Active
                end
            end
        end
    end)

    UIS.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            if MouseIn(Window.Position, Vector2.new(Window.Size.X, 25)) then
                dragging = true; dragOffset = UIS:GetMouseLocation() - Window.Position
            end
            for _, tab in ipairs(Window.Tabs) do
                if MouseIn(tab.Instance.Position, Vector2.new(80, 20)) then
                    for _, t in ipairs(Window.Tabs) do t.Active = false end
                    tab.Active = true
                end
            end
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    function Window:CreateTab(name)
        local Tab = {Active = #Window.Tabs == 0, Elements = {}}
        Tab.Instance = Create("Text", {Text = string.upper(name), Size = 13, Outline = true, Visible = true})

        function Tab:CreateToggle(name, callback)
            local toggleData = {Enabled = false, Drawings = {}}
            local yPos = 45 + (#Tab.Elements * 20)

            local box = Create("Square", {Size = Vector2.new(10, 10), Color = Dragonite.Theme.Outline, Filled = true, Visible = false})
            local label = Create("Text", {Text = string.upper(name), Size = 13, Color = Dragonite.Theme.Text, Outline = true, Visible = false})

            RunService.RenderStepped:Connect(function()
                if Tab.Active then
                    box.Position = innerContent.Position + Vector2.new(10, yPos)
                    box.Color = toggleData.Enabled and Dragonite.Theme.Accent or Dragonite.Theme.Outline
                    label.Position = box.Position + Vector2.new(18, -2)
                end
            end)

            UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and Tab.Active and MouseIn(box.Position, Vector2.new(100, 15)) then
                    toggleData.Enabled = not toggleData.Enabled
                    callback(toggleData.Enabled)
                end
            end)

            table.insert(toggleData.Drawings, box)
            table.insert(toggleData.Drawings, label)
            table.insert(Tab.Elements, toggleData)
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    return Window
end

return Dragonite
