Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}
Ez_lib.Functions.Inventory = Ez_lib.Functions.Inventory or {}

--- Function to register a stash
--- @param name string The name of the stash
--- @param stash table The stash to register {slots, maxweight}
--- @usage Ez_lib.Functions.Inventory.RegisterStash("stash", {slots = 10, maxweight = 10000})
local function register_stash(name, stash)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:RegisterStash(name, name, stash.slots or 50, stash.maxweight or 4000000)
    end
end

--- Function to register a shop
--- @param name string The name of the shop
--- @param shop table The shop to register {label, slots, items = {name, price, info, type, amount, slot}}
--- @usage Config.RegisterShop("shop", {label = "Shop", slots = 10, items = {name = "item", price = 100, info = {}, type = "item", amount = 1, slot = 1}})
local function register_shop(name, shop)
    if Config.Inventory == "ox_inventory" then
        exports.ox_inventory:RegisterShop(name, { name = shop.label, inventory = shop.items })
    elseif Config.Inventory == "new-qb-inventory" then
        exports['qb-inventory']:CreateShop({
            name = name,
            label = shop.label,
            slots = #shop.items,
            items = shop.items
        })
    end
end

if Config.Inventory == "new-qb-inventory" then
    RegisterNetEvent("inventory:server:OpenInventory", function(type, name, other)
        if type == "stash" then
            other.label = name
            exports['qb-inventory']:OpenInventory(source, name, other)
        elseif type == "shop" then
            exports['qb-inventory']:OpenShop(source, name)
        else
            exports['qb-inventory']:OpenInventory(source, name, other)
        end
    end)
end

--- @Section Assign Functions
Ez_lib.Functions.Inventory.RegisterStash = register_stash
Ez_lib.Functions.Inventory.RegisterShop = register_shop
