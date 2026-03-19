local Dragonite = {}

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

Dragonite.Theme = {
    Background = Color3.fromRGB(18,18,18),
    Panel = Color3.fromRGB(24,24,24),
    Accent = Color3.fromRGB(180,20,20),
    Text = Color3.fromRGB(255,255,255)
}

Dragonite.UI = {
    TitleSize = 15,
    TabSize = 13,
    ElementSize = 12,
    TabSpacing = 30,
    ElementSpacing = 25
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i,v in pairs(props) do
        obj[i] = v
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

    local Accent = Create("Frame", {
        Parent = Main,
        Size = UDim2.new(0,2,1,0),
        Position = UDim2.new(0,90,0,0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    })

    local Title = Create("TextLabel", {
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

    -- DRAGGING
    local dragging = false
    local dragOffset

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragOffset = input.Position - Main.AbsolutePosition
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position - dragOffset
            Main.Position = UDim2.new(0,pos.X,0,pos.Y)
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
                callback(state)
            end)

            table.insert(Tab.Elements, btn)
        end

        function Tab:CreateSlider(name, min, max, callback)
            local value = min

            local Frame = Create("Frame", {
                Parent = TabFrame,
                Size = UDim2.new(0,150,0,25),
                Position = UDim2.new(0,0,0,Tab:NextY()),
                BackgroundColor3 = Dragonite.Theme.Panel,
                BorderSizePixel = 0
            })

            local Label = Create("TextLabel", {
                Parent = Frame,
                Size = UDim2.new(1,0,1,0),
                BackgroundTransparency = 1,
                Text = name.." : "..value,
                TextColor3 = Dragonite.Theme.Text,
                TextSize = Dragonite.UI.ElementSize
            })

            Frame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local move
                    move = UIS.InputChanged:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseMovement then
                            local percent = (i.Position.X - Frame.AbsolutePosition.X) / Frame.AbsoluteSize.X
                            percent = math.clamp(percent,0,1)

                            value = math.floor(min + (max-min)*percent)
                            Label.Text = name.." : "..value
                            callback(value)
                        end
                    end)

                    local up
                    up = UIS.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            move:Disconnect()
                            up:Disconnect()
                        end
                    end)
                end
            end)

            table.insert(Tab.Elements, Frame)
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
