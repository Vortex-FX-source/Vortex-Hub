-- SYZO Hub - Ultimate Universal Auto-Loader
-- Developer: Syzo Gamer

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- ═══ CONFIGURATION ═══
local VALID_KEYS = { "syzo1234@++++c" }
local KEY_SAVE_NAME = "SYZO_SavedKey.txt"
local DISCORD_LINK = "https://discord.gg/sAUgSnu42T"

local SCRIPTS = {
    {
        Name = "Blox Fruits",
        Description = "Sea 1, Sea 2, and Sea 3",
        Icon = "",
        URL = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua",
        GameId = 2753915549,
    },
    {
        Name = "Blox Fruits (Sea 2)",
        Description = "Sea 2",
        Icon = "",
        URL = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua",
        GameId = 4442272183,
    },
    {
        Name = "Blox Fruits (Sea 3)",
        Description = "Sea 3",
        Icon = "",
        URL = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua",
        GameId = 7449423635,
    },
    {
        Name = "Blox Fruits (Sea 3 Alt)",
        Description = "Sea 3 Alt",
        Icon = "",
        URL = "https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua",
        GameId = 7447361652,
    },
    {
        Name = "Anime Card Collection",
        Description = "Auto buy, auto grade, auto tokens, and more",
        Icon = "",
        URL = "https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexAnimeCardsCollection",
        GameId = 76285745979410,
    },
    {
        Name = "Waifu Cards Collection",
        Description = "Auto buy, auto grade, auto tokens, auto showdown, and more",
        Icon = "",
        URL = "https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/AnimeWifuCardCollection",
        GameId = 9952351777,
    },
}

-- ═══ FIND MATCHING SCRIPT ═══
local currentGameScript = nil
for _, scriptData in ipairs(SCRIPTS) do
    if scriptData.GameId == game.PlaceId then
        currentGameScript = scriptData
        break
    end
end

-- ═══ KEY SAVE/LOAD ═══
local function saveKey(key)
    pcall(function()
        if writefile then
            writefile(KEY_SAVE_NAME, key)
        end
    end)
end

local function loadSavedKey()
    local success, result = pcall(function()
        if isfile and readfile and isfile(KEY_SAVE_NAME) then
            return readfile(KEY_SAVE_NAME)
        end
        return nil
    end)
    if success then
        return result
    end
    return nil
end

local function isKeyValid(key)
    if not key or key == "" then
        return false
    end
    key = key:gsub("^%s+", ""):gsub("%s+$", "")
    for _, k in ipairs(VALID_KEYS) do
        if key == k then
            return true
        end
    end
    return false
end

-- ═══ CHECK SAVED KEY — AUTO LAUNCH ═══
local savedKey = loadSavedKey()
if isKeyValid(savedKey) and currentGameScript then
    -- Key already saved and game is supported — skip UI entirely
    pcall(function()
        loadstring(game:HttpGet(currentGameScript.URL))()
    end)
    return
end

-- ═══ COLOR SYSTEM (more colorful, readable) ═══
local C = {
    -- Backgrounds
    bg = Color3.fromRGB(20, 20, 30),
    bgLight = Color3.fromRGB(28, 28, 42),
    card = Color3.fromRGB(32, 32, 48),
    cardHover = Color3.fromRGB(40, 40, 58),
    cardActive = Color3.fromRGB(45, 42, 65),
    surface = Color3.fromRGB(36, 36, 52),
    surfaceLight = Color3.fromRGB(44, 44, 62),
    -- Accent (vibrant purple-blue)
    accent = Color3.fromRGB(140, 120, 255),
    accentHover = Color3.fromRGB(160, 142, 255),
    accentPress = Color3.fromRGB(120, 100, 230),
    accentGhost = Color3.fromRGB(50, 42, 85),
    accentSoft = Color3.fromRGB(65, 55, 110),
    -- Secondary accent (warm)
    warm = Color3.fromRGB(255, 160, 100),
    warmSoft = Color3.fromRGB(80, 50, 35),
    -- Status
    success = Color3.fromRGB(70, 220, 130),
    successBg = Color3.fromRGB(25, 60, 40),
    successSoft = Color3.fromRGB(40, 80, 55),
    error = Color3.fromRGB(255, 90, 90),
    errorBg = Color3.fromRGB(60, 25, 25),
    warning = Color3.fromRGB(255, 200, 60),
    -- Text (brighter, more readable)
    text = Color3.fromRGB(250, 250, 255),
    textBright = Color3.fromRGB(255, 255, 255),
    textSecondary = Color3.fromRGB(185, 185, 210),
    textMuted = Color3.fromRGB(120, 120, 150),
    textOnAccent = Color3.fromRGB(255, 255, 255),
    -- Borders
    border = Color3.fromRGB(55, 55, 78),
    borderLight = Color3.fromRGB(70, 70, 95),
    borderFocus = Color3.fromRGB(140, 120, 255),
    -- Input
    inputBg = Color3.fromRGB(24, 24, 38),
    inputBgFocus = Color3.fromRGB(30, 28, 48),
    -- Base
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0),
}

-- ═══ CLEANUP ═══
if CoreGui:FindFirstChild("SYZOLoader") then
    CoreGui:FindFirstChild("SYZOLoader"):Destroy()
end

-- ═══ INSTANCE FACTORY ═══
local function new(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function()
                inst[k] = v
            end)
        end
    end
    if props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function corner(parent, r)
    return new("UICorner", {
        CornerRadius = UDim.new(0, r or 8),
        Parent = parent,
    })
end

local function stroke(parent, color, thickness, trans)
    return new("UIStroke", {
        Color = color or C.border,
        Thickness = thickness or 1,
        Transparency = trans or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

-- ═══ TWEEN UTILITY ═══
local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then
        return
    end
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.3, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ═══ CREATE MAIN GUI ═══
local ScreenGui = new("ScreenGui", {
    Name = "SYZOLoader",
    Parent = CoreGui,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    ResetOnSpawn = false,
})

-- Background overlay
local Overlay = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.6,
    Parent = ScreenGui,
})

-- Main container
local Main = new("Frame", {
    Size = UDim2.new(0, 420, 0, 520),
    Position = UDim2.new(0.5, -210, 0.5, -260),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
})
corner(Main, 16)
stroke(Main, C.borderLight, 1, 0.5)

-- Glow effect
local Glow = new("Frame", {
    Size = UDim2.new(1, 20, 1, 20),
    Position = UDim2.new(0.5, -10, 0.5, -10),
    BackgroundColor3 = C.accent,
    BackgroundTransparency = 0.95,
    BorderSizePixel = 0,
    Parent = Main,
})
corner(Glow, 20)

-- ═══ KEY PAGE ═══
local KeyPage = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Parent = Main,
})

-- Header row
local HeaderRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Logo mark with gradient background
local LogoMark = new("Frame", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(LogoMark, 12)
stroke(LogoMark, C.accent, 1, 0.7)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "✦",
    TextColor3 = C.accent,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoMark,
})

-- Brand name
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 52, 0, 3),
    BackgroundTransparency = 1,
    Text = "SYZO Hub",
    TextColor3 = C.textBright,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

-- Subtitle
new("TextLabel", {
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 52, 0, 25),
    BackgroundTransparency = 1,
    Text = "ultimate auto-loader",
    TextColor3 = C.textSecondary,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = HeaderRow,
})

-- Version badge
local VBadge = new("Frame", {
    Size = UDim2.new(0, 40, 0, 20),
    Position = UDim2.new(0, 158, 0, 5),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = HeaderRow,
})
corner(VBadge, 6)
stroke(VBadge, C.accent, 1, 0.7)
new("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "v1.0",
    TextColor3 = C.accent,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = VBadge,
})

-- Divider
new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 54),
    BackgroundColor3 = C.border,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Greeting
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 18),
    Position = UDim2.new(0, 0, 0, 68),
    BackgroundTransparency = 1,
    Text = "Welcome, " .. LocalPlayer.Name .. " ",
    TextColor3 = C.text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Game detection info
local gameStatusText = currentGameScript and ("✓ " .. currentGameScript.Name) or "⚠ This game is not currently supported"
local gameStatusColor = currentGameScript and C.success or C.warning
local GameStatusLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 88),
    BackgroundTransparency = 1,
    Text = gameStatusText,
    TextColor3 = gameStatusColor,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Key input label
new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 120),
    BackgroundTransparency = 1,
    Text = "Enter License Key",
    TextColor3 = C.textSecondary,
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Key input field
local KeyInput = new("TextBox", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 140),
    BackgroundColor3 = C.inputBg,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamMedium,
    PlaceholderText = "Enter your key...",
    PlaceholderColor3 = C.textMuted,
    Text = "",
    TextColor3 = C.textBright,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})
corner(KeyInput, 10)
stroke(KeyInput, C.border, 1, 0)

-- Input focus effect
local InputFocus = new("Frame", {
    Size = UDim2.new(1, 0, 0, 2),
    Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = C.accent,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = KeyInput,
})

-- Key input events
KeyInput.Focused:Connect(function()
    tween(InputFocus, { BackgroundTransparency = 0 }, 0.2)
    tween(KeyInput, { BackgroundColor3 = C.inputBgFocus }, 0.2)
end)

KeyInput.FocusLost:Connect(function()
    tween(InputFocus, { BackgroundTransparency = 1 }, 0.2)
    tween(KeyInput, { BackgroundColor3 = C.inputBg }, 0.2)
end)

-- Status message
local StatusLabel = new("TextLabel", {
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 190),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = C.textSecondary,
    TextSize = 11,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage,
})

-- ═══ BUTTONS ═══
local ButtonRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 220),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Unlock button
local UnlockBtn = new("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "UNLOCK",
    TextColor3 = C.textOnAccent,
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = ButtonRow,
})
corner(UnlockBtn, 10)

-- Button hover/click effects
UnlockBtn.MouseEnter:Connect(function()
    tween(UnlockBtn, { BackgroundColor3 = C.accentHover }, 0.15)
end)
UnlockBtn.MouseLeave:Connect(function()
    tween(UnlockBtn, { BackgroundColor3 = C.accent }, 0.15)
end)
UnlockBtn.MouseButton1Down:Connect(function()
    tween(UnlockBtn, { BackgroundColor3 = C.accentPress }, 0.05)
end)
UnlockBtn.MouseButton1Up:Connect(function()
    tween(UnlockBtn, { BackgroundColor3 = C.accentHover }, 0.1)
end)

-- Unlock function
local function attemptUnlock()
    local key = KeyInput.Text
    if key == "" then
        StatusLabel.Text = "⚠ Please enter a key"
        StatusLabel.TextColor3 = C.warning
        return
    end

    if isKeyValid(key) then
        saveKey(key)
        StatusLabel.Text = "✅ Key accepted! Loading script..."
        StatusLabel.TextColor3 = C.success

        -- Destroy GUI after a moment
        task.wait(0.5)
        ScreenGui:Destroy()

        if currentGameScript then
            pcall(function()
                loadstring(game:HttpGet(currentGameScript.URL))()
            end)
        else
            -- No matching script — load universal fly script
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexFlyScript"))()
            end)
            -- Notification
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "SYZO Hub",
                    Text = "Game not supported. Loaded Universal Fly Script!",
                    Duration = 5,
                })
            end)
        end
    else
        StatusLabel.Text = "❌ Invalid key. Please try again."
        StatusLabel.TextColor3 = C.error
        -- Shake animation on input
        tween(KeyInput, { Position = UDim2.new(0, 5, 0, 140) }, 0.05, Enum.EasingStyle.Linear)
        task.wait(0.05)
        tween(KeyInput, { Position = UDim2.new(0, -5, 0, 140) }, 0.05, Enum.EasingStyle.Linear)
        task.wait(0.05)
        tween(KeyInput, { Position = UDim2.new(0, 0, 0, 140) }, 0.05, Enum.EasingStyle.Linear)
    end
end

UnlockBtn.MouseButton1Click:Connect(attemptUnlock)

-- Enter key support
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        attemptUnlock()
    end
end)

-- ═══ FOOTER WITH DISCORD LINK ═══
local Footer = new("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = KeyPage,
})

-- Left side: version info
new("TextLabel", {
    Size = UDim2.new(0, 150, 0, 14),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    Text = "SYZO Hub v1.0",
    TextColor3 = C.textMuted,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = Footer,
})

-- Right side: Discord button (clickable)
local DiscordBtn = new("TextButton", {
    Size = UDim2.new(0, 120, 0, 20),
    Position = UDim2.new(1, -130, 0, 5),
    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
    BorderSizePixel = 0,
    AutoButtonColor = false,
    Text = "💬 Join Discord",
    TextColor3 = C.textSecondary,
    TextSize = 10,
    Font = Enum.Font.GothamMedium,
    ZIndex = 6,
    Parent = Footer,
})
corner(DiscordBtn, 6)
stroke(DiscordBtn, C.borderLight, 1, 0.4)

-- Discord button hover effects
DiscordBtn.MouseEnter:Connect(function()
    tween(DiscordBtn, { BackgroundColor3 = Color3.fromRGB(50, 50, 70) }, 0.15)
    tween(DiscordBtn, { TextColor3 = C.textBright }, 0.15)
end)
DiscordBtn.MouseLeave:Connect(function()
    tween(DiscordBtn, { BackgroundColor3 = Color3.fromRGB(30, 30, 45) }, 0.15)
    tween(DiscordBtn, { TextColor3 = C.textSecondary }, 0.15)
end)

-- Open Discord link on click
DiscordBtn.MouseButton1Click:Connect(function()
    GuiService:OpenBrowserWindow(DISCORD_LINK)
end)

-- ═══ AUTO-FOCUS INPUT ═══
task.wait(0.1)
KeyInput:CaptureFocus()

-- ═══ CLOSE ON ESCAPE ═══
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.KeyCode == Enum.KeyCode.Escape then
        ScreenGui:Destroy()
    end
end)