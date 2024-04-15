Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

---@module Callback(Server)
---@description Callback Server system for FiveM.

Callbacks = Callbacks or {}

local function CreateCallback(name, func)
    DebugPrint("Creating callback: " .. name)
    Callbacks[name] = func
end

RegisterNetEvent("ns_lib:server:trigger_callback", function(name, cb_id, data)
    if Callbacks[name] ~= nil then
        Callbacks[name](source, function(result)
            TriggerClientEvent("ns_lib:client:callback_result", source, cb_id, result)
        end, data)
    else
        DebugPrint("Callback not found: " .. name)
    end
    return
end)

Ns_lib.Functions.CreateCallback = CreateCallback