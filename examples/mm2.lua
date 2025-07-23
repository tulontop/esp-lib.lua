-- // esp-lib.lua
local esplib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua"))()

-- // mm2 coin esp
game.Workspace.DescendantAdded:Connect(function(coin)
    if coin.Name == "Coin_Server" then
        esplib.add_box(coin)
        esplib.add_name(coin)
        esplib.add_distance(coin)
        esplib.add_tracer(coin)
    end
end)
