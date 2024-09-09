---@module Callback(Client)
---@description Callback Client system for FiveM. Trigger Server Callbacks from the client side.

Ez_lib = Ez_lib or {}
Ez_lib.Callbacks = Ez_lib.Callbacks or {}
Ez_lib.Functions = Ez_lib.Functions or {}

function TriggerCallback(name, data)
    local cb_id = math.random(1, 1000000)
    Ez_lib.Callbacks[cb_id] = -1
    TriggerServerEvent(ResourceName..":server:trigger_callback", name, cb_id, data)

    local res = Ez_lib.Callbacks[cb_id]
    while res ~= nil do
        Wait(0)
        if res == -1 then
        else
            Ez_lib.Callbacks[cb_id] = nil
            return res
        end
        res = Ez_lib.Callbacks[cb_id]
    end
    return false
end

RegisterNetEvent(ResourceName..":client:callback_result", function(cb_id, result)
    if Ez_lib.Callbacks[cb_id] == -1 then
        Ez_lib.Callbacks[cb_id] = result
    else
        DebugPrint("Callback not found", cb_id)
    end
    return
end)

Ez_lib.Functions.TriggerCallback = TriggerCallback