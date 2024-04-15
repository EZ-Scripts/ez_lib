---@module Callback(Client)
---@description Callback Client system for FiveM. Trigger Server Callbacks from the client side.

Ns_lib = Ns_lib or {}
Ns_lib.Callbacks = Ns_lib.Callbacks or {}
Ns_lib.Functions = Ns_lib.Functions or {}

function TriggerCallback(name, data)
    local cb_id = math.random(1, 1000000)
    Ns_lib.Callbacks[cb_id] = -1
    TriggerServerEvent('ns_lib:server:trigger_callback', name, cb_id, data)

    local res = Ns_lib.Callbacks[cb_id]
    while res ~= nil do
        Wait(0)
        if res == -1 then
        else
            Ns_lib.Callbacks[cb_id] = nil
            return res
        end
        res = Ns_lib.Callbacks[cb_id]
    end
    return false
end

RegisterNetEvent("ns_lib:client:callback_result", function(cb_id, result)
    if Ns_lib.Callbacks[cb_id] == -1 then
        Ns_lib.Callbacks[cb_id] = result
    else
        DebugPrint("Callback not found: " .. cb_id)
    end
    return
end)

Ns_lib.Functions.TriggerCallback = TriggerCallback