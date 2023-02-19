local tppos2
local deathtpmod = {["Enabled"] = false}
local lplr = game.Players.LocalPlayer
local entityLibrary = shared.vapeentity
local connectionstodisconnect = {}
local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, num, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, num, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, num, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end
local GuiLibrary = shared.GuiLibrary
local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end
local timer_players = os.clock()
deathtpmod = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
	Name = "BedTPRedirection",
	Function = function(callback)
		if callback then
			if callback then 
				local i_ = 0
				if os.clock() - timer_players < 1 then
					deathtpmod.ToggleButton(false)
					return print('its auto load btw')
				end 
				for i,bed in pairs(workspace:GetChildren()) do
					if bed.Name == "bed" then
						i_ = i_ + 1
					end
					if bed.Name == "bed" and bed.Covers.BrickColor ~= lplr.Team.TeamColor then
						pcall(function ()
							tppos2 = bed:GetChildren()[1].Position + Vector3.new(0,5,0)
							game.Players.LocalPlayer.Character.Humanoid.Health = 0
							--entity.fullEntityRefresh()
							repeat task.wait() until tppos2 == nil
							repeat task.wait() until not bed.Parent
						end)
					end
				end
				--local warning = createwarning("TPRedirection", "Set TP Position", 3)
			end
			deathtpmod.ToggleButton(false)
		end
	end
})
connectionstodisconnect[#connectionstodisconnect + 1] = lplr:GetAttributeChangedSignal("LastTeleported"):Connect(function(char)
	if tppos2 then 	
		task.spawn(function()
			task.wait(0.1)
			local root = entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and entityLibrary.character.HumanoidRootPart
			if root and tppos2 then 
				if (workspace:GetServerTimeNow() - lplr:GetAttribute("LastTeleported")) > 1 then
					createwarning("DNut Private", "Anticheat will interfere cuz of ur lag.", 5)
					deathtpmod.ToggleButton(false)
				end
				RunLoops:BindToHeartbeat("TPRedirection", 1, function(dt)
					if root and tppos2 then 
						local dist = (1100 * dt)
						if (tppos2 - root.CFrame.p).Magnitude > dist then
							root.CFrame = root.CFrame + (tppos2 - root.CFrame.p).Unit * dist
							root.Velocity = (tppos2 - root.CFrame.p).Unit * 20
						else
							root.CFrame = root.CFrame + (tppos2 - root.CFrame.p)
						end
					end
				end)
				RunLoops:BindToStepped("TPRedirection", 1, function()
					if entityLibrary.isAlive then 
						for i,v in pairs(lplr.Character:GetChildren()) do 
							if v:IsA("BasePart") then v.CanCollide = false end
						end
					end
				end)
				repeat
					task.wait()
				until tppos2 == nil or (tppos2 - root.CFrame.p).Magnitude < 1
				RunLoops:UnbindFromHeartbeat("TPRedirection")
				RunLoops:UnbindFromStepped("TPRedirection")
				--createwarning("TPRedirection", "Teleported.", 5)
				tppos2 = nil
			end
		end)
	end
end)
local tppos2
local deathtpmod = {["Enabled"] = false}
local lplr = game.Players.LocalPlayer
local entityLibrary = shared.vapeentity
local connectionstodisconnect = {}
local timer_players = os.clock()
local GuiLibrary = shared.GuiLibrary
deathtpmod = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
	Name = "PlayersTPRedirection",
	Function = function(callback)
		if callback then
			if callback then 
				if os.clock() - timer_players < 1 then
					deathtpmod.ToggleButton(false)
					return print('its auto load btw')
				end 
				local i_ = 0
				local tpos2backup
				for i,plr in pairs(game.Players:GetPlayers()) do
					task.wait(0.1)
					if plr.Character and plr ~= lplr and lplr.Team.TeamColor ~= plr.Team.TeamColor then
						pcall(function ()
							tpos2backup = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
							tppos2 = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
							game.Players.LocalPlayer.Character.Humanoid.Health = 0
							task.wait(1)
							pcall(function ()
								tppos2 = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
							end)
							if not tppos2 then
								tppos2 = tpos2backup
							end
							task.wait(1)
							pcall(function ()
								tppos2 = plr.Character.HumanoidRootPart.Position + Vector3.new(0,5,0)
							end)
							if not tppos2 then
								tppos2 = tpos2backup
							end
							repeat task.wait() until tppos2 == nil
							pcall(function ()
								repeat task.wait() until not plr.Character:FindFirstChild("HumanoidRootPart")
							end)
						end)
					end
				end
			end
			deathtpmod.ToggleButton(false)
		end
	end
})
connectionstodisconnect[#connectionstodisconnect + 1] = lplr:GetAttributeChangedSignal("LastTeleported"):Connect(function(char)
	if tppos2 then 	
		task.spawn(function()
			task.wait(0.1)
			local root = entityLibrary.isAlive and entityLibrary.character.Humanoid.Health > 0 and entityLibrary.character.HumanoidRootPart
			if root and tppos2 then 
				if (workspace:GetServerTimeNow() - lplr:GetAttribute("LastTeleported")) > 1 then
					createwarning("DNut Private", "Anticheat will interfere cuz of ur lag.", 5)
					deathtpmod.ToggleButton(false)
				end
				RunLoops:BindToHeartbeat("TPRedirection", 1, function(dt)
					if root and tppos2 then 
						local dist = (1100 * dt)
						if (tppos2 - root.CFrame.p).Magnitude > dist then
							root.CFrame = root.CFrame + (tppos2 - root.CFrame.p).Unit * dist
							root.Velocity = (tppos2 - root.CFrame.p).Unit * 20
						else
							root.CFrame = root.CFrame + (tppos2 - root.CFrame.p)
						end
					end
				end)
				RunLoops:BindToStepped("TPRedirection", 1, function()
					if entityLibrary.isAlive then 
						for i,v in pairs(lplr.Character:GetChildren()) do 
							if v:IsA("BasePart") then v.CanCollide = false end
						end
					end
				end)
				repeat
					task.wait()
				until tppos2 == nil or (tppos2 - root.CFrame.p).Magnitude < 1
				RunLoops:UnbindFromHeartbeat("TPRedirection")
				RunLoops:UnbindFromStepped("TPRedirection")
				--createwarning("TPRedirection", "Teleported.", 5)
				tppos2 = nil
			end
		end)
	end
end)
local GuiLibrary = shared.GuiLibrary
local Settings = {}
SkipTimerr = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
	["Name"] = "SkipTimer",
	["Function"] = function(callback) 
		if callback then 
			local key = game.Players.LocalPlayer:GetMouse().Hit.Position + Vector3.new(5,5,5)
			Settings.SkippedTimer = true
			local tween = game:GetService("TweenService")
			game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
				repeat task.wait() pcall(function ()
						task.spawn(function ()
							local info = TweenInfo.new(.01, Enum.EasingStyle.Linear,Enum.EasingDirection.In)
							tween:Create(game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),info
								,{CFrame = CFrame.new(key.X,key.Y,key.Z)}):Play()
							SkipTimerr.ToggleButton(false)
						end)
					end) until not Settings.SkippedTimer
			end)
		else
			Settings.SkippedTimer = false
		end
	end,
})
local entityLibrary = shared.vapeentity
local GuiLibrary = shared.GuiLibrary
local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(236, 129, 44)
		return frame
	end)
	return (suc and res)
end

local CheckMagnitude = {["Enabled"] = false}
CheckMagnitude = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
	["Name"] = "CheckMagnitude",
	["Function"] = function(Enabled)
		if Enabled then
			local mousepos = lplr:GetMouse().UnitRay
			local rayparams = RaycastParams.new()
			rayparams.FilterDescendantsInstances = {workspace.Map, workspace:FindFirstChild("SpectatorPlatform")}
			rayparams.FilterType = Enum.RaycastFilterType.Whitelist
			local ray = workspace:Raycast(mousepos.Origin, mousepos.Direction * 10000, rayparams)
			if not ray then
				createwarning("DNut","Unable to find position.",5)
				return fly.ToggleButton(false)
			else
				ray = ray.Position
			end
			local magnitude = (lplr.Character.HumanoidRootPart.Position - ray).magnitude
			if magnitude > 70 then
				createwarning("DNut","will get anticheated.(if no ground in path)",5)
			else
				createwarning("DNut","will NOT get anticheated!",5)	
			end
			CheckMagnitude.ToggleButton(false)
		end
	end
})

createwarning("DNut","Fully loaded",5)
