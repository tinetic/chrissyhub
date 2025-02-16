local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local exposevotesinchattoggle = false
local flying = false

if game.PlaceId == 4939362930 then
	local lol = {}
	local success, err = pcall(function()
		for k, v in pairs(getgc(true)) do -- https://v3rmillion.net/showthread.php?tid=1209519
			if pcall(function() return rawget(v, "indexInstance") end) and type(rawget(v, "indexInstance")) == "table" and (rawget(v, "indexInstance"))[1] == "kick" then
				bypassed = true
				v.tvk = { "kick", function() return game.Workspace:WaitForChild("") end }
			end
		end
	end)

	if getgenv().trdshowvotesgui then
		getgenv().trdshowvotesdeletefunc()
	end

	local votingfolder = game.ReplicatedStorage.Season.Voting

	table.insert(lol, votingfolder.Votes.ChildAdded:Connect(function(vote)
		local whovoted = vote.Value
		local votedfor = vote.Name

		if game.ReplicatedStorage:FindFirstChild("Season") and game.ReplicatedStorage.Season:FindFirstChild("Players") then
			if game.ReplicatedStorage.Season.Players:FindFirstChild(whovoted) then
				whovoted = game.ReplicatedStorage.Season.Players[whovoted].Value
			end
			if game.ReplicatedStorage.Season.Players:FindFirstChild(votedfor) then
				votedfor = game.ReplicatedStorage.Season.Players[votedfor].Value
			end
		end

		-- Send vote message in chat
		if not exposevotesinchattoggle then return end
		game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(whovoted .. " voted " .. votedfor, "All")
	end))

	game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Done loading", Text = "Done loading" })
end

-- Flying Function
local function startFlying()
    local plr = game.Players.LocalPlayer
    local character = plr.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not character or not humanoid then return end

    if workspace:FindFirstChild("Core") then
        workspace.Core:Destroy()
    end

    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)
    Core.Parent = workspace

    local Weld = Instance.new("Weld", Core)
    Weld.Part0 = Core
    Weld.Part1 = character:FindFirstChild("LowerTorso") or character:FindFirstChild("HumanoidRootPart")
    Weld.C0 = CFrame.new(0, 0, 0)

    local torso = Core
    local speed = 10
    local keys = {w = false, s = false, a = false, d = false}

    local pos = Instance.new("BodyPosition", torso)
    local gyro = Instance.new("BodyGyro", torso)

    pos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    pos.Position = torso.Position
    gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    gyro.CFrame = torso.CFrame

    local function updatePosition()
        while flying do
            task.wait()
            humanoid.PlatformStand = true
            local new = gyro.CFrame - gyro.CFrame.Position + pos.Position

            if keys.w then new = new + workspace.CurrentCamera.CFrame.LookVector * speed end
            if keys.s then new = new - workspace.CurrentCamera.CFrame.LookVector * speed end
            if keys.a then new = new * CFrame.new(-speed, 0, 0) end
            if keys.d then new = new * CFrame.new(speed, 0, 0) end

            pos.Position = new.Position
            gyro.CFrame = workspace.CurrentCamera.CFrame
        end
        humanoid.PlatformStand = false
        pos:Destroy()
        gyro:Destroy()
        Core:Destroy()
    end

    local function keyDown(input)
        local key = input.KeyCode
        if key == Enum.KeyCode.W then keys.w = true end
        if key == Enum.KeyCode.S then keys.s = true end
        if key == Enum.KeyCode.A then keys.a = true end
        if key == Enum.KeyCode.D then keys.d = true end
        if key == Enum.KeyCode.X then
            flying = not flying
            if flying then
                updatePosition()
            end
        end
    end

    local function keyUp(input)
        local key = input.KeyCode
        if key == Enum.KeyCode.W then keys.w = false end
        if key == Enum.KeyCode.S then keys.s = false end
        if key == Enum.KeyCode.A then keys.a = false end
        if key == Enum.KeyCode.D then keys.d = false end
    end

    game:GetService("UserInputService").InputBegan:Connect(keyDown)
    game:GetService("UserInputService").InputEnded:Connect(keyUp)

    updatePosition()
end

local Window = Rayfield:CreateWindow({
   Name = "Chrissy Hub",
   LoadingTitle = "Chrissy Hub",
   LoadingSubtitle = "Universal + Game Scripts",
   ConfigurationSaving = { Enabled = true, FolderName = nil, FileName = "chrissyConfig" },
   Discord = { Enabled = false, Invite = "usercreation", RememberJoins = true },
   KeySystem = true,
   KeySettings = { Title = "Chrissy Hub", Subtitle = "Key System", Note = "it is 'Hello!'", FileName = "ChrissyKey", SaveKey = false, GrabKeyFromSite = false, Key = "Hello!" }
})

local UniversalTab = Window:CreateTab("Universal", 4483362458)
local UniversalSection = UniversalTab:CreateSection("Main")

local flyButton = UniversalTab:CreateButton({
    Name = "Toggle Fly",
    Callback = function()
        flying = not flying
        if flying then
            startFlying()
        end
    end,
})

local SpeedButton = UniversalTab:CreateButton({
   Name = "Speed: 20",
   Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 20
   end,
})

local JumpButton = UniversalTab:CreateButton({
   Name = "JumpPower: 57.5",
   Callback = function()
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = 57.5
   end,
})

local InfiniteJumpEnabled = false
local InfiniteJumpToggle = UniversalTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "infiniteJump",
   Callback = function(Value)
      InfiniteJumpEnabled = Value
   end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
   if InfiniteJumpEnabled then
      game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
   end
end)

local Mouse = game.Players.LocalPlayer:GetMouse()
local TeleportationEnabled = false

local TeleportToggle = UniversalTab:CreateToggle({
   Name = "Enable CTRL+Click Teleportation",
   CurrentValue = false,
   Flag = "teleportToggle",
   Callback = function(Value)
      TeleportationEnabled = Value
   end,
})

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
   if TeleportationEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 and gameProcessed == false and 
      game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
      game.Players.LocalPlayer.Character:MoveTo(Mouse.Hit.p)
   end
end)

local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local RandomTeleportButton = TeleportTab:CreateButton({
   Name = "Teleport to Random Location",
   Callback = function()
      local randomPosition = Vector3.new(math.random(-500, 500), math.random(10, 50), math.random(-500, 500))
      game.Players.LocalPlayer.Character:MoveTo(randomPosition)
   end,
})

local HumanoidTab = Window:CreateTab("Humanoid", 4483362458)

local ResetCharacterButton = HumanoidTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      game.Players.LocalPlayer.Character:BreakJoints()
   end,
})

local GamesTab = Window:CreateTab("Games", 4483362458)
local TotalDramaSection = GamesTab:CreateSection("Total Roblox Drama")

local ExposeVotesInChat = GamesTab:CreateButton({
   Name = "Toggle Show Votes In Chat",
   Callback = function()
		exposevotesinchattoggle = not exposevotesinchattoggle
   end,
})

local FinishObby = GamesTab:CreateButton({
	Name = "Finish Obby",
	Callback = function()
		for i,v in pairs(workspace.Assets:GetDescendants()) do
			if v.Name == "Finish" then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
				break
			end
		end
	end,
})

local FindStat = GamesTab:CreateButton({
	Name = "Find Statue",
	Callback = function()
		local IdolsFolder = workspace.Idols
		if IdolsFolder.Bag then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = IdolsFolder.Bag.WorldPivot
		end
		if IdolsFolder["Safety Statue"] then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = IdolsFolder["Safety Statue"].WorldPivot
		end
	end,
})

local BloxFruitsSection = GamesTab:CreateSection("Blox Fruits")
local CollectBloxFruitsChests = GamesTab:CreateButton({
	Name = "Collect All Chests",
	Callback = function()
		for i,v in pairs(workspace.ChestModels:GetChildren()) do
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame
			wait(0.1)
		end
	end,
})

local FTAPSection = GamesTab:CreateSection("Fling Things And People")

local FTAPScript = GamesTab:CreateButton({
	Name = "FTAP Script",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"))()
	end,
})
