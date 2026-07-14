local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local VALID_KEYS = {"syzo"}
local DISCORD_LINK = "https://discord.gg/sAUgSnu42T"
local KEY_FILE = "SYZOHub_SavedKey.txt"

-- ============================================================
-- ★★★ 20 SCRIPT SLOTS (fill in your own GameId & URL) ★★★
-- ============================================================
local SCRIPTS = {
    -- 1
    { Name = "Script 1", Icon = "", URL = "", GameId = "" },
    -- 2
    { Name = "Script 2", Icon = "", URL = "", GameId = "" },
    -- 3
    { Name = "Script 3", Icon = "", URL = "", GameId = "" },
    -- 4
    { Name = "Script 4", Icon = "", URL = "", GameId = "" },
    -- 5
    { Name = "Script 5", Icon = "", URL = "", GameId = "" },
    -- 6
    { Name = "Script 6", Icon = "", URL = "", GameId = "" },
    -- 7
    { Name = "Script 7", Icon = "", URL = "", GameId = "" },
    -- 8
    { Name = "Script 8", Icon = "", URL = "", GameId = "" },
    -- 9
    { Name = "Script 9", Icon = "", URL = "", GameId = "" },
    -- 10
    { Name = "Script 10", Icon = "", URL = "", GameId = "" },
    -- 11
    { Name = "Script 11", Icon = "", URL = "", GameId = "" },
    -- 12
    { Name = "Script 12", Icon = "", URL = "", GameId = "" },
    -- 13
    { Name = "Script 13", Icon = "", URL = "", GameId = "" },
    -- 14
    { Name = "Script 14", Icon = "", URL = "", GameId = "" },
    -- 15
    { Name = "Script 15", Icon = "", URL = "", GameId = "" },
    -- 16
    { Name = "Script 16", Icon = "", URL = "", GameId = "" },
    -- 17
    { Name = "Script 17", Icon = "", URL = "", GameId = "" },
    -- 18
    { Name = "Script 18", Icon = "", URL = "", GameId = "" },
    -- 19
    { Name = "Script 19", Icon = "", URL = "", GameId = "" },
    -- 20
    { Name = "Script 20", Icon = "", URL = "", GameId = "" },
}

-- Fallback Fly Script URL (optional – keep or change)
local FLY_SCRIPT_URL = "https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexFlyScript"

-- ============================================================
-- ═══ HELPERS ═══
-- ============================================================
local function trim(s)
    return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function isKeyValid(key)
    if not key or key == "" then return false end
    key = trim(key)
    for _, k in ipairs(VALID_KEYS) do
        if key == k then return true end
    end
    return false
end

local function saveKey(key)
    pcall(function()
        if writefile then
            writefile(KEY_FILE, key)
        end
    end)
end

local function loadKey()
    local ok, res = pcall(function()
        return (isfile and readfile and isfile(KEY_FILE)) and readfile(KEY_FILE) or nil
    end)
    return ok and res or nil
end

local function getGameScript()
    for _, s in ipairs(SCRIPTS) do
        if s.GameId == game.PlaceId then
            return s
        end
    end
    return nil
end

local function launchScript(url)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
end

-- ============================================================
-- ★★★ AUTO-LAUNCH IF KEY SAVED ★★★
-- ============================================================
local savedKey = loadKey()
local gameScript = getGameScript()

if isKeyValid(savedKey) then
    if gameScript then
        launchScript(gameScript.URL)
    else
        launchScript(FLY_SCRIPT_URL)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "SYZO PEAK HUB",
                Text = "Game not supported. Loaded Universal Fly Script!",
                Duration = 5
            })
        end)
    end
    return
end

-- ============================================================
-- ═══ COLORS ═══ (same as before, no changes)
-- ============================================================
local C = {
    bg = Color3.fromRGB(20, 20, 30),
    card = Color3.fromRGB(32, 32, 48),
    surface = Color3.fromRGB(36, 36, 52),
    surfaceL = Color3.fromRGB(44, 44, 62),
    accent = Color3.fromRGB(140, 120, 255),
    accentH = Color3.fromRGB(160, 142, 255),
    accentP = Color3.fromRGB(120, 100, 230),
    accentGhost = Color3.fromRGB(50, 42, 85),
    accentSoft = Color3.fromRGB(65, 55, 110),
    discord = Color3.fromRGB(88, 101, 242),
    discordH = Color3.fromRGB(110, 122, 255),
    discordP = Color3.fromRGB(72, 84, 220),
    success = Color3.fromRGB(70, 220, 130),
    error = Color3.fromRGB(255, 90, 90),
    errorBg = Color3.fromRGB(60, 25, 25),
    warning = Color3.fromRGB(255, 200, 60),
    text = Color3.fromRGB(250, 250, 255),
    textB = Color3.fromRGB(255, 255, 255),
    textS = Color3.fromRGB(185, 185, 210),
    textM = Color3.fromRGB(120, 120, 150),
    border = Color3.fromRGB(55, 55, 78),
    borderF = Color3.fromRGB(140, 120, 255),
    inputBg = Color3.fromRGB(24, 24, 38),
    inputBgF = Color3.fromRGB(30, 28, 48),
    black = Color3.fromRGB(0, 0, 0),
    white = Color3.fromRGB(255, 255, 255),
}

-- ============================================================
-- ═══ UI FACTORY ═══ (unchanged)
-- ============================================================
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

local function corner(p, r)
    return new("UICorner", {
        CornerRadius = UDim.new(0, r or 8),
        Parent = p
    })
end

local function stroke(p, col, thick)
    return new("UIStroke", {
        Color = col or C.border,
        Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = p
    })
end

local function tween(obj, props, dur, style, dir)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props):Play()
end

local function label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.GothamMedium
    return new("TextLabel", props)
end

local function setupHover(btn, n, h, p)
    btn.MouseEnter:Connect(function()
        tween(btn, { BackgroundColor3 = h }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, { BackgroundColor3 = n }, 0.2)
    end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, { BackgroundColor3 = p or h }, 0.05)
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, { BackgroundColor3 = h }, 0.1)
    end)
end

local function makeBtn(props, parent)
    local btn = new("TextButton", {
        Size = props.size,
        Position = props.pos,
        BackgroundColor3 = props.col,
        Text = "",
        AutoButtonColor = false,
        ZIndex = props.z or 7,
        ClipsDescendants = true,
        Parent = parent,
    })
    corner(btn, 10)
    label({
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = props.text,
        TextColor3 = C.textB,
        TextSize = props.ts or 12,
        Font = Enum.Font.GothamBold,
        ZIndex = (props.z or 7) + 1,
        Parent = btn
    })
    setupHover(btn, props.col, props.hov, props.press)
    return btn
end

-- ============================================================
-- ═══ BUILD GUI ═══ (unchanged)
-- ============================================================
if CoreGui:FindFirstChild("SYZOLoader") then
    CoreGui.SYZOLoader:Destroy()
end

local Gui = new("ScreenGui", {
    Name = "SYZOLoader",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui
})

local Backdrop = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.black,
    BackgroundTransparency = 1,
    ZIndex = 1,
    Parent = Gui
})

local CW, CH = 520, 330

local Card = new("Frame", {
    Name = "Card",
    Size = UDim2.new(0, CW, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 2,
    Parent = Gui,
})
corner(Card, 16)

local cardStroke = stroke(Card, C.border, 1)
cardStroke.Transparency = 1

-- Accent bar
local AccentBar = new("Frame", {
    Size = UDim2.new(1, 0, 0, 3),
    BackgroundColor3 = C.accent,
    BorderSizePixel = 0,
    ZIndex = 15,
    Parent = Card
})

local accentGrad = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 120, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255))
    }),
    Parent = AccentBar,
})

task.spawn(function()
    local t = 0
    while AccentBar and AccentBar.Parent do
        t += 0.02
        accentGrad.Offset = Vector2.new(math.sin(t) * 0.4, 0)
        accentGrad.Rotation = math.sin(t * 0.5) * 25
        RunService.RenderStepped:Wait()
    end
end)

-- Intro animation
task.wait(0.15)
tween(Backdrop, { BackgroundTransparency = 0.5 }, 0.5)
task.wait(0.05)
tween(Card, { Size = UDim2.new(0, CW, 0, CH), BackgroundTransparency = 0 }, 0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(cardStroke, { Transparency = 0 }, 0.4)
task.wait(0.55)

-- Close button
local CloseBtn = new("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundColor3 = C.surface,
    BackgroundTransparency = 0.4,
    Text = "✕",
    TextColor3 = C.textM,
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false,
    ZIndex = 20,
    Parent = Card
})
corner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0, BackgroundColor3 = C.errorBg, TextColor3 = C.error }, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, { BackgroundTransparency = 0.4, BackgroundColor3 = C.surface, TextColor3 = C.textM }, 0.2)
end)

local function closeGUI()
    tween(Card, { Size = UDim2.new(0, CW, 0, 0), BackgroundTransparency = 1 }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.35)
    task.wait(0.4)
    Gui:Destroy()
end

CloseBtn.MouseButton1Click:Connect(closeGUI)

-- Content area
local Content = new("Frame", {
    Size = UDim2.new(1, -68, 1, -56),
    Position = UDim2.new(0, 34, 0, 28),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    ZIndex = 4,
    Parent = Card
})

local function closeThenLaunch(url)
    tween(Card, { Size = UDim2.new(0, CW, 0, 0), BackgroundTransparency = 1 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    tween(Backdrop, { BackgroundTransparency = 1 }, 0.4)
    task.wait(0.5)
    Gui:Destroy()
    launchScript(url)
end

-- ============================================================
-- KEY PAGE (unchanged)
-- ============================================================
local KeyPage = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = not isKeyValid(savedKey),
    ZIndex = 5,
    Parent = Content
})

-- Header
local LogoMark = new("Frame", {
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 0, 0, 2),
    BackgroundColor3 = C.accentGhost,
    ZIndex = 6,
    Parent = KeyPage
})
corner(LogoMark, 12)
stroke(LogoMark, C.accent, 1)

label({
    Size = UDim2.new(1, 0, 1, 0),
    Text = "✦",
    TextColor3 = C.accent,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    ZIndex = 7,
    Parent = LogoMark
})

label({
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 52, 0, 3),
    Text = "SYZO PEAK HUB",
    TextColor3 = C.textB,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = KeyPage
})

label({
    Size = UDim2.new(0, 200, 0, 14),
    Position = UDim2.new(0, 52, 0, 25),
    Text = "script loader v3.0",
    TextColor3 = C.textS,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    Parent = KeyPage
})

new("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 54),
    BackgroundColor3 = C.border,
    BorderSizePixel = 0,
    ZIndex = 5,
    Parent = KeyPage
})

label({
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 68),
    Text = "Welcome, " .. LocalPlayer.Name .. " ",
    TextColor3 = C.text,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage
})

local gameScriptCheck = getGameScript()
label({
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 87),
    Text = gameScriptCheck and ("✓ " .. gameScriptCheck.Name) or "⚠ This game is not supported",
    TextColor3 = gameScriptCheck and C.success or C.warning,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage
})

-- Input
label({
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 0, 114),
    Text = "ENTER KEY",
    TextColor3 = C.textM,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage
})

local InputWrap = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 0, 132),
    BackgroundColor3 = C.inputBg,
    ZIndex = 6,
    Parent = KeyPage
})
corner(InputWrap, 10)

local inputStroke = stroke(InputWrap, C.border, 1.5)

label({
    Size = UDim2.new(0, 34, 1, 0),
    Position = UDim2.new(0, 4, 0, 0),
    Text = "",
    TextSize = 14,
    ZIndex = 7,
    Parent = InputWrap
})

local KeyInput = new("TextBox", {
    Size = UDim2.new(1, -48, 1, 0),
    Position = UDim2.new(0, 38, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "enter your key here...",
    PlaceholderColor3 = C.textM,
    TextColor3 = C.textB,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 7,
    Parent = InputWrap
})

KeyInput.Focused:Connect(function()
    tween(inputStroke, { Color = C.borderF }, 0.2)
    tween(InputWrap, { BackgroundColor3 = C.inputBgF }, 0.2)
end)

KeyInput.FocusLost:Connect(function()
    tween(inputStroke, { Color = C.border }, 0.25)
    tween(InputWrap, { BackgroundColor3 = C.inputBg }, 0.25)
end)

local StatusMsg = label({
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 184),
    Text = "",
    TextColor3 = C.error,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = KeyPage
})

label({
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 204),
    Text = "free permanent key in our discord — saves automatically ♡",
    TextColor3 = C.textM,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 5,
    Parent = KeyPage
})

-- Buttons
local BtnRow = new("Frame", {
    Size = UDim2.new(1, 0, 0, 44),
    Position = UDim2.new(0, 0, 1, -44),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = KeyPage
})

local DiscordBtn = makeBtn({
    size = UDim2.new(0, 108, 1, 0),
    pos = UDim2.new(0, 0, 0, 0),
    col = C.discord,
    hov = C.discordH,
    press = C.discordP,
    text = " Get Key",
    ts = 12
}, BtnRow)

local PasteBtn = makeBtn({
    size = UDim2.new(0, 76, 1, 0),
    pos = UDim2.new(0, 116, 0, 0),
    col = C.surface,
    hov = C.surfaceL,
    text = " Paste",
    ts = 11
}, BtnRow)

local VerifyBtn = makeBtn({
    size = UDim2.new(1, -200, 1, 0),
    pos = UDim2.new(0, 200, 0, 0),
    col = C.accent,
    hov = C.accentH,
    press = C.accentP,
    text = "Verify & Launch →",
    ts = 13
}, BtnRow)
local VerifyLabel = VerifyBtn:FindFirstChildWhichIsA("TextLabel")

-- ============================================================
-- UNSUPPORTED PAGE (unchanged)
-- ============================================================
local UnsupportedPage = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 5,
    Parent = Content
})

label({
    Size = UDim2.new(1, 0, 0, 50),
    Position = UDim2.new(0, 0, 0, 20),
    Text = "",
    TextSize = 42,
    ZIndex = 6,
    Parent = UnsupportedPage
})

label({
    Size = UDim2.new(1, 0, 0, 24),
    Position = UDim2.new(0, 0, 0, 78),
    Text = "Game Not Supported",
    TextColor3 = C.text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = UnsupportedPage
})

label({
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 108),
    Text = "SYZO PEAK HUB doesn't support this game yet. Join our Discord to request it!",
    TextColor3 = C.textS,
    TextSize = 11,
    ZIndex = 6,
    Parent = UnsupportedPage
})

local UnsupDiscord = makeBtn({
    size = UDim2.new(0, 180, 0, 42),
    pos = UDim2.new(0.5, -90, 1, -50),
    col = C.discord,
    hov = C.discordH,
    press = C.discordP,
    text = " Join Discord",
    ts = 13,
    z = 7
}, UnsupportedPage)

UnsupDiscord.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_LINK) end
    end)
end)

-- ============================================================
-- LAUNCH PAGE (unchanged)
-- ============================================================
local LaunchPage = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 5,
    Parent = Content
})

-- Spinner dots
local spinnerDots = {}
local SpinnerWrap = new("Frame", {
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.5, -25, 0, 40),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = LaunchPage
})

for i = 1, 3 do
    local dot = new("Frame", {
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, (i - 1) * 18 + 2, 0.5, -5),
        BackgroundColor3 = ({ Color3.fromRGB(140, 120, 255), Color3.fromRGB(180, 140, 255), Color3.fromRGB(100, 180, 255) })[i],
        ZIndex = 7,
        Parent = SpinnerWrap
    })
    corner(dot, 5)
    spinnerDots[i] = dot
end

task.spawn(function()
    while SpinnerWrap and SpinnerWrap.Parent do
        for i, dot in ipairs(spinnerDots) do
            task.delay((i - 1) * 0.15, function()
                if dot and dot.Parent then
                    tween(dot, { Position = dot.Position - UDim2.new(0, 0, 0, 12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    task.wait(0.2)
                    if dot and dot.Parent then
                        tween(dot, { Position = dot.Position + UDim2.new(0, 0, 0, 12) }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    end
                end
            end)
        end
        task.wait(0.9)
    end
end)

local LaunchTitle = label({
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 105),
    Text = "Launching Script...",
    TextColor3 = C.text,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    ZIndex = 6,
    Parent = LaunchPage
})

local LaunchSub = label({
    Size = UDim2.new(1, 0, 0, 16),
    Position = UDim2.new(0, 0, 0, 132),
    Text = "",
    TextColor3 = C.textS,
    TextSize = 12,
    ZIndex = 6,
    Parent = LaunchPage
})

label({
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -30),
    Text = "key saved — you won't need to enter it again ✓",
    TextColor3 = C.success,
    TextSize = 10,
    ZIndex = 6,
    Parent = LaunchPage
})

-- Show correct page if key already valid
if isKeyValid(savedKey) then
    KeyPage.Visible = false
    UnsupportedPage.Visible = true
end

-- ============================================================
-- BUTTON LOGIC (unchanged)
-- ============================================================
DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(DISCORD_LINK) end
    end)
    StatusMsg.Text = " Discord invite copied!"
    StatusMsg.TextColor3 = C.discord
    task.delay(3, function()
        if StatusMsg and StatusMsg.Parent then
            tween(StatusMsg, { TextTransparency = 1 }, 0.3)
            task.wait(0.35)
            if StatusMsg and StatusMsg.Parent then
                StatusMsg.Text = ""
                StatusMsg.TextTransparency = 0
            end
        end
    end)
end)

PasteBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if getclipboard then
            KeyInput.Text = getclipboard()
        end
    end)
end)

local function shakeInput()
    local orig = InputWrap.Position
    for _ = 1, 4 do
        tween(InputWrap, { Position = orig + UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
        tween(InputWrap, { Position = orig - UDim2.new(0, 6, 0, 0) }, 0.035, Enum.EasingStyle.Linear)
        task.wait(0.04)
    end
    tween(InputWrap, { Position = orig }, 0.06)
end

local function showStatus(msg, col)
    StatusMsg.Text = msg
    StatusMsg.TextColor3 = col
    StatusMsg.TextTransparency = 0
end

local function transitionTo(fromPage, toPage)
    tween(fromPage, { Position = UDim2.new(-1.2, 0, 0, 0) }, 0.4)
    task.wait(0.1)
    toPage.Visible = true
    toPage.Position = UDim2.new(1.2, 0, 0, 0)
    tween(toPage, { Position = UDim2.new(0, 0, 0, 0) }, 0.4)
end

local verifying = false

local function doVerify()
    if verifying then return end
    local key = trim(KeyInput.Text)
    if key == "" then
        showStatus("⚠ please enter a key", C.warning)
        shakeInput()
        return
    end
    verifying = true
    VerifyLabel.Text = "Verifying..."
    tween(VerifyBtn, { BackgroundColor3 = C.accentSoft }, 0.15)
    task.wait(0.6)

    if isKeyValid(key) then
        saveKey(key)
        showStatus("✓ Key verified!", C.success)
        tween(VerifyBtn, { BackgroundColor3 = C.success }, 0.2)
        tween(inputStroke, { Color = C.success }, 0.2)
        VerifyLabel.Text = "✓ Verified!"
        task.wait(0.7)

        if gameScriptCheck then
            LaunchSub.Text = gameScriptCheck.Icon .. " " .. gameScriptCheck.Name
            transitionTo(KeyPage, LaunchPage)
            task.wait(1.5)
            closeThenLaunch(gameScriptCheck.URL)
        else
            -- Fallback: load fly script
            LaunchSub.Text = "🪁 Universal Fly Script"
            transitionTo(KeyPage, LaunchPage)
            task.wait(1.5)
            closeThenLaunch(FLY_SCRIPT_URL)
        end
    else
        showStatus("✗ Invalid key — join Discord for a free key", C.error)
        tween(inputStroke, { Color = C.error }, 0.15)
        shakeInput()
        task.delay(3.5, function()
            tween(inputStroke, { Color = C.border }, 0.3)
            if StatusMsg and StatusMsg.Parent then
                tween(StatusMsg, { TextTransparency = 1 }, 0.4)
                task.wait(0.4)
                if StatusMsg and StatusMsg.Parent then
                    StatusMsg.Text = ""
                    StatusMsg.TextTransparency = 0
                end
            end
        end)
        VerifyLabel.Text = "Verify & Launch →"
        tween(VerifyBtn, { BackgroundColor3 = C.accent }, 0.2)
        verifying = false
    end
end

VerifyBtn.MouseButton1Click:Connect(doVerify)
KeyInput.FocusLost:Connect(function(enter)
    if enter then doVerify() end
end)

-- ============================================================
-- DRAGGING
-- ============================================================
local dragging, dragInput, dragStart, startPos

Card.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and (input.Position.Y - Card.AbsolutePosition.Y) <= 55 then
        dragging = true
        dragStart = input.Position
        startPos = Card.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Card.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

-- ============================================================
-- LOGO PULSE
-- ============================================================
task.spawn(function()
    while LogoMark and LogoMark.Parent do
        tween(LogoMark, { BackgroundColor3 = C.accentSoft }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
        tween(LogoMark, { BackgroundColor3 = C.accentGhost }, 1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        task.wait(1.8)
    end
end)