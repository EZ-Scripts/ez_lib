---@module Target
---@description Target system bridge for FiveM

Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

--- Function to check if resource exists
CreateThread(function()
    if (Config.Target ~= "none" or Config.Target ~= nil) and GetResourceState(Config.Target) ~= "started" then
        DebugPrint("Target resource not found")
        return
    end
end)

Targets = {}
InLocation = false

--- Function to check if player can open stash
---@param: data: The data of the target. minZ, maxZ, coords(vector4), length(optional), width(optional), icon, action(entity), event, distance (optional), canInteract(entity) [Optional], type [Optional], label
---@return: Target
function CreateTarget(data)
    DebugPrint("^5Debug^7: ^2Creating Target^7: '^6"..data.label.."^7' at ^6"..data.coords.."^7")
    local k = #Targets+1
    print(k)
    local vector3 = vector3(data.coords.x, data.coords.y, data.coords.z)
    local heading = data.coords.w or 0.0
    local length = data.length or 1.5
    local width = data.width or 1.5
    if Config.Target == "none" or Config.Target == nil then
        local Zone = BoxZone:Create(vector3, length, width, {name = "box_zone", debugPoly = Config.Debug, heading = heading, minZ = data.minZ or data.coords.z - 1, maxZ = data.maxZ or data.coords.z + 1})
        Targets[k] = ComboZone:Create({Zone}, {name = "ns_lib_Target#"..k, debugPoly = Config.Debug})
        Targets[k]:onPlayerInOut(function(isPointInside, _, _)
            if isPointInside then
                InLocation = true
                if data.canInteract(nil) or data.canInteract == nil then
                    Config.ShowUI(data.label)
                    while InLocation do
                        Wait(0)
                        if IsControlJustReleased(0, 38) then
                            data.action(nil)
                            break
                        end
                    end
                end
            else
                InLocation = false
                Config.HideUI()
            end
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
                    canInteract = function(entity)
                        if data.canInteract == nil then return true end
                        return data.canInteract(entity)
                    end,
                    label = data.label,
                    distance = data.distance or 2.5,
                    onSelect = function(entity)
                        data.action(entity)
                    end
                },
            },
        }
        exports.ox_target:addBoxZone(Targets[k])
    else
        Targets[k] =
        exports[Config.Target]:AddBoxZone("ns_lib_Target#"..k, vector3, length, width,
            {
                name = "ns_lib_Target#"..k,
                heading = heading,
                debugPoly=Config.Debug,
                minZ = data.minZ or data.coords.z - 1,
                maxZ = data.maxZ or data.coords.z + 1,
            },
            {
                options = {
                    {
                        type = data.type or "client",
                        canInteract = function(entity)
                            if data.canInteract == nil then return true end
                            return data.canInteract(entity) or true
                        end,
                        event = data.event,
                        action = function(entity)
                            data.action(entity)
                        end,
                        icon = data.icon,
                        label = data.label,
                    },
                },
                distance = data.distance or 2.5,
            }
        )
    end
    print(Targets[k])
    return Targets[k]
end

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
    DebugPrint("^5Debug^7: ^2Removing Target^7: '^6"..target.."^7'")
end

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

--- @Section Assign Functions
Ns_lib.Functions.CreateTarget = CreateTarget
Ns_lib.Functions.RemoveTarget = RemoveTarget