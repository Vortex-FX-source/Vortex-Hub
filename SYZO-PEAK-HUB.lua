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
-- ★★★ YOUR LIST OF GAME SCRIPTS (keep as many as you need) ★★★
-- ============================================================
local SCRIPTS = {
-- [ 1. BLOX FRUITS (Sea 1, Sea 2, and Sea 3) ] --
if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 or PlaceId == 7447361652 then
    print("Vortex FX: Blox Fruits Detected! Loading Hub...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()

-- [ 2. ANIME CARD COLLECTION ] --
elseif PlaceId == 76285745979410 then
    print("Vortex FX: Anime Card Collection Detected! Loading Hub...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexAnimeCardsCollection"))()


-- [ 4. EVERY OTHER GAME (Universal Fly Script) ] --
else
    print("Vortex FX: Game not officially supported. Loading Universal Fly Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexFlyScript"))()
    
    -- Optional: A quick notification so the user knows what happened
    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Vortex FX",
            Text = "Game not supported. Loaded Universal Fly Script!",
            Duration = 5
        })
    end)
  end

-- ============================================================
-- ★★★ FALLBACK FLY SCRIPT (loads when no game matches) ★★★
-- ============================================================
local FLY_SCRIPT_URL = "https://your-fly-script-url-here.lua"  -- <-- Put your fly script URL

-- ============================================================

-- ═══ HELPERS ═══
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
        if writefile then writefile(KEY_FILE, key) end
    end)
end

local function loadKey()
    local ok, res = pcall(function()
        return (isfile and readfile and isfile(KEY_FILE)) and readfile(KEY_FILE) or nil
    end)
    return ok and res or nil
end

-- Get the script that matches the current game, or nil if none
local function getMatchingScript()
    for _, s in ipairs(SCRIPTS) do
        if s.GameId == game.PlaceId then
            return s
        end
    end
    return nil
end

-- Launch a script from its URL
local function launchScript(url)
    pcall(function()
        loadstring(game:HttpGet(url))()
    end)
end

-- ============================================================
-- ★★★ AUTO‑LAUNCH LOGIC (executed when key is saved) ★★★
-- ============================================================
local savedKey = loadKey()
if isKeyValid(savedKey) then
    -- Try to find a matching game script
    local matched = getMatchingScript()
    if matched then
        launchScript(matched.URL)
    else
        -- No match → load the fly script
        launchScript(FLY_SCRIPT_URL)
    end
    -- After launching, we can either stop here (if you don't want the UI)
    -- or let the UI still show. Remove the "return" if you want the UI to appear.
    return   -- <-- Remove this line if you want the GUI to show even after auto-launch
end

-- ============================================================
-- If we reach here, no valid key was saved → show the UI
-- ============================================================

-- ═══ COLORS (same as before) ═══
local C = { ... }  -- (keep all the color definitions as before)

-- ═══ UI FACTORY (keep exactly as before) ═══
-- ... (all UI construction functions: new, corner, stroke, tween, label, setupHover, makeBtn)

-- ═══ BUILD GUI (same as before) ═══
-- ... (all GUI building code up to the buttons)

-- BUTTON LOGIC – now modified to use the same fallback after verification
local verifying = false
local function doVerify()
    if verifying then return end
    verifying = true
    local key = KeyInput.Text
    StatusMsg.Text = "Checking..."
    StatusMsg.TextColor3 = C.textS
    task.wait(0.3)

    if isKeyValid(key) then
        saveKey(key)
        StatusMsg.Text = "✓ Key accepted!"
        StatusMsg.TextColor3 = C.success
        task.wait(0.3)

        -- Close the GUI and launch the appropriate script
        closeGUI()   -- (define closeGUI as before)

        -- Now decide which script to launch
        local matched = getMatchingScript()
        if matched then
            launchScript(matched.URL)
        else
            launchScript(FLY_SCRIPT_URL)   -- fallback fly script
        end
    else
        StatusMsg.Text = "✕ Invalid key! Check Discord."
        StatusMsg.TextColor3 = C.error
    end
    verifying = false
end

-- ... (rest of the UI: DiscordBtn, PasteBtn, VerifyBtn events, dragging, pulse, etc.)
