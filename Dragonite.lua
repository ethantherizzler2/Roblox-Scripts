local Dragonite = {}

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

Dragonite.Theme = {
    Background = Color3.fromRGB(18,18,18),
    Panel = Color3.fromRGB(24,24,24),
    Accent = Color3.fromRGB(180,20,20),
    Text = Color3.fromRGB(255,255,255),
    ToggleOn = Color3.fromRGB(50,200,50),
    ToggleOff = Color3.fromRGB(200,50,50)
}

Dragonite.UI = {
    TitleSize = 18,
    TabSize = 14,
    ElementSize = 14,
    TabSpacing = 35,
    ElementSpacing = 30
}

local function Create(class, props)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    return obj
end

function Dragonite:CreateWindow(cfg)
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil

    local ScreenGui = Create("ScreenGui", {
        Parent = PlayerGui,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Parent = ScreenGui,
        Size = UDim2.new(0,600,0,400),
        Position = UDim2.new(0.5,-300,0.5,-200),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0
    })

    local Sidebar = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(0,90,1,0),
        BackgroundColor3 = self.Theme.Panel,
        BorderSizePixel = 0
    })

    Create("Frame", {
        Parent = Main,
        Size = UDim2.new(0,2,1,0),
        Position = UDim2.new(0,90,0,0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    })

    Create("TextLabel", {
        Parent = Main,
        Text = cfg.Title or "Dragonite",
        Size = UDim2.new(0,200,0,30),
        Position = UDim2.new(0,100,0,5),
        BackgroundTransparency = 1,
        TextColor3 = self.Theme.Text,
        TextSize = self.UI.TitleSize,
        Font = Enum.Font.SourceSansBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local Content = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(1,-100,1,-40),
        Position = UDim2.new(0,100,0,40),
        BackgroundTransparency = 1
    })

    local dragging, dragOffset = false, nil

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = input.Position - Main.AbsolutePosition
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position - dragOffset
            Main.Position = UDim2.new(0,pos.X,0,pos.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    function Window:CreateTab(name, icon)
        local Tab = {}
        Tab.Elements = {}

        local tabIndex = #Window.Tabs
        local TabButton = Create("TextButton", {
            Parent = Sidebar,
            Text = (icon or "").." "..name,
            Size = UDim2.new(1,0,0,25),
            Position = UDim2.new(0,0,0,50 + tabIndex * Dragonite.UI.TabSpacing),
            BackgroundTransparency = 1,
            TextColor3 = Dragonite.Theme.Text,
            TextSize = Dragonite.UI.TabSize,
            Font = Enum.Font.SourceSans
        })

        local TabFrame = Create("Frame", {
            Parent = Content,
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            Visible = false
        })

        TabButton.MouseButton1Click:Connect(function()
            for _,t in pairs(Window.Tabs) do
                t.Frame.Visible = false
            end
            TabFrame.Visible = true
            Window.ActiveTab = Tab
        end)

        function Tab:NextY()
            return (#Tab.Elements) * Dragonite.UI.ElementSpacing
        end

        function Tab:CreateButton(name, callback)
            local btn = Create("TextButton", {
                Parent = TabFrame,
                Text = name,
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize,
                BorderSizePixel = 0
            })
            btn.MouseButton1Click:Connect(callback)
            table.insert(Tab.Elements, btn)
        end

        function Tab:CreateToggle(name, callback)
            local state = false
            local btn = Create("TextButton", {
                Parent = TabFrame,
                Text = name.." : OFF",
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize,
                BorderSizePixel = 0
            })
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = name.." : "..(state and "ON" or "OFF")
                btn.TextColor3 = state and Dragonite.Theme.ToggleOn or Dragonite.Theme.ToggleOff
                callback(state)
            end)
            table.insert(Tab.Elements, btn)
        end

        function Tab:CreateSlider(name, min, max, callback)
            local value = min
            local SliderFrame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                BorderSizePixel = 0
            })

            local Label = Create("TextLabel", {
                Parent = SliderFrame,
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text = name.." : "..value,
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize
            })

            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move, up
                    move = UIS.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement then
                            local percent = (i.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X
                            percent = math.clamp(percent,0,1)
                            value = math.floor(min + (max-min)*percent)
                            Label.Text = name.." : "..value
                            callback(value)
                        end
                    end)
                    up = UIS.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            move:Disconnect()
                            up:Disconnect()
                        end
                    end)
                end
            end)
            table.insert(Tab.Elements, SliderFrame)
        end

        function Tab:CreateKeybind(name, callback)
            local key = nil
            local btn = Create("TextButton", {
                Parent = TabFrame,
                Text = name.." : NONE",
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize,
                BorderSizePixel = 0
            })

            btn.MouseButton1Click:Connect(function()
                btn.Text = name.." : ..."
                local conn
                conn = UIS.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        key = input.KeyCode
                        btn.Text = name.." : "..tostring(key):gsub("Enum.KeyCode.","")
                        conn:Disconnect()
                        callback(key)
                    end
                end)
            end)

            table.insert(Tab.Elements, btn)
        end

        function Tab:CreateListBox(name, items, callback)
            local listFrame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                BorderSizePixel = 0
            })

            local label = Create("TextLabel", {
                Parent = listFrame,
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text = name.." : "..(items[1] or ""),
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize
            })

            local currentIndex = 1
            listFrame.MouseButton1Click:Connect(function()
                currentIndex = currentIndex % #items + 1
                label.Text = name.." : "..items[currentIndex]
                callback(items[currentIndex])
            end)

            table.insert(Tab.Elements, listFrame)
        end

        Tab.Frame = TabFrame
        table.insert(Window.Tabs, Tab)

        if not Window.ActiveTab then
            TabFrame.Visible = true
            Window.ActiveTab = Tab
        end

        return Tab
    end

    return Window
end

return Dragonite
