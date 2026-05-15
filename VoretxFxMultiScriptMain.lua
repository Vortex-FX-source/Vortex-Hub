-- [[ 
-- Vortex FX - Ultimate Universal Auto-Loader
-- Developer: Syzo Gamer
-- ]]

local PlaceId = game.PlaceId

print("🌪️ Vortex FX: Scanning game...")

-- [ 1. BLOX FRUITS (Sea 1, Sea 2, and Sea 3) ] --
if PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 or PlaceId == 7447361652 then
    print("Vortex FX: Blox Fruits Detected! Loading Hub...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/Vortex-FX"))()

-- [ 2. ANIME CARD COLLECTION ] --
elseif PlaceId == 76285745979410 then
    print("Vortex FX: Anime Card Collection Detected! Loading Hub...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/VortexAnimeCardsCollection"))()

-- [ 3. WAIFU CARDS COLLECTION ] --
elseif PlaceId == 9952351777 then
    print("Vortex FX: Waifu Cards Detected! Loading Hub...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vortex-FX-source/Vortex-Hub/refs/heads/main/AnimeWifuCardCollection"))()

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
