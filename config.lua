Config = {}

Config.Debug = true -- Set to false to disable debug messages
Config.Framework = "qb-core" -- "qb-core" or "es_extended" or "other"
Config.Target = "qb-target" -- "none" or "ox_target" or "qb-target", etc
Config.SQL = "oxmysql" -- "oxmysql" or "ghmattimysql" or "mysql-async", etc
Config.Menu = { -- or other(Update the menu.lua file)
	Menu = "qb", -- "ox" or "qb"
	Input = "ox", -- "ox" or "qb"
} -- If you do not have Ox_lib, remove it from fxmanifest.lua

--- Funtion to notify user
---@param: message: The message you want to send to user
---@param: type: The type of notification you want to send to user
---@param: src: The source of the player you want to send notification to
Config.triggerNotify = function(message, type, src)
    --[[if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
	else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end]]
	if not src then	TriggerEvent("QBCore:Notify", message, type)
	else TriggerClientEvent("QBCore:Notify", src, message, type) end
end

--- Function to show UI to open stash in its zone
---@param: stashName: The stash name you have assigned to it, you may use if needed.
---@param: sharedStash: True=Shared, False=Personal. You may use if you want.
Config.ShowUI = function(label)
    exports['qb-core']:DrawText("<b>[E] "..label.."</b>", 'left')
end

--- Function to hide UI to open stash in its zone
Config.HideUI = function()
    exports['qb-core']:HideText()
end
