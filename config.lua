Config = {}

Config.Debug = false -- Set to false to disable debug messages
Config.Framework = "qb-core" -- "qb-core" or "es_extended" or "other"
Config.Qbox = false -- If you use "qbx-core", make sure to set the top framework at "qb-core"
Config.Target = "qb-target" -- "none" or "ox_target" or "qb-target", etc
Config.Inventory = "new-qb-inventory" -- "ox_inventory" or "new-qb-inventory" or "qb-inventory" or "qs-inventory" or "codem-inventory", etc
Config.SQL = "oxmysql" -- "oxmysql" or "ghmattimysql" or "mysql-async", etc
Config.Menu = { -- or other(Update the menu.lua file)
	Menu = "qb", -- "ox" or "qb"
	Input = "qb", -- "ox" or "qb"
} -- If you do not have Ox_lib, remove it from fxmanifest.lua

--- Funtion to notify user
---@param: message: The message you want to send to user
---@param: type: The type of notification you want to send to user
---@param: src: The source of the player you want to send notification to
Config.TriggerNotify = function(title, message, type, src)
    --[[if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
	else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end]]
	if not src then	TriggerEvent("QBCore:Notify", message, type)
	else TriggerClientEvent("QBCore:Notify", src, message, type) end
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
    exports['qb-core']:DrawText("<b>[E] "..label.."</b>", 'left')
end

--- Function to hide UI to open stash in its zone
Config.HideUI = function()
    exports['qb-core']:HideText()
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
--- @param duration integer The duration of the progress bar
--- @param useWhileDead boolean The progress bar can be used while dead
--- @param canCancel boolean The progress bar can be cancelled
--- @param controlDisables table The controls to disable {disableMovement, disableCarMovement, disableMouse, disableCombat}
--- @param animation table The animation to play {animDict, anim, flags}
--- @param prop table The prop to show {prop, bone, x, y, z, xR, yR, zR}
--- @param prop2 table The prop to show {prop, bone, x, y, z, xR, yR, zR}
--- @param cb function The callback function
Config.ProgressBar = function(name, label, duration, useWhileDead, canCancel, controlDisables, animation, prop, prop2, cb, icon)
	exports['progressbar']:Progress({
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
	--[[
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

	local QBCore = exports["qb-core"]:GetCoreObject()
	-- QBCore
	TriggerServerEvent("consumables:server:addThirst", QBCore.Functions.GetPlayerData().metadata.thirst + n)
end

Config.RelieveHunger = function(n) -- Removes n amount of hunger (Client)
	-- ESX
	--TriggerClientEvent("esx_status:add", source, "hunger", n * 10000)

	local QBCore = exports["qb-core"]:GetCoreObject()
	-- QBCore
	TriggerServerEvent("consumables:server:addHunger", QBCore.Functions.GetPlayerData().metadata.hunger + n)
end

--- Server Side Functions

--- Add Money to Society
--- @param society string The society to add money to
--- @param amount integer The amount to add
--- @usage Config.AddMoneyToSociety("police", 100)
Config.AddMoneyToSociety = function(society, amount)
	exports['qb-management']:AddMoney(society, amount)
end

-- DO NOT TOUCH BELOW THIS LINE
ResourceName = GetCurrentResourceName()
