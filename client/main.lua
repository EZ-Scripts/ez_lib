Ez_lib = Ez_lib or {}

function DebugPrint(name, info)
    if Config.Debug then print("^5Debug^7: ^2"..name.."^7: '^6"..info.."^7'") end
end

exports('GetCoreObject', function()
    return Ez_lib
end)