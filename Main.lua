--[[ 
    PREMIUM MODERN SILVER UI (V11) - FINAL COMPLETE
    - Style: Compact & Refined
    - Features: URL Loader, Animated Title (letter by letter), Complete Key System
    - Key Methods: Local Keys, URL Get Key (copy to clipboard), PlatoBoost, PandaDevelopment, LuaArmor
    - Usage: loadstring(game:HttpGet("YOUR_URL_HERE"))()
]]

local Library = {}

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

function Library:Notify(title, content, duration)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    
    local duration = duration or 5
    local NotifGui = Player:WaitForChild("PlayerGui"):FindFirstChild("ModernNotifs") or Create("ScreenGui", {Name = "ModernNotifs", Parent = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))})
    local Holder = NotifGui:FindFirstChild("Holder") or Create("Frame", {Name = "Holder", Size = UDim2.new(0, 220, 1, -20), Position = UDim2.new(1, -230, 0, 10), BackgroundTransparency = 1, Parent = NotifGui}, {Create("UIListLayout", {VerticalAlignment = "Bottom", Padding = UDim.new(0, 8), HorizontalAlignment = "Right"})})

    local Notif = Create("Frame", {Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = Color3.fromRGB(10, 10, 10), Parent = Holder}, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    ApplyPremiumBorder(Notif, 2)

    Create("TextLabel", {Text = title:upper(), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Color3.fromRGB(255, 255, 255), TextXAlignment = "Left", BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 8), Size = UDim2.new(1, -40, 0, 15), Parent = Notif})
    Create("TextLabel", {Text = content, Font = Enum.Font.GothamMedium, TextSize = 10, TextColor3 = Color3.fromRGB(180, 180, 180), TextXAlignment = "Left", TextYAlignment = "Top", TextWrapped = true, BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 25), Size = UDim2.new(1, -20, 0, 30), Parent = Notif})

    Notif.Position = UDim2.new(1.5, 0, 0, 0)
    TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(duration, function()
        local t = TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1.5, 0, 0, 0), BackgroundTransparency = 1})
        t:Play() t.Completed:Connect(function() Notif:Destroy() end)
    end)
end

local function CreateAnimatedTitle(parent, titleText, position, size, textSize)
    local TweenService = game:GetService("TweenService")
    textSize = textSize or 14
    
    local titleContainer = Create("Frame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local letters = {}
    for i = 1, #titleText do
        local char = string.sub(titleText, i, i)
        table.insert(letters, char)
    end
    
    local letterLabels = {}
    local totalWidth = 0
    
    for i, letter in ipairs(letters) do
        local letterLabel = Create("TextLabel", {
            Text = letter,
            Font = Enum.Font.GothamBold,
            TextSize = textSize,
            TextColor3 = Color3.fromRGB(230, 230, 230),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, letter == " " and (textSize/2) or textSize + 4, 1, 0),
            Position = UDim2.new(0, totalWidth, 0, 0),
            Parent = titleContainer
        })
        
        if letter == " " then
            totalWidth = totalWidth + (textSize/2)
        else
            totalWidth = totalWidth + (textSize + 4)
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

local function ShowKeySystem(config, callback)
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local HttpService = game:GetService("HttpService")
    local Clipboard = game:GetService("Clipboard")
    
    local screenGui = Create("ScreenGui", {
        Name = "KeySystemUI",
        ResetOnSpawn = false,
        Parent = game:GetService("CoreGui") or Player:WaitForChild("PlayerGui")
    })
    
    local Background = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        Parent = screenGui
    })
    
    local KeyWindow = Create("Frame", {
        Size = UDim2.fromOffset(450, 470),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Parent = screenGui
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 12)})})
    ApplyPremiumBorder(KeyWindow, 2.5)
    
    local titleText = "KEY SYSTEM"
    local titleContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        Parent = KeyWindow
    })
    
    local letters = {}
    for i = 1, #titleText do
        table.insert(letters, string.sub(titleText, i, i))
    end
    
    local totalWidth = 0
    local letterLabels = {}
    for i, letter in ipairs(letters) do
        local letterLabel = Create("TextLabel", {
            Text = letter,
            Font = Enum.Font.GothamBold,
            TextSize = 24,
            TextColor3 = Color3.fromRGB(230, 230, 230),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, letter == " " and 12 or 28, 0, 50),
            Position = UDim2.new(0.5, -((#letters * 28)/2) + totalWidth, 0, 5),
            Parent = titleContainer
        })
        
        if letter == " " then
            totalWidth = totalWidth + 12
        else
            totalWidth = totalWidth + 28
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
    
    local yOffset = 70
    
    if config.Thumbnail and config.Thumbnail.Image then
        local ThumbnailFrame = Create("Frame", {
            Size = UDim2.new(0, 80, 0, 80),
            Position = UDim2.new(0.5, -40, 0, yOffset),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = KeyWindow
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 10)})})
        
        local ThumbnailImage = Create("ImageLabel", {
            Size = UDim2.new(1, -4, 1, -4),
            Position = UDim2.fromOffset(2, 2),
            BackgroundTransparency = 1,
            Image = config.Thumbnail.Image,
            Parent = ThumbnailFrame
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 8)})})
        
        if config.Thumbnail.Title then
            Create("TextLabel", {
                Text = config.Thumbnail.Title,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(230, 230, 230),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, -100, 0, yOffset + 85),
                Size = UDim2.new(0, 200, 0, 25),
                Parent = KeyWindow
            })
        end
        yOffset = yOffset + 120
    end
    
    if config.Note then
        Create("TextLabel", {
            Text = config.Note,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 20, 0, yOffset),
            Size = UDim2.new(1, -40, 0, 40),
            TextWrapped = true,
            Parent = KeyWindow
        })
        yOffset = yOffset + 45
    end
    
    local KeyBox = Create("Frame", {
        Size = UDim2.new(0.85, 0, 0, 45),
        Position = UDim2.new(0.5, -190, 0, yOffset),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        Parent = KeyWindow
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 8)})})
    
    local KeyInput = Create("TextBox", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        PlaceholderText = "Enter your key...",
        Text = "",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        ClearTextOnFocus = false,
        Parent = KeyBox
    })
    
    if config.SaveKey then
        local savedKey = getgenv and getgenv().SavedKey or nil
        if savedKey then
            KeyInput.Text = savedKey
        end
    end
    
    local ButtonsFrame = Create("Frame", {
        Size = UDim2.new(0.85, 0, 0, 40),
        Position = UDim2.new(0.5, -190, 0, yOffset + 55),
        BackgroundTransparency = 1,
        Parent = KeyWindow
    })
    
    local VerifyBtn = Create("TextButton", {
        Size = UDim2.new(config.URL and 0.48 or 1, 0, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = "VERIFY",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(220, 220, 220),
        Parent = ButtonsFrame
    }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
    ApplyPremiumBorder(VerifyBtn, 1.5)
    
    if config.URL then
        local GetKeyBtn = Create("TextButton", {
            Size = UDim2.new(0.48, 0, 1, 0),
            Position = UDim2.new(0.52, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            Text = "GET KEY",
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = Color3.fromRGB(220, 220, 220),
            Parent = ButtonsFrame
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
        ApplyPremiumBorder(GetKeyBtn, 1.5)
        
        GetKeyBtn.MouseButton1Click:Connect(function()
            Clipboard:set(config.URL)
            Library:Notify("URL Copied!", "Key URL copied to clipboard!", 3)
        end)
    end
    
    local StatusText = Create("TextLabel", {
        Text = "Enter your key to continue",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, yOffset + 105),
        Size = UDim2.new(1, 0, 0, 30),
        Parent = KeyWindow
    })
    
    local function VerifyKey(key)
        StatusText.Text = "Verifying key..."
        StatusText.TextColor3 = Color3.fromRGB(255, 200, 100)
        
        local verified = false
        
        if config.Key and type(config.Key) == "table" then
            for _, validKey in ipairs(config.Key) do
                if key == validKey then
                    verified = true
                    break
                end
            end
        end
        
        if not verified and config.API then
            for _, api in ipairs(config.API) do
                if api.Type == "platoboost" and api.ServiceId and api.Secret then
                    local success, response = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet("https://api.platoboost.com/v1/verify/" .. api.ServiceId .. "/" .. key .. "?secret=" .. api.Secret))
                    end)
                    if success and response and response.valid then
                        verified = true
                        break
                    end
                elseif api.Type == "pandadevelopment" and api.ServiceId then
                    local success, response = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet("https://api.pandadevelopment.net/verify/" .. api.ServiceId .. "/" .. key))
                    end)
                    if success and response and response.success then
                        verified = true
                        break
                    end
                elseif api.Type == "luarmor" and api.ScriptId then
                    local success, response = pcall(function()
                        return HttpService:JSONDecode(game:HttpGet("https://api.luarmor.net/v3/scripts/" .. api.ScriptId .. "/verify?key=" .. key))
                    end)
                    if success and response and response.valid then
                        verified = true
                        break
                    end
                end
            end
        end
        
        if verified then
            StatusText.Text = "✓ Key verified successfully!"
            StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            if config.SaveKey then
                getgenv().SavedKey = key
            end
            
            task.wait(1)
            screenGui:Destroy()
            if callback then callback(true) end
        else
            StatusText.Text = "✗ Invalid key! Please try again."
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
    
    VerifyBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text ~= "" then
            VerifyKey(KeyInput.Text)
        else
            StatusText.Text = "Please enter a key!"
            StatusText.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
            if KeyInput.Text ~= "" then
                VerifyKey(KeyInput.Text)
            end
        end
    end)
    
    local CloseBtn = Create("ImageButton", {
        Size = UDim2.fromOffset(25, 25),
        Position = UDim2.new(1, -35, 0, 10),
        BackgroundTransparency = 1,
        Image = "rbxassetid://74666642456643",
        ImageColor3 = Color3.fromRGB(200, 200, 200),
        Parent = KeyWindow
    })
    CloseBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        if callback then callback(false) end
    end)
    
    KeyWindow.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(KeyWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(450, 470)
    }):Play()
end

function Library:CreateWindow(config)
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    
    local titleText = config.Title or "PREMIUM UI"
    local windowCreated = false
    local screenGui = nil
    local MainFrame = nil
    local OpenButton = nil
    local titleContainer = nil
    local letterLabels = nil
    
    if config.KeySystem then
        ShowKeySystem(config.KeySystem, function(verified)
            if verified then
                CreateMainUI()
            else
                Library:Notify("Access Denied", "Key verification failed!", 3)
            end
        end)
    else
        CreateMainUI()
    end
    
    function CreateMainUI()
        if windowCreated then return end
        windowCreated = true
        
        screenGui = Create("ScreenGui", {
            Name = "PremiumSilverUI",
            ResetOnSpawn = false,
            Parent = (game:GetService("CoreGui") or Player:WaitForChild("PlayerGui"))
        })
    
        OpenButton = Create("ImageButton", {
            Size = UDim2.fromOffset(40, 40),
            Position = UDim2.new(0, 15, 0.5, -20),
            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
            Image = "rbxassetid://74666642456643",
            Parent = screenGui
        }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
        ApplyPremiumBorder(OpenButton, 2)
    
        MainFrame = Create("Frame", {
            Name = "MainFrame",
            Size = UDim2.fromOffset(420, 280),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(8, 8, 8),
            Visible = true,
            Parent = screenGui
        }, {Create("UICorner", {CornerRadius = UDim.new(0, 10)})})
        ApplyPremiumBorder(MainFrame, 2.8)
    
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
                MainFrame:TweenSize(UDim2.fromOffset(420, 280), "Out", "Back", 0.4, true)
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
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Parent = MainFrame
        })
        
        titleContainer, letterLabels = CreateAnimatedTitle(TopBar, titleText, UDim2.fromOffset(12, 0), UDim2.new(1, -60, 1, 0), 14)
        
        if config.Author then
            Create("TextLabel", {
                Text = config.Author,
                Font = Enum.Font.Gotham,
                TextSize = 8,
                TextColor3 = Color3.fromRGB(150, 150, 150),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -100, 0, 25),
                Size = UDim2.new(0, 100, 0, 10),
                Parent = TopBar
            })
        end
        
        local CloseBtn = Create("ImageButton", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(1, -30, 0, 8),
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
    
        local Sidebar = Create("Frame", {
            Size = UDim2.new(0, 110, 1, -55),
            Position = UDim2.fromOffset(10, 45),
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = MainFrame
        }, {
            Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
            Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center"}),
            Create("UIPadding", {PaddingTop = UDim.new(0, 8)})
        })
        ApplyPremiumBorder(Sidebar, 1.2)
    
        local Container = Create("Frame", {
            Size = UDim2.new(1, -140, 1, -55),
            Position = UDim2.fromOffset(130, 45),
            BackgroundTransparency = 1,
            Parent = MainFrame
        })
    
        local Window = {}
        local firstTab = true
    
        function Window:CreateTab(name)
            local TabBtn = Create("TextButton", {
                Size = UDim2.new(0.85, 0, 0, 30),
                BackgroundColor3 = firstTab and Color3.fromRGB(220, 220, 220) or Color3.fromRGB(20, 20, 20),
                Text = name,
                TextColor3 = firstTab and Color3.fromRGB(20, 20, 20) or Color3.fromRGB(200, 200, 200),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                Parent = Sidebar
            }, {Create("UICorner", {CornerRadius = UDim.new(0, 5)})})
            
            local Page = Create("ScrollingFrame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Visible = firstTab,
                ScrollBarThickness = 0,
                Parent = Container
            }, {
                Create("UIListLayout", {Padding = UDim.new(0, 8), HorizontalAlignment = "Center"}),
                Create("UIPadding", {PaddingTop = UDim.new(0, 2)})
            })
    
            TabBtn.MouseButton1Click:Connect(function()
                for _, v in pairs(Sidebar:GetChildren()) do 
                    if v:IsA("TextButton") then 
                        TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play() 
                    end 
                end
                for _, v in pairs(Container:GetChildren()) do 
                    v.Visible = false 
                end
                TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(220, 220, 220), TextColor3 = Color3.fromRGB(20, 20, 20)}):Play()
                Page.Visible = true
            end)
    
            firstTab = false
            local Tab = {}
    
            function Tab:CreateButton(text, callback)
                local Btn = Create("TextButton", {
                    Size = UDim2.new(0.96, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(18, 18, 18),
                    Text = text,
                    TextColor3 = Color3.fromRGB(230, 230, 230),
                    Font = Enum.Font.GothamMedium,
                    TextSize = 11,
                    Parent = Page
                }, {Create("UICorner", {CornerRadius = UDim.new(0, 6)})})
                ApplyPremiumBorder(Btn, 1)
                Btn.MouseButton1Click:Connect(function() 
                    if callback then callback() end 
                    Btn:TweenSize(UDim2.new(0.9, 0, 0, 32), "Out", "Quad", 0.1, true, function() 
                        Btn:TweenSize(UDim2.new(0.96, 0, 0, 35), "Out", "Quad", 0.1, true) 
                    end) 
                end)
            end
    
            function Tab:CreateToggle(text, callback)
                local TglFrame = Create("Frame", {
                    Size = UDim2.new(0.96, 0, 0, 35),
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
                    Position = UDim2.fromOffset(10, 0),
                    Size = UDim2.new(1, -60, 1, 0),
                    Parent = TglFrame
                })
                
                local TglBtn = Create("TextButton", {
                    Size = UDim2.fromOffset(36, 18),
                    Position = UDim2.new(1, -46, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Text = "",
                    Parent = TglFrame
                }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local Circle = Create("Frame", {
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.fromOffset(2, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = TglBtn
                }, {Create("UICorner", {CornerRadius = UDim.new(1, 0)})})
                
                local toggled = false
                TglBtn.MouseButton1Click:Connect(function() 
                    toggled = not toggled
                    local targetPos = toggled and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2)
                    local targetColor = toggled and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(35, 35, 35)
                    TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                    TweenService:Create(TglBtn, TweenInfo.new(0.3), {BackgroundColor3 = targetColor}):Play()
                    if callback then callback(toggled) end 
                end)
            end
    
            function Tab:CreateSlider(text, min, max, default, callback)
                local SliderFrame = Create("Frame", {
                    Size = UDim2.new(0.96, 0, 0, 55),
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
                    Position = UDim2.fromOffset(10, 5),
                    Size = UDim2.new(1, -20, 0, 15),
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    Text = tostring(default),
                    Font = Enum.Font.GothamBold,
                    TextSize = 10,
                    TextColor3 = Color3.fromRGB(220, 220, 220),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -40, 0, 5),
                    Size = UDim2.new(0, 35, 0, 15),
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
    
            return Tab
        end
    
        return Window
    end
end

return Library
