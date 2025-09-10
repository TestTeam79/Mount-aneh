-- Mount aneh

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Buat Window
local Window = Rayfield:CreateWindow({
    Name = "Mount aneh (Final Safe)  ||  By TestTeam",
    LoadingTitle = "Sabar...",
    LoadingSubtitle = "by TestTeam",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "TeleportCPReset"
    }
})

-- Tab Teleport & Loop
local TeleportTab = Window:CreateTab("Teleport", 4483362458)
local LoopTab = Window:CreateTab("Loop", 4483362458)

-- Services
local TweenService = game:GetService("TweenService")

-- Variabel Looping
local loopDirectSummit = false
local loopThroughCPs = false

-- Delay default (detik)
local teleportDelay = 2
local resetDelay = 5
local tweenTime = 2 -- durasi tween per teleport

-- Koordinat CP & Summit
local checkpoints = {
    Basecamp = Vector3.new(570, 373, 145),
    CP1 = Vector3.new(725, 45, 681),
    CP2 = Vector3.new(825, 51, 498),
    CP3 = Vector3.new(801, 58, -132),
    CP4 = Vector3.new(417, 210, -375),
    CP5 = Vector3.new(434, 226, -239),
    CP6 = Vector3.new(262, 458, 60),
    CP7 = Vector3.new(195, 218, -366), -- langsung teleport
    CP8 = Vector3.new(-82, 330, -405),
    CP9 = Vector3.new(-445, 170, -515), -- langsung teleport
    CP10 = Vector3.new(-557, 418, -458),
    CP11 = Vector3.new(-1139, 938, 279),
    Summit = Vector3.new(-1085, 1346, 636)
}

-- Urutan CP untuk loop berurutan
local cpOrder = {"CP1","CP2","CP3","CP4","CP5","CP6","CP7","CP8","CP9","CP10","CP11","Summit"}

-- Fungsi teleport aman dengan Tween
local function safeTeleport(targetPos, direct)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        if direct then
            hrp.CFrame = CFrame.new(targetPos) -- teleport langsung
        else
            local info = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
            local goal = {CFrame = CFrame.new(targetPos)}
            local tween = TweenService:Create(hrp, info, goal)
            tween:Play()
            tween.Completed:Wait()
        end
    end
end

-- Tombol Teleport manual
local order = {"Basecamp","CP1","CP2","CP3","CP4","CP5","CP6","CP7","CP8","CP9","CP10","CP11","Summit"}
for _, name in ipairs(order) do
    TeleportTab:CreateButton({
        Name = "Teleport ke " .. name,
        Callback = function()
            local direct = (name == "CP7" or name == "CP9")
            safeTeleport(checkpoints[name], direct)
        end,
    })
end

-- Slider delay teleport
LoopTab:CreateSlider({
    Name = "Delay Teleport / Tween (detik)",
    Range = {0.1,10},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = teleportDelay,
    Callback = function(Value)
        teleportDelay = Value
        tweenTime = Value -- sesuaikan durasi tween
    end
})

-- Slider delay reset
LoopTab:CreateSlider({
    Name = "Delay Reset (detik)",
    Range = {1,20},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = resetDelay,
    Callback = function(Value)
        resetDelay = Value
    end
})

-- Loop 1: Langsung Summit + Reset
LoopTab:CreateToggle({
    Name = "Loop Langsung Summit + Reset",
    CurrentValue = false,
    Callback = function(Value)
        loopDirectSummit = Value
        if loopDirectSummit then
            task.spawn(function()
                while loopDirectSummit do
                    safeTeleport(checkpoints["Summit"], false)
                    task.wait(teleportDelay)
                    game.Players.LocalPlayer.Character:BreakJoints()
                    task.wait(resetDelay)
                end
            end)
        end
    end
})

-- Loop 2: CP1 → … → Summit + Reset
LoopTab:CreateToggle({
    Name = "Loop CP1 → … → Summit + Reset",
    CurrentValue = false,
    Callback = function(Value)
        loopThroughCPs = Value
        if loopThroughCPs then
            task.spawn(function()
                while loopThroughCPs do
                    for _, cp in ipairs(cpOrder) do
                        local direct = (cp == "CP7" or cp == "CP9") -- CP7 & CP9 teleport langsung
                        safeTeleport(checkpoints[cp], direct)
                        task.wait(teleportDelay)
                    end
                    game.Players.LocalPlayer.Character:BreakJoints()
                    task.wait(resetDelay)
                end
            end)
        end
    end
})

-- Tombol Stop Loop
LoopTab:CreateButton({
    Name = "Stop Semua Loop",
    Callback = function()
        loopDirectSummit = false
        loopThroughCPs = false
    end
})
