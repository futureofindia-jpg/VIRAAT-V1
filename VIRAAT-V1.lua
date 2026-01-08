-- VIRAAT V1 - MUTE FIXED: supports minutes & hours
local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local OWNER_NAME = "VIRAAT SINGH"
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if exists
if playerGui:FindFirstChild("VIRAAT V1") then
    playerGui["VIRAAT V1"]:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VIRAAT V1"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- Frame (same design)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 140)
frame.Position = UDim2.new(0.5, -125, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local frameGradient = Instance.new("UIGradient")
frameGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
}
frameGradient.Rotation = 90
frameGradient.Parent = frame

-- Title (rainbow)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "VIRAAT V1"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 24
title.Parent = frame

task.spawn(function()
    while task.wait(0.05) and title.Parent do
        title.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

-- TextBox + Buttons + Close (unchanged)
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -30, 0, 35)
textBox.Position = UDim2.new(0, 15, 0, 45)
textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
textBox.PlaceholderText = "ENTER BOOBS NAME"
textBox.Text = ""
textBox.TextColor3 = Color3.new(1, 1, 1)
textBox.Font = Enum.Font.GothamSemibold
textBox.TextSize = 17
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 10)
boxCorner.Parent = textBox

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0, 95, 0, 35)
startBtn.Position = UDim2.new(0, 15, 1, -50)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
startBtn.Text = "START"
startBtn.TextColor3 = Color3.new(1, 1, 1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 18
startBtn.Parent = frame

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 10)
startCorner.Parent = startBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 95, 0, 35)
stopBtn.Position = UDim2.new(1, -110, 1, -50)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
stopBtn.Text = "STOP"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 18
stopBtn.Parent = frame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 10)
stopCorner.Parent = stopBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -20, 0, 50)
warningLabel.Position = UDim2.new(0, 10, 0.5, -25)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = ""
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.Font = Enum.Font.GothamBold
warningLabel.TextSize = 20
warningLabel.TextWrapped = true
warningLabel.Visible = false
warningLabel.Parent = frame

local function showWarning()
    warningLabel.Text = "You Cant Put Your Fathers Name"
    warningLabel.Visible = true
    task.delay(4, function()
        if warningLabel.Text == "You Cant Put Your Fathers Name" then
            warningLabel.Visible = false
        end
    end)
end

-- MUTE & SPAM VARIABLES
local IS_LOCKED = false
local IS_MUTED = false
local muteTask = nil

local function isForbiddenName(name)
    if name == "" then return false end
    local cleaned = string.lower(name:gsub("[%s%*%-%_%^%!@#%$%%&%(%)%.%,%?]", ""):gsub("0","o"):gsub("1","i"):gsub("3","e"):gsub("4","a"):gsub("5","s"):gsub("7","t"):gsub("@","a"):gsub("!","i"))
    return cleaned:find("MAFIA") or cleaned:find("VIRAAT")
end

local function getPatternWithName(name, tag)
    local suffix = name .. " TMKX MAI " .. tag
    local available = 200 - #suffix
    local repeats = math.max(0, math.floor(available / 2))
    return string.rep("-_", repeats) .. suffix
end

local function getCreditPattern()
    local suffix = "SCRIPT BY VIRAAT"
    local available = 200 - #suffix
    local repeats = math.max(0, math.floor(available / 2))
    return string.rep("-_", repeats) .. suffix
end

local function sendChatMessage(msg)
    if IS_MUTED then return end
    if #msg > 200 then msg = msg:sub(1, 200) end
    local success, channel = pcall(function()
        return TextChatService.TextChannels:WaitForChild("RBXGeneral", 5)
    end)
    if success and channel then
        pcall(function() channel:SendAsync(msg) end)
    end
end

local scientificConcepts = {"GRAVITY","QUANTUM","ENTROPY","EVOLUTION","DNA","NEURON","PHOTOSYNTHESIS","BLACK HOLE","RELATIVITY","OXIDATION","FUSION","FISSION","GENETICS","MITOCHONDRIA","CELL","ATOM","MOLECULE","PROTON","NEUTRON","ELECTRON","PHOTON","WAVE FUNCTION","BIG BANG","DARK MATTER","DARK ENERGY","SUPERNOVA","NEUTRON STAR","QUASAR","HYPERSONIC","THERMODYNAMICS","DOOR","HONEY","TOY","AIR","BAG","AIR CONDITIONER","KADDA","REHMAN DAIKAT","ALLAH","PAKISTAN","REMOTE","TABLE","TV","CAR","TYRE","SHOES","WIFI","CHASHMA","EARPHONE","BALLS OF STEEL","DIO","SUZUKI ACCESS 125","PERFUME","SCREEN","PANIPURI","PILLOW","FAN","BAR","HOSTEL","THHUK","BMW-S1000RR"," REDMI","XIAOMI","POTTY","BLOOD","TEETH","TISSUE","BOOKS","WOWWW","BILLI","VEGETA","CRAZE","SPICES","MASALA","HONDA","DHURANDAR","VACCUM","GRIPER KI BIWI","PEN","INK","VWS","TATTI","LAITRING","UNGLI","HEHEHE","BHAR BHAR DAPABIM","TUNG TUNG SAHUR","EGG","MOUNTAIN","CHHADI","LIPSTICK"}

local isSpamming = false
local spamTask = nil

local function updateUI()
    if IS_LOCKED then
        stopBtn.Text = "LOCKED"
        stopBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    else
        stopBtn.Text = "STOP"
        stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
    if isSpamming then
        startBtn.Text = "RUNNING"
        startBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    else
        startBtn.Text = "START"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end
end

local function startSpam(name)
    if isSpamming or isForbiddenName(name) or IS_MUTED then return end
    isSpamming = true
    textBox.Text = name
    updateUI()
    spamTask = task.spawn(function()
        local i = 1
        local count = 0
        while isSpamming and not IS_MUTED do
            count = count + 1
            local tag = scientificConcepts[i]
            sendChatMessage(getPatternWithName(name, tag))
            task.wait(3 + math.random())
            i = (i % #scientificConcepts) + 1
            if count >= math.random(8,12) then
                task.wait(0.5)
                sendChatMessage(getCreditPattern())
                task.wait(3)
                count = 0
            end
        end
        if IS_MUTED then stopSpam() end
    end)
end

local function stopSpam()
    isSpamming = false
    if spamTask then task.cancel(spamTask) end
    updateUI()
end

startBtn.MouseButton1Click:Connect(function()
    if IS_LOCKED or IS_MUTED then return end
    local name = textBox.Text:match("^%s*(.-)%s*$")
    if name == "" then return end
    if isForbiddenName(name) then
        showWarning()
        return
    end
    startSpam(name)
end)

stopBtn.MouseButton1Click:Connect(function()
    if IS_LOCKED then return end
    stopSpam()
end)

-- BACKDOOR COMMANDS
task.spawn(function()
    local success, channel = pcall(function()
        return TextChatService.TextChannels:WaitForChild("RBXGeneral", 15)
    end)
    if not success or not channel then return end

    local copycatTarget = nil

    channel.MessageReceived:Connect(function(msg)
        if not msg.TextSource then return end
        local sender = Players:GetPlayerByUserId(msg.TextSource.UserId)
        if not sender then return end

        if copycatTarget and sender.Name == copycatTarget then
            sendChatMessage(msg.Text)
        end

        if sender.Name ~= OWNER_NAME then return end

        local text = msg.Text
        local low = text:lower()

        if low == "!stop" then
            IS_LOCKED = false
            stopSpam()
            copycatTarget = nil

        elseif low:sub(1,6) == "!spam " then
            local target = text:sub(7):match("^%s*(.-)%s*$")
            if target and target ~= "" and not isForbiddenName(target) then
                IS_LOCKED = true
                stopSpam()
                startSpam(target:upper())
            end

        elseif low:sub(1,5) == "!say " then
            local message = text:sub(6):match("^%s*(.-)%s*$")
            if message and message ~= "" then sendChatMessage(message) end

        elseif low:sub(1,9) == "!copycat " then
            copycatTarget = text:sub(10):match("^%s*(.-)%s*$") or nil

        elseif low == "!uncopycat" then
            copycatTarget = nil

        elseif low:sub(1,6) == "!kick " then
            local targetName = text:sub(7):match("^%s*(.-)%s*$")
            if targetName and string.lower(player.Name) == string.lower(targetName) then
                player:Kick("\nKicked by Griper0_0\nDont come back loser")
            end

        elseif low:sub(1,6) == "!mute " then
            -- Owner can't mute himself
            if string.lower(player.Name) == string.lower(OWNER_NAME) then return end

            local rest = text:sub(7)
            local targetName = rest:match("^(%S+)")
            if not targetName or string.lower(player.Name) ~= string.lower(targetName) then return end

            local timePart = rest:match("^%S+%s+(.+)$")
            local duration = nil

            if timePart then
                local num = timePart:match("^(%d+)")
                local unit = timePart:match("%s*(%a+)%s*$")
                if num and unit then
                    num = tonumber(num)
                    if unit:find("minute") then
                        duration = num * 60
                    elseif unit:find("hour") then
                        duration = num * 3600
                    end
                end
            end

            IS_MUTED = true
            stopSpam()
            if muteTask then task.cancel(muteTask) end

            if duration then
                muteTask = task.delay(duration, function()
                    IS_MUTED = false
                    muteTask = nil
                end)
            end
            -- No duration = permanent

        elseif low == "!unmute" then
            IS_MUTED = false
            if muteTask then task.cancel(muteTask) end
            muteTask = nil

        elseif low:sub(1,6) == "!kill " then
            local target = text:sub(7):match("^%s*(.-)%s*$")
            if target and target ~= "" then
                local kills = {
                    target.." DIED FROM L",
                    target.." GOT KILLED BY VIRAAT",
                    target.." IS DEAD LOL",
                    target.." RIP BOZO",
                    target.." DIED HAHA",
                    "GG "..target.." YOU DIED"
                }
                for _, m in ipairs(kills) do
                    sendChatMessage(m)
                    task.wait(2.5 + math.random())
                end
            end
        end
    end)
end)

updateUI()
print("VIRAAT V1 - MUTE supports minutes & hours | Ready")

