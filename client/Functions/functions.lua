---@module Functions
---@description Functions using fivem nattives

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}

--- Loads Animation Dictionary
---@param dict string
---@usage Ez_lib.Functions.LoadAnimDict("anim@heists@ornate_bank@grab_cash")
function LoadAnimDict(dict)
	DebugPrint("Loading animation dictionary", dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

--- Loads Model Stream
---@param model string
---@usage Ez_lib.Functions.LoadModel("hei_p_m_bag_var22_arm_s")
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

--- Deletes a blip from the map
--- @param blip integer The blip to delete
--- @usage Ez_lib.Functions.DeleteBlip(blip)
--- @return void
--- @usage Ez_lib.Functions.DeleteBlip(blip)
local function delete_blip(blip)
	RemoveBlip(blip)
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

--- Function to create a Ped at a specific location
--- @param model string The model of the ped
--- @param coords table The coordinates to spawn the ped
--- @param freeze boolean Whether to freeze the ped or not
--- @param collision boolean Whether to enable collision or not
--- @param scenario string The scenario to player
--- @param anim table The animation to play (1 = dict, 2 = name)
--- @return number ped The ped handle
--- @usage Ez_lib.Functions.CreatePed("a_m_m_skater_01", vector4(0.0, 0.0, 0.0, 0.0), true, false, "WORLD_HUMAN_SMOKING", {"amb@world_human_smoking@male@male_a@enter", "enter"})
local function create_ped(model, coords, freeze, collision, scenario, anim)
	LoadModel(model)
	local ped = CreatePed(4, GetHashKey(model), coords.x, coords.y, coords.z, coords.w, false, false)
	SetEntityInvincible(ped, true)
	FreezeEntityPosition(ped, freeze)
	if collision then SetEntityNoCollisionEntity(ped, PlayerPedId(), false) end
	if scenario then TaskStartScenarioInPlace(ped, scenario, 0, true) end
	if anim then
		LoadAnimDict(anim[1])
		TaskPlayAnim(ped, anim[1], anim[2], 8.0, 8.0, -1, 0, 0, 0, 0, 0)
	end
	return ped
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
Ez_lib.Functions.LoadAnimDict = LoadAnimDict
Ez_lib.Functions.LoadModel = LoadModel
Ez_lib.Functions.MakeBlip = make_blip
Ez_lib.Functions.DeleteBlip = delete_blip
Ez_lib.Functions.Look = look
Ez_lib.Functions.CreateProp = create_prop
Ez_lib.Functions.SpawnVehicle = spawn_vehicle
Ez_lib.Functions.CreatePed = create_ped

---@section Client Events

--- Event to use consumable items
--- @param item string The item to use
--- @param data table The item to use data
--- @usage TriggerEvent(ResourceName..":UseConsumable", "item")
RegisterNetEvent(ResourceName..":UseConsumable", function(item, data)
	if data.RequiredItems then
		local player_items = Ez_lib.Functions.GetPlayerItems()
		for k, v in pairs(data.RequiredItems) do
			if not (player_items[k] and player_items[k].amount >= v) then
				Ez_lib.Shared.TriggerNotify(nil, "Missing required item: "..k, "error")
				return
			end
		end
	end
	if data.Progress then
		if data.Progress.animationInCar and IsPedInAnyVehicle(PlayerPedId(), true) == 1 then
			data.Progress.animation = data.Progress.animationInCar
		end
		Ez_lib.Shared.ProgressBar(item, data.Progress.label or "Eating..", (data.Progress.time * 1000) or 5500, data.Progress.useWhileDead or false, data.Cancelled or data.canCancel or false, {
			disableMovement = data.Progress.disableMovement or false,
			disableMouse = data.Progress.disableMouse or false,
			disableCombat = data.Progress.disableCombat or false,
		}, {}, {}, {}, function(success) -- Done
			if not success then
				if data.Cancelled then
					data.Cancelled()
				end
				return
			end
			if data.RemoveItem then
				TriggerServerEvent("ez_lib:server:RemoveItem", item)
			end
			if data.Success then
				data.Success()
			end
			if data.Armour then AddArmourToPed(data, data.Armour) end
			if data.Stress then Config.RemoveStress(data.Stress) end
			if data.Thirst then Config.RelieveThirst(data.Thirst) end
			if data.Hunger then Config.RelieveHunger(data.Hunger) end
		end, item)
		if data.Progress.animation then
			Ez_lib.Functions.Emote.OnEmotePlay({
				data.Progress.animation.animDict,
				data.Progress.animation.anim,
				"Ez_lib:useConsumable",
				AnimationOptions = data.Progress.animation.animationOptions or {}
			})
		end
		Wait((data.Progress.time * 1000) or 5500)
		Ez_lib.Functions.Emote.DestroyAllProps()
	else
		if data.RemoveItem then
			TriggerServerEvent("ez_lib:server:RemoveItem", item)
		end
		if data.Success then
			data.Success()
		end
		if data.Armour then AddArmourToPed(data, data.Armour) end
		if data.Stress then Config.RemoveStress(data.Stress) end
		if data.Thirst then Config.RelieveThirst(data.Thirst) end
		if data.Hunger then Config.RelieveHunger(data.Hunger) end
	end
end)