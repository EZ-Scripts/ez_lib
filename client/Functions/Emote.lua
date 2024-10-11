---@module Emote Function
---@description Emote function Written by andristum Edited by Rayaan Uddin
---@auther andristum

Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}
Ez_lib.Functions.Emote = Ez_lib.Functions.Emote or {}

local PlayerProps = {}
local hashSkinMale = GetHashKey("mp_m_freemode_01")

local function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(Player))
  
    if not HasModelLoaded(prop1) then
      LoadModel(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

local function PtfxThis(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
      RequestNamedPtfxAsset(asset)
      Wait(10)
    end
    UseParticleFxAssetNextCall(asset)
end

local function DestroyAllProps()
    for _,v in pairs(PlayerProps) do
      DeleteEntity(v)
    end
    PlayerHasProp = false
	ClearPedTasks(PlayerPedId())
end

local function OnEmotePlay(EmoteName)
    if not DoesEntityExist(GetPlayerPed(-1)) then
      return false
    end
    if IsPedArmed(GetPlayerPed(-1), 7) then
    	SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
    end
    ChosenDict,ChosenAnimation,ename = table.unpack(EmoteName)
    AnimationDuration = -1
    if PlayerHasProp then
      DestroyAllProps()
    end
    if ChosenDict == "Expression" then
      SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
      return
    end
    if ChosenDict == "MaleScenario" or "Scenario" then
      	if ChosenDict == "MaleScenario" then if InVehicle then return end
		  	if GetEntityModel(PlayerPedId()) == hashSkinMale then
				ClearPedTasks(GetPlayerPed(-1))
				TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
				IsInAnimation = true
			end
			return
    	elseif ChosenDict == "ScenarioObject" then
			if InVehicle then
				return
			end
			BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
			ClearPedTasks(GetPlayerPed(-1))
			TaskStartScenarioAtPosition(GetPlayerPed(-1), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
			IsInAnimation = true
			return
		elseif ChosenDict == "Scenario" then
			if InVehicle then return end
			ClearPedTasks(GetPlayerPed(-1))
			TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
			IsInAnimation = true
			return
		end
	end
    LoadAnimDict(ChosenDict)

    if EmoteName.AnimationOptions then
		if EmoteName.AnimationOptions.EmoteLoop then
			MovementType = 1
			if EmoteName.AnimationOptions.EmoteMoving then
				MovementType = 51
    		end
    	elseif EmoteName.AnimationOptions.EmoteMoving then
      		MovementType = 51
    	elseif EmoteName.AnimationOptions.EmoteMoving == false then
      		MovementType = 0
    	elseif EmoteName.AnimationOptions.EmoteStuck then
      		MovementType = 50
    	end
    else
      	MovementType = 0
    end

    if InVehicle == 1 then
      MovementType = 51
    end

    if EmoteName.AnimationOptions then
      	if EmoteName.AnimationOptions.EmoteDuration == nil then 
        	EmoteName.AnimationOptions.EmoteDuration = -1
        	AttachWait = 0
    	else
        	AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
        	AttachWait = EmoteName.AnimationOptions.EmoteDuration
      	end

      	if EmoteName.AnimationOptions.PtfxAsset then
			PtfxAsset = EmoteName.AnimationOptions.PtfxAsset
			PtfxName = EmoteName.AnimationOptions.PtfxName
			if EmoteName.AnimationOptions.PtfxNoProp then
			PtfxNoProp = EmoteName.AnimationOptions.PtfxNoProp
			else
			PtfxNoProp = false
			end
			Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(EmoteName.AnimationOptions.PtfxPlacement)
			PtfxInfo = EmoteName.AnimationOptions.PtfxInfo
			PtfxWait = EmoteName.AnimationOptions.PtfxWait
			PtfxNotif = false
			PtfxPrompt = true
			PtfxThis(PtfxAsset)
		else
			PtfxPrompt = false
		end
    end

    TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
    RemoveAnimDict(ChosenDict)
    IsInAnimation = true
    MostRecentDict = ChosenDict
    MostRecentAnimation = ChosenAnimation

    if EmoteName.AnimationOptions then
		if EmoteName.AnimationOptions.Prop then
			PropName = EmoteName.AnimationOptions.Prop
			PropBone = EmoteName.AnimationOptions.PropBone
			PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
			if EmoteName.AnimationOptions.SecondProp then
				SecondPropName = EmoteName.AnimationOptions.SecondProp
				SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
				SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
				SecondPropEmote = true
			else
				SecondPropEmote = false
			end
			Wait(AttachWait)
			AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
			if SecondPropEmote then
				AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
			end
		end
    end
    return true
end

---@section Assign Functions
Ez_lib.Functions.Emote.OnEmotePlay = OnEmotePlay
Ez_lib.Functions.Emote.DestroyAllProps = DestroyAllProps
Ez_lib.Functions.Emote.AddPropToPlayer = AddPropToPlayer