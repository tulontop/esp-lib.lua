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
        tracer = {
            enabled = true,
            fill = Color3.new(1,1,1),
            outline = Color3.new(0,0,0),
            from = "mouse", -- mouse, head, top, bottom, center
        }
    }
    getgenv().esplib = esplib
end

local espfunctions = {}

-- // services
local run_service = game:GetService("RunService")
local players = game:GetService("Players")
local user_input_service = game:GetService("UserInputService")
local camera = workspace.CurrentCamera

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
                    local pos, visible = camera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = camera:WorldToViewportPoint(handle.Position)
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
                local pos, visible = camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
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
                    local pos, visible = camera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = camera:WorldToViewportPoint(handle.Position)
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
                    local pos, visible = camera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = camera:WorldToViewportPoint(handle.Position)
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
                local pos, visible = camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
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
                    local pos, visible = camera:WorldToViewportPoint(p.Position)
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                elseif p:IsA("Accessory") then
                    local handle = p:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local pos, visible = camera:WorldToViewportPoint(handle.Position)
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
                local pos, visible = camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
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
            local bottomY = max.Y
            local distance = (instance:GetPivot().Position - camera.CFrame.Position).Magnitude
            text.Text = tostring(math.floor(distance)) .. "m"
            text.Position = Vector2.new(centerX, bottomY + 3)
            text.Color = esplib.distance.fill
            text.Size = esplib.distance.size
            text.Visible = true
        else
            text.Visible = false
        end
    end)
end

function espfunctions.add_tracer(instance)
    local outline = Drawing.new("Line")
    outline.Thickness = 3
    outline.Transparency = 1

    local fill = Drawing.new("Line")
    fill.Thickness = 1
    fill.Transparency = 1

    local conn
    conn = run_service.RenderStepped:Connect(function()
        if not instance or not instance.Parent then
            conn:Disconnect()
            outline:Remove()
            fill:Remove()
            return
        end

        local onscreen = false

        if instance:IsA("Model") then
            if instance.PrimaryPart then
                local pos, visible = camera:WorldToViewportPoint(instance.PrimaryPart.Position)
                if visible then
                    local v2 = Vector2.new(pos.X, pos.Y)
                    outline.To = v2
                    fill.To = v2
                    onscreen = true
                end
            end
        elseif instance:IsA("BasePart") then
            local pos, visible = camera:WorldToViewportPoint(instance.Position)
            if visible then
                local v2 = Vector2.new(pos.X, pos.Y)
                outline.To = v2
                fill.To = v2
                onscreen = true
            end
        end

        if esplib.tracer.enabled and onscreen then
            if esplib.tracer.from == "mouse" then
                outline.From = Vector2.new(user_input_service:GetMouseLocation().X, user_input_service:GetMouseLocation().Y)
                fill.From = Vector2.new(user_input_service:GetMouseLocation().X, user_input_service:GetMouseLocation().Y)
            elseif esplib.tracer.from == "head" then
                if players.LocalPlayer.Character and players.LocalPlayer.Character:FindFirstChild("Head") then
                    local pos, visible = camera:WorldToViewportPoint(players.LocalPlayer.Character.Head.Position)
                    outline.From = Vector2.new(pos.X, pos.Y)
                    fill.From = Vector2.new(pos.X, pos.Y)
                end
            elseif esplib.tracer.from == "top" then
                outline.From = Vector2.new(camera.ViewportSize.X / 2, 0)
                fill.From = Vector2.new(camera.ViewportSize.X / 2, 0)
            elseif esplib.tracer.from == "bottom" then
                outline.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                fill.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
            elseif esplib.tracer.from == "center" then
                outline.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                fill.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
            end

            outline.Color = esplib.tracer.outline
            fill.Color = esplib.tracer.fill
            outline.Visible = true
            fill.Visible = true
        else
            outline.Visible = false
            fill.Visible = false
        end

    end)
end

for k, v in pairs(espfunctions) do
    esplib[k] = v
end

return esplib
