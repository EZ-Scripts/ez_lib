---@module Functions
---@description Functions using fivem nattives

Ns_lib = Ns_lib or {}
Ns_lib.Functions = Ns_lib.Functions or {}

function LoadAnimDict(dict)
	DebugPrint("^5Debug^7: ^2Loading Anim Dictionary^7: '^6"..dict.."^7'")
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(5)
	end
end

function LoadModel(model)
	time = 0
    while not HasModelLoaded(GetHashKey(model)) do
		if time > 1000 then break end
		RequestModel(GetHashKey(model))
		Wait(10)
		time = time + 1
    end
end

--- Creates a blip on the map
---@param data table
---@return integer
---@usage Ns_lib.Functions.MakeBlip({name = "Test", coords = vector3(0.0, 0.0, 0.0), sprite = 1, col = 0, scale = 0.7, disp = 6, category = 0})
local function MakeBlip(data)
	DebugPrint("^5Debug^7: ^2Creating Blip^7: '^6"..data.name.."^7' at ^6"..data.coords.."^7")
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
---@usage Ns_lib.Functions.Look(vector3(0.0, 0.0, 0.0))
function Look(coords)
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
---@usage Ns_lib.Functions.CreateProp("prop_test", vector4(0.0, 0.0, 0.0, 0.0), false, true)
local function CreateProp(model, coords, synced, frozen)
	LoadModel(model)
	local prop = CreateObject(GetHashKey(model), coords.x, coords.y, coords.z -1, synced or false, synced or false, false)
	SetEntityHeading(prop, coords.w)
	FreezeEntityPosition(prop, frozen or true)
	return prop
end

---@section Assign Functions
Ns_lib.Functions.MakeBlip = MakeBlip
Ns_lib.Functions.Look = Look
Ns_lib.Functions.CreateProp = CreateProp