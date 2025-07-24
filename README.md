# esp-lib.lua
A lightweight esp library for roblox using the drawing api.

Provides programmatic access to 2d visuals including bounding boxes, health bars, name tags, distances and tracers for in-game instances.

Authored by tul (@.lutyeh)

<img width="2559" height="817" alt="image" src="https://github.com/user-attachments/assets/5288be3f-8208-4815-8ecc-055ace7a5d5a" />
https://www.youtube.com/watch?v=onTUHYr7aA0

https://www.youtube.com/watch?v=rILDep7_05o

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

```lua
esplib.add_distance(instance: Instance)
```
Renders a distance label under the instance.

```lua
esplib.add_tracer(instance: Instance)
```
Creates a tracer to the instances main part.

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
    tracer = {
        enabled = true,
        fill = Color3.new(1,1,1),
        outline = Color3.new(0,0,0),
        from = "mouse", -- mouse, head, top, bottom, center
    }
}
```
(Optional) Allows you to customize the esp easily in real time. Add this on top of your code if wanted.

# ▶️ Examples
Find pre-made scripts in the examples folder.

# 📝 Notes
Fully made with drawing.

This project is fully open source, feel free to modify it and use it on your own project.
