---@module Functions Crafting
---@description Crafting functions

--- Function to create and open the crafting menu
--- @param data table The crafting table data
--- @usage Ez_lib.Functions.Crafting({craftingTable = craftingTable, Items = Items, imageTemplate = imageTemplate})
local function crafting(data)
	local Menu = {}
	local player_items = Ez_lib.Functions.GetPlayerItems()
	for k, v in pairs(data.craftingTable.Items) do
		local label, title, titletemp = "", "", ""
		if data.Items[v.item] ~= nil then
			title = data.Items[v.item].label
		else
			title = v.item
		end
        titletemp = title
		if v.amount and v.amount > 1 then
			title = title.." x"..v.amount
		end
		local disable = false
		for l, j in pairs(v.recipe) do
			if data.Items[l] ~= nil then
				label = label..data.Items[l].label
			else
				label = label..l
			end
			if j > 1 then
				label = label.." x"..j.."\n"
			else
				label = label.."\n"
			end
			if not(disable) then
				if not (player_items[l] and player_items[l].amount >= j) then
					disable = true
				end
			end
		end
		if not disable then title = title.." ✔️" end
		Menu[#Menu + 1] = {
			disabled = disable,
			image = data.imageTemplate:gsub("?", v.item),
			title = title,
			label = label,
			event = ResourceName..":Crafting:MakeItem",
			args = { craft = v, craftingTable = data.craftingTable, imageTemplate = data.imageTemplate, title = titletemp, Items = data.Items},
		}
	end
	Ez_lib.Functions.Menu(data.craftingTable.Menu.header, Menu)
end

RegisterNetEvent(ResourceName..":Crafting:MakeItem", function(data)
	Ez_lib.Shared.ProgressBar('ez_crafting', data.craftingTable.Progress.label..data.title, data.craftingTable.Progress.time * 1000, false, true, { disableMovement = true, disableCarMovement = false, disableMouse = false, disableCombat = false, },
	{ animDict = data.craftingTable.Progress.animation.animDict, anim = data.craftingTable.Progress.animation.anim, flags = data.craftingTable.Progress.animation.flag or 49, }, {}, {}, function(success)
		if not success then
			return
		end
		TriggerServerEvent(ResourceName..":server:Crafting:MakeItem", data.craft)
		Wait(1000)
		crafting(data)
	end, data.craft.item)
end)

---@section Assign Functions
Ez_lib.Functions.Crafting = crafting
