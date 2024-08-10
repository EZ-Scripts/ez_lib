---@module Functions
---@description Functions using fivem nattives

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

function LoadAnimDict(dict)
	DebugPrint("Loading animation dictionary", dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function LoadModel(model)
	local time = 0
	DebugPrint("Loading model", model)
    while not HasModelLoaded(GetHashKey(model)) do
		if time > 5000 then DebugPrint("Loading model", "Failed") break end
		RequestModel(GetHashKey(model))
		Wait(200)
		time = time + 200
    end
	DebugPrint("Loading model", "Success") 
end

--- Creates a blip on the map
---@param data table
---@return integer
---@usage Ez_lib.Functions.MakeBlip({name = "Test", coords = vector3(0.0, 0.0, 0.0), sprite = 1, col = 0, scale = 0.7, disp = 6, category = 0})
local function make_blip(data)
	DebugPrint("Creating Blip", data.name.."^7' at ^6"..data.coords.."^7")
	local blip = AddBlipForCoord(data.coords)
	SetBlipAsShortRange(blip, true)
	SetBlipSprite(blip, data.sprite or 1)
	SetBlipColour(blip, data.col or 0)
	SetBlipScale(blip, data.scale or 0.7)
	SetBlipDisplay(blip, (data.disp or 6))
    if data.category then SetBlipCategory(blip, data.category) end
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentString(tostring(data.name))
	EndTextCommandSetBlipName(blip)
    return blip
end

--- Function to make player look and move at a specific location
---@param coords vector The coordinates to look at
---@usage Ez_lib.Functions.Look(vector3(0.0, 0.0, 0.0))
local function look(coords)
	if not IsPedHeadingTowardsPosition(PlayerPedId(), coords.xyz, 10.0) then
		TaskTurnPedToFaceCoord(PlayerPedId(), coords.xyz, 1500)
		Wait(1500)
	end
end

--- Function to create a Prop at a specific location
---@param model string The model of the prop
---@param coords vector4 The coordinates to spawn the prop
---@param synced boolean Whether to network the prop or not
---@param frozen boolean Whether the prop should be frozen or not
---@return integer
---@usage Ez_lib.Functions.CreateProp("prop_test", vector4(0.0, 0.0, 0.0, 0.0), false, true)
local function create_prop(model, coords, synced, frozen)
	LoadModel(model)
	local prop = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z -1, synced or false, synced or false, false)
	SetEntityHeading(prop, coords.w)
	FreezeEntityPosition(prop, frozen or true)
	return prop
end

--- Function to spawn a vehicle at a specific location
--- @param model string The model of the vehicle
--- @param coords table The coordinates to spawn the vehicle
--- @param cb function The callback function
--- @param isnetworked boolean Whether to network the vehicle or not
--- @usage Ez_lib.Functions.SpawnVehicle("adder", vector4(0.0, 0.0, 0.0, 0.0), function(veh) print(veh) end, false)
local function spawn_vehicle(model, coords, cb, isnetworked)
    local ped = PlayerPedId()
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    local isnetworked = isnetworked or true
    if not IsModelInCdimage(GetHashKey(model)) then
        return
    end
    LoadModel(model)
	DebugPrint("Spawning vehicle", model)
    local veh = CreateVehicle(GetHashKey(model), coords.x, coords.y, coords.z, coords.w or 0.0, isnetworked or false, false)
    local netid = NetworkGetNetworkIdFromEntity(veh)
    SetVehicleHasBeenOwnedByPlayer(veh, true)
    SetNetworkIdCanMigrate(netid, true)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehRadioStation(veh, 'OFF')
    SetModelAsNoLongerNeeded(model)
    if cb then
        cb(veh)
    end
end

---@section Assign Functions
Ez_lib.Functions.MakeBlip = make_blip
Ez_lib.Functions.Look = look
Ez_lib.Functions.CreateProp = create_prop
Ez_lib.Functions.SpawnVehicle = spawn_vehicle