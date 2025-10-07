ResourceNames = {
	["qb-core"] = "qb-core",
	["es_extended"] = "es_extended",
	["qbx_core"] = "qbx_core",
	["ox_lib"] = "ox_lib",
	["qb-menu"] = "qb-menu",
	["oxmysql"] = "oxmysql",
	["ghmattimysql"] = "ghmattimysql",
	["mysql-async"] = "mysql-async",
	["ox_inventory"] = "ox_inventory",
	["qb-inventory"] = "qb-inventory",
	["qb-target"] = "qb-target",
	["ox_target"] = "ox_target",
}

Config = {}
Config.Debug = false -- Set to false to disable debug messages

Config.Framework = "auto" -- "qb-core" or "es_extended" or "auto" or "other"
Config.Target = "auto" -- "none" or "ox_target" or "qb-target" or "auto"
Config.Inventory = "auto" -- "ox_inventory" or "qb-inventory" or "other"(like qs-inventory, ...) or "auto"
Config.SQL = "auto" -- "oxmysql" or "ghmattimysql" or "mysql-async" or "auto"
Config.Menu = { -- or other(Update the menu.lua file)
	Menu = "auto", -- "ox" or "qb" or "auto"
	Input = "auto", -- "ox" or "qb" or "auto"
} -- If you do not have Ox_lib, remove it from fxmanifest.lua

--- Funtion to notify user
---@param message string The message you want to send to user
---@param type string The type of notification you want to send to user
---@param src integer The source of the player you want to send notification to
Config.TriggerNotify = function(title, message, type, src)
    --[[if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
	else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end]]
	if not src then
		TriggerEvent("QBCore:Notify", message, type)
		TriggerEvent("ESX:Notify", type, 6000, message)
		--TriggerEvent('okokNotify:Alert', title, message, 6000, type)
	else
		TriggerClientEvent("QBCore:Notify", src, message, type)
		TriggerClientEvent("ESX:Notify", src, type, 6000, message)
		--TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type)
	end
	DebugPrint("Notify", message)
end

--- Function give vehicle keys
--- @param veh integer The vehicle to give keys
--- @param src integer The source of the player to give keys
--- @usage Config.GiveVehicleKeys(veh, src)
Config.GiveVehicleKeys = function(veh, src)
	if not src then TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
	else TriggerClientEvent("vehiclekeys:client:SetOwner", src, GetVehicleNumberPlateText(veh)) end
end

--- Function to print debug messages
--- @param name string The name of the debug message
--- @param info string The information of the debug message
--- @usage Config.DebugPrint("name", "info")
function DebugPrint(name, info)
	if not info then info = "nil" end
    if Config.Debug then print("^5Debug^7: ^2"..name.."^7: '^6"..info.."^7'") end
end
Config.DebugPrint = DebugPrint


--- Client Side Functions

--- Function to show UI to open stash in its zone
--- @param label string The label to show
Config.ShowUI = function(label)
	lib.showTextUI("[E] "..label, { position = "left-center" })
    --exports['qb-core']:DrawText("<b>[E] "..label.."</b>", 'left')
end

--- Function to hide UI to open stash in its zone
Config.HideUI = function()
	lib.hideTextUI()
    --exports['qb-core']:HideText()
end

--- Set Fuel Function
--- @param veh integer The vehicle to set fuel
--- @param fuel integer The fuel to set
--- @usage Config.SetFuel(100)
Config.SetFuel = function(veh, fuel)
	-- Entity(veh).state.fuel = fuel -- For ox_fuel
	exports["LegacyFuel"]:SetFuel(veh, fuel)
end

--- Progress bar function (Client Side Only)
--- @param name string The name of the progress bar
--- @param label string The label of the progress bar
--- @param duration integer The duration, in ms, of the progress bar
--- @param useWhileDead boolean The progress bar can be used while dead
--- @param canCancel boolean The progress bar can be cancelled
--- @param controlDisables table The controls to disable {disableMovement, disableCarMovement, disableMouse, disableCombat}
--- @param animation table The animation to play {animDict, anim, flags}
--- @param prop table The prop to show {prop, bone, x, y, z, xR, yR, zR}
--- @param prop2 table The prop to show {prop, bone, x, y, z, xR, yR, zR}
--- @param cb function The callback function
Config.ProgressBar = function(name, label, duration, useWhileDead, canCancel, controlDisables, animation, prop, prop2, cb, icon)
	if lib.progressBar({
	    duration = duration or 5000,
	    label = label or 'Drinking water',
	    useWhileDead = useWhileDead or false,
	    canCancel = canCancel or false,
	    disable = {
	        car = true,
	    },
	    anim = {
	        dict = animation.animDict,
	        clip = animation.anim
	    },
	}) then cb(true) else cb(false) end

	--[[exports['progressbar']:Progress({
		name = name,
		duration = duration or 5000,
		label = label,
		useWhileDead = useWhileDead or false,
		canCancel = canCancel or false,
		controlDisables = controlDisables or {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = animation or {},
		prop = prop or {},
		propTwo = prop2 or {}
	}, function(cancelled)
		local success = not cancelled -- Get if successfull then pass it through to function
		cb(success)
	end, icon)

	exports['mythic_progbar']:Progress({
		name = name,
		duration = duration or 5000,
		label = label,
		useWhileDead = useWhileDead or false,
		canCancel = canCancel or false,
		animation = animation or nil,
		controlDisables = controlDisables or {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(cancelled)
		local success = not cancelled -- Get if successfull then pass it through to function
		cb(success)
	end, icon)

	exports["esx_progressbar"]:Progressbar(name, duration or 5000,{
        	FreezePlayer = controlDisables.disableMovement or true,
	    	animation ={
                	type = "anim",
                	dict = animation.animDict, 
                	lib =animation.anim
            	},
            	onFinish = function()
        		cb(true)
    		end
	})
	]]
end

Config.RemoveStress = function(stress) -- Your remove stress event/export (Client) [Optional]
	TriggerServerEvent("hud:server:RelieveStress", stress)
end

Config.RelieveThirst = function(n) -- Removes n amount of thirst (Client)
	-- ESX
	--TriggerClientEvent("esx_status:add", source, "thirst", n * 10000)

	-- QBCore
	TriggerServerEvent("consumables:server:addThirst", Ez_lib.Functions.GetPlayerData().metadata.thirst + n)
end

Config.RelieveHunger = function(n) -- Removes n amount of hunger (Client)
	-- ESX
	--TriggerClientEvent("esx_status:add", source, "hunger", n * 10000)

	-- QBCore
	TriggerServerEvent("consumables:server:addHunger", Ez_lib.Functions.GetPlayerData().metadata.hunger + n)
end

--- Server Side Functions

--- Add Money to Society
--- @param society string The society to add money to
--- @param amount integer The amount to add
--- @usage Config.AddMoneyToSociety("police", 100)
Config.AddMoneyToSociety = function(society, amount)
	exports['qb-management']:AddMoney(society, amount)
end

------------------------------- DO NOT TOUCH BELOW THIS LINE -------------------------------
ResourceName = GetCurrentResourceName()

CreateThread(function()
	while Config.Menu.Menu == "auto" or Config.Menu.Menu == nil do
		print("Detecting menu...")
		if GetResourceState(ResourceNames["ox_lib"]) == "started" then
			Config.Menu.Menu = "ox"
			break
		elseif GetResourceState(ResourceNames["qb-menu"]) == "started" then
			Config.Menu.Menu = "qb"
			break
		end
		Wait(1000)
	end

	while Config.Menu.Input == "auto" or Config.Menu.Input == nil do
		print("Detecting input...")
		if GetResourceState(ResourceNames["ox_lib"]) == "started" then
			Config.Menu.Input = "ox"
			break
		elseif GetResourceState(ResourceNames["qb-input"]) == "started" then
			Config.Menu.Input = "qb"
			break
		end
		Wait(1000)
	end
	if Config.Framework == "qbx_core" then
		Config.Framework = "qb-core"
		Config.Qbox = true
	end
	while Config.Framework == "auto" or Config.Framework == nil do
		print("Detecting framework...")
		if GetResourceState(ResourceNames["es_extended"]) == "started" then
			Config.Framework = "es_extended"
			break
		elseif GetResourceState(ResourceNames["qb-core"]) == "started" or GetResourceState(ResourceNames["qbx_core"]) == "started" then
			Config.Framework = "qb-core"
			break
		end
		Wait(1000)
	end
	print("Framework: "..Config.Framework)
	if GetResourceState(ResourceNames["qbx_core"]) == "started" then Config.Qbox = true end
	while Config.SQL == "auto" or Config.SQL == nil do
		print("Detecting SQL...")
		if GetResourceState(ResourceNames["oxmysql"]) == "started" then
			Config.SQL = "oxmysql"
			break
		elseif GetResourceState(ResourceNames["ghmattimysql"]) == "started" then
			Config.SQL = "ghmattimysql"
			break
		elseif GetResourceState(ResourceNames["mysql-async"]) == "started" then
			Config.SQL = "mysql-async"
			break
		end
		Wait(1000)
	end
	if Config.Target == "auto" or Config.Target == nil then
		print("Detecting target...")
		if GetResourceState(ResourceNames["ox_target"]) == "started" then
			Config.Target = "ox_target"
		elseif GetResourceState(ResourceNames["qb-target"]) == "started" then
			Config.Target = "qb-target"
		else
			Config.Target = "none"
		end
	end

	if Config.Inventory == "auto" or Config.Inventory == nil then
		print("Detecting inventory...")
		if GetResourceState(ResourceNames["ox_inventory"]) == "started" then
			Config.Inventory = "ox_inventory"
		elseif GetResourceState(ResourceNames["qb-inventory"]) == "started" then
			Config.Inventory = "qb-inventory"
		else
			Config.Inventory = "other"
		end
	end
end)