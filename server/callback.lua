Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

---@module Callback(Server)
---@description Callback Server system for FiveM.

Callbacks = Callbacks or {}

local function CreateCallback(name, func)
    DebugPrint("Creating callback", name)
    Callbacks[name] = func
end

RegisterNetEvent("ez_lib:server:trigger_callback", function(name, cb_id, data)
    if Callbacks[name] ~= nil then
        Callbacks[name](source, function(result)
            TriggerClientEvent("ez_lib:client:callback_result", source, cb_id, result)
        end, data)
    else
        DebugPrint("Callback not found", name)
    end
    return
end)

Ez_lib.Functions.CreateCallback = CreateCallback