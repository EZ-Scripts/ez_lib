Ns_lib = Ns_lib or {}
Callbacks = Callbacks or {}
Ns_lib.Functions = Ns_lib.Functions or {}

function DebugPrint(message)
    if Config.Debug then print(message) end
end

exports('GetCoreObject', function()
    return Ns_lib
end)