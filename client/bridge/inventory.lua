Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}
Ez_lib.Functions.Inventory = Ez_lib.Functions.Inventory or {}

--- Client Side Function to open stash
--- @param name string The name of the stash
--- @param stash table The stash to open {maxweight, slots}
--- @usage Ez_lib.Functions.Inventory.OpenStash("stash", {maxweight = 10000, slots = 10})
local function open_stash(name, stash)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:openInventory('stash', name)
    else
        TriggerEvent("inventory:client:SetCurrentStash", name)
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', name,  stash)
	end
end

--- Client Side Function to open shop
--- @param name string The name of the shop
--- @param shop table The shop to open {label, slots, items = {name, price, info, type, amount, slot}}
--- @usage Config.OpenShop("shop", {label = "Shop", slots = 10, items = {name = "item", price = 100, info = {}, type = "item", amount = 1, slot = 1}})
local function open_shop(name, shop)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:openInventory('shop', { type = name })
    else
        TriggerServerEvent("inventory:server:OpenInventory", "shop", name, shop)
    end
end

--- @Section Assign Functions
Ez_lib.Functions.Inventory.OpenStash = open_stash
Ez_lib.Functions.Inventory.OpenShop = open_shop