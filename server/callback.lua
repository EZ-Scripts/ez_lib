---@module Callback(Server)
---@description Callback Server system for FiveM.

Callbacks = {}

local function CreateCallback(name, func)
    Callbacks[name] = func
end

RegisterNetEvent("ns_lib:server:trigger_callback", function(name, cb_id, ...)
    if Callbacks[name] then
        Callbacks[name](source, function(...)
            TriggerClientEvent("ns_lib:client:callback_result", source, cb_id, ...)
        end, ...)
    else
        DebugPrint("Callback not found: " .. name)
    end
end)

Ns_lib.Functions.CreateCallback = CreateCallback