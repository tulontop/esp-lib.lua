-- // simple player esp
getgenv().esplib = {
    box = {
        enabled = true,
        fill = Color3.new(1,1,1),
        outline = Color3.new(0,0,0),
    },
    healthbar = {
        enabled = true,
        fill = Color3.new(0,1,0),
        outline = Color3.new(0,0,0),
    },
    name = {
        enabled = true,
        fill = Color3.new(1,1,1),
        size = 13,
    },
    distance = {
        enabled = true,
        fill = Color3.new(1,1,1),
        size = 13,
    },
    tracer = {
        enabled = true,
        fill = Color3.new(1,1,1),
        outline = Color3.new(0,0,0),
        from = "mouse", -- mouse, head, top, bottom, center
    },
}

local esplib = loadstring(game:HttpGet('https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua'))()

for _, plr in ipairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        if plr.Character then
            esplib.add_box(plr.Character)
            esplib.add_healthbar(plr.Character)
            esplib.add_name(plr.Character)
            esplib.add_distance(plr.Character)
            esplib.add_tracer(plr.Character)
        end

        plr.CharacterAdded:Connect(function(character)
            esplib.add_box(character)
            esplib.add_healthbar(character)
            esplib.add_name(character)
            esplib.add_distance(character)
            esplib.add_tracer(character)
        end)
    end
end

game.Players.PlayerAdded:Connect(function(plr)
    if plr ~= game.Players.LocalPlayer then
        plr.CharacterAdded:Connect(function(character)
            esplib.add_box(character)
            esplib.add_healthbar(character)
            esplib.add_name(character)
            esplib.add_distance(character)
            esplib.add_tracer(character)
        end)
    end
end)
