--- @module Framework
--- @description Framework system bridge for FiveM

Framework = Framework or nil
Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}
Ez_lib.Functions.Inventory = Ez_lib.Functions.Inventory or {}
Ez_lib.Functions.Money = Ez_lib.Functions.Money or {}

--- @section Initialization

--- Initializes the connection to the specified framework when the resource starts.
-- Supports ''qb-core', 'es_extended', edit if needed.
AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
    while GetResourceState(Config.Framework) ~= 'started' do
        Wait(50)
    end
    DebugPrint("Framework", Config.Framework)
    if Config.Framework == 'qb-core' then
        Framework = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'es_extended' then
        Framework = exports['es_extended']:getSharedObject()
    else
        -- Add more frameworks here
    end
end)
while Framework == nil do Wait(0) end

--- @section Functions

--- Retrieves player data from the server based on the framework.
--- @param source source Player source identifier.
--- @return Player data object.
--- @usage local player = Ez_lib.Functions.get_player(source)
local function get_player(source)
    local player
    if Config.Framework == 'qb-core' then
        player = Framework.Functions.GetPlayer(source)
    elseif Config.Framework == 'es_extended' then
        player = Framework.GetPlayerFromId(source)
    else
        -- Add more frameworks here
    end
    return player
end

--- Check if a player has an item in their inventory.
--- @param source source Player source identifier.
--- @param item_name string Name of the item to check.
--- @param item_amount integer (Optional) Amount of the item to check for.
--- @return boolean
--- @usage local has_item = Ez_lib.Functions.HasItem(source, 'item_name', item_amount)
local function has_item(source, item_name, item_amount)
    local player = get_player(source)
    if not player then return false end
    item_amount = item_amount or 1
    local has_item = false
    if Config.Framework == 'qb-core' then
        local count = 0
        for k, v in pairs(player.PlayerData.items) do
            if v.name == item_name then
                count = count + v.amount
            end
        end
        has_item = count >= item_amount and true or false
    elseif Config.Framework == 'es_extended' then
        local item = player.getInventoryItem(item_name)
        if item ~= nil and item.count >= item_amount then
            has_item =  true
        end
    else
        -- Add more frameworks here
    end
    DebugPrint("Has Item (id: "..source..")", item_name .. ' Amount: ' .. item_amount.." | "..tostring(has_item))
    return has_item
end

--- Adjusts the player's inventory based on action.
--- @param source source Player source identifier.
--- @param action string Action to perform on the inventory ('add' or 'remove').
--- @param item string Item to adjust in the inventory.
--- @param count integer Amount of the item to adjust.
--- @param item_data table (Optional) Item data to add to the inventory.
--- @usage Ez_lib.Functions.Inventory.Add(source, 'item_name', item_amount, item_data)
--- @usage Ez_lib.Functions.Inventory.Remove(source, 'item_name', item_amount)
--- @return boolean
local function adjust_inventory(source, action, item, count, item_data)
    local player = get_player(source)
    if not player then return false end

    if Config.Framework == 'qb-core' then
        if action == 'add' then
            return player.Functions.AddItem(item, count, nil, item_data)
        elseif action == 'remove' then
            return player.Functions.RemoveItem(item, count)
        end
    elseif Config.Framework == 'es_extended' then
        if action == 'add' then
            return player.addInventoryItem(item, count)
        elseif action == 'remove' then
            return player.removeInventoryItem(item, count)
        end
    end
end
local function addItem(source, item, count, item_data)
    return adjust_inventory(source, 'add', item, count, item_data)
end
local function removeItem(source, item, count)
    return adjust_inventory(source, 'remove', item, count, nil)
end

--- Adjust the player's bank balance based on action.
--- @param source source Player source identifier.
--- @param action string Action to perform on the bank balance ('add' or 'remove').
--- @param type string Type of account(cash or bank).
--- @param amount integer Amount to adjust the bank balance by.
--- @usage Ez_lib.Functions.Money.Add(source, 'cash', 100)
--- @usage Ez_lib.Functions.Money.Remove(source, 'bank', 100)
local function adjust_balance(source, action, type, amount)
    local player = get_player(source)
    if not player then return false end

    if Config.Framework == 'qb-core' then
        if action == 'add' then
            player.Functions.AddMoney(type, amount)
        elseif action == 'remove' then
            player.Functions.RemoveMoney(type, amount)
        end
    elseif Config.Framework == 'es_extended' then
        if type == 'cash' then
            if action == 'add' then
                player.addMoney(amount)
            elseif action == 'remove' then
                player.removeMoney(amount)
            end
        else
            if action == 'add' then
                player.addAccountMoney(type, amount)
            elseif action == 'remove' then
                player.removeAccountMoney(type, amount)
            end
        end
    end
end
local function addMoney(source, type, amount)
    adjust_balance(source, 'add', type, amount)
end
local function removeMoney(source, type, amount)
    adjust_balance(source, 'remove', type, amount)
end

--- Get the player's bank balance.
--- @param source source Player source identifier.
--- @param type string Type of account(cash or bank).
--- @return integer
--- @usage local cash = Ez_lib.Functions.GetMoney(source, 'cash')
--- @usage local bank = Ez_lib.Functions.GetMoney(source, 'bank')
local function get_money(source, type)
    local player = get_player(source)
    if not player then return false end
    DebugPrint('Getting Player Money', type)
    if Config.Framework == 'qb-core' then
        return player.Functions.GetMoney(type)
    elseif Config.Framework == 'es_extended' then
        if type == 'cash' then
            return player.getMoney()
        else
            return player.getAccount(type).money
        end
    else
        return -1
    end
end

--- Get the job of a player by their source identifier.
--- @param source source The player's source identifier.
--- @return table
--- @usage local player_job = Ez_lib.Functions.GetPlayerJob(source)
local function get_player_job(source)
    local player_job = {}
    local player = get_player(source)
    if player then
        if Config.Framework == 'qb-core' then
            player_job.name = player.PlayerData.job.name
            player_job.onduty = player.PlayerData.job.onduty
            player_job.label = player.PlayerData.job.label
            player_job.grade = {number = player.PlayerData.job.grade.level, label = player.PlayerData.job.grade.name}
        elseif Config.Framework == 'es_extended' then
            player_job.name = player.getJob().name
            player_job.onduty = player.getJob().onduty
            player_job.label = player.getJob().label
            player_job.grade = {number = player.getJob().grade, label = player.getJob().grade_label}

        end
    end
    return player_job
end

--- Set the player's job by their source identifier.
--- @param source source The player's source identifier.
--- @param job string The job name to set.
--- @param grade integer The job grade to set.
--- @usage Ez_lib.Functions.SetPlayerJob(source, 'police', 1)
local function set_player_job(source, job, grade)
    local player = get_player(source)
    if not player then return false end
    if Config.Framework == 'qb-core' then
        player.Functions.SetJob(job, grade)
    elseif Config.Framework == 'es_extended' then
        player.setJob(job, grade)
    end
end

--- Get player id from the server based on the framework.
--- @param source source Player source identifier.
--- @return string
--- @usage local player_id = Ez_lib.Functions.GetPlayerUniqueIdentifier(source)
local function get_player_unique_id(source)
    local player_id
    local player = get_player(source)
    if not player then return false end
    if Config.Framework == 'qb-core' then
        player_id = player.PlayerData.citizenid
    elseif Config.Framework == 'es_extended' then
        player_id = player.getIdentifier()
    end
    return player_id
end

--- Retrieves a player's identity information depending on the framework.
--- @param source source source identifier.
--- @return table
--- @usage local player_identity = Ez_lib.Functions.GetIdentity(source)
local function get_identity(source)
    local player_data = nil
    if Config.Framework == 'qb-core' then
        local player = get_player(source)
        player_data = {
            firstname = player.PlayerData.charinfo.firstname,
            lastname = player.PlayerData.charinfo.lastname,
            dob = player.PlayerData.charinfo.birthdate,
            sex = player.PlayerData.charinfo.gender,
            nationality = player.PlayerData.charinfo.nationality
        }
    elseif Config.Framework == 'es_extended' then
        local player = get_player(source)
        local name = {}
        for s in string.gmatch(player.name, "%S+") do
            if #name + 1 == 1 then
                name[1] = s
            elseif name[2] == nil then
                name[2] = s
            else
                name[2] = name[2] .. " " .. s
            end
        end
        print(name[1])
        player_data = {
            firstname = name[1] or "",
            lastname = name[2] or "",
            dob = "01/01/1996",
            sex = "other",
            nationality = "LS, Los Santos"
        }
    end
    if player_data == nil then
        return false
    end
    return player_data
end

--- Registers a usable item.
--- @param name string name of item.
--- @return function function to execute when item is used.
--- @usage Ez_lib.Functions.RegisterUsableItem('item_name', function(source) end)
local function register_usable_item(name, func)
    DebugPrint('Registering usable item', name)
    if Config.Framework == 'qb-core' then
        Framework.Functions.CreateUseableItem(name, func)
    elseif Config.Framework == 'es_extended' then
        Framework.RegisterUsableItem(name, func)
    end
end

--- Get all jobs in server
--- @return table
--- @usage local jobs = Ez_lib.Functions.GetJobs()
local function get_jobs()
    local jobs = {}
    local grades = {}
    if Config.Framework == 'qb-core' then
        for k, v in pairs(Framework.Shared.Jobs) do
            jobs[k] = {
                name = k,
                label = v.label,
            }
            for i, j in pairs(v.grades) do
                grades[i] = { name = j.label, payment = j.payment }
            end
            jobs[k].grades = grades
        end
    elseif Config.Framework == 'es_extended' then
        for k, v in pairs(Framework.Jobs) do
            jobs[k] = {
                name = k,
                label = v.label,
            }
            for i, j in pairs(v.grades) do
                grades[i] = { name = j.label, payment = j.salary }
            end
            jobs[k].grades = grades
        end
    else
        -- Add more frameworks here
    end
    return jobs
end

--- Create an item in the for server.
--- @param name string Name of the item.
--- @param data table Data of the item (label, weight, type, description, combinable, shouldClose, useable, unique)
--- @returns boolean when server restart is needed FOR ESX
--- @usage Ez_lib.Functions.CreateItem('item_name', {label = 'Item Label', weight = 1, limit = 10})
local function create_item(name, data)
    if Config.Framework == 'qb-core' then
        exports['qb-core']:AddItem(name, {
            name = name,
            label = data.label,
            weight = data.weight or 100,
            type = data.type or 'item',
            image = data.image or name..'.png',
            unique = data.unique or false,
            useable = data.useable or false,
            shouldClose = data.shouldClose or true,
            combinable = data.combinable,
            description = data.description or '',
        })
        DebugPrint('Creating Item', name)
    elseif Config.Framework == 'es_extended' then
        local doesExist = Ez_lib.Functions.ExecuteSql("SELECT * FROM items WHERE name = '"..name.."'")
        if doesExist[1] == nil then
            DebugPrint('Creating Item (Server Restart Needed)', name)
            Ez_lib.Functions.ExecuteSql("INSERT INTO items (name, label, weight, rare, can_remove) VALUES ('"..name.."', '"..data.label.."', "..data.weight..", "..'0'..", "..'1'..")")
            return true
        end
    else
        -- Add more frameworks here
    end
    return false
end

--- @Section Assign Functions
Ez_lib.Functions.HasItem = has_item
Ez_lib.Functions.GetPlayer = get_player
Ez_lib.Functions.Inventory.Add = addItem
Ez_lib.Functions.Inventory.Remove = removeItem
Ez_lib.Functions.Money.Add = addMoney
Ez_lib.Functions.Money.Remove = removeMoney
Ez_lib.Functions.GetMoney = get_money
Ez_lib.Functions.GetPlayerJob = get_player_job
Ez_lib.Functions.GetPlayerUniqueIdentifier = get_player_unique_id
Ez_lib.Functions.GetIdentity = get_identity
Ez_lib.Functions.SetPlayerJob = set_player_job
Ez_lib.Functions.RegisterUsableItem = register_usable_item
Ez_lib.Functions.GetJobs = get_jobs
Ez_lib.Functions.CreateItem = create_item


--- @section Callbacks

--- Callback to check if a player has an item in their inventory.
Ez_lib.Functions.CreateCallback(ResourceName..":server:has_item", function(source, cb, data)
    local item_name = data.item
    local item_amount = data.amount or 1
    local player_has_item = false
    cb(Ez_lib.Functions.HasItem(source, item_name, item_amount))
end)

--- @section Server Events
RegisterNetEvent(ResourceName..":server:RemoveItem", function(item, count)
    removeItem(source, item, count or 1)
end)
RegisterNetEvent(ResourceName..":server:AddItem", function(item, count)
    if count>1 then temp = 'items' else temp = 'item' end
    if addItem(source, item, count or 1) then
        Config.TriggerNotify('Add Item', 'You have received ' .. count .. ' ' ..temp , 'success', source)
    else
        Config.TriggerNotify('No Space', 'You do not have enough space in your inventory', 'error', source)
    end
end)



