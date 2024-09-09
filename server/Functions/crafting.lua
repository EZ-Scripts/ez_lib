RegisterNetEvent(ResourceName..":server:Crafting:MakeItem", function(craft)
	local src = source
	if craft.recipe then
		for k, v in pairs(craft.recipe) do
			if Ez_lib.Functions.HasItem(src, k, v) then
				Ez_lib.Functions.Inventory.Remove(src, k, v)
			else
				local PId = Ez_lib.Functions.GetIdentity(src)
				Ez_lib.Shared.DebugPrint("Catched DupeWarn", PId.firstname.." "..PId.lastname.." (id: "..src..") Tried to remove item ("..k..") but it wasn't there")
				if not Ez_lib.Shared.Debug then DropPlayer(src, "Kicked for attempting to duplicate items") end
				return
			end
		end
	end
	Ez_lib.Functions.Inventory.Add(src, craft.item, craft.amount)
	Ez_lib.Shared.TriggerNotify(nil, "Received "..craft.amount.." item(s)", 'success', src)
end)