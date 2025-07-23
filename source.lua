--[[

    esp-lib.lua
    A library for creating esp visuals in roblox using drawing.
    Provides functions to add boxes, health bars, names and distances to instances.
    Written by tul (@.lutyeh).

]]

-- // table

local esplib = getgenv().esplib
if not esplib then
    esplib = {
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
    getgenv().esplib = esplib
end

local espfunctions = {}

-- // services
local run_service = game:GetService("RunService")

-- // functions
function espfunctions.add_box(instance)
    local outline = Drawing.new("Square")
    outline.Thickness = 3
    outline.Filled = false
    outline.Transparency = 1

    local fill = Drawing.new("Square")
    fill.Thickness = 1
    fill.Filled = false
    fill.Transparency = 1

    local conn
    conn = run_service.RenderStepped:Connect(function()
        if not instance or not instance.Parent then
            conn:Disconnect()
            outline:Remove()
            fill:Remove()
            return
        end

        local min, max = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
        local onscreen = false

        if instance:IsA("Model") then
            for _, p in ipairs(instance:GetChildren()) do
                if p:IsA("BasePart") then
                    local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(handle.Position)
                        if visible then
                            local v2 = Vector2.new(pos.X, pos.Y)
                            min = min:Min(v2)
                            max = max:Max(v2)
                            onscreen = true
                        end
                    end
                end
            end
        elseif instance:IsA("BasePart") then
            local size = instance.Size / 2
            local cf = instance.CFrame
            for _, offset in ipairs({
                Vector3.new( size.X,  size.Y,  size.Z),
                Vector3.new(-size.X,  size.Y,  size.Z),
                Vector3.new( size.X, -size.Y,  size.Z),
                Vector3.new(-size.X, -size.Y,  size.Z),
                Vector3.new( size.X,  size.Y, -size.Z),
                Vector3.new(-size.X,  size.Y, -size.Z),
                Vector3.new( size.X, -size.Y, -size.Z),
                Vector3.new(-size.X, -size.Y, -size.Z),
            }) do
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
                if visible then
                    local v2 = Vector2.new(pos.X, pos.Y)
                    min = min:Min(v2)
                    max = max:Max(v2)
                    onscreen = true
                end
            end
        end

        if esplib.box.enabled and onscreen then
            outline.Color = esplib.box.outline
            outline.Position = min
            outline.Size = max - min
            outline.Visible = true

            fill.Color = esplib.box.fill
            fill.Position = min
            fill.Size = max - min
            fill.Visible = true
        else
            outline.Visible = false
            fill.Visible = false
        end
    end)
end

function espfunctions.add_healthbar(instance)
    local outline = Drawing.new("Square")
    outline.Thickness = 1
    outline.Filled = true
    outline.Transparency = 1

    local fill = Drawing.new("Square")
    fill.Filled = true
    fill.Transparency = 1

    local padding = 1
    local conn
    conn = run_service.RenderStepped:Connect(function()
        if not instance or not instance.Parent then
            conn:Disconnect()
            outline:Remove()
            fill:Remove()
            return
        end

        local min, max = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
        local onscreen = false

        if instance:IsA("Model") then
            for _, p in ipairs(instance:GetChildren()) do
                if p:IsA("BasePart") then
                    local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(handle.Position)
                        if visible then
                            local v2 = Vector2.new(pos.X, pos.Y)
                            min = min:Min(v2)
                            max = max:Max(v2)
                            onscreen = true
                        end
                    end
                end
            end
        end

        if not esplib.healthbar.enabled or not onscreen then
            outline.Visible = false
            fill.Visible = false
            return
        end

        local humanoid = instance:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            outline.Visible = false
            fill.Visible = false
            return
        end

        local height = max.Y - min.Y
        local x = min.X - 3 - 1 - padding
        local y = min.Y - padding
        local health = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        local fillheight = height * health

        outline.Color = esplib.healthbar.outline
        outline.Position = Vector2.new(x, y)
        outline.Size = Vector2.new(1 + 2 * padding, height + 2 * padding)
        outline.Visible = true

        fill.Color = esplib.healthbar.fill
        fill.Position = Vector2.new(x + padding, y + (height + padding) - fillheight)
        fill.Size = Vector2.new(1, fillheight)
        fill.Visible = true
    end)
end

function espfunctions.add_name(instance)
    local text = Drawing.new("Text")
    text.Center = true
    text.Outline = true
    text.Font = 1
    text.Transparency = 1

    local conn
    conn = run_service.RenderStepped:Connect(function()
        if not instance or not instance.Parent then
            conn:Disconnect()
            text:Remove()
            return
        end

        local min, max = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
        local onscreen = false

        if instance:IsA("Model") then
            for _, p in ipairs(instance:GetChildren()) do
                if p:IsA("BasePart") then
                    local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(handle.Position)
                        if visible then
                            local v2 = Vector2.new(pos.X, pos.Y)
                            min = min:Min(v2)
                            max = max:Max(v2)
                            onscreen = true
                        end
                    end
                end
            end
        elseif instance:IsA("BasePart") then
            local size = instance.Size / 2
            local cf = instance.CFrame
            for _, offset in ipairs({
                Vector3.new( size.X,  size.Y,  size.Z),
                Vector3.new(-size.X,  size.Y,  size.Z),
                Vector3.new( size.X, -size.Y,  size.Z),
                Vector3.new(-size.X, -size.Y,  size.Z),
                Vector3.new( size.X,  size.Y, -size.Z),
                Vector3.new(-size.X,  size.Y, -size.Z),
                Vector3.new( size.X, -size.Y, -size.Z),
                Vector3.new(-size.X, -size.Y, -size.Z),
            }) do
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
                if visible then
                    local v2 = Vector2.new(pos.X, pos.Y)
                    min = min:Min(v2)
                    max = max:Max(v2)
                    onscreen = true
                end
            end
        end

        if esplib.name.enabled and onscreen then
            local centerX = (min.X + max.X) / 2
            local topY = min.Y
            text.Text = instance.Name
            text.Position = Vector2.new(centerX, topY - text.Size - 3)
            text.Color = esplib.name.fill
            text.Size = esplib.name.size
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

function espfunctions.add_distance(instance)
    local text = Drawing.new("Text")
    text.Center = true
    text.Outline = true
    text.Font = 1
    text.Transparency = 1

    local conn
    conn = run_service.RenderStepped:Connect(function()
        if not instance or not instance.Parent then
            conn:Disconnect()
            text:Remove()
            return
        end

        local min, max = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
        local onscreen = false

        if instance:IsA("Model") then
            for _, p in ipairs(instance:GetChildren()) do
                if p:IsA("BasePart") then
                    local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(handle.Position)
                        if visible then
                            local v2 = Vector2.new(pos.X, pos.Y)
                            min = min:Min(v2)
                            max = max:Max(v2)
                            onscreen = true
                        end
                    end
                end
            end
        elseif instance:IsA("BasePart") then
            local size = instance.Size / 2
            local cf = instance.CFrame
            for _, offset in ipairs({
                Vector3.new( size.X,  size.Y,  size.Z),
                Vector3.new(-size.X,  size.Y,  size.Z),
                Vector3.new( size.X, -size.Y,  size.Z),
                Vector3.new(-size.X, -size.Y,  size.Z),
                Vector3.new( size.X,  size.Y, -size.Z),
                Vector3.new(-size.X,  size.Y, -size.Z),
                Vector3.new( size.X, -size.Y, -size.Z),
                Vector3.new(-size.X, -size.Y, -size.Z),
            }) do
                local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
                if visible then
                    local v2 = Vector2.new(pos.X, pos.Y)
                    min = min:Min(v2)
                    max = max:Max(v2)
                    onscreen = true
                end
            end
        end

        if esplib.distance.enabled and onscreen then
            local centerX = (min.X + max.X) / 2
            local topY = max.Y
            text.Text = instance.Name
            text.Position = Vector2.new(centerX, topY - text.Size - 3)
            text.Color = esplib.distance.fill
            text.Size = esplib.distance.size
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

for k, v in pairs(espfunctions) do
    esplib[k] = v
end

return esplib
