---@module Callback(Client)
---@description Callback Client system for FiveM. Trigger Server Callbacks from the client side.

Ns_lib = Ns_lib or {}
Ns_lib.Callbacks = Ns_lib.Callbacks or {}

function TriggerCallback(name, cb, ...)
    local cb_id = math.random(1, 1000000)
    Ns_lib.Callbacks[cb_id] = cb
    TriggerServerEvent('ns_lib:server:trigger_callback', name, cb_id, ...)
end

RegisterNetEvent("ns_lib:client:callback_result", function(cb_id, ...)
    if Ns_lib.Callbacks[cb_id] then
        Ns_lib.Callbacks[cb_id](...)
        Ns_lib.Callbacks[cb_id] = nil
    else
        DebugPrint("Callback not found: " .. cb_id)
    end
end)

Ns_lib.Functions.TriggerCallback = TriggerCallback