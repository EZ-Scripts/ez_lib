-- Last Modified: 24/03/2024
---@version 1.0.0
---@module Target
---@description Target system bridge for FiveM


--- Function to check if resource exists
CreateThread(function()
    Wait(500)
    if (Config.Target ~= "none" or Config.Target ~= nil) and GetResourceState(Config.Target) ~= "started" then
        DebugPrint("Target resource not found")
        return
    end
end)

Targets = {}

--- Function to check if player can open stash
---@param: data: The data of the target. minZ, maxZ, coords(vector4), length(optional), width(optional), icon, action, event, distance (optional)
---@return: Target
function CreateTarget(data)
    local k = "ns_lib_Target#"..#Targets+1
    local vector3 = vector3(data.coords.x, data.coords.y, data.coords.z)
    local heading = data.coords.w or 0.0
    local length = data.length or 1.5
    local width = data.width or 1.5
    if Config.Target == "none" or Config.Target == nil then
        local Zone = BoxZone:Create(vector3, length, width, {name = "box_zone", debugPoly = Config.Debug, heading = heading, minZ = data.minZ or data.coords.z - 1, maxZ = data.maxZ or data.coords.z + 1})
        Targets[k] = ComboZone:Create({Zone}, {name = k, debugPoly = Config.Debug})
        Targets[k]:onPlayerInOut(function(isPointInside, _, _)
            data.action(isPointInside)
        end)
    elseif Config.Target == "ox_target" then
        Targets[k] =
        {
            coords = vector3,
            size = vector3(width, length, (data.maxZ - (data.minZ + 1)) or 3.5),
            distance = 150.0,
            rotation = heading,
            debug = Config.Debug,
            options = {
                {
                    icon = data.icon,
                    label = Loc[Config.Locale].target["smoke_bong"],
                    distance = data.distance or 2.5,
                    onSelect = function()
                        data.action(true)
                    end
                },
            },
        }
        exports.ox_target:addBoxZone(Targets[k])
    else
        Targets[k] =
        exports[Config.Target]:AddBoxZone(k, vector3, length, width,
            {
                name = k,
                heading = heading,
                debugPoly=Config.Debug,
                minZ = data.minZ or data.coords.z - 1,
                maxZ = data.maxZ or data.coords.z + 1,
            },
            {
                options = {
                    {
                        type = "client",
                        event = data.event,
                        action = data.action(true),
                        icon = data.icon,
                        label = data.label,
                    },
                },
                distance = data.distance or 2.5,
            }
        )
    end
    return Targets[k]
end

exports("CreateTarget", CreateTarget)

--- Function to remove target
---@param: target: The target you want to remove
function RemoveTarget(target)
    if Config.Target == "none" or Config.Target == nil then
        target:destroy()
    elseif Config.Target == "ox_target" then
        exports.ox_target:removeZone(target)
    else
        exports[Config.Target]:RemoveZone(target)
    end
end

exports("RemoveTarget", RemoveTarget)

--- On resource stop
AddEventHandler("onResourceStop", function(resource)
    if Config.Target == "none" or Config.Target == nil then
        for k, v in pairs(Targets) do
            v:destroy()
        end
    elseif Config.Target == "ox_target" then
        for k, v in pairs(Targets) do
            exports.ox_target:removeZone(v)
        end
    else
        for k, v in pairs(Targets) do
            exports[Config.Target]:RemoveZone(v)
        end
    end
end)