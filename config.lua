Config = {}

Config.Framework = "qb" -- "qb" or "esx"
Config.Target = "none" -- "none" or "ox_target" or "qb-target", etc
Config.Notify = "qb"

--- Funtion to notify user
---@param: message: The message you want to send to user
---@param: type: The type of notification you want to send to user
---@param: src: The source of the player you want to send notification to
Config.triggerNotify = function(message, type, src)
    if Config.Notify == "okok" then
		if not src then	exports['okokNotify']:Alert(title, message, 6000, type)
		else TriggerClientEvent('okokNotify:Alert', src, title, message, 6000, type) end
	elseif Config.Notify == "qb" then
		if not src then	TriggerEvent("QBCore:Notify", message, type)
		else TriggerClientEvent("QBCore:Notify", src, message, type) end
	elseif Config.Notify == "t" then
		if not src then exports['t-notify']:Custom({title = title, style = type, message = message, sound = true})
		else TriggerClientEvent('t-notify:client:Custom', src, { style = type, duration = 6000, title = title, message = message, sound = true, custom = true}) end
	elseif Config.Notify == "infinity" then
		if not src then TriggerEvent('infinity-notify:sendNotify', message, type)
		else TriggerClientEvent('infinity-notify:sendNotify', src, message, type) end
	elseif Config.Notify == "rr" then
		if not src then exports.rr_uilib:Notify({msg = message, type = type, style = "dark", duration = 6000, position = "top-right", })
		else TriggerClientEvent("rr_uilib:Notify", src, {msg = message, type = type, style = "dark", duration = 6000, position = "top-right", }) end
	end
end

--- Function to show UI to open stash in its zone
---@param: stashName: The stash name you have assigned to it, you may use if needed.
---@param: sharedStash: True=Shared, False=Personal. You may use if you want.
Config.ShowUI = function(stashName, sharedStash)
    exports['qb-core']:DrawText("<b>[E] Open Stash</b>", 'left')
end

--- Function to hide UI to open stash in its zone
Config.HideUI = function()
    exports['qb-core']:HideText()
end
