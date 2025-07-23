# esp-lib.lua
A lightweight esp library for roblox using the drawing api.

Provides programmatic access to 2d visuals including bounding boxes, health bars, name tags and distances for in-game instances.

Authored by tul (@.lutyeh)

<img width="2559" height="817" alt="image" src="https://github.com/user-attachments/assets/5288be3f-8208-4815-8ecc-055ace7a5d5a" />

# 📦 Installation
To load the library into your script:
```lua
local esplib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua"))()
```

# 🧩 API Reference
```lua
esplib.add_box(instance: Instance)
```
Renders a 2d bounding box around the given instance.
Ideal for characters or other visible objects in the 3d world.

```lua
esplib.add_healthbar(instance: Instance)
```
Displays a dynamic health bar adjacent to the instance.
Works with objects containing a humanoid.

```lua
esplib.add_name(instance: Instance)
```
Renders a name label above the instance’s head.
Defaults to instance.Name.

# ⚙️ Settings Table

```lua
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
}
```
(Optional) Allows you to customize the esp easily in real time. Add this ontop of your code if wanted.

# ▶️ Examples

```lua
-- // self esp
local esplib = loadstring(game:HttpGet('https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua'))()

esplib.add_box(game.Players.LocalPlayer.Character)
esplib.add_healthbar(game.Players.LocalPlayer.Character)
esplib.add_name(game.Players.LocalPlayer.Character)
esplib.add_distance(game.Players.LocalPlayer.Character)
```

```lua
-- // simple player esp
getgenv().esplib = {
    box = {
        enabled = true,
        fill = Color3.new(1,0,0),
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
}

local esplib = loadstring(game:HttpGet('https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua'))()

for _, plr in ipairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        if plr.Character then
            esplib.add_box(plr.Character)
            esplib.add_healthbar(plr.Character)
            esplib.add_name(plr.Character)
            esplib.add_distance(plr.Character)
        end

        plr.CharacterAdded:Connect(function(character)
            esplib.add_box(character)
            esplib.add_healthbar(character)
            esplib.add_name(character)
            esplib.add_distance(character)
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
        end)
    end
end)
```


```lua
-- // mm2 coin esp
local esplib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tulontop/esp-lib.lua/refs/heads/main/source.lua"))()

game.Workspace.DescendantAdded:Connect(function(coin)
    if coin.Name == "Coin_Server" then
        esplib.add_box(coin)
        esplib.add_name(coin)
        esplib.add_distance(coin)
    end
end)
```

# 📝 Notes
Fully made with drawing.

All functions take these classes: Model / Part / BasePart.

This project is fully open source, feel free to modify it and use it on your own project.
