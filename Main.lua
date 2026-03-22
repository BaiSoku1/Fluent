--[[ 
    PREMIUM MODERN SILVER UI (V12) - COMPLETE EDITION
    - Style: Compact & Refined
    - Features: Key System, All UI Elements, Icons Support
    - Icons: Lucide, Solar, SF Symbol
]]

local Library = {}

-- Icon loader functions
local function LoadIcon(iconName, iconSet)
    if not iconName then return nil end
    local success, icon = pcall(function()
        if iconSet == "lucide" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
        elseif iconSet == "solar" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/solar/dist/Icons.lua"))()
        elseif iconSet == "sfsymbol" then
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/sfsymbol/dist/Icons.lua"))()
        end
    end)
    if success and icon and icon[iconName] then
        return icon[iconName]
    end
    return nil
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k] = v end
    for _,c in pairs(children or {}) do c.Parent = obj end
    return obj
end

local function ApplyPremiumBorder(parent, thickness)
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    local stroke = Create("UIStroke", {
        Thickness = thickness or 2.2,
        Color = Color3.fromRGB(255, 255, 255),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    }, {
        Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 220, 220)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 30)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 220))
            }),
            Rotation = 0
        })
    })

    task.spawn(function()
        local g = stroke:FindFirstChildOfClass("UIGradient")
        while stroke and stroke.Parent do
            g.Rotation = g.Rotation + 1.5
            RunService.RenderStepped:Wait()
        end
    end)
    return stroke
end

function Library:Notify(title, content, duration, icon)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local duration = duration or 5
    local NotifGui = Player:WaitForChild("PlayerGui"):FindFirstChild("ModernNotifs") or Create("ScreenGui", {Name = "ModernNotifs", Parent = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))})
    local Holder = NotifGui:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.new(0, 280, 1, -20), Position = UDim2.new(1, -290, 0, 10), BackgroundTransparency = 1, Parent = NotifGui}, {Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8), HorizontalAlignment = "Right"})})

    local Notif = Create("Frame", {Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = Color3.fromRGB(10, 10, 10), Parent = Holder}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    ApplyPremiumBorder(Notif, 2)

    if icon then
        local iconLabel = Create("ImageLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromOffset(10, 10),
            BackgroundTransparency = 1,
            Image = icon,
            Parent = Notif
        })
    end

    Create("TextLabel", {Text = title:upper(), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = "Left", BackgroundTransparency = 1, Position = UDim2.fromOffset(icon and 40 or 10, 8), Size = UDim2.new(1, -50, 0, 15), Parent = Notif})
    Create("TextLabel", {Text = content, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = Color3.fromRGB(180, 180, 180), TextXAlignment = "Left", TextYAlignment = "Top", TextWrapped = true, BackgroundTransparency = 1, Position = UDim2.fromOffset(icon and 40 or 10, 25), Size = UDim2.new(1, -30, 0, 40), Parent = Notif})

    Notif.Position = UDim2.new(1.5, 0, 0, 0)
    TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(duration, function()
        local t = TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1})
        t:Play() t.Completed:Connect(function() Notif:Destroy() end)
    end)
end

-- Create dialog/popup
function Library:Dialog(config)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local dialogGui = Create("ScreenGui", {
        Name = "DialogGUI",
        Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
    })
    
    local overlay = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = dialogGui
    })
    
    local dialogFrame = Create("Frame", {
        Size = UDim2.fromOffset(300, 200),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Parent = overlay
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)})
    })
    ApplyPremiumBorder(dialogFrame, 2)
    
    Create("TextLabel", {
        Text = config.Title or "Dialog",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Parent = dialogFrame
    })
    
    Create("TextLabel", {
        Text = config.Content or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        Position = UDim2.fromOffset(15, 45),
        Size = UDim2.new(1, -30, 0, 80),
        BackgroundTransparency = 1,
        TextWrapped = true,
        Parent = dialogFrame
    })
    
    local inputBox = nil
    if config.Input then
        inputBox = Create("TextBox", {
            Size = UDim2.new(0.9, 0, 0, 35),
            Position = UDim2.fromOffset(15, 130),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Text = "",
            PlaceholderText = config.Placeholder or "Enter value...",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            Parent = dialogFrame
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 5)})
        })
    end
    
    local buttonFrame = Create("Frame", {
        Size = UDim2.new(1, -30, 0, 35),
        Position = UDim2.fromOffset(15, config.Input and 175 or 140),
        BackgroundTransparency = 1,
        Parent = dialogFrame
    })
    
    local confirmBtn = Create("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.fromScale(0, 0),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        Text = "Confirm",
        TextColor3 = Color3.fromRGB(20, 20, 20),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = buttonFrame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    
    local cancelBtn = Create("TextButton", {
        Size = UDim2.new(0.48, 0, 1, 0),
        Position = UDim2.fromScale(0.52, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = buttonFrame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    
    local result = nil
    confirmBtn.MouseButton1Click:Connect(function()
        result = inputBox and inputBox.Text or true
        dialogGui:Destroy()
        if config.Callback then config.Callback(result) end
    end)
    
    cancelBtn.MouseButton1Click:Connect(function()
        result = nil
        dialogGui:Destroy()
        if config.Callback then config.Callback(nil) end
    end)
    
    return dialogFrame
end

-- Create popup
function Library:Popup(config)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local popupGui = Create("ScreenGui", {
        Name = "PopupGUI",
        Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
    })
    
    local overlay = Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = popupGui
    })
    
    local popupFrame = Create("Frame", {
        Size = UDim2.fromOffset(250, 150),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Parent = overlay
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 10)})
    })
    ApplyPremiumBorder(popupFrame, 2)
    
    Create("TextLabel", {
        Text = config.Title or "Popup",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Parent = popupFrame
    })
    
    Create("TextLabel", {
        Text = config.Content or "",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(180, 180, 180),
        Position = UDim2.fromOffset(15, 45),
        Size = UDim2.new(1, -30, 0, 60),
        BackgroundTransparency = 1,
        TextWrapped = true,
        Parent = popupFrame
    })
    
    local closeBtn = Create("TextButton", {
        Size = UDim2.new(0.8, 0, 0, 30),
        Position = UDim2.fromScale(0.1, 0.75),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        Text = "OK",
        TextColor3 = Color3.fromRGB(20, 20, 20),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        Parent = popupFrame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
    
    closeBtn.MouseButton1Click:Connect(function()
        popupGui:Destroy()
        if config.Callback then config.Callback() end
    end)
    
    return popupFrame
end

-- Create animated title
local function CreateAnimatedTitle(parent, titleText, position, size, icon)
    local TweenService = game:GetService("TweenService")
    
    local titleContainer = Create("Frame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    if icon then
        local iconLabel = Create("ImageLabel", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.fromOffset(0, 8),
            BackgroundTransparency = 1,
            Image = icon,
            Parent = titleContainer
        })
    end
    
    local letters = {}
    for i = 1, #titleText do
        local char = string.sub(titleText, i, i)
        table.insert(letters, char)
    end
    
    local letterLabels = {}
    local totalWidth = icon and 22 or 0
    
    for i, letter in ipairs(letters) do
        local letterLabel = Create("TextLabel", {
            Text = letter,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(230, 230, 230),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, letter == " " and 8 or 20, 1, 0),
            Position = UDim2.new(0, totalWidth, 0, 0),
            Parent = titleContainer
        })
        
        if letter == " " then
            totalWidth = totalWidth + 8
        else
            totalWidth = totalWidth + 20
        end
        
        table.insert(letterLabels, letterLabel)
    end
    
    for i, letterLabel in ipairs(letterLabels) do
        letterLabel.TextTransparency = 1
        task.wait(0.05)
        TweenService:Create(letterLabel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            TextTransparency = 0
        }):Play()
    end
    
    return titleContainer, letterLabels
end

-- Create tag
local function CreateTag(parent, text, tagType)
    local colors = {
        success = Color3.fromRGB(0, 200, 0),
        error = Color3.fromRGB(200, 0, 0),
        warning = Color3.fromRGB(200, 150, 0),
        info = Color3.fromRGB(100, 100, 200),
        default = Color3.fromRGB(150, 150, 150)
    }
    
    local tagColor = colors[tagType] or colors.default
    
    local tag = Create("Frame", {
        Size = UDim2.new(0, text:len() * 7 + 15, 0, 20),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Parent = parent
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
        Create("UIStroke", {
            Thickness = 1,
            Color = tagColor
        })
    })
    
    Create("TextLabel", {
        Text = text,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = tagColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = tag
    })
    
    return tag
end

-- Create divider
local function CreateDivider(parent, text)
    local divider = Create("Frame", {
        Size = UDim2.new(0.96, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local line = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.fromScale(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Parent = divider
    })
    
    if text then
        local label = Create("TextLabel", {
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextSize = 10,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, text:len() * 8, 1, 0),
            Position = UDim2.fromScale(0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            Parent = divider
        })
    end
    
    return divider
end

-- Create space
local function CreateSpace(parent, height)
    local space = Create("Frame", {
        Size = UDim2.new(1, 0, 0, height or 10),
        BackgroundTransparency = 1,
        Parent = parent
    })
    return space
end

function Library:CreateWindow(config)
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    
    local titleText = config.Title or "PREMIUM UI"
    local icon = config.Icon and LoadIcon(config.Icon, "lucide")
    local keySystem = config.KeySystem
    local hasKey = false
    
    local screenGui = Create("ScreenGui", {
        Name = "PremiumSilverUI",
        ResetOnSpawn = false,
        Parent = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))
    })
    
    -- Key System GUI
    local keyFrame = nil
    if keySystem then
        keyFrame = Create("Frame", {
            Size = UDim2.fromOffset(380, 220),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(8, 8, 8),
            Visible = true,
            Parent = screenGui
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 12)})
        })
        ApplyPremiumBorder(keyFrame, 2.5)
        
        Create("TextLabel", {
            Text = titleText:upper(),
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromOffset(20, 25),
            Size = UDim2.new(1, -40, 0, 25),
            BackgroundTransparency = 1,
            Parent = keyFrame
        })
        
        if config.Author then
            Create("TextLabel", {
                Text = config.Author,
                Font = Enum.Font.Gotham,
                TextSize = 9,
                TextColor3 = Color3.fromRGB(150, 150, 150),
                Position = UDim2.fromOffset(20, 50),
                Size = UDim2.new(1, -40, 0, 15),
                BackgroundTransparency = 1,
                Parent = keyFrame
            })
        end
        
        if keySystem.Note then
            Create("TextLabel", {
                Text = keySystem.Note,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                Position = UDim2.fromOffset(20, 80),
                Size = UDim2.new(1, -40, 0, 30),
                BackgroundTransparency = 1,
                TextWrapped = true,
                Parent = keyFrame
            })
        end
        
        local keyInput = Create("TextBox", {
            Size = UDim2.new(0.9, 0, 0, 40),
            Position = UDim2.fromOffset(20, 120),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            PlaceholderText = "Enter your key...",
            Text = "",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.GothamMedium,
            TextSize = 12,
            Parent = keyFrame
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 6)})
        })
        
        local submitBtn = Create("TextButton", {
            Size = UDim2.new(0.43, 0, 0, 40),
            Position = UDim2.fromOffset(20, 170),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
            Text = "SUBMIT",
            TextColor3 = Color3.fromRGB(20, 20, 20),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            Parent = keyFrame
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        
        local getKeyBtn = Create("TextButton", {
            Size = UDim2.new(0.43, 0, 0, 40),
            Position = UDim2.fromOffset(210, 170),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = "GET KEY",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            Parent = keyFrame
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        
        submitBtn.MouseButton1Click:Connect(function()
            local enteredKey = keyInput.Text
            local valid = false
            
            if type(keySystem.Key) == "table" then
                for _, k in ipairs(keySystem.Key) do
                    if enteredKey == k then
                        valid = true
                        break
                    end
                end
            elseif type(keySystem.Key) == "string" then
                valid = enteredKey == keySystem.Key
            end
            
            if valid then
                hasKey = true
                keyFrame:Destroy()
                Library:Notify("Success", "Key verified! Welcome to " .. titleText, 3)
            else
                Library:Notify("Error", "Invalid key! Please try again.", 3, nil)
            end
        end)
        
        getKeyBtn.MouseButton1Click:Connect(function()
            if keySystem.GetKey then
                keySystem.GetKey()
            else
                Library:Dialog({
                    Title = "Get Key",
                    Content = "Join our Discord server to get a key.",
                    Callback = function()
                        Library:Notify("Info", "Check Discord for key information", 3)
                    end
                })
            end
        end)
    end
    
    -- Wait for key if needed
    if keySystem then
        repeat task.wait() until hasKey
    end
    
    local OpenButton = Create("ImageButton", {
        Size = UDim2.fromOffset(40, 40),
        Position = UDim2.new(0, 15, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        Image = icon or "rbxassetid://74666642456643",
        Parent = screenGui
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    ApplyPremiumBorder(OpenButton, 2)

    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.fromOffset(520, 380),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Visible = true,
        Parent = screenGui
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 10)})})
    ApplyPremiumBorder(MainFrame, 2.8)

    -- Draggable
    do
        local dragging, dragStart, startPos
        MainFrame.InputBegan:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                dragging = true
                dragStart = input.Position
                startPos = MainFrame.Position
            end 
        end)
        UIS.InputChanged:Connect(function(input) 
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end 
        end)
        UIS.InputEnded:Connect(function(input) 
            if input.UserInputType == Enum.UserInputType.MouseButton1 then 
                dragging = false 
            end 
        end)
    end

    OpenButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then 
            MainFrame:TweenSize(UDim2.fromOffset(520, 380), "Out", "Back", 0.4, true)
            if titleContainer and letterLabels then
                for _, letterLabel in ipairs(letterLabels) do
                    letterLabel.TextTransparency = 1
                end
                for i, letterLabel in ipairs(letterLabels) do
                    task.wait(0.05)
                    TweenService:Create(letterLabel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        TextTransparency = 0
                    }):Play()
                end
            end
        end
    end)

    local TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = MainFrame
    })
    
    local titleContainer, letterLabels = CreateAnimatedTitle(TopBar, titleText, UDim2.fromOffset(12, 0), UDim2.new(1, -100, 1, 0), icon)
    
    if config.Author then
        Create("TextLabel", {
            Text = config.Author,
            Font = Enum.Font.Gotham,
            TextSize = 8,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -110, 0, 28),
            Size = UDim2.new(0, 100, 0, 10),
            Parent = TopBar
        })
    end
    
    local CloseBtn = Create("ImageButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -30, 0, 10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://74666642456643",
        ImageColor3 = Color3.fromRGB(200, 200, 200),
        Parent = TopBar
    })
    CloseBtn.MouseButton1Click:Connect(function() 
        MainFrame:TweenSize(UDim2.fromOffset(0, 0), "In", "Back", 0.3, true, function() 
            MainFrame.Visible = false 
        end) 
    end)

    -- Sidebar
    local Sidebar = Create("ScrollingFrame", {
        Size = UDim2.new(0, 130, 1, -50),
        Position = UDim2.fromOffset(10, 50),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        Parent = MainFrame,
        ScrollBarThickness = 0
    }, {
        Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
        Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}),
        Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)})
    })
    ApplyPremiumBorder(Sidebar, 1.2)

    -- Container
    local Container = Create("ScrollingFrame", {
        Size = UDim2.new(1, -150, 1, -50),
        Position = UDim2.fromOffset(150, 50),
        BackgroundTransparency = 1,
        Parent = MainFrame,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    })

    local Window = {}
    local firstTab = true
    local tabs = {}
    local currentTab = nil

    function Window:CreateTab(name, tabIcon)
        local TabBtn = Create("TextButton", {
            Size = UDim2.new(0.85, 0, 0, 32),
            BackgroundColor3 = firstTab and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(20, 20, 20),
            Text = name,
            TextColor3 = firstTab and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            Parent = Sidebar
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        
        if tabIcon then
            local iconImg = LoadIcon(tabIcon, "lucide")
            if iconImg then
                Create("ImageLabel", {
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.fromOffset(8, 9),
                    BackgroundTransparency = 1,
                    Image = iconImg,
                    ImageColor3 = firstTab and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200),
                    Parent = TabBtn
                })
                TabBtn.Text = "  " .. name
            end
        end
        
        local Page = Create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Visible = firstTab,
            ScrollBarThickness = 0,
            Parent = Container
        }, {
            Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5)})
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Sidebar:GetChildren()) do 
                if v:IsA("TextButton") then 
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                    for _, img in pairs(v:GetChildren()) do
                        if img:IsA("ImageLabel") then
                            TweenService:Create(img, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                        end
                    end
                end 
            end
            for _, v in pairs(Container:GetChildren()) do 
                v.Visible = false 
            end
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(220, 220, 220), TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            for _, img in pairs(TabBtn:GetChildren()) do
                if img:IsA("ImageLabel") then
                    TweenService:Create(img, TweenInfo.new(0.3), {ImageColor3 = Color3.fromRGB(20, 20, 20)}):Play()
                end
            end
            Page.Visible = true
            currentTab = Page
        end)

        firstTab = false
        local Tab = {}
        
        -- Create section
        function Tab:CreateSection(title)
            local section = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            ApplyPremiumBorder(section, 1)
            
            Create("TextLabel", {
                Text = title:upper(),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 12),
                Size = UDim2.new(1, -24, 0, 20),
                Parent = section
            })
            
            return section
        end
        
        -- Create section tab
        function Tab:CreateSectionTab(title, items)
            local sectionTabFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 45),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {
                Create("UICorner", {CornerRadius = UDim.new(0, 6)})
            })
            ApplyPremiumBorder(sectionTabFrame, 1)
            
            local buttonContainer = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
                Position = UDim2.fromOffset(5, 10),
                BackgroundTransparency = 1,
                Parent = sectionTabFrame
            })
            
            local buttons = {}
            local activeIndex = 1
            
            for i, item in ipairs(items) do
                local btn = Create("TextButton", {
                    Size = UDim2.new(1 / #items, -5, 1, 0),
                    Position = UDim2.new((i-1) / #items, 5, 0, 0),
                    BackgroundColor3 = i == 1 and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(30, 30, 30),
                    Text = item.name,
                    TextColor3 = i == 1 and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200),
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                    Parent = buttonContainer
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                
                btn.MouseButton1Click:Connect(function()
                    for j, b in ipairs(buttons) do
                        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
                    end
                    TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 200, 200), TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
                    activeIndex = i
                    if item.callback then item.callback() end
                end)
                
                table.insert(buttons, btn)
            end
            
            return sectionTabFrame
        end
        
        -- Create button
        function Tab:CreateButton(text, callback, buttonIcon)
            local Btn = Create("TextButton", {
                Size = UDim2.new(0.96, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Text = text,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(Btn, 1)
            
            if buttonIcon then
                local iconImg = LoadIcon(buttonIcon, "lucide")
                if iconImg then
                    Create("ImageLabel", {
                        Size = UDim2.fromOffset(14, 14),
                        Position = UDim2.fromOffset(10, 12),
                        BackgroundTransparency = 1,
                        Image = iconImg,
                        Parent = Btn
                    })
                    Btn.Text = "  " .. text
                end
            end
            
            Btn.MouseButton1Click:Connect(function() 
                if callback then callback() end 
                Btn:TweenSize(UDim2.new(0.9, 0, 0, 35), "Out", "Quad", 0.1, true, function() 
                    Btn:TweenSize(UDim2.new(0.96, 0, 0, 38), "Out", "Quad", 0.1, true) 
                end) 
            end)
        end
        
        -- Create toggle
        function Tab:CreateToggle(text, callback, default)
            local TglFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 38),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(TglFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Parent = TglFrame
            })
            
            local TglBtn = Create("TextButton", {
                Size = UDim2.fromOffset(40, 20),
                Position = UDim2.new(1, -52, 0.5, -10),
                BackgroundColor3 = default and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(35, 35, 35),
                Text = "",
                Parent = TglFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            local Circle = Create("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = default and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = TglBtn
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            local toggled = default or false
            TglBtn.MouseButton1Click:Connect(function() 
                toggled = not toggled
                local targetPos = toggled and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
                local targetColor = toggled and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(35, 35, 35)
                TweenService:Create(Circle, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                TweenService:Create(TglBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                if callback then callback(toggled) end 
            end)
        end
        
        -- Create slider
        function Tab:CreateSlider(text, min, max, default, callback)
            local SliderFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 65),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(SliderFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 8),
                Size = UDim2.new(1, -80, 0, 18),
                Parent = SliderFrame
            })
            
            local ValueLabel = Create("TextLabel", {
                Text = tostring(default),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(220, 220, 220),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -45, 0, 8),
                Size = UDim2.new(0, 40, 0, 18),
                Parent = SliderFrame
            })
            
            local SliderBar = Create("Frame", {
                Size = UDim2.new(0.9, 0, 0, 4),
                Position = UDim2.new(0.05, 0, 0.7, 0),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Parent = SliderFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            local Fill = Create("Frame", {
                Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Parent = SliderBar
            }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
            
            local value = default
            local dragging = false
            
            local function update(input)
                local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                ValueLabel.Text = tostring(value)
                if callback then callback(value) end
            end
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            
            UIS.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    update(input)
                end
            end)
            
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
        end
        
        -- Create dropdown
        function Tab:CreateDropdown(text, options, default, callback)
            local DropdownFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 45),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(DropdownFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Parent = DropdownFrame
            })
            
            local selectedLabel = Create("TextLabel", {
                Text = default or options[1],
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = Color3.fromRGB(180, 180, 180),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Position = UDim2.new(1, -105, 0.5, -12),
                Size = UDim2.fromOffset(95, 24),
                Parent = DropdownFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            
            local dropdownOpen = false
            local dropdownList = nil
            
            selectedLabel.MouseButton1Click:Connect(function()
                if dropdownOpen then
                    if dropdownList then dropdownList:Destroy() end
                    dropdownOpen = false
                else
                    dropdownList = Create("Frame", {
                        Size = UDim2.new(0.96, 0, 0, 0),
                        Position = UDim2.fromOffset(0, 45),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        Parent = DropdownFrame,
                        ClipsDescendants = true
                    }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
                    
                    local listLayout = Create("UIListLayout", {
                        Padding = UDim.new(0, 2),
                        Parent = dropdownList
                    })
                    
                    for _, option in ipairs(options) do
                        local optionBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                            Text = option,
                            TextColor3 = Color3.fromRGB(200, 200, 200),
                            Font = Enum.Font.GothamMedium,
                            TextSize = 10,
                            Parent = dropdownList
                        }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
                        
                        optionBtn.MouseButton1Click:Connect(function()
                            selectedLabel.Text = option
                            if callback then callback(option) end
                            dropdownList:Destroy()
                            dropdownOpen = false
                        end)
                    end
                    
                    local height = #options * 30 + 5
                    dropdownList.Size = UDim2.new(0.96, 0, 0, height)
                    dropdownOpen = true
                end
            end)
        end
        
        -- Create input
        function Tab:CreateInput(text, placeholder, callback)
            local InputFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 45),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(InputFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -140, 1, 0),
                Parent = InputFrame
            })
            
            local inputBox = Create("TextBox", {
                Size = UDim2.fromOffset(120, 28),
                Position = UDim2.new(1, -132, 0.5, -14),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                PlaceholderText = placeholder or "Enter text...",
                Text = "",
                TextColor3 = Color3.fromRGB(200, 200, 200),
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                Parent = InputFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            
            inputBox:GetPropertyChangedSignal("Text"):Connect(function()
                if callback then callback(inputBox.Text) end
            end)
        end
        
        -- Create paragraph
        function Tab:CreateParagraph(text)
            local ParaFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page,
                AutomaticSize = Enum.AutomaticSize.Y
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(ParaFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 10,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextWrapped = true,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 12),
                Size = UDim2.new(1, -24, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ParaFrame
            })
            
            ParaFrame.Size = UDim2.new(0.96, 0, 0, ParaFrame:FindFirstChildOfClass("TextLabel").TextBounds.Y + 24)
        end
        
        -- Create keybind
        function Tab:CreateKeybind(text, default, callback)
            local KeybindFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 45),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(KeybindFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -140, 1, 0),
                Parent = KeybindFrame
            })
            
            local keyLabel = Create("TextButton", {
                Size = UDim2.fromOffset(100, 28),
                Position = UDim2.new(1, -112, 0.5, -14),
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Text = default and tostring(default) or "None",
                TextColor3 = Color3.fromRGB(200, 200, 200),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                Parent = KeybindFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            
            local waiting = false
            local currentKey = default
            
            keyLabel.MouseButton1Click:Connect(function()
                waiting = true
                keyLabel.Text = "..."
                
                local connection
                connection = UIS.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if waiting then
                        local key = input.KeyCode
                        if key ~= Enum.KeyCode.Unknown then
                            currentKey = key
                            keyLabel.Text = tostring(key):gsub("Enum.KeyCode.", "")
                            if callback then callback(currentKey) end
                            waiting = false
                            connection:Disconnect()
                        end
                    end
                end)
                
                task.wait(3)
                if waiting then
                    waiting = false
                    keyLabel.Text = currentKey and tostring(currentKey):gsub("Enum.KeyCode.", "") or "None"
                    connection:Disconnect()
                end
            end)
        end
        
        -- Create colorpicker
        function Tab:CreateColorPicker(text, default, callback)
            local ColorFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 45),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(ColorFrame, 1)
            
            Create("TextLabel", {
                Text = text,
                Font = Enum.Font.GothamMedium,
                TextSize = 11,
                TextColor3 = Color3.fromRGB(200, 200, 200),
                TextXAlignment = "Left",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 0),
                Size = UDim2.new(1, -100, 1, 0),
                Parent = ColorFrame
            })
            
            local colorDisplay = Create("Frame", {
                Size = UDim2.fromOffset(30, 30),
                Position = UDim2.new(1, -42, 0.5, -15),
                BackgroundColor3 = default or Color3.fromRGB(200, 100, 100),
                Parent = ColorFrame
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 4)})})
            ApplyPremiumBorder(colorDisplay, 1)
            
            local colorPickerOpen = false
            local colorPicker = nil
            
            colorDisplay.MouseButton1Click:Connect(function()
                if colorPickerOpen then
                    if colorPicker then colorPicker:Destroy() end
                    colorPickerOpen = false
                else
                    colorPicker = Create("Frame", {
                        Size = UDim2.fromOffset(180, 150),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                        Parent = ColorFrame
                    }, {Create("UICorner", {CornerRadius = UDim.new(0, 8)})})
                    
                    local rSlider, gSlider, bSlider
                    
                    local function updateColor()
                        local color = Color3.fromRGB(rSlider.Value, gSlider.Value, bSlider.Value)
                        colorDisplay.BackgroundColor3 = color
                        if callback then callback(color) end
                    end
                    
                    rSlider = CreateSlider(colorPicker, "R", 0, 255, default and default.R * 255 or 200, updateColor)
                    gSlider = CreateSlider(colorPicker, "G", 0, 255, default and default.G * 255 or 100, updateColor)
                    bSlider = CreateSlider(colorPicker, "B", 0, 255, default and default.B * 255 or 100, updateColor)
                    
                    colorPickerOpen = true
                end
            end)
        end
        
        -- Create code
        function Tab:CreateCode(codeText)
            local CodeFrame = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 0),
                BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                Parent = Page,
                AutomaticSize = Enum.AutomaticSize.Y
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
            ApplyPremiumBorder(CodeFrame, 1)
            
            local codeLabel = Create("TextLabel", {
                Text = codeText,
                Font = Enum.Font.Code,
                TextSize = 10,
                TextColor3 = Color3.fromRGB(150, 220, 150),
                TextWrapped = true,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(12, 12),
                Size = UDim2.new(1, -24, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = CodeFrame
            })
            
            CodeFrame.Size = UDim2.new(0.96, 0, 0, codeLabel.TextBounds.Y + 24)
        end
        
        -- Create space
        function Tab:CreateSpace(height)
            CreateSpace(Page, height or 10)
        end
        
        -- Create divider
        function Tab:CreateDivider(text)
            CreateDivider(Page, text)
        end
        
        -- Create tag
        function Tab:CreateTag(text, tagType)
            local tagContainer = Create("Frame", {
                Size = UDim2.new(0.96, 0, 0, 30),
                BackgroundTransparency = 1,
                Parent = Page
            })
            CreateTag(tagContainer, text, tagType)
        end
        
        -- Create notification
        function Tab:CreateNotification(title, content, duration, icon)
            Library:Notify(title, content, duration, icon)
        end
        
        return Tab
    end

    return Window
end

-- Helper function for slider in colorpicker
local function CreateSlider(parent, label, min, max, default, callback)
    local sliderFrame = Create("Frame", {
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.fromScale(0.05, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    Create("TextLabel", {
        Text = label,
        Font = Enum.Font.GothamMedium,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(0, 5),
        Parent = sliderFrame
    })
    
    local valueLabel = Create("TextLabel", {
        Text = tostring(default),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(30, 20),
        Position = UDim2.new(1, -35, 0, 5),
        Parent = sliderFrame
    })
    
    local sliderBar = Create("Frame", {
        Size = UDim2.new(0.7, 0, 0, 3),
        Position = UDim2.fromOffset(25, 13),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Parent = sliderFrame
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    local fill = Create("Frame", {
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        Parent = sliderBar
    }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
    
    local value = default
    local dragging = false
    local UIS = game:GetService("UserInputService")
    
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value)
        if callback then callback() end
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            update(input)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderFrame
end

-- Return the library for URL loading
return Library
