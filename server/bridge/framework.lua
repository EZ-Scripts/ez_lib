--- @module Framework
--- @description Framework system bridge for FiveM

Framework = Framework or nil
Ez_lib = Ez_lib or {}
Ez_lib.Functions = Ez_lib.Functions or {}
Ez_lib.Functions.Inventory = Ez_lib.Functions.Inventory or {}
Ez_lib.Functions.Money = Ez_lib.Functions.Money or {}

--- @section Initialization

--- Initializes the connection to the specified framework when the resource starts.
-- Supports ''qb-core', 'es_extended', edit if needed
CreateThread(function()
    while GetResourceState(Config.Framework) ~= 'started' do
        Wait(500)
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
        local item = player.Functions.GetItemByName(item_name)
        if item ~= nil and item.amount >= item_amount then
            has_item =  true
        end
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
--- @usage local cash = Ez_lib.Functions.GetBank(source, 'cash')
--- @usage local bank = Ez_lib.Functions.GetBank(source, 'bank')
local function get_bank(source, type)
    local player = get_player(source)
    if not player then return false end

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
        local identifier = get_player_unique_id(source)
		local result = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE identifier = @identifier', {
		['@identifier'] = identifier
		})

		if result[1]['firstname'] ~= nil then
            player_data = {
                firstname = result[1].firstname,
                lastname = result[1].lastname,
                dob = result[1]['dateofbirth'],
                sex = result[1]['sex'],
                nationality = 'LS, Los Santos'
            }
		end
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

--- @Section Assign Functions
Ez_lib.Functions.HasItem = has_item
Ez_lib.Functions.GetPlayer = get_player
Ez_lib.Functions.Inventory.Add = addItem
Ez_lib.Functions.Inventory.Remove = removeItem
Ez_lib.Functions.Money.Add = addMoney
Ez_lib.Functions.Money.Remove = removeMoney
Ez_lib.Functions.GetBank = get_bank
Ez_lib.Functions.GetPlayerJob = get_player_job
Ez_lib.Functions.GetPlayerUniqueIdentifier = get_player_unique_id
Ez_lib.Functions.GetIdentity = get_identity
Ez_lib.Functions.SetPlayerJob = set_player_job
Ez_lib.Functions.RegisterUsableItem = register_usable_item
Ez_lib.Functions.GetJobs = get_jobs


--- @section Callbacks

--- Callback to check if a player has an item in their inventory.
Ez_lib.Functions.CreateCallback('ez_lib:server:has_item', function(source, cb, data)
    local item_name = data.item
    local item_amount = data.amount or 1
    local player_has_item = false
    cb(Ez_lib.Functions.HasItem(source, item_name, item_amount))
end)

--- @section Server Events
RegisterNetEvent("ez_lib:server:RemoveItem", function(item, count)
    removeItem(source, item, count or 1)
end)
RegisterNetEvent("ez_lib:server:AddItem", function(item, count)
    if count>1 then temp = 'items' else temp = 'item' end
    if addItem(source, item, count or 1) then
        Config.TriggerNotify('Add Item', 'You have received ' .. count .. ' ' ..temp , 'success', source)
    else
        Config.TriggerNotify('No Space', 'You do not have enough space in your inventory', 'error', source)
    end
end)



