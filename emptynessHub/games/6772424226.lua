local default = getgenv().mainLib:NewTab("Game Tab 1")
local PlaceId =
    default:NewSection(
    {
        Name = "",
        column = 1
    }
)
local function getBases()
    for i, v in pairs(game.workspace.Beams:GetChildren()) do
        if v.Attachment0 ~= nil and v.Attachment1 ~= nil then
            return v.Name
        end
    end
end

local function getTycoon()
    for i, v in pairs(game.workspace.Tycoons:GetChildren()) do
        if tostring(v.Values.Owner.Value) == game.Players.LocalPlayer.Name then
            return v
        end
    end
end

local function collect(it)
    firetouchinterest(it.Important.CashCollect.CollectArea, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
    firetouchinterest(it.Important.CashCollect.CollectArea, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
end

local function infMoney(toggled)
    local mt = debug.getmetatable(game)
    local nc = mt.__namecall

    setreadonly(mt, false)

    mt.__namecall =
        newcclosure(
        function(self, ...)
            local args = {...}
            local method = getnamecallmethod()

            if (method == "FireServer" and self.Name == "Upgrade" and toggled) then
                args[1] = {
                    ["Name"] = "Dropper1",
                    ["Class"] = {
                        ["Upgrade"] = {
                            ["Value"] = 2000000000000
                        }
                    }
                }
            end

            return nc(self, unpack(args))
        end
    )

    setreadonly(mt, true)
end

PlaceId:CreateToggle(
    {
        Name = "Infinite money",
        Callback = function(bool)
            infMoney(bool)
        end
    }
)
PlaceId:CreateButton(
    {
        Name = "Delete Ads",
        Callback = function()
            for i, v in pairs(game.workspace:GetChildren()) do
                if v.Name == "Ads" or v.Name == "Sales" or v.Name == "LikeGoals" or v.Name == "Boxes" then
                    v:Destroy()
                end
            end
        end
    }
)
PlaceId:CreateToggle(
    {
        Name = "Auto Buy",
        Callback = function(bool)
            while bool do
                task.wait()
                local tyc = getTycoon()
                if not tyc then
                    return
                end
                if tyc then
                    for i, v in pairs(tyc.Buttons:GetDescendants()) do
                        if v:FindFirstChild("Info") then
                            if v.Transparency == 0 then
                                if not string.find(v.Info.Price.Main.Text, "R") then
                                    firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                                    firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)
                                end
                            end
                        end
                    end
                end
            end
        end
    }
)
PlaceId:CreateToggle(
    {
        Name = "Auto Collect",
        Callback = function(bool)
            while bool do
                task.wait()
                local temp = getTycoon()
                if temp then
                    collect(temp)
                end
            end
        end
    }
)
PlaceId:CreateToggle(
    {
        Name = "Auto Rebirth",
        Callback = function(bool)
            while bool do
                task.wait(0.2)
                game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
            end
        end
    }
)
PlaceId:CreateToggle(
    {
        Name = "Auto Farm",
        Callback = function(bool)
            while bool do
                task.wait()
                local test = getBases()
                local tyc = getTycoon()

                if test or tyc then
                    pcall(
                        function()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                game.workspace.Tycoons[test].Important.Door.CFrame
                            task.wait(1)
                            tyc = getTycoon()
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                tyc.Buttons.Floor1.Conveyor.CFrame
                            task.wait(0.1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                tyc.Buttons.Floor1.Dropper1.CFrame
                            task.wait(0.1)
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                tyc.Buttons.Floor1.Upgrade1.CFrame
                            task.wait(0.1)
                        end
                    )
                    infMoney(true)

                    tyc = getTycoon()

                    local thingens = nil
                    for i, v in pairs(tyc.Buttons.Floor8:GetChildren()) do
                        if string.find(v.Name, "FINISH") then
                            thingens = v
                        end
                    end

                    while thingens.Transparency == 1 do
                        for i, v in pairs(tyc.Buttons:GetDescendants()) do
                            if v:FindFirstChild("Info") then
                                if v.Transparency == 0 then
                                    if not string.find(v.Info.Price.Main.Text, "R") then
                                        firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
                                        firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 1)

                                        task.wait(0.1)
                                        collect(tyc)
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = thingens.CFrame
                    task.wait(2)
                    game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
                end
            end
            infMoney(false)
        end
    }
)
